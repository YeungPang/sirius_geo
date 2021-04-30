import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sirius_geo/builder/color_button.dart';
import 'package:sirius_geo/builder/abstraction.dart';
import 'package:sirius_geo/builder/special_widgets.dart';
import 'package:sirius_geo/builder/tap_list_item.dart';

Widget getColumnWidget(Map<String, dynamic> map) {
  dynamic d = map["children"];
  DescendantList descendant = (d is List<Widget>) ? null : d;
  return Column(
      key: map["key"],
      crossAxisAlignment:
          map["crossAxisAlignment"] ?? CrossAxisAlignment.center,
      mainAxisAlignment: map["mainAxisAlignment"] ?? MainAxisAlignment.start,
      mainAxisSize: map["mainAxisSize"] ?? MainAxisSize.max,
      textBaseline: map["textBaseline"],
      textDirection: map["textDirection"],
      verticalDirection: map["verticalDirection"] ?? VerticalDirection.down,
      children: (descendant != null) ? descendant.getWidgetList() : d);
}

Widget getRowWidget(Map<String, dynamic> map) {
  dynamic d = map["children"];
  DescendantList descendant = (d is List<Widget>) ? null : d;
  return Row(
      key: map["key"],
      crossAxisAlignment:
          map["crossAxisAlignment"] ?? CrossAxisAlignment.center,
      mainAxisAlignment: map["mainAxisAlignment"] ?? MainAxisAlignment.start,
      mainAxisSize: map["mainAxisSize"] ?? MainAxisSize.max,
      textBaseline: map["textBaseline"],
      textDirection: map["textDirection"],
      verticalDirection: map["verticalDirection"] ?? VerticalDirection.down,
      children: (descendant != null) ? descendant.getWidgetList() : d);
}

Widget getScaffolWidget(Map<String, dynamic> map) {
  dynamic d = map["body"];
  Descendant descendant = (d is Widget) ? null : d;
  return Scaffold(
    appBar: map["appBar"],
    body: (descendant != null) ? descendant.getWidget() : d,
    backgroundColor: map['backgroundColor'],
    bottomNavigationBar: map['bottomNavigationBar'],
    bottomSheet: map['bottomSheet'],
    drawer: map['drawer'],
    drawerDragStartBehavior:
        map['drawerDragStartBehavior'] ?? DragStartBehavior.start,
    endDrawer: map['endDrawer'],
    endDrawerEnableOpenDragGesture:
        map['endDrawerEnableOpenDragGesture'] ?? true,
    extendBody: map['extendBody'] ?? false,
    extendBodyBehindAppBar: map['extendBodyBehindAppBar'] ?? false,
    floatingActionButton: map['floatingActionButton'],
    floatingActionButtonAnimator: map['floatingActionButtonAnimator'],
    floatingActionButtonLocation: map['floatingActionButtonLocation'],
    persistentFooterButtons: map['persistentFooterButtons'],
    primary: map['primary'] ?? true,
    resizeToAvoidBottomInset: map['resizeToAvoidBottomInset'],
  );
}

Widget getAppBarWidget(Map<String, dynamic> map) {
  return AppBar(
    actions: map["actions"],
    actionsIconTheme: map["actionsIconTheme"],
    backgroundColor: map['backgroundColor'],
    automaticallyImplyLeading: map['automaticallyImplyLeading'] ?? true,
    bottom: map['bottom'],
    bottomOpacity: map['bottomOpacity'] ?? 1.0,
    brightness: map['brightness'],
    centerTitle: map['centerTitle'],
    elevation: map['elevation'],
    excludeHeaderSemantics: map['excludeHeaderSemantics'] ?? false,
    flexibleSpace: map['flexibleSpace'],
    iconTheme: map['iconTheme'],
    leading: map['leading'],
    leadingWidth: map['leadingWidth'],
    primary: map['primary'] ?? true,
    shadowColor: map['shadowColor'],
    shape: map['shape'],
    textTheme: map["textTheme"],
    title: map["title"],
    titleSpacing: map['titleSpacing'] ?? NavigationToolbar.kMiddleSpacing,
    toolbarHeight: map['toolbarHeight'] ?? kToolbarHeight,
    toolbarOpacity: map['toolbarOpacity'] ?? 1.0,
  );
}

Widget getTextWidger(Map<String, dynamic> map) {
  return Text(
    map["text"],
    locale: map["locale"],
    maxLines: map["maxLines"],
    overflow: map["textOverflow"],
    semanticsLabel: map["semanticsLabel"],
    softWrap: map["softWrap"],
    strutStyle: map["strutStyle"],
    style: map["textStyle"],
    textAlign: map["textAlign"],
    textDirection: map["textDirection"],
    textHeightBehavior: map["textHeightBehavior"],
    textScaleFactor: map["textScaleFactor"],
    textWidthBasis: map["textWidthBasis"],
  );
}

