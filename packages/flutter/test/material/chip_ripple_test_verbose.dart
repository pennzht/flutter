// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' show window;

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import '../rendering/mock_canvas.dart';

RenderBox getMaterialBox(WidgetTester tester) {
  return tester.firstRenderObject<RenderBox>(
    find.descendant(
      of: find.byType(RawChip),
      matching: find.byType(CustomPaint),
    ),
  );
}

/// Adds the basic requirements for a Chip.
Widget _wrapForChip({
  Widget child,
  TextDirection textDirection = TextDirection.ltr,
  double textScaleFactor = 1.0,
  Brightness brightness = Brightness.light,
}) {
  return MaterialApp(
    theme: ThemeData(brightness: brightness),
    home: Directionality(
      textDirection: textDirection,
      child: MediaQuery(
        data: MediaQueryData.fromWindow(window).copyWith(textScaleFactor: textScaleFactor),
        child: Material(child: child),
      ),
    ),
  );
}

Widget _chipWithOptionalDeleteButton({
  UniqueKey deleteButtonKey,
  UniqueKey labelKey,
  bool deletable,
  TextDirection textDirection = TextDirection.ltr,
}){
  return _wrapForChip(
    textDirection: textDirection,
    child: Wrap(
      children: <Widget>[
        RawChip(
          onPressed: () {},
          onDeleted: deletable ? () {} : null,
          deleteIcon: Icon(Icons.close, key: deleteButtonKey),
          label: Text(
            deletable
              ? 'Chip with Delete Button'
              : 'Chip without Delete Button',
            key: labelKey,
          ),
        ),
      ],
    ),
  );
}

bool offsetsAreClose(Offset a, Offset b) => (a - b).distance < 1.0;
bool radiiAreClose(double a, double b) => (a - b).abs() < 1.0;

