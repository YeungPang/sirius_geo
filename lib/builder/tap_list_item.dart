import 'package:flutter/material.dart';
import 'package:sirius_geo/builder/wrappers.dart';
import 'package:sirius_geo/builder/comp_builder.dart';
import 'package:sirius_geo/locator.dart';
import 'package:sirius_geo/builder/get_widget.dart';

class TapListItem extends StatelessWidget {
  final Map<String, dynamic> map;
  final CompBuilder compBuilder = locator<CompBuilder>();

  TapListItem(this.map);
  @override
  Widget build(BuildContext context) {
    print("Buidling list view");
    List<dynamic> itemRef = map["itemRef"] as List<dynamic>;
    if (map["crossAxisCount"] == null) {
      return ListView.builder(
        scrollDirection: map["direction"] ?? Axis.vertical,
        padding: map["padding"] ?? null,
        shrinkWrap: map["shrinkWrap"] ?? true,
        physics: map["physics"],
        itemCount: itemRef.length,
        itemBuilder: (context, index) => _itemBuilder(itemRef[index], index),
      );
    }
    SliverGridDelegate gd = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: map["crossAxisCount"] as int,
      mainAxisSpacing: map["mainAxisSpacing"] ?? 0.0,
      crossAxisSpacing: map["crossAxisSpacing"] ?? 0.0,
      childAspectRatio: map["childAspectRatio"] ?? 1.0,
    );
    return GridView.builder(
      gridDelegate: gd,
      scrollDirection: map["direction"] ?? Axis.vertical,
      padding: map["padding"] ?? null,
      physics: map["physics"],
      shrinkWrap: true,
      itemCount: itemRef.length,
      itemBuilder: (context, index) => _itemBuilder(itemRef[index], index),
    );
  }

  Widget _itemBuilder(dynamic item, int index) {
    BaseBuilder bb = compBuilder.getBuilder(map["child"] as String);
    Map<String, dynamic> itemMap = {"item": item, "index": index};
    bb.map = itemMap;
    itemMap = bb.build(map);
    if (map["onTap"] == null) {
      return getBuilderWidget(itemMap);
    }
    return TapItem(itemMap);
  }
}