Widget getImageAsset(Map<String, dynamic> map) {
  return Image.asset(map["name"],
      key: map["key"],
      bundle: map["bundle"],
      frameBuilder: map["frameBuilder"],
      errorBuilder: map["errorBuilder"],
      semanticLabel: map["semanticLabel"],
      excludeFromSemantics: map["excludeFromSemantics"] ?? false,
      scale: map["scale"],
      width: map["width"],
      height: map["height"],
      color: map["color"],
      colorBlendMode: map["colorBlendMode"],
      fit: map["boxFit"],
      alignment: map["alignment"] ?? Alignment.center,
      repeat: map["repeat"] ??= ImageRepeat.noRepeat,
      centerSlice: map["centerSlice"],
      matchTextDirection: map["matchTextDirection"] ?? false,
      gaplessPlayback: map["gaplessPlayback"] ?? false,
      isAntiAlias: map["isAntiAlias"] ?? false,
      package: map["package"],
      filterQuality: map["filterQuality"] ?? FilterQuality.low,
      cacheWidth: map["cacheWidth"],
      cacheHeight: map["cacheHeight"]);
}

Widget getSVGAsset(Map<String, dynamic> map) {
  return SvgPicture.asset(
    map["name"],
    height: map["height"],
  );
}

Widget getStack(Map<String, dynamic> map) {
  dynamic d = map["children"];
  DescendantList descendant = (d is List<Widget>) ? null : d;
  return Stack(
      children: (descendant != null) ? descendant.getWidgetList() : d,
      alignment: map["alignment"] ?? AlignmentDirectional.topStart,
      clipBehavior: map["clipBehavior"] ?? Clip.hardEdge,
      fit: map["stackFit"] ?? StackFit.loose,
      textDirection: map["textDirection"]);
}

Widget getContainer(Map<String, dynamic> map) {
  dynamic d = map["child"];
  Descendant descendant = (d is Widget) ? null : d;
  return Container(
      child: (descendant != null) ? descendant.getWidget() : d,
      color: map["color"],
      alignment: map["alignment"],
      clipBehavior: map["clipBehavior"] ?? Clip.none,
      constraints: map["boxConstraints"],
      decoration: map["boxDecoration"],
      foregroundDecoration: map["foregroundDecoration"],
      width: map["width"],
      height: map["height"],
      margin: map["margin"],
      padding: map["padding"],
      transform: map["transform"]);
}

Widget getSingleChildScrollView(Map<String, dynamic> map) {
  dynamic d = map["child"];
  Descendant descendant = (d is Widget) ? null : d;
  return SingleChildScrollView(
      key: map["key"],
      child: (d is Widget) ? d : descendant.getWidget(),
      clipBehavior: map["clipBehavior"] ?? Clip.hardEdge,
      controller: map["controller"],
      dragStartBehavior: map["dragStartBehavior"] ?? DragStartBehavior.start,
      padding: map["padding"],
      physics: map["scrollPhysics"],
      primary: map["primary"],
      restorationId: map["restorationId"],
      reverse: map["reverse"] ?? false,
      scrollDirection: map["scrollDirection"] ?? Axis.vertical);
}

Widget getImageBanner(Map<String, dynamic> map) {
  return ImageBanner(name: map["name"] as String, height: map["height"]);
}

Widget getTapListItem(Map<String, dynamic> map) {
  return TapListItem(map);
}

Widget getGridView(Map<String, dynamic> map) {
  dynamic d = map["children"];
  DescendantList descendant = (d is List<Widget>) ? null : d;
  return GridView.count(
    key: map["key"],
    scrollDirection: map["scrollDirection"] ?? Axis.vertical,
    reverse: map["reverse"] ?? false,
    controller: map["controller"],
    primary: map["primary"],
    physics: map["physics"],
    shrinkWrap: map["shrinkWrap"] ?? false,
    padding: map["padding"],
    crossAxisCount: map["crossAxisCount"],
    mainAxisSpacing: map["mainAxisSpacing"] ?? 0.0,
    crossAxisSpacing: map["crossAxisSpacing"] ?? 0.0,
    childAspectRatio: map["childAspectRatio"] ?? 1.0,
    addAutomaticKeepAlives: map["addAutomaticKeepAlives"] ?? true,
    addRepaintBoundaries: map["addRepaintBoundaries"] ?? true,
    addSemanticIndexes: map["addSemanticIndexes"] ?? true,
    cacheExtent: map["cacheExtent"],
    children: (d is List<Widget>) ? d : descendant.getWidgetList(),
    semanticChildCount: map["semanticChildCount"],
    dragStartBehavior: map["dragStartBehavior"] ?? DragStartBehavior.start,
    keyboardDismissBehavior: map["keyboardDismissBehavior"] ??
        ScrollViewKeyboardDismissBehavior.manual,
    restorationId: map["restorationId"],
    clipBehavior: map["clipBehavior"] ?? Clip.hardEdge,
  );
}

