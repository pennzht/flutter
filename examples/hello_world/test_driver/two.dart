// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '../../../dev/benchmarks/macrobenchmarks/lib/src/web/recorder.dart';

import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:hello_world/main.dart' as app;

/* void main() {
  enableFlutterDriverExtension();

  app.main();
} */

typedef RecorderFactory = Recorder Function();

Future<void> main() async {
  print('main called');

  enableFlutterDriverExtension();

  const String benchmarkName = 'helloworldapp';

  print('running benchmark $benchmarkName');

  await _runBenchmark(benchmarkName);
  // html.window.location.reload();
}

Future<void> _runBenchmark(String benchmarkName) async {

  print('running benchmark $benchmarkName >>>');
  final RecorderFactory recorderFactory = () => HelloWorldApp();

  print('recorderFactory is not null');

  final Recorder recorder = recorderFactory();

  try {
    final Profile profile = await recorder.run();
    print('profile = $profile');
    print('profile.toJson() = ${profile.toJson()}');
    print('profile.scoreData = ${profile.scoreData}');

  } catch (error, stackTrace) {
    print('error: $error, stackTrace: $stackTrace');
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
