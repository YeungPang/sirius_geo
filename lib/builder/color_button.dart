import 'package:flutter/material.dart';
import 'package:sirius_geo/builder/abstraction.dart';

class ColorButton extends StatelessWidget {
  final Map<String, dynamic> map;

  ColorButton(this.map);
  @override
  Widget build(BuildContext context) {
    double borderRadius = map["btnBRadius"] ?? 10.0;
    dynamic d = map["child"];
    Descendant descendant = (d is Widget) ? null : d;
    Gradient g = (map["beginColor"] == null)
        ? null
        : LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [map["beginColor"], map["endColor"]]);
    Color c = map["color"] as Color;
    BoxBorder b = (map["borderColor"] == null)
        ? null
        : Border.all(
            color: map["borderColor"], width: map["borderWidth"] ?? 1.0);

    BoxDecoration box = BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      border: b,
      color: c,
      gradient: g,
      boxShadow: (map["noShadow"] != null)
          ? null
          : [
              BoxShadow(
                color: Colors.grey[400],
                offset: Offset(
                  2, // Move to right 10  horizontally
                  2, // Move to bottom 10 Vertically
                ),
              )
            ],
    );
    return Container(
      alignment: map["cbAlignment"] ?? Alignment.center,
      height: map["height"] ?? null,
      width: map["width"] ?? null,
      decoration: box,
      child: ((d is Widget) || (d == null)) ? d : descendant.getWidget(),
    );
  }
}
