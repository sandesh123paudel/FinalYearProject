import 'package:flutter/material.dart';
import '../constants/util/util.dart';

class ResponsiveText extends StatelessWidget {
  const ResponsiveText(
      this.text, {super.key,
        this.fontSize = 14,
        this.textColor,
        this.fontWeight,
        this.textAlign = TextAlign.start,
        this.fontFamily,
        this.height,
        this.fontStyle,
        this.textOverflow,
        this.maxLines, this.style,
        this.decoration,
      });

  final double fontSize;
  final String text;
  final Color? textColor;
  final TextAlign textAlign;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final TextOverflow? textOverflow;
  final FontStyle? fontStyle;
  final double? height;
  final int? maxLines;
  final TextStyle? style;
  final TextDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      textScaleFactor: 1,
      style: style ?? Theme.of(context).textTheme.bodyText2?.copyWith(
          color: textColor,
          fontFamily: fontFamily?? 'RobotoMono',
          fontSize: getResponsiveFont(fontSize),
          fontWeight: fontWeight,
          decoration: decoration,
          height: height,
          overflow: textOverflow,
          fontStyle: fontStyle),
      maxLines: maxLines,
    );
  }
}