import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plantdiseaseidentifcationml/app_color.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final bool? softWrap;
  final TextOverflow? overflow;
  final int? maxLines;
  final IconData? icon;
  final bool? iconBeforeText;
  final double? iconSize;
  final String? svgIconPath;
  final Color? iconColor; // New property for icon color

  const TextWidget({
    Key? key,
    required this.text,
    this.fontSize,
    this.color,
    this.fontWeight,
    this.textStyle,
    this.textAlign,
    this.textDirection,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.icon,
    this.iconBeforeText,
    this.iconSize,
    this.svgIconPath,
    this.iconColor, // Initialize the new property
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    if ((icon != null || svgIconPath != null) && iconBeforeText == true) {
      if (svgIconPath != null) {
        children.add(SvgPicture.asset(
          svgIconPath!,
          color: iconColor ?? color ?? Colors.black,
          width: iconSize ?? fontSize ?? 14,
          height: iconSize ?? fontSize ?? 14,
        ));
      } else if (icon != null) {
        children.add(Icon(icon,
            color: iconColor ?? color ?? Colors.black,
            size: iconSize ?? fontSize ?? 14));
      }
    }

    children.add(Text(
      (icon != null || svgIconPath != null) && iconBeforeText == true
          ? " " + text
          : text,
      style: GoogleFonts.raleway(
        textStyle: textStyle ?? Theme.of(context).textTheme.displayLarge,
        fontSize: fontSize ?? 14,
        color: color ?? Colors.black,
        fontWeight: fontWeight ?? FontWeight.normal,
      ),
      textAlign: textAlign,
      textDirection: textDirection,
      softWrap: softWrap,
      overflow: overflow,
      maxLines: maxLines,
    ));

    if ((icon != null || svgIconPath != null) && iconBeforeText != true) {
      if (svgIconPath != null) {
        children.add(SvgPicture.asset(
          svgIconPath!,
          color: iconColor ?? color ?? Colors.black,
          width: iconSize ?? fontSize ?? 14,
          height: iconSize ?? fontSize ?? 14,
        ));
      } else if (icon != null) {
        children.add(Icon(icon,
            color: iconColor ?? color ?? Colors.black,
            size: iconSize ?? fontSize ?? 14));
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}
