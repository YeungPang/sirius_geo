import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:json_theme/json_theme.dart';
import 'package:sirius_geo/resources/fonts.dart';
import 'package:sirius_geo/resources/basic_resources.dart';

TextStyle decodeTextStyle(dynamic v) {
  return (v is String)
      ? textStyle[v]
      : ThemeDecoder.decodeTextStyle(v, validate: false);
}

Locale decodeLocale(dynamic v) {
  return ThemeDecoder.decodeLocale(v, validate: false);
}

TextOverflow decodeTextOverflow(dynamic v) {
  return ThemeDecoder.decodeTextOverflow(v, validate: false);
}

Alignment decodeAlignment(dynamic v) {
  if (v is Map<String, dynamic>) {
    return Alignment(v["horiz"], v["vert"]);
  }
  return ThemeDecoder.decodeAlignment(v, validate: false);
}

AppBarTheme decodeAppBarTheme(dynamic v) {
  return ThemeDecoder.decodeAppBarTheme(v, validate: false);
}

Color decodeColor(dynamic v) {
  return ((v is String) && (colorMap[v] != null))
      ? colorMap[v]
      : ThemeDecoder.decodeColor(v, validate: false);
}

StrutStyle decodeStrutStyle(dynamic v) {
  return ThemeDecoder.decodeStrutStyle(v, validate: false);
}

TextAlign decodeTextAlign(dynamic v) {
  return ThemeDecoder.decodeTextAlign(v, validate: false);
}

TextDirection decodeTextDirection(dynamic v) {
  return ThemeDecoder.decodeTextDirection(v, validate: false);
}

TextHeightBehavior decodeTextHeightBehavior(dynamic v) {
  return ThemeDecoder.decodeTextHeightBehavior(v, validate: false);
}

TextWidthBasis decodeTextWidthBasis(dynamic v) {
  return ThemeDecoder.decodeTextWidthBasis(v, validate: false);
}

TextTheme decodeTextTheme(dynamic v) {
  return ThemeDecoder.decodeTextTheme(v, validate: false);
}

DragStartBehavior decodeDragStartBehavior(dynamic v) {
  return ThemeDecoder.decodeDragStartBehavior(v, validate: false);
}

FloatingActionButtonAnimator decodeFloatingActionButtonAnimator(dynamic v) {
  return ThemeDecoder.decodeFloatingActionButtonAnimator(v, validate: false);
}

FloatingActionButtonLocation decodeFloatingActionButtonLocation(dynamic v) {
  return ThemeDecoder.decodeFloatingActionButtonLocation(v, validate: false);
}

CrossAxisAlignment decodeCrossAxisAlignment(dynamic v) {
  return ThemeDecoder.decodeCrossAxisAlignment(v, validate: false);
}

MainAxisAlignment decodeMainAxisAlignment(dynamic v) {
  return ThemeDecoder.decodeMainAxisAlignment(v, validate: false);
}

MainAxisSize decodeMainAxisSize(dynamic v) {
  return ThemeDecoder.decodeMainAxisSize(v, validate: false);
}

TextBaseline decodeTextBaseline(dynamic v) {
  return ThemeDecoder.decodeTextBaseline(v, validate: false);
}

VerticalDirection decodeVerticalDirection(dynamic v) {
  return ThemeDecoder.decodeVerticalDirection(v, validate: false);
}

IconThemeData decodeIconThemeData(dynamic v) {
  return ThemeDecoder.decodeIconThemeData(v, validate: false);
}

Brightness decodeBrightness(dynamic v) {
  return ThemeDecoder.decodeBrightness(v, validate: false);
}

ShapeBorder decodeShapeBorder(dynamic v) {
  return ThemeDecoder.decodeShapeBorder(v, validate: false);
}

FilterQuality decodeFilterQuality(dynamic v) {
  return ThemeDecoder.decodeFilterQuality(v, validate: false);
}

