// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_gallery/demo/shrine/model/product.dart';
import 'package:flutter_gallery/demo/shrine/supplemental/product_card.dart';

class DesktopProductCardColumn extends StatelessWidget {
  const DesktopProductCardColumn({
    @required this.columnCount,
    @required this.currentColumn,
    @required this.products,
  });

  final int columnCount;
  final int currentColumn;
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      const double spacerHeight = 44.0;

      final double heightOfCards = (constraints.biggest.height - spacerHeight) / 2.0;
      final double availableHeightForImages = heightOfCards - MobileProductCard.kTextBoxHeight;
      // Ensure the cards take up the available space as long as the screen is
      // sufficiently tall, otherwise fallback on a constant aspect ratio.
      /* final double imageAspectRatio = availableHeightForImages >= 0.0
        ? constraints.biggest.width / availableHeightForImages
        : 49.0 / 33.0; */
      const double imageAspectRatio = 49.0 / 33.0;

      final int currentColumnProductCount = (products.length - currentColumn - 1) ~/ columnCount + 1;
      final int currentColumnWidgetCount = max(2 * currentColumnProductCount - 1, 0);

      print('currentcolumn = $currentColumn');
      print('currentcolumnProductCount = $currentColumnProductCount');

      return Container(
        width: 186,
        child: Column(
          children: <Widget>[
            if (currentColumn % 2 == 1) Container(height: 84),
            ... (List<Widget>.generate(currentColumnWidgetCount, (int index) {
              if (index % 2 == 0) {
                return DesktopProductCard(
                  product: products[(index ~/ 2) * columnCount + currentColumn],
                );
              } else {
                return Container(
                  height: 24,
                );
              }
            })),
          ],
        ),
      );
    });
  }
}
