import 'package:sirius_geo/builder/special_widgets.dart';
import 'package:sirius_geo/controller/process_controller.dart';
import 'package:sirius_geo/locator.dart';
import 'package:sirius_geo/builder/widgets.dart';
import 'package:flutter/material.dart';
import 'package:sirius_geo/resources/s_g_icons.dart';
import 'package:sirius_geo/builder/wrappers.dart';

final ProcessController controller = locator<ProcessController>();

setupMap(Map<String, dynamic> map) {
  Map<String, dynamic> mapping = map["buildMapping"];
  if (mapping != null) {
    mapping.forEach((key, value) {
      map[key] = controller.getContent(value as String, map);
    });
  }
  Map<String, dynamic> buildActions = map["buildActions"];
  if (buildActions != null) {
    controller.performActions(buildActions, map);
  }
}

Widget setupWidget(Map<String, dynamic> map) {
  setupMap(map);
  String builder = map["builder"];
  Function f = getWidget[builder];
  if (f == null) {
    f = controller.model.appActions.getWidget(builder);
  }
  return f(map);
}

Widget getBuilderWidget(Map<String, dynamic> map) {
  dynamic wrapper = map["wrapper"];
  if (wrapper != null) {
    return getWrappedWidget(wrapper, map);
  }
  return setupWidget(map);
}

List<Widget> getBuilderWidgetList(List<Map<String, dynamic>> list) {
  List<Widget> widgetList = [];
  for (var m in list) {
    widgetList.add(getBuilderWidget(m));
  }
  return widgetList;
}

Widget getWrappedWidget(dynamic wrapper, Map<String, dynamic> map) {
  if (wrapper is String) {
    return getWrapperWidget[wrapper](map);
  } else if (wrapper is List<dynamic>) {
    return getWrapperWidget[wrapper[0]](map);
  }
  return setupWidget(map);
}

const Map<String, Function> getWidget = {
  "AppBar": getAppBarWidget,
  "Center": getCenterWidget,
  "ColorButton": getColorButton,
  "Column": getColumnWidget,
  "Container": getContainer,
  "Draggable": getDraggable,
  "DragTarget": getDragTarget,
  "GridView": getGridView,
  "Icon": getIcon,
  "ImageAsset": getImageAsset,
  "ImageBanner": getImageBanner,
  "IndexedStack": getIndexedStack,
  "InTextField": getInTextField,
  "ListView": getListView,
  "RollingSwitch": getRollingSwitch,
  "Row": getRowWidget,
  "Scaffold": getScaffolWidget,
  "SingleChildScrollView": getSingleChildScrollView,
  "SizeBox": getSizeBox,
  "Stack": getStack,
  "SVGAsset": getSVGAsset,
  "TapListItem": getTapListItem,
  "Text": getTextWidger,
  "TextField": getTextField,
  "ValueStack": getValueStack,
};

const Map<String, Function> getWrapperWidget = {
  "Align": getAlign,
  "Badge": getBadge,
  "Card": getCard,
  "ClipRRect": getClipRRect,
  "DottedBorder": getDottedBorder,
  "Expanded": getExpanded,
  "FittedBox": getFittedBox,
  "Padding": getPadding,
  "ScrollLayout": getScrollLayout,
  "SelectionDescendant": getSelectionDescendant,
  "SelectionWidget": getSelectionWidget,
  "WrappedSizeBox": getWrappedSizeBox,
  "SizeBoxExpand": getSizeBoxExpandWidget,
  "TapItem": getTapItem,
  "ValueOpacity": getValueOpacity,
  "ValueTypeListener": getValueTypeListener,
  "WillPopScope": getWillPopScope,
  "WrappedCenter": getWrappedCenterWidget,
  "WrappedContainer": getWrappedContainer,
  "WrappedContext": getWrappedContext,
  "WrappedDraggable": getWrappedDraggable,
};
