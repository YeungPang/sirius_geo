import 'package:flutter/material.dart';
import 'package:sirius_geo/builder/wrappers.dart';

class ValueTypeListener<T> extends StatelessWidget {
  final Map<String, dynamic> map;

  ValueTypeListener(this.map);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T>(
      valueListenable: map["notifier"],
      builder: (BuildContext context, T value, Widget child) =>
          _getListnerWidget(value),
    );
  }

  Widget _getListnerWidget(T value) {
    String key = map["notifierKey"];
    if (key == null) {
      key = (value is List<Widget>) ? "children" : "child";
    }
    map[key] = value;
    map["widget"] = getWWidget("ValueTypeListener", map);
    return map["widget"];
  }
}
