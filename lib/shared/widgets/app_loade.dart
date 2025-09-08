import 'dart:ui';

import 'package:books_discovery_app/core/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AppLoader {
  static Widget loaderWidget({Color? color}) {
    final finalColor = color ?? HexColor(ColorConstants.themeColor);
    return Center(
      child: SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(strokeWidth: 1.5, color: finalColor),
      ),
    );
  }
}
