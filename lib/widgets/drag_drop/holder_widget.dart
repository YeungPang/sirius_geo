import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class HolderWidget extends StatelessWidget {
  final Map<String, dynamic> map;

  HolderWidget(this.map);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: DottedBorder(
        color: map["color"],
        dashPattern: map["dashPattern"] ?? const [4, 4],
        strokeWidth: map["strokeWidth"] ?? 1,
        borderType: BorderType.RRect,
        radius: map["radius"] ?? const Radius.circular(10),
        child: map["child"],
      ),
    );
  }
}