Widget getColorButton(Map<String, dynamic> map) {
  return ColorButton(map);
}

Widget getIndexedStack(Map<String, dynamic> map) {
  dynamic d = map["children"];
  DescendantList descendant = (d is List<Widget>) ? null : d;
  return ValueListenableBuilder<int>(
    valueListenable: map["notifier"],
    builder: (BuildContext context, int value, Widget child) => IndexedStack(
        children: (descendant != null) ? descendant.getWidgetList() : d,
        alignment: map["alignment"] ?? AlignmentDirectional.topStart,
        sizing: map["sizing"] ?? StackFit.loose,
        index: value,
        textDirection: map["textDirection"]),
  );
}

Widget getValueStack(Map<String, dynamic> map) {
  return ValueListenableBuilder<List<Widget>>(
    valueListenable: map["notifier"],
    builder: (BuildContext context, List<Widget> children, Widget child) =>
        Stack(
            children: children,
            alignment: map["alignment"] ?? AlignmentDirectional.topStart,
            clipBehavior: map["clipBehavior"] ?? Clip.hardEdge,
            fit: map["stackFit"] ?? StackFit.loose,
            textDirection: map["textDirection"]),
  );
}

Widget getCenterWidget(Map<String, dynamic> map) {
  dynamic d = map["child"];
  Descendant descendant = (d is Widget) ? null : d;
  return Center(
      child: (descendant != null) ? descendant.getWidget() : d,
      heightFactor: map["heightFactor"],
      key: map["key"],
      widthFactor: map["widthFactor"]);
}

Widget getTextField(Map<String, dynamic> map) {
  return TextField(
    autocorrect: map["autocorrect"] ?? true,
    autofocus: map["autofocus"] ?? false,
    controller: map["textController"],
    enabled: map["enabled"] ?? true,
    style: map["textStyle"],
    showCursor: map["showCursor"],
    maxLines: map["maxLines"] ?? 1,
    expands: map["expands"] ?? false,
    onSubmitted: map["onSubmitted"],
    keyboardType: map["keyboardType"],
    decoration: InputDecoration(
      border: map["inputBorder"],
      icon: map["icon"],
      hintText: map["hintText"],
      hintStyle: map["hintStyle"],
      labelText: map["labelText"],
      labelStyle: map["labelStyle"],
      prefixIcon: map["prefixIcon"],
      suffixIcon: map["suffixIcon"],
      filled: map["filled"],
      fillColor: map["fillColor"],
      contentPadding: map["padding"],
    ),
  );
}

Widget getListView(Map<String, dynamic> map) {
  dynamic d = map["children"];
  DescendantList descendant = (d is List<Widget>) ? null : d;
  return ListView(
    key: map["key"],
    scrollDirection: map["scrollDirection"] ?? Axis.vertical,
    reverse: map["reverse"] ?? false,
    controller: map["controller"],
    primary: map["primary"],
    physics: map["physics"],
    shrinkWrap: map["shrinkWrap"] ?? true,
    padding: map["padding"],
    addAutomaticKeepAlives: map["addAutomaticKeepAlives"] ?? true,
    addRepaintBoundaries: map["addRepaintBoundaries"] ?? true,
    addSemanticIndexes: map["addSemanticIndexes"] ?? true,
    cacheExtent: map["cacheExtent"],
    children: (d is List<Widget>) ? d : descendant.getWidgetList(),
    semanticChildCount: map["semanticChildCount"],
    dragStartBehavior: map["dragStartBehavior"] ?? DragStartBehavior.start,
    keyboardDismissBehavior: map["keyboardDismissBehavior"] ??
        ScrollViewKeyboardDismissBehavior.manual,
    restorationId: map["restorationId"],
    clipBehavior: map["clipBehavior"] ?? Clip.hardEdge,
  );
}

Widget getInTextField(Map<String, dynamic> map) {
  return InTextField(map);
}

Widget getSizeBox(Map<String, dynamic> map) {
  return SizedBox(
    height: map["height"],
    width: map["width"],
  );
}

Widget getRollingSwitch(Map<String, dynamic> map) {
  return RollingSwitch(map);
}