// Ripple pattern matches if there exists at least one ripple
// with the [expectedCenter] and [expectedRadius].
// This ensures the existence of a ripple.
PaintPattern ripplePattern(Offset expectedCenter, double expectedRadius) {
  return paints
    ..something((Symbol method, List<dynamic> arguments) {
        if (method != #drawCircle)
          return false;
        final Offset center = arguments[0];
        final double radius = arguments[1];
        return offsetsAreClose(center, expectedCenter) && radiiAreClose(radius, expectedRadius);
      }
    );
}

void main() {
  // Test 11 times, each time using a different way to wait 200ms.
  // The first 3 tests succeed; the remaining 8 fail.
  // The only difference between tests is the way to wait 200ms.

  testWidgets('Test 1 - 100ms, 100ms', (WidgetTester tester) async {
    // Creates a chip with a delete button.
    final UniqueKey labelKey = UniqueKey();
    final UniqueKey deleteButtonKey = UniqueKey();

    await tester.pumpWidget(
      _chipWithOptionalDeleteButton(
        labelKey: labelKey,
        deleteButtonKey: deleteButtonKey,
        deletable: true,
      ),
    );

    final RenderBox box = getMaterialBox(tester);

    // Taps at a location close to the center of the delete icon.
    final Offset centerOfDeleteButton = tester.getCenter(find.byKey(deleteButtonKey));
    final Offset tapLocationOfDeleteButton = centerOfDeleteButton + const Offset(-10, -10);
    final TestGesture gesture = await tester.startGesture(tapLocationOfDeleteButton);
    await tester.pump();

    // Waits for 200 ms.
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));

    // There should be one unique ink ripple
    // with center (3.0, 3.0) and radius 3.5
    expect(box, ripplePattern(const Offset(3.0, 3.0), 3.5));

    await gesture.up();
  }, skip: isBrowser);

  testWidgets('Test 2 - 50ms, 50ms, 50ms, 50ms', (WidgetTester tester) async {
    // Creates a chip with a delete button.
    final UniqueKey labelKey = UniqueKey();
    final UniqueKey deleteButtonKey = UniqueKey();

    await tester.pumpWidget(
      _chipWithOptionalDeleteButton(
        labelKey: labelKey,
        deleteButtonKey: deleteButtonKey,
        deletable: true,
      ),
    );

    final RenderBox box = getMaterialBox(tester);

    // Taps at a location close to the center of the delete icon.
    final Offset centerOfDeleteButton = tester.getCenter(find.byKey(deleteButtonKey));
    final Offset tapLocationOfDeleteButton = centerOfDeleteButton + const Offset(-10, -10);
    final TestGesture gesture = await tester.startGesture(tapLocationOfDeleteButton);
    await tester.pump();

    // Waits for 200 ms.
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 50));

    // There should be one unique ink ripple
    // with center (3.0, 3.0) and radius 3.5
    expect(box, ripplePattern(const Offset(3.0, 3.0), 3.5));

    await gesture.up();
  }, skip: isBrowser);

  testWidgets('Test 3 - 20ms * 10', (WidgetTester tester) async {
    // Creates a chip with a delete button.
    final UniqueKey labelKey = UniqueKey();
    final UniqueKey deleteButtonKey = UniqueKey();

    await tester.pumpWidget(
      _chipWithOptionalDeleteButton(
        labelKey: labelKey,
        deleteButtonKey: deleteButtonKey,
        deletable: true,
      ),
    );

    final RenderBox box = getMaterialBox(tester);

    // Taps at a location close to the center of the delete icon.
    final Offset centerOfDeleteButton = tester.getCenter(find.byKey(deleteButtonKey));
    final Offset tapLocationOfDeleteButton = centerOfDeleteButton + const Offset(-10, -10);
    final TestGesture gesture = await tester.startGesture(tapLocationOfDeleteButton);
    await tester.pump();

    // Waits for 200 ms.
    await tester.pump(const Duration(milliseconds: 20));
    await tester.pump(const Duration(milliseconds: 20));
    await tester.pump(const Duration(milliseconds: 20));
    await tester.pump(const Duration(milliseconds: 20));
    await tester.pump(const Duration(milliseconds: 20));
    await tester.pump(const Duration(milliseconds: 20));
    await tester.pump(const Duration(milliseconds: 20));
    await tester.pump(const Duration(milliseconds: 20));
    await tester.pump(const Duration(milliseconds: 20));
    await tester.pump(const Duration(milliseconds: 20));

    // There should be one unique ink ripple
    // with center (3.0, 3.0) and radius 3.5
    expect(box, ripplePattern(const Offset(3.0, 3.0), 3.5));

    await gesture.up();
  }, skip: isBrowser);

  testWidgets('Test 4 - 200ms', (WidgetTester tester) async {
    // Creates a chip with a delete button.
    final UniqueKey labelKey = UniqueKey();
    final UniqueKey deleteButtonKey = UniqueKey();

    await tester.pumpWidget(
      _chipWithOptionalDeleteButton(
        labelKey: labelKey,
        deleteButtonKey: deleteButtonKey,
        deletable: true,
      ),
    );

    final RenderBox box = getMaterialBox(tester);

    // Taps at a location close to the center of the delete icon.
    final Offset centerOfDeleteButton = tester.getCenter(find.byKey(deleteButtonKey));
    final Offset tapLocationOfDeleteButton = centerOfDeleteButton + const Offset(-10, -10);
    final TestGesture gesture = await tester.startGesture(tapLocationOfDeleteButton);
    await tester.pump();

    // Waits for 200 ms.
    await tester.pump(const Duration(milliseconds: 200));

    // There should be one unique ink ripple
    // with center (3.0, 3.0) and radius 3.5
    expect(box, ripplePattern(const Offset(3.0, 3.0), 3.5));

    await gesture.up();
  }, skip: isBrowser);

  testWidgets('Test 5 - pump, 200ms', (WidgetTester tester) async {
    // Creates a chip with a delete button.
    final UniqueKey labelKey = UniqueKey();
    final UniqueKey deleteButtonKey = UniqueKey();

    await tester.pumpWidget(
      _chipWithOptionalDeleteButton(
        labelKey: labelKey,
        deleteButtonKey: deleteButtonKey,
        deletable: true,
      ),
    );

    final RenderBox box = getMaterialBox(tester);

    // Taps at a location close to the center of the delete icon.
    final Offset centerOfDeleteButton = tester.getCenter(find.byKey(deleteButtonKey));
    final Offset tapLocationOfDeleteButton = centerOfDeleteButton + const Offset(-10, -10);
    final TestGesture gesture = await tester.startGesture(tapLocationOfDeleteButton);
    await tester.pump();

    // Waits for 200 ms.
    await tester.pump(); // using one extra tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // There should be one unique ink ripple
    // with center (3.0, 3.0) and radius 3.5
    expect(box, ripplePattern(const Offset(3.0, 3.0), 3.5));

    await gesture.up();
  }, skip: isBrowser);

  testWidgets('Test 6 - 60ms, 140ms', (WidgetTester tester) async {
    // Creates a chip with a delete button.
    final UniqueKey labelKey = UniqueKey();
    final UniqueKey deleteButtonKey = UniqueKey();

    await tester.pumpWidget(
      _chipWithOptionalDeleteButton(
        labelKey: labelKey,
        deleteButtonKey: deleteButtonKey,
        deletable: true,
      ),
    );

    final RenderBox box = getMaterialBox(tester);

    // Taps at a location close to the center of the delete icon.
    final Offset centerOfDeleteButton = tester.getCenter(find.byKey(deleteButtonKey));
    final Offset tapLocationOfDeleteButton = centerOfDeleteButton + const Offset(-10, -10);
    final TestGesture gesture = await tester.startGesture(tapLocationOfDeleteButton);
    await tester.pump();

    // Waits for 200 ms.
    await tester.pump(const Duration(milliseconds: 60));
    await tester.pump(const Duration(milliseconds: 140));

    // There should be one unique ink ripple
    // with center (3.0, 3.0) and radius 3.5
    expect(box, ripplePattern(const Offset(3.0, 3.0), 3.5));

    await gesture.up();
  }, skip: isBrowser);

  testWidgets('Test 7 - 140ms, 60ms', (WidgetTester tester) async {
    // Creates a chip with a delete button.
    final UniqueKey labelKey = UniqueKey();
    final UniqueKey deleteButtonKey = UniqueKey();

    await tester.pumpWidget(
      _chipWithOptionalDeleteButton(
        labelKey: labelKey,
        deleteButtonKey: deleteButtonKey,
        deletable: true,
      ),
    );

    final RenderBox box = getMaterialBox(tester);

    // Taps at a location close to the center of the delete icon.
    final Offset centerOfDeleteButton = tester.getCenter(find.byKey(deleteButtonKey));
    final Offset tapLocationOfDeleteButton = centerOfDeleteButton + const Offset(-10, -10);
    final TestGesture gesture = await tester.startGesture(tapLocationOfDeleteButton);
    await tester.pump();

    // Waits for 200 ms.
    await tester.pump(const Duration(milliseconds: 140));
    await tester.pump(const Duration(milliseconds: 60));

    // There should be one unique ink ripple
    // with center (3.0, 3.0) and radius 3.5
    expect(box, ripplePattern(const Offset(3.0, 3.0), 3.5));

    await gesture.up();
  }, skip: isBrowser);

  testWidgets('Test 8 - 20ms, 180ms', (WidgetTester tester) async {
    // Creates a chip with a delete button.
    final UniqueKey labelKey = UniqueKey();
    final UniqueKey deleteButtonKey = UniqueKey();

    await tester.pumpWidget(
      _chipWithOptionalDeleteButton(
        labelKey: labelKey,
        deleteButtonKey: deleteButtonKey,
        deletable: true,
      ),
    );

    final RenderBox box = getMaterialBox(tester);

    // Taps at a location close to the center of the delete icon.
    final Offset centerOfDeleteButton = tester.getCenter(find.byKey(deleteButtonKey));
    final Offset tapLocationOfDeleteButton = centerOfDeleteButton + const Offset(-10, -10);
    final TestGesture gesture = await tester.startGesture(tapLocationOfDeleteButton);
    await tester.pump();

    // Waits for 200 ms.
    await tester.pump(const Duration(milliseconds: 20));
    await tester.pump(const Duration(milliseconds: 180));

    // There should be one unique ink ripple
    // with center (3.0, 3.0) and radius 3.5
    expect(box, ripplePattern(const Offset(3.0, 3.0), 3.5));

    await gesture.up();
  }, skip: isBrowser);

  testWidgets('Test 9 - 20ms, 60ms, 60ms, 60ms', (WidgetTester tester) async {
    // Creates a chip with a delete button.
    final UniqueKey labelKey = UniqueKey();
    final UniqueKey deleteButtonKey = UniqueKey();

    await tester.pumpWidget(
      _chipWithOptionalDeleteButton(
        labelKey: labelKey,
        deleteButtonKey: deleteButtonKey,
        deletable: true,
      ),
    );

    final RenderBox box = getMaterialBox(tester);

    // Taps at a location close to the center of the delete icon.
    final Offset centerOfDeleteButton = tester.getCenter(find.byKey(deleteButtonKey));
    final Offset tapLocationOfDeleteButton = centerOfDeleteButton + const Offset(-10, -10);
    final TestGesture gesture = await tester.startGesture(tapLocationOfDeleteButton);
    await tester.pump();

    // Waits for 200 ms.
    await tester.pump(const Duration(milliseconds: 20));
    await tester.pump(const Duration(milliseconds: 60));
    await tester.pump(const Duration(milliseconds: 60));
    await tester.pump(const Duration(milliseconds: 60));

    // There should be one unique ink ripple
    // with center (3.0, 3.0) and radius 3.5
    expect(box, ripplePattern(const Offset(3.0, 3.0), 3.5));

    await gesture.up();
  }, skip: isBrowser);

  testWidgets('Test 10 - pump * 5, 200ms', (WidgetTester tester) async {
    // Creates a chip with a delete button.
    final UniqueKey labelKey = UniqueKey();
    final UniqueKey deleteButtonKey = UniqueKey();

    await tester.pumpWidget(
      _chipWithOptionalDeleteButton(
        labelKey: labelKey,
        deleteButtonKey: deleteButtonKey,
        deletable: true,
      ),
    );

    final RenderBox box = getMaterialBox(tester);

    // Taps at a location close to the center of the delete icon.
    final Offset centerOfDeleteButton = tester.getCenter(find.byKey(deleteButtonKey));
    final Offset tapLocationOfDeleteButton = centerOfDeleteButton + const Offset(-10, -10);
    final TestGesture gesture = await tester.startGesture(tapLocationOfDeleteButton);
    await tester.pump();

    // Waits for 200 ms.
    await tester.pump();
    await tester.pump();
    await tester.pump();
    await tester.pump();
    await tester.pump(); // using 5 extra tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // There should be one unique ink ripple
    // with center (3.0, 3.0) and radius 3.5
    expect(box, ripplePattern(const Offset(3.0, 3.0), 3.5));

    await gesture.up();
  }, skip: isBrowser);

  testWidgets('Test 11 - 200ms, pump', (WidgetTester tester) async {
    // Creates a chip with a delete button.
    final UniqueKey labelKey = UniqueKey();
    final UniqueKey deleteButtonKey = UniqueKey();

    await tester.pumpWidget(
      _chipWithOptionalDeleteButton(
        labelKey: labelKey,
        deleteButtonKey: deleteButtonKey,
        deletable: true,
      ),
    );

    final RenderBox box = getMaterialBox(tester);

    // Taps at a location close to the center of the delete icon.
    final Offset centerOfDeleteButton = tester.getCenter(find.byKey(deleteButtonKey));
    final Offset tapLocationOfDeleteButton = centerOfDeleteButton + const Offset(-10, -10);
    final TestGesture gesture = await tester.startGesture(tapLocationOfDeleteButton);
    await tester.pump();

    // Waits for 200 ms.
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump();

    // There should be one unique ink ripple
    // with center (3.0, 3.0) and radius 3.5
    expect(box, ripplePattern(const Offset(3.0, 3.0), 3.5));

    await gesture.up();
  }, skip: isBrowser);

}
