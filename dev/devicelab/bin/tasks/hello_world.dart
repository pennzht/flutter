import 'dart:async';

import 'package:flutter_devicelab/framework/framework.dart';

Future<void> main() async {
  await task(() async {
    return TaskResult.success(
      <String, dynamic>{
        'message': 'Hey, the test is a success!',
        'mails': 500,
        'e': 2.718281828,
        'wind': true,
        'list': [1, 2, 3],
        'thing': <String, int>{'one': 1, 'two': 2, 'three': 3},
      },
    );
  });
}


