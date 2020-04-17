// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:macrobenchmarks/src/web/recorder.dart';

import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:hello_world/main.dart' as app;

typedef RecorderFactory = Recorder Function();

final List<String> messages = <String>[];

void mprint(String s) {
  print(s);
  messages.add(s);
}

Future<String> _handler (String s) async {
  final String ans = messages.join('\n');
  messages.clear();
  return ans;
}

Future<void> main() async {
  mprint('main called');

  enableFlutterDriverExtension(handler: _handler);

  const String benchmarkName = 'helloworldapp';

  mprint('running benchmark $benchmarkName');

  mprint('Initial message');

  await _runBenchmark(benchmarkName);
  // html.window.location.reload();
}

Future<void> _runBenchmark(String benchmarkName) async {

  mprint('running benchmark $benchmarkName >>>');

  final RecorderFactory recorderFactory = () => HelloWorldApp();

  mprint('recorderFactory is not null');

  final Recorder recorder = recorderFactory();

  try {
    final Profile profile = await recorder.run();
    mprint('success');
    // mprint(profile.toJson().toString());
  } catch (error, stackTrace) {
    mprint('error: $error, stackTrace: $stackTrace');
  }
}

/// Creates an infinite list of Material cards and scrolls it.
class HelloWorldApp extends WidgetRecorder {
  // WidgetRecorder.

  HelloWorldApp() : super(name: benchmarkName);

  static const String benchmarkName = 'helloworldapp';

  @override
  Widget createWidget () {
    mprint('Creates widget');
    return app.hello();
  }
}
