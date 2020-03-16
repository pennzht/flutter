// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert' show json;
import 'dart:io';

import '../../lib/framework/framework.dart';
import '../../lib/framework/utils.dart';

Future<void> main() async {
  await task(const StartupTest('temp/gallery').run);
}

/// Measure application startup performance.
class StartupTest {
  const StartupTest(this.testDirectory, { this.reportMetrics = true });

  final String testDirectory;
  final bool reportMetrics;

  Future<TaskResult> run() async {
    await gitClone(path: 'temp', repo: 'https://github.com/flutter/gallery.git');

    final TaskResult taskResult = await inDirectory<TaskResult>('temp/gallery', () async {
      const String deviceId = 'chrome';
      await flutter('packages', options: <String>['get']);

      await flutter('run', options: <String>[
        '--verbose',
        '--profile',
        '--trace-startup',
        '-d',
        deviceId,
      ]);
      final Map<String, dynamic> data = json.decode(
        file('$testDirectory/build/start_up_info.json').readAsStringSync(),
      ) as Map<String, dynamic>;

      if (!reportMetrics)
        return TaskResult.success(data);

      return TaskResult.success(data, benchmarkScoreKeys: <String>[
        'timeToFirstFrameMicros',
        'timeToFirstFrameRasterizedMicros',
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
