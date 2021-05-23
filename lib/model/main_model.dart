import 'package:flutter/material.dart';
import 'package:sirius_geo/builder/abstraction.dart';
import 'package:sirius_geo/model/base_model.dart';

final cSet = Set.from(['/', '*', '.', '^', '°']);

class MainModel extends BaseModel {
  String mainModelName = "assets/models/geo.json";
  //"assets/models/main_view_c.json";

  double screenHeight = 812.0;
  double screenWidth = 375.0;
  double screenHRatio = 1.0;
  double screenWRatio = 1.0;

  Map<String, dynamic> get logical => stateData["logical"];

  AppActions appActions;

  BuildContext context;

  Map<String, dynamic> fsm;

  List<Map<String, dynamic>> fsmList = [];
  ValueNotifier<List<int>> progNoti;

  int _count = 0;

  int get count => _count;

  addCount() {
    _count++;
  }

  Future<String> getJson(BuildContext context) {
    return DefaultAssetBundle.of(context).loadString(mainModelName);
  }

  init() {
    stateData.addAll({"cache": {}, "logical": {}, "user": {}});
    Map<String, dynamic> map = stateData["map"];
    double designHeight = map["designHeight"] ?? 0.0;
    double designWidth = map["designWidth"] ?? 0.0;
    if (designHeight > 0.0) {
      screenHRatio = screenHeight / designHeight;
    }
    if (designWidth > 0.0) {
      screenWRatio = screenWidth / designWidth;
    }
    List<dynamic> ld = map["userProfile"]["progress"];
    List<int> li = (ld == null) ? null : ld.map<int>((e) => e as int).toList();
    progNoti = ValueNotifier<List<int>>(li);
    stateData["progNoti"] = progNoti;
  }
}
