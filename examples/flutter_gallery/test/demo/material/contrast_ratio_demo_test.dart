// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_gallery/demo/material/contrast_ratio_demo.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Unmerged good demo.', (WidgetTester tester) async {
    await tester.pumpWidget(ContrastRatioDemoUnmergedGood());

    expect(tester, meetsGuideline(textContrastGuideline));
  });

  testWidgets('Unmerged bad demo.', (WidgetTester tester) async {
    await tester.pumpWidget(ContrastRatioDemoUnmergedBad());

    expect(tester, meetsGuideline(textContrastGuideline));
  });

  testWidgets('Merged good demo.', (WidgetTester tester) async {
    await tester.pumpWidget(ContrastRatioDemoMergedGood());

    expect(tester, meetsGuideline(textContrastGuideline));
  });

  testWidgets('Merged bad demo.', (WidgetTester tester) async {
    await tester.pumpWidget(ContrastRatioDemoMergedBad());

    expect(tester, meetsGuideline(textContrastGuideline));
  });
}
