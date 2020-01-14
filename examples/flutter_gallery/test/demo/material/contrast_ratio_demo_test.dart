// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_gallery/demo/material/contrast_ratio_demo.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Contrast ratio is correct.', (WidgetTester tester) async {
    await tester.pumpWidget(ContrastRatioDemo());

    expect(tester, meetsGuideline(textContrastGuideline));
  });
}
