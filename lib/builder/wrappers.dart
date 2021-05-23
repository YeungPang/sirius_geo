import 'package:flutter/material.dart';
import 'package:sirius_geo/builder/get_widget.dart';
import 'package:badges/badges.dart';
import 'package:sirius_geo/builder/special_widgets.dart';
import 'package:sirius_geo/builder/selection_widget.dart';
import 'package:sirius_geo/builder/value_listener.dart';
import 'package:dotted_border/dotted_border.dart';

class TapItem extends StatelessWidget {
  final Map<String, dynamic> map;

  TapItem(this.map);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => _onTap(context, map), child: getWWidget("TapItem", map));
  }

  _onTap(BuildContext context, Map<String, dynamic> itemMap) {
    Map<String, dynamic> actionMap = controller.getContent("*/onTap", map);
    if (actionMap != null) {
      controller.model.context = context;
      controller.performActions(actionMap, itemMap);
      //controller.model.context = null;
    }
  }
}

Widget getWWidget(String name, Map<String, dynamic> map) {
  dynamic wrapper = map["wrapper"];
  if ((wrapper != null) && (wrapper != name)) {
    bool wrap = (wrapper is String);
    if (wrapper is List<dynamic>) {
      int i = wrapper.indexOf(name) + 1;
      wrap = (i == 0);
      if ((!wrap) && (i < wrapper.length)) {
        return getWrapperWidget[wrapper[i]](map);
      }
    }
    if (wrap) {
      return getWrappedWidget(wrapper, map);
    }
  }
  return setupWidget(map);
}

Widget getTapItem(Map<String, dynamic> map) {
  return TapItem(map);
}

Widget getBadge(Map<String, dynamic> map) {
  return Badge(
    badgeContent: map["badgeContext"],
    badgeColor: map["badgeColor"],
    showBadge: map["showBadge"] ?? true,
    padding: EdgeInsets.all(0.0),
    child: getWWidget("Badge", map),
  );
}

Widget getAlign(Map<String, dynamic> map) {
  return Align(
    alignment: map["align"] ?? Alignment.center,
    heightFactor: map["heightFactor"],
    widthFactor: map["widthFactor"],
    child: getWWidget("Align", map),
  );
}

Widget getSelectionWidget(Map<String, dynamic> map) {
  return SelectionWidget(map);
}

Widget getSelectionDescendant(Map<String, dynamic> map) {
  return SelectionDescendant(map);
}

Widget getValueTypeListener(Map<String, dynamic> map) {
  ValueNotifier notifier = map["notifier"];
  if (notifier == null) {
    return null;
  }
  var value = notifier.value;
  if (value is String) {
    return ValueTypeListener<String>(map);
  } else if (value is Map<String, dynamic>) {
    return ValueTypeListener<Map<String, dynamic>>(map);
  } else if (value is int) {
    return ValueTypeListener<int>(map);
  } else if (value is Widget) {
    return ValueTypeListener<Widget>(map);
  } else if (value is List<Widget>) {
    return ValueTypeListener<List<Widget>>(map);
  } else if (value is double) {
    return ValueTypeListener<double>(map);
  } else if (value is bool) {
    return ValueTypeListener<bool>(map);
  } else if (value is List<int>) {
    return ValueTypeListener<List<int>>(map);
  }
  return null;
}

Widget getClipRRect(Map<String, dynamic> map) {
  return ClipRRect(
    borderRadius: map["borderRadius"],
    child: getWWidget("ClipRRect", map),
  );
}

Widget getCard(Map<String, dynamic> map) {
  return Card(
    color: map["cardColor"],
    shadowColor: map["shadowColor"],
    elevation: map["elevation"],
    shape: map["shape"] ??
        RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(map["cardRadius"] ?? 4.0)),
    borderOnForeground: map["borderOnForeground"] ?? true,
    margin: map["margin"],
    clipBehavior: map["clipBehavior"],
    child: getWWidget("Card", map),
  );
}

