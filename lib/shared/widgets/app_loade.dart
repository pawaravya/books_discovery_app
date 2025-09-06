import 'dart:ui';

import 'package:flutter/material.dart';

class AppLoader {
  static Widget loaderWidget({
    Color? color = Colors.white,
  }) {
    return Center(
      child: SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(strokeWidth: 1.5, color: color),
      ),
    );
  }
}
