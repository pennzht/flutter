// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '../../../dev/benchmarks/macrobenchmarks/lib/src/web/recorder.dart';


import 'package:flutter_driver/driver_extension.dart';
import 'package:hello_world/main.dart' as app;
import '../../../dev/benchmarks/macrobenchmarks/lib/main.dart';

void main() {
  enableFlutterDriverExtension();

  app.main();
}


typedef RecorderFactory = Recorder Function();

Future<void> main() async {

  /*

  // Check if the benchmark server wants us to run a specific benchmark.
  final html.HttpRequest request = await requestXhr(
    '/next-benchmark',
    method: 'POST',
    mimeType: 'application/json',
    sendData: json.encode(benchmarks.keys.toList()),
  );

  // 404 is expected in the following cases:
  // - The benchmark is ran using plain `flutter run`, which does not provide "next-benchmark" handler.
  // - We ran all benchmarks and the benchmark is telling us there are no more benchmarks to run.
  if (request.status == 404) {
    _fallbackToManual('The server did not tell us which benchmark to run next.');
    return;
  }

  final String benchmarkName = request.responseText;

   */

  final String benchmarkName = 'bench_card_infinite_scroll';


  print('running benchmark $benchmarkName');

  await _runBenchmark(benchmarkName);
  // html.window.location.reload();
}

Future<void> _runBenchmark(String benchmarkName) async {

  print('running benchmark $benchmarkName >>>');
  final RecorderFactory recorderFactory = benchmarks[benchmarkName];

  if (recorderFactory == null) {
    print('recorderFactory is null');
    _fallbackToManual('Benchmark $benchmarkName not found.');
    return;
  }
  print('recorderFactory is not null');

  final Recorder recorder = recorderFactory();

  try {
    print('isInManualMode = $isInManualMode');
    final Profile profile = await recorder.run();
    print('profile = $profile');
    print('profile.toJson() = ${profile.toJson()}');
    print('profile.scoreData = ${profile.scoreData}');
    print('profile.scoreData[...]/a = ${profile.scoreData["drawFrameDuration"].allValues}');
    print('profile.scoreData[...]/m = ${profile.scoreData["drawFrameDuration"].measuredValues}');
    /*
    if (!isInManualMode) {
      final html.HttpRequest request = await html.HttpRequest.request(
        '/profile-data',
        method: 'POST',
        mimeType: 'application/json',
        sendData: json.encode(profile.toJson()),
      );
      if (request.status != 200) {
        throw Exception(
          'Failed to report profile data to benchmark server. '
          'The server responded with status code ${request.status}.'
        );
      }
    } else {
      print(profile);
    }

     */
  } catch (error, stackTrace) {
    print('error: $error, stackTrace: $stackTrace');
  }
}
