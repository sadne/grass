import 'package:flutter/material.dart';

class GsColors {
  static GsColors of(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return GsColors(isLight);
  }

  GsColors(this.isLight);
  bool isLight;

  Color get primary => isLight ? Color(0xFF409EFF) : Color(0xFF409EFF);
  Color get white => isLight ? Color(0xFFFFFFFF) : Color(0xFFB8B8B8);
  Color get black => isLight ? Color(0xFF222222) : Color(0xFFB8B8B8);
  Color get red => isLight ? Color(0xFFEC352D) : Color(0xFFEC352D);
  Color get green => isLight ? Color(0xFF00CF67) : Color(0xFFEC352D);
  Color get gray => isLight ? Color(0xFFC6C6C6) : Color(0xFF666666);
  Color get grayB => isLight ? Color(0xFF777777) : Color(0xFF666666);
  Color get text => isLight ? Color(0xFF222222) : Color(0xFFB8B8B8);
  Color get background => isLight ? Color(0xFFFFFFFF) : Color(0xFF1F1F1F);
  Color get backgroundGray => isLight ? Color(0xFFF6F6F6) : Color(0xFF1F1F1F);
  Color get backgroundGrayB => isLight ? Color(0xFFE6E7E9) : Color(0xFF1F1F1F);
}
