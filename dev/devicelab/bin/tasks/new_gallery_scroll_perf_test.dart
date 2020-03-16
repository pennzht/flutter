// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert' show json;
import 'dart:io';

import '../../lib/framework/adb.dart';
import '../../lib/framework/framework.dart';
import '../../lib/framework/ios.dart';
import '../../lib/framework/utils.dart';

Future<void> main() async {
  await task(CustomPerfTest(
    'temp/gallery',
    'test_driver/scroll_perf.dart',
    'home_scroll_perf',
  ).run);
}

/// Measures application runtime performance, specifically per-frame
/// performance.
class CustomPerfTest {
  const CustomPerfTest(
      this.testDirectory,
      this.testTarget,
      this.timelineFileName,
      {this.needsMeasureCpuGPu = false});

  final String testDirectory;
  final String testTarget;
  final String timelineFileName;

  final bool needsMeasureCpuGPu;

  Future<TaskResult> run() async {
    await gitClone(path: 'temp', repo: 'https://github.com/flutter/gallery.git');

    final TaskResult taskResult = await inDirectory<TaskResult>('temp/gallery', () async {
      const String deviceId = 'chrome';
      await flutter('packages', options: <String>['get']);

      await flutter('drive', options: <String>[
        '-v',
        '--profile',
        '--trace-startup', // Enables "endless" timeline event buffering.
        '-d',
        deviceId,
      ]);
      final Map<String, dynamic> data = json.decode(
        file('$testDirectory/build/$timelineFileName.timeline_summary.json').readAsStringSync(),
      ) as Map<String, dynamic>;

      if (data['frame_count'] as int < 5) {
        return TaskResult.failure(
          'Timeline contains too few frames: ${data['frame_count']}. Possibly '
              'trace events are not being captured.',
        );
      }

      if (needsMeasureCpuGPu) {
        await inDirectory<void>('$testDirectory/build', () async {
          data.addAll(await measureIosCpuGpu(deviceId: deviceId));
        });
      }

      return TaskResult.success(data, benchmarkScoreKeys: <String>[
        'average_frame_build_time_millis',
        'worst_frame_build_time_millis',
        'missed_frame_build_budget_count',
        '90th_percentile_frame_build_time_millis',
        '99th_percentile_frame_build_time_millis',
        'average_frame_rasterizer_time_millis',
        'worst_frame_rasterizer_time_millis',
        'missed_frame_rasterizer_budget_count',
        '90th_percentile_frame_rasterizer_time_millis',
        '99th_percentile_frame_rasterizer_time_millis',
        if (needsMeasureCpuGPu) 'cpu_percentage',
        if (needsMeasureCpuGPu) 'gpu_percentage',
      ]);
    });

    await removePath('temp');

    return taskResult;
  }

  Future<void> gitClone({String path, String repo}) async {
    if (Directory(path).existsSync()) {
      removePath(path);
    }

    await Directory(path).create(recursive: true);

    await inDirectory(path, () async{
      await exec('git', <String>['clone', repo]);
    });
  }

  Future<void> removePath(String path) async {
    await Directory(path).delete(recursive: true);
  }
}
