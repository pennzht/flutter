// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_gallery/demo/material/menu_demo.dart';
import 'package:flutter_gallery/gallery/themes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Menu icon satisfies accessibility contrast ratio guidelines, light mode', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: kLightGalleryTheme,
      home: const MenuDemo(),
    ));

    await expectLater(tester, meetsGuideline(textContrastGuideline));

    await expectLater(tester, meetsGuideline(CustomContrastGuideline(finder: find.byWidgetPredicate((Widget widget) => widget is Icon))));
  });

  testWidgets('Menu icon satisfies accessibility contrast ratio guidelines, dark mode', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: kDarkGalleryTheme,
      home: const MenuDemo(),
    ));

    await expectLater(tester, meetsGuideline(textContrastGuideline));

    await expectLater(tester, meetsGuideline(CustomContrastGuideline(finder: find.byWidgetPredicate((Widget widget) => widget is Icon))));
  });
}