Widget getPadding(Map<String, dynamic> map) {
  return Padding(
      child: getWWidget("Padding", map), padding: map["wrapperPadding"]);
}

Widget getExpanded(Map<String, dynamic> map) {
  return Expanded(
    flex: map["flex"] ?? 1,
    child: getWWidget("Expanded", map),
  );
}

Widget getFittedBox(Map<String, dynamic> map) {
  return FittedBox(
    fit: map["fit"] ?? BoxFit.contain,
    alignment: map["alignment"] ?? Alignment.center,
    clipBehavior: map["clip"] ?? Clip.hardEdge,
    child: getWWidget("FittedBox", map),
  );
}

Widget getWrappedCenterWidget(Map<String, dynamic> map) {
  return Center(
      child: getWWidget("WrappedCenter", map),
      heightFactor: map["heightFactor"],
      widthFactor: map["widthFactor"]);
}

Widget getSizeBoxExpandWidget(Map<String, dynamic> map) {
  return SizedBox.expand(
    child: getWWidget("SizeBoxExpand", map),
  );
}

Widget getWrappedContainer(Map<String, dynamic> map) {
  return Container(
      child: getWWidget("WrappedContainer", map),
      color: map["color"],
      alignment: map["alignment"],
      clipBehavior: map["clipBehavior"] ?? Clip.none,
      constraints: map["boxConstraints"],
      decoration: map["boxDecoration"],
      foregroundDecoration: map["foregroundDecoration"],
      width: map["width"],
      height: map["height"],
      margin: map["margin"],
      //padding: map["padding"],
      transform: map["transform"]);
}

Widget getValueOpacity(Map<String, dynamic> map) {
  return ValueListenableBuilder<double>(
    valueListenable: map["notifier"],
    builder: (BuildContext context, double value, Widget child) => Opacity(
      child: getWWidget("ValueOpacity", map),
      opacity: value,
    ),
  );
}

Widget getScrollLayout(Map<String, dynamic> map) {
  return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: viewportConstraints.maxHeight,
        ),
        child: IntrinsicHeight(
          child: getWWidget("ScrollLayout", map),
        ),
      ),
    );
  });
}

Widget getWrappedSizeBox(Map<String, dynamic> map) {
  return SizedBox(
    height: map["height"],
    width: map["width"],
    child: getWWidget("WrappedSizeBox", map),
  );
}

Widget getDottedBorder(Map<String, dynamic> map) {
  double r = map["radius"];
  return DottedBorder(
    dashPattern: map["dashPattern"] ?? [4, 2],
    strokeWidth: map["strokeWidth"] ?? 1,
    radius: (r != null) ? Radius.circular(r) : null,
    borderType: (r != null) ? BorderType.RRect : null,
    color: map["dottedColor"],
    child: getWWidget("DottedBorder", map),
  );
}

Widget getWrappedDraggable(Map<String, dynamic> map) {
  return Draggable(
      data: map["data"],
      onDragStarted: () {
        Map<String, dynamic> actions = map["dragStarted"];
        if (actions != null) {
          controller.performActions(actions, map);
        }
      },
      child: getWWidget("WrappedDraggable", map),
      feedback: Opacity(
        child: map["feedback"] ?? getWWidget("WrappedDraggable", map),
        opacity: 0.7,
      ),
      childWhenDragging:
          map["childWhenDragging"] ?? getWWidget("WrappedDraggable", map));
}

Widget getWillPopScope(Map<String, dynamic> map) {
  return NaviScope(map);
}

class WrappedContext extends StatelessWidget {
  final Map<String, dynamic> map;

  WrappedContext(this.map);
  @override
  Widget build(BuildContext context) {
    map["context"] = context;
    return getWWidget("WrappedContext", map);
  }
}

Widget getWrappedContext(Map<String, dynamic> map) {
  return WrappedContext(map);
}
