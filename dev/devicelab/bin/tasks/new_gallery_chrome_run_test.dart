// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io' as io;
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_static/shelf_static.dart';

import 'package:flutter_devicelab/framework/browser.dart';
import 'package:flutter_devicelab/framework/framework.dart';
import 'package:flutter_devicelab/framework/utils.dart';

/// The port number used by the local benchmark server.
const int benchmarkServerPort = 9999;

/// Runs all Web benchmarks using the HTML rendering backend.
Future<void> main() async {
  await task(const NewGalleryChromeRunTest().run);
}

class NewGalleryChromeRunTest {
  const NewGalleryChromeRunTest();

  Future<TaskResult> run() async {
    await gitClone(path: 'temp', repo: 'https://github.com/flutter/gallery.git');

    await inDirectory<TaskResult>('temp/gallery', () async {
      await flutter('doctor');
      await flutter('packages', options: <String>['get']);

      await evalFlutter('build', options: <String>[
        'web',
        '-v',
        '--release',
        '--no-pub',
      ], environment: <String, String>{
        'FLUTTER_WEB': 'true',
      });

      io.HttpServer server;
      final Cascade cascade = Cascade().add(createStaticHandler('temp/gallery/build/web'));
      server = await io.HttpServer.bind('localhost', benchmarkServerPort);

      Chrome chrome;

      shelf_io.serveRequests(server, cascade.handler);

      final ChromeOptions options = ChromeOptions(
        url: 'http://localhost:$benchmarkServerPort/index.html',
        windowHeight: 1024,
        windowWidth: 1024,
        headless: false,
      );

      chrome = await Chrome.launch(
        options,
        onError: (dynamic error) {print('error $error happened');},
        workingDirectory: cwd,
      );

      await Future<String>.delayed(Duration(seconds: 5), () => 'done');

      server?.close();
      chrome?.stop();

      return null;
    });

    await removePath('temp');

    return TaskResult.success(<String, dynamic>{}, benchmarkScoreKeys: <String>[]);
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
