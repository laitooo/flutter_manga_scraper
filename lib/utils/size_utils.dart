import 'package:flutter/material.dart';

class SizeUtils {
  double width = 0;
  double height = 0;

  void init(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
  }

  double horizontalWrapPadding(int cardWidth, [int spacing = 10]) {
    final b = width ~/ cardWidth;
    final c = width + spacing - (b * cardWidth);
    return c / 2;
  }
}

final SizeUtils sizeUtils = SizeUtils();