BlendMode decodeBlendMode(dynamic v) {
  return ThemeDecoder.decodeBlendMode(v, validate: false);
}

BoxFit decodeBoxFit(dynamic v) {
  return ThemeDecoder.decodeBoxFit(v, validate: false);
}

ImageRepeat decodeImageRepeat(dynamic v) {
  return ThemeDecoder.decodeImageRepeat(v, validate: false);
}

StackFit decodeStackFit(dynamic v) {
  return ThemeDecoder.decodeStackFit(v, validate: false);
}

BoxConstraints decodeBoxConstraints(dynamic v) {
  return ThemeDecoder.decodeBoxConstraints(v, validate: false);
}

BoxDecoration decodeBoxDecoration(dynamic v) {
  return ThemeDecoder.decodeBoxDecoration(v, validate: false);
}

EdgeInsetsGeometry decodeEdgeInsetsGeometry(dynamic v) {
  return ThemeDecoder.decodeEdgeInsetsGeometry(v, validate: false);
}

Matrix4 decodeMatrix4(dynamic v) {
  return ThemeDecoder.decodeMatrix4(v, validate: false);
}

Axis decodeAxis(dynamic v) {
  return ThemeDecoder.decodeAxis(v, validate: false);
}

Clip decodeClip(dynamic v) {
  return ThemeDecoder.decodeClip(v, validate: false);
}

BorderRadius decodeBorderRadius(dynamic v) {
  return ThemeDecoder.decodeBorderRadius(v, validate: false);
}
// Border decodeBorder(dynamic v) {
//   return ThemeDecoder.decodeBoxBorder(v, validate: false);
// }

Function getThemeDecoder(String name) {
  if (name == "color" || name.endsWith("Color")) {
    return decodeColor;
  }
  return themeDecoder[name];
}

const Map<String, Function> themeDecoder = {
  "actionsIconTheme": decodeIconThemeData,
  "align": decodeAlignment,
  "alignment": decodeAlignment,
  "appBarTheme": decodeAppBarTheme,
  "borderRadius": decodeBorderRadius,
  "boxConstraints": decodeBoxConstraints,
  "boxDecoration": decodeBoxDecoration,
  "boxFit": decodeBoxFit,
  "brightness": decodeBrightness,
  "clip": decodeClip,
  "colorBlendMode": decodeBlendMode,
  "crossAxisAlignment": decodeCrossAxisAlignment,
  "decoration": decodeBoxDecoration,
  "direction": decodeAxis,
  "dragStartBehavior": decodeDragStartBehavior,
  "drawerDragStartBehavior": decodeDragStartBehavior,
  "filterQuality ": decodeFilterQuality,
  "floatingActionButtonAnimator": decodeFloatingActionButtonAnimator,
  "floatingActionButtonLocation": decodeFloatingActionButtonLocation,
  "foregroundDecoration": decodeBoxDecoration,
  "iconTheme": decodeIconThemeData,
  "locale": decodeLocale,
  "mainAxisAlignment": decodeMainAxisAlignment,
  "mainAxisSize": decodeMainAxisSize,
  "margin": decodeEdgeInsetsGeometry,
  "padding": decodeEdgeInsetsGeometry,
  "wrapperPadding": decodeEdgeInsetsGeometry,
  "repeat": decodeImageRepeat,
  "shape": decodeShapeBorder,
  "stackFit": decodeStackFit,
  "strutStyle": decodeStrutStyle,
  "textAlign": decodeTextAlign,
  "textDirection": decodeTextDirection,
  "textHeightBehavior": decodeTextHeightBehavior,
  "textOverflow": decodeTextOverflow,
  "textStyle": decodeTextStyle,
  "textWidthBasis": decodeTextWidthBasis,
  "textTheme": decodeTextTheme,
  "textBaseline": decodeTextBaseline,
  "transform": decodeMatrix4,
  "verticalDirection": decodeVerticalDirection,
};
