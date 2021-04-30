import 'package:flutter/material.dart';

abstract class Descendant {
  Widget getWidget();
}

abstract class DescendantList {
  List<Widget> getWidgetList();
}

abstract class AppActions {
  Function getAction(String name);
  Function getWidget(String name);
}
