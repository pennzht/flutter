// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '../../../dev/benchmarks/macrobenchmarks/lib/src/web/recorder.dart';

import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:hello_world/main.dart' as app;

typedef RecorderFactory = Recorder Function();

final List<String> messages = <String>[];

Future<String> _handler (String s) async {
  final String ans = messages.join('\n');
  messages.clear();
  return ans;
}

Future<void> main() async {
  messages.add('main called');

  enableFlutterDriverExtension(handler: _handler);

  const String benchmarkName = 'helloworldapp';

  messages.add('running benchmark $benchmarkName');

  messages.add('Initial message');

  await _runBenchmark(benchmarkName);
  // html.window.location.reload();
}

Future<void> _runBenchmark(String benchmarkName) async {

  messages.add('running benchmark $benchmarkName >>>');

  final RecorderFactory recorderFactory = () => HelloWorldApp();

  messages.add('recorderFactory is not null');

  final Recorder recorder = recorderFactory();

  try {
    final Profile profile = await recorder.run();
    messages.add(profile.toJson().toString());
  } catch (error, stackTrace) {
    messages.add('error: $error, stackTrace: $stackTrace');
  }
}

/// Creates an infinite list of Material cards and scrolls it.
class HelloWorldApp extends WidgetRecorder {
  // WidgetRecorder.

  HelloWorldApp() : super(name: benchmarkName);

  static const String benchmarkName = 'helloworldapp';

  @override
  Widget createWidget () => app.hello();
}
