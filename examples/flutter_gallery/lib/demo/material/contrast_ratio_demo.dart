// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

/// A simple app with black text on white background.
/// Passes the test, which is expected.
class ContrastRatioDemoUnmergedGood extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Text(
                'I am text one',
                style: TextStyle(color: Colors.black),
              ),
              Text(
                'And I am text two',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A simple app with white text on white background.
/// Fails the test, which is expected.
class ContrastRatioDemoUnmergedBad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Text(
                'I am text one',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'And I am text two',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A simple app with black text on white background,
/// using [MergeSemantics].
/// Passes the test, which is expected.
class ContrastRatioDemoMergedGood extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: MergeSemantics(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Text(
                  'I am text one',
                  style: TextStyle(color: Colors.black),
                ),
                Text(
                  'And I am text two',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A simple app with white text on white background,
/// using [MergeSemantics].
/// Passes the test, which is NOT expected.
///
/// This app does NOT satisfy WCAG guidelines, but is not caught
/// by [textContrastGuideline].
class ContrastRatioDemoMergedBad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: MergeSemantics(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Text(
                  'I am text one',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  'And I am text two',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
