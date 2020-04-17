// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_driver/driver_extension.dart';
import 'package:hello_world/main.dart' as app;

Future<String> _handler (String s) async {
  print('report: $s');
  return 'report: $s';
}

Future<void> main() async {
  print('main called\nmain called\nmain called\n');

  enableFlutterDriverExtension(handler: _handler);

  print('line 13\nline 13\nline 13\n');

  app.main();

  print('line 17\nline 17\nline 17\n');
}
