// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/painting.dart';
import 'package:flutter/scheduler.dart';

import 'disposable_build_context.dart';
import 'framework.dart';
import 'scrollable.dart';

/// An [ImageProvider] that makes use of
/// [Scollable.recommendDeferredLoadingForContext] to avoid loading images when
/// rapidly scrolling.
///
/// This provider assumes that its wrapped [imageProvider] correctly uses the
/// [ImageCache], and does not attempt to re-acquire or decode images in the
/// cache.
///
/// Calling [resolve] on this provider will cause it to obtain the image key
/// and then check the following:
///
///   1. If the returned [ImageStream] has been completed, end. This can happen
///      if the caller sets the completer on the stream.
///   2. If the [ImageCache] has a completer for the key for this image, ask the
///      wrapped provider to resolve.
///      This can happen if the image was precached, or another [ImageProvider]
///      already resolved the same image.
///   3. If the [context] has been disposed, end. This can happen if the caller
///      has been disposed and is no longer interested in resolving the image.
///   4. If the widget is scrolling with high velocity at this point in time,
///      wait until the beginning of the next frame and go back to step 1.
///   5. Delegate loading the image to the wrapped provider and finish.
///
/// If the cycle ends at steps 1 or 3, the [ImageStream] will never be marked as
/// complete and listeners will not be notified.
///
/// The [Image] widget wraps its incoming providers with this provider to avoid
/// overutilization of resources for images that would never appear on screen or
/// only be visible for a very brief period.
@optionalTypeArgs
class ScrollAwareImageProvider<T> extends ImageProvider<T> {
  /// Creates a [ScrollingAwareImageProvider].
  ///
  /// The [context] object is the [BuildContext] of the [State] using this
  /// provider. It is used to determine scrolling velocity during [resolve]. It
  /// must not be null.
  ///
  /// The [imageProvider] is used to create a key and load the image. It must
  /// not be null, and is assumed to interact with the cache in the normal way
  /// that [ImageProvider.resolveStreamForKey] does.
  const ScrollAwareImageProvider({
    @required this.context,
    @required this.imageProvider,
  }) : assert(context != null),
       assert(imageProvider != null);

  /// The context that may or may not be enclosed by a [Scrollable].
  ///
  /// Once [DisposableBuildContext.dispose] is called on this context,
  /// the provider will stop trying to resolve the image if it has not already
  /// been resolved.
  final DisposableBuildContext context;

  /// The wrapped image provider to delegate [obtainKey] and [load] to.
  final ImageProvider<T> imageProvider;

  @override
  void resolveStreamForKey(
    ImageConfiguration configuration,
    ImageStream stream,
    T key,
    ImageErrorListener handleError,
  ) {
    // Something managed to complete the stream. Nothing left to do.
    if (stream.completer != null) {
      return;
    }
    // Something else got this image into the cache. Return it.
    if (PaintingBinding.instance.imageCache.containsKey(key)) {
      imageProvider.resolveStreamForKey(configuration, stream, key, handleError);
    }
    // The context has gone out of the tree - ignore it.
    if (context.context == null) {
      return;
    }
    // Something still wants this image, but check if the context is scrolling
    // too fast before scheduling work that might never show on screen.
    // Try to get to end of the frame callbacks of the next frame, and then
    // check again.
    if (Scrollable.recommendDeferredLoadingForContext(context.context)) {
        SchedulerBinding.instance.scheduleFrameCallback((_) {
          scheduleMicrotask(() => resolveStreamForKey(configuration, stream, key, handleError));
        });
        return;
    }
    // We are in the tree, we're not scrolling too fast, the cache doens't
    // have our image, and no one has otherwise completed the stream.  Go.
    imageProvider.resolveStreamForKey(configuration, stream, key, handleError);
  }

  @override
  ImageStreamCompleter load(T key, DecoderCallback decode) => imageProvider.load(key, decode);

  @override
  Future<T> obtainKey(ImageConfiguration configuration) => imageProvider.obtainKey(configuration);
}
