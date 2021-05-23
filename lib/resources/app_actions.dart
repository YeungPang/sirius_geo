import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sirius_geo/builder/abstraction.dart';
import 'package:sirius_geo/builder/comp_builder.dart';
import 'package:sirius_geo/builder/value_listener.dart';
import 'package:sirius_geo/locator.dart';
import 'package:sirius_geo/model/main_model.dart';
import 'package:sirius_geo/controller/process_controller.dart';
import 'package:sirius_geo/resources/basic_resources.dart';
import 'package:sirius_geo/builder/special_widgets.dart';
import 'package:sirius_geo/resources/fonts.dart';
import 'package:sirius_geo/resources/s_g_icons.dart';
import 'package:sirius_geo/widgets/bubble/hint_bubble.dart';
import 'package:sirius_geo/widgets/game_complete/game_complete.dart';
import 'package:sirius_geo/widgets/main_menu/main_menu.dart';
import 'package:sirius_geo/widgets/slider/slider_widget.dart';
import 'package:sirius_geo/widgets/slider/vertical_slider.dart';

class AppActionBuild implements AppActions {
  Function getAction(String name) {
    return appActions[name];
  }

  Function getWidget(String name) {
    return appWidgets[name];
  }
}

const Map<String, Function> appActions = {
  "buildResultDialog": buildResultDialog,
  "buildSlider": buildSlider,
  "buildSliderResult": buildSliderResult,
  "closeResultDialog": closeResultDialog,
  "dropSelected": dropSelected,
  "dragDropAnswer": dragDropAnswer,
  "ddSelect": ddSelect,
  "gameComplete": gameComplete,
  "getAppResource": getAppResource,
  "getBaseNaviRow": getBaseNaviRow,
  "getCatView": getCatView,
  "getBottomRow": getBottomRow,
  "getGroupBody": getGroupBody,
  "getQuitDialog": getQuitDialog,
  "multiAnswer": multiAnswer,
  "progNotify": progNotify,
  "repeatGame": repeatGame,
  "routing": routing,
  "setHint": setHint,
  "setProgRow": setProgRow,
  "showAnswer": showAnswer,
  "sliderShowAnswer": sliderShowAnswer,
  "threeSliderAnswer": threeSliderAnswer,
  "vSliderAnswer": vSliderAnswer,
};

const Map<String, dynamic> appResource = {};

const Map<String, Function> appWidgets = {
  "TopicWidget": topicWidget,
};

getAppResource(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  Map<String, dynamic> map = parm["map"] as Map<String, dynamic>;
  String name = parm["name"];
  String key = parm["key"];
  String type = parm["type"];
  if (type == null) {
    map[key] = resources[name];
  } else {
    switch (type) {
      case "parm":
        map[key] = appResource[name](parm);
        break;
      case "map":
        map[key] = appResource[name](map);
        break;
      default:
        break;
    }
  }
}

ddSelect(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  Map<String, dynamic> map = parm["map"] as Map<String, dynamic>;
  Map<String, dynamic> fsm = model.fsm;
  String state = fsm["state"];
  String event = parm["event"];
  List<dynamic> gl = fsm["gridList"];
  List<Widget> dragDropList = fsm["dragDropList"];
  List<Widget> draggingList = fsm["draggingList"];
  int si = -1;
  Widget selElem;
  int nsi = controller.getContent("*/index", map);
  switch (state) {
    case "unselected":
      if (event == "childSel") {
        fsm["state"] = "ChildSelected";
      } else {
        fsm["state"] = "AnsSelected";
      }
      break;
    case "ChildSelected":
      si = fsm["selIndex"];
      List<Widget> dragChildList = fsm["dragChildList"];
      selElem = dragChildList[si];
      if (event == "childSel") {
        fsm["state"] = "ChildSelected";
      } else if (event == "ansSel") {
        fsm["state"] = "AnsSelected";
      }
      break;
    case "AnsSelected":
      si = fsm["selIndex"];
      List<Widget> ansChildList = fsm["ansChildList"];
      selElem = ansChildList[si];
      if (event == "childSel") {
        fsm["state"] = "ChildSelected";
      } else if (event == "ansSel") {
        fsm["state"] = "AnsSelected";
      }
      break;
    default:
      break;
  }
  if (selElem != null) {
    int gi = gl.indexOf(si);
    dragDropList[gi] = selElem;
  }
  if (si == nsi) {
    fsm["state"] = "unselected";
  } else {
    selElem = draggingList[nsi];
    //selElem = fsm["ansTargetList"][0];
    int gi = gl.indexOf(nsi);
    dragDropList[gi] = selElem;
    fsm["selIndex"] = nsi;
  }
  Map<String, dynamic> nParm = {
    "map": map,
    "notifier": fsm["gridViewNoti"],
    "value": dragDropList
  };
  controller.doAction("valueNotify", nParm);
}

dropSelected(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  Map<String, dynamic> map = parm["map"] as Map<String, dynamic>;
  Map<String, dynamic> fsm = model.fsm;
  String state = fsm["state"];
  if (state == "unselected") {
    return;
  }
  int si = fsm["selIndex"];
  Widget se;
  List<dynamic> gl = fsm["gridList"];
  int gi = gl.indexOf(si);
  int ti = controller.getContent("*/item", map);
  List<dynamic> targetList = fsm["targetList"];
  int tei = targetList.indexOf(ti);
  int gt = gl.indexOf(ti);
  if (state == "ChildSelected") {
    se = fsm["ansChildList"][si];
    fsm["answered"]++;
    if (fsm["answered"] == fsm["totalAnswered"]) {
      ValueNotifier<double> notifier = fsm["confirmNoti"];
      notifier.value = 1.0;
    }
  } else {
    int p = gt % 2;
    if (p == 0) {
      se = fsm["dragChildList"][si];
      if (fsm["answered"] == fsm["totalAnswered"]) {
        ValueNotifier<double> notifier = fsm["confirmNoti"];
        notifier.value = 0.5;
      }
      fsm["answered"]--;
    } else {
      se = fsm["ansChildList"][si];
    }
  }
  Widget te = fsm["ansTargetList"][tei];
  gl[gi] = ti;
  gl[gt] = si;
  List<Widget> dragDropList = fsm["dragDropList"];
  dragDropList[gi] = te;
  dragDropList[gt] = se;
  Map<String, dynamic> nParm = {
    "map": map,
    "notifier": fsm["gridViewNoti"],
    "value": dragDropList
  };
  controller.doAction("valueNotify", nParm);
  fsm["state"] = "unselected";
}

dragDropAnswer(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  Map<String, dynamic> map = parm["map"] as Map<String, dynamic>;
  Map<String, dynamic> fsm = model.fsm;
  int ta = fsm["totalAnswered"];
  if (fsm["answered"] != ta) {
    return;
  }
  List<dynamic> answers = fsm["answers"];
  List<dynamic> gridList = fsm["gridList"];
  List<Widget> dragDropList = fsm["dragDropList"];
  Map<String, dynamic> nParm;
  int wrong = 0;
  for (int i = 0; i < answers.length; i++) {
    int n = i * 2 + 1;
    Map<String, dynamic> nMap = {
      "parent": map,
      "item": gridList[n],
      "index": n
    };
    if (answers[i] == gridList[n]) {
      nMap["elem"] = _buildWidget("CorrChoiceElement", nMap);
    } else {
      wrong++;
      nMap["elem"] = _buildWidget("IncorrChoiceElement", nMap);
    }
    dragDropList[n] = nMap["elem"];
  }
  nParm = {"map": map, "notifier": fsm["gridViewNoti"], "value": dragDropList};
  controller.doAction("valueNotify", nParm);
  fsm["state"] = "confirmed";
  List<Widget> stackList = fsm["stackList"];
  Widget d;
  if (wrong == 0) {
    d = fsm["corrDialog"];
    parm["mode"] = "success";
    setProgRow(parm, model, controller);
  } else {
    parm["mode"] = "fail";
    setProgRow(parm, model, controller);
    int c = ta - wrong;
    int s = (c * 100 ~/ ta);
    String score = fsm["scoreText"];
    score = score
        .replaceFirst("#%#", s.toString())
        .replaceFirst("#C#", c.toString())
        .replaceFirst("#T#", ta.toString());
    Map<String, dynamic> nMap = {"parent": map, "scoreText": score};
    d = _buildWidget("DDIncorrDialog", nMap);
    nMap["elem"] = d;
  }
  stackList.add(d);
  _notifyStack(stackList, controller, map);
  fsm["answered"] = 0;
}

buildSlider(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  Map<String, dynamic> map = parm["map"] as Map<String, dynamic>;
  Map<String, dynamic> fsm = model.fsm;
  String key = parm["key"];
  String type = parm["type"];
  List<dynamic> mapping = parm["mapping"];
  Map<String, dynamic> nmap = {"parent": map};
  if (mapping != null) {
    for (String st in mapping) {
      nmap[st] = map[st];
    }
  }
  fsm["sliderNoti"] = ValueNotifier<int>(0);
  if (type == "vertical") {
    fsm["scaleNoti"] = ValueNotifier<double>(50.0);
    map[key] = Container(
        margin: catIconPadding,
        height: map["height"],
        width: map["width"],
        alignment: Alignment.center,
        child: VertSlider(nmap, fsm));
  } else {
    nmap["height"] = 812.0 * model.screenHRatio;
    nmap["width"] = 375.0 * model.screenWRatio;
    map[key] = ThreeSliderWidget(nmap, fsm);
  }
}

List<Widget> prepareProgRow(Map<String, dynamic> parm) {
  List<dynamic> l = parm["list"];
  List<Widget> lg = [space10];
  int ln = l.length;
  int ln1 = ln - 1;
  for (int i = 0; i < ln; i++) {
    Icon ic = (l[i] == -1)
        ? incompleteProg
        : ((l[i] == 1) || (l[i] == 3))
            ? completeProg
            : incorrProg;
    lg.add(ic);
    if (i < ln1) {
      lg.add(space5);
    }
  }
  return lg;
}

Widget _buildWidget(dynamic builder, Map<String, dynamic> map) {
  CompBuilder compBuilder = locator<CompBuilder>();
  return compBuilder.builderBuild(builder, map);
}

getBottomRow(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  Map<String, dynamic> map = parm["map"] as Map<String, dynamic>;
  String key = parm["key"];
  map["progIcons"] = prepareProgRow(parm);
  List<Widget> l = [_buildWidget("ProgRow", map), space10];
  if (cSet.contains(key[0])) {
    parm["content"] = l;
    controller.doAction("setContent", parm);
  } else {
    map[key] = l;
  }
}

setProgRow(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  Map<String, dynamic> map = parm["map"] as Map<String, dynamic>;
  Map<String, dynamic> fsm = model.fsm;
  List<dynamic> l = fsm["progress"];
  String s = parm["mode"];
  if ((s != null) && (s != "first")) {
    bool loop = true;
    int i = 0;
    int l1 = l.length - 1;
    while (loop) {
      if (s == "repeat") {
        if (l[i] == -1) {
          i--;
          l[i] += 2;
          loop = false;
        } else if (i == l1) {
          l[i] += 2;
          loop = false;
        } else {
          loop = i != l1;
          i++;
        }
      } else {
        if (l[i] >= 2) {
          l[i] -= 2;
          loop = false;
        } else if (l[i] == -1) {
          loop = false;
          l[i] = (s == "success") ? 1 : 0;
        } else {
          loop = i != l1;
          i++;
        }
      }
    }
    if (i >= l1) {
      fsm["gameOver"] = true;
    }
  }
  parm["list"] = l;
  map["progIcons"] = prepareProgRow(parm);
  List<Widget> br = controller.getContent("^/bottomRow", map);
  br[0] = _buildWidget("ProgRow", map);
  if (s == "first") {
    List<dynamic> hintList = controller.getContent("°/game/hints", map);
    if (hintList == null) {
      br[1] = Opacity(
        opacity: 0.5,
        child: _buildWidget("HintIcon", map),
      );
    } else {
      br[1] = _buildWidget("HintIcon", map);
    }
  }
  Map<String, dynamic> nParm = {
    "map": map,
    "notifier": "^/bottomRowNoti",
    "value": br
  };
  controller.doAction("valueNotify", nParm);
}

setHint(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  Map<String, dynamic> map = parm["map"] as Map<String, dynamic>;
  List<dynamic> hintList = controller.getContent("°/game/hints", map);
  if (hintList == null) {
    return;
  }
  Map<String, dynamic> fsm = model.fsm;
  List<Widget> stackList = fsm["stackList"];
  int ix = fsm["hintIndex"];
  int hl = hintList.length;
  String mode = parm["mode"] as String;
  bool hintShowed = fsm["hintShowed"];
  if (mode == "showHint") {
    if (hintShowed) {
      return;
    }
    fsm["hintShowed"] = true;
  }
  switch (mode) {
    case "prevHint":
      stackList.removeLast();
      ix--;
      fsm["hintIndex"] = ix;
      break;
    case "nextHint":
      stackList.removeLast();
      ix++;
      fsm["hintIndex"] = ix;
      break;
    case "cancel":
      stackList.removeLast();
      Map<String, dynamic> nParm = {
        "map": map,
        "notifier": "°/stackListNoti",
        "value": "°/stackList"
      };
      controller.doAction("valueNotify", nParm);
      fsm["hintShowed"] = false;
      return;
    default:
      break;
  }
  String hintText = controller.getContent("/text/hintText", map);
  bool hasPrev = ix > 1;
  bool last = ix == hl;
  hintText = hintText
      .replaceFirst("#n#", ix.toString())
      .replaceFirst("#t#", hl.toString());
  String hints = hintList[ix - 1];
  Map<String, dynamic> nmap = {
    "parent": map,
    "align": Alignment(0.65, 1.0),
    "bubbleSize": 50.0 * model.screenHRatio,
    "assetName": "assets/images/hint_bubble_arrow.png",
    "bubbleHeight": 160.0 * model.screenHRatio,
    "arrowAlign": Alignment(0.9, 1.0),
    "boxAlign": Alignment.topCenter,
    "boxWidth": 330.0 * model.screenWRatio,
    "boxHeight": 130.0 * model.screenHRatio,
    "bannerHeight": 35.0 * model.screenHRatio,
    "hintText": hintText,
    "prevHint": controller.getContent("/text/prevHint", map),
    "nextHint": controller.getContent("/text/nextHint", map),
    "tryTeachMode": controller.getContent("/text/tryTeachMode", map),
    "onCancel": {
      "setHint": {"mode": "cancel"}
    },
    "onTryTeachMode": {
      "setHint": {"mode": "cancel"}
    },
    "onPrev": {
      "setHint": {"mode": "prevHint"}
    },
    "onNext": {
      "setHint": {"mode": "nextHint"}
    },
  };
  nmap["bubbleArrow"] = _buildWidget("BubbleArrow", nmap);
  nmap["controller"] = controller;
  List<Widget> hintBox = [
    getHintBanner(nmap),
    getHints(hints),
    getPrevNext(hasPrev, last, nmap),
  ];
  nmap["bubbleBox"] = hintBox;
  Widget hintBubble = Bubble(nmap);
  stackList.add(hintBubble);
  _notifyStack(stackList, controller, map);
}

getQuitDialog(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  Map<String, dynamic> map = parm["map"] as Map<String, dynamic>;
  Map<String, dynamic> nmap = {
    "parent": map,
    "align": Alignment(-0.65, -0.85),
    "alignCancel": Alignment(0.9, 0.0),
    "bubbleSize": 50.0 * model.screenHRatio,
    "assetName": "assets/images/quit_bubble_arrow.png",
    "bubbleHeight": 190.0 * model.screenHRatio,
    "arrowAlign": Alignment(-0.9, -1.0),
    "boxAlign": Alignment.bottomCenter,
    "boxWidth": 330.0 * model.screenWRatio,
    "width": 330.0,
    "boxHeight": 160.0 * model.screenHRatio,
    "bannerHeight": 35.0 * model.screenHRatio,
    "crossAxisAlignment": "start",
    "BtnText": controller.getContent("/text/quit", map),
    "BlueBtnText": controller.getContent("/text/cancel", map),
    "onBtnTap": {
      "popRoute": {"mode": true}
    },
    "onBlueBtnTap": {
      "popRoute": {"mode": false}
    },
    "onCancel": {
      "popRoute": {"mode": false}
    },
  };
  nmap["bubbleArrow"] = _buildWidget("BubbleArrow", nmap);
  String quitText = controller.getContent("/text/quitText", map);
  String looseProgress = controller.getContent("/text/looseProgress", map);
  nmap["controller"] = controller;
  List<Widget> box = [
    getBubbleBanner(nmap),
    getBubbleText(quitText, looseProgress),
    _buildWidget("BubbleBtnCon", nmap),
  ];
  nmap["bubbleBox"] = box;
  String key = parm["key"];
  map[key] = Bubble(nmap);
}

gameComplete(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  Map<String, dynamic> map = parm["map"] as Map<String, dynamic>;
  Map<String, dynamic> fsm = model.fsm;
  List<dynamic> l = fsm["progress"];
  int corr = 0;
  int ll = l.length;
  for (int i = 0; i < ll; i++) {
    if (l[i] == 1) {
      corr++;
    }
  }
  int score = ((corr / ll) * 100).round();
  int incorr = ll - corr;
  List<Widget> slw = [];
  List<Widget> completeText;
  Map<String, dynamic> text = model.map["text"];
  double width = 350.0 * model.screenWRatio;
  TextStyle sts = YourScoreStyle;
  TextStyle bts = YourScoreStyle.copyWith(fontSize: 50);
  double textHeight = 66.0;

  bool scoreMark = score >= fsm["scoreMark"];
  if (scoreMark) {
    Widget bcs = Align(
        alignment: Alignment.topCenter,
        child: Container(
          height: 400.0 * model.screenHRatio,
          width: width,
          child: Image.asset(
            "assets/images/star_background.png",
            fit: BoxFit.cover,
          ),
        ));
    slw.add(bcs);
    if (score >= fsm["complMark"]) {
      Widget bct = Align(
          alignment: Alignment(0.0, -0.6),
          child: Container(
            height: 150.0 * model.screenHRatio,
            //width: 250.0 * model.screenWRatio,
            child: Image.asset(
              "assets/images/trophy.png",
              fit: BoxFit.cover,
            ),
          ));
      slw.add(bct);
      textHeight = 88.0;
      completeText = [
        Text(
          text["congrat"],
          style: ComplTextStyle,
          textAlign: TextAlign.center,
        ),
        Text(
          text["highScore"],
          style: ComplTextStyle,
          textAlign: TextAlign.center,
        ),
        Text(
          text["forQuiz"],
          style: ComplTextStyle,
          textAlign: TextAlign.center,
        ),
      ];
    } else {
      completeText = [
        Text(
          text["wellDone"],
          style: ComplTextStyle,
          textAlign: TextAlign.center,
        ),
        Text(
          text["quizComplete"],
          style: ComplTextStyle,
          textAlign: TextAlign.center,
        ),
      ];
    }
    int p = fsm["progId"];
    List<int> pl = model.progNoti.value;
    int n = p & 15;
    pl[n] |= p;
    model.map["userProfile"]["progress"] = pl;
    //model.progNoti.value = pl;
  } else {
    sts = sts.copyWith(color: Color(0xFFF76F71));
    bts = bts.copyWith(color: Color(0xFFF76F71));

    textHeight = 88.0;
    Widget bct = Align(
        alignment: Alignment.topCenter,
        child: Container(
          //height: 350.0 * model.screenHRatio,
          width: width,
          child: Image.asset(
            "assets/images/circles.png",
            fit: BoxFit.cover,
          ),
        ));
    slw.add(bct);
    completeText = [
      Text(
        "HMM...",
        style: ComplTextStyle,
        textAlign: TextAlign.center,
      ),
      Text(
        text["maybe"],
        style: ComplTextStyle,
        textAlign: TextAlign.center,
      ),
      Text(
        text["practice"],
        style: ComplTextStyle,
        textAlign: TextAlign.center,
      )
    ];
  }
  Widget w = Align(
      alignment: Alignment(0.0, -0.95),
      child: Container(
          alignment: Alignment.center,
          height: textHeight * model.screenHRatio,
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: completeText,
          )));
  slw.add(w);

  Widget c = Container(
      alignment: Alignment.center,
      height: 90.0 * model.screenHRatio,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text["yourScore"],
            style: sts,
            textAlign: TextAlign.center,
          ),
          Text(
            score.toString() + " %",
            style: bts,
            textAlign: TextAlign.center,
          )
        ],
      ));

  double sh = 110.0 * model.screenHRatio;
  double sw = 70.0 * model.screenWRatio;
  Widget s = Container(
    alignment: Alignment.center,
    height: sh,
    width: sw * 3 + 20.0,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        getScoreCard(text["corr"], corr, Color(0xFF4DC591),
            Alignment.bottomCenter, sh, sw),
        getScoreCard(
            text["totalQ"], ll, Color(0xFF1785C1), Alignment.topCenter, sh, sw),
        getScoreCard(text["incorr"], incorr, Color(0xFFF76F71),
            Alignment.bottomCenter, sh, sw),
      ],
    ),
  );

  double shareHeight = 60 * model.screenHRatio;
  Map<String, dynamic> nmap = {
    "parent": map,
    "width": width,
    "height": 750.0 * model.screenHRatio,
    "shareHeight": shareHeight,
    "controller": controller,
    "shareIcon": "assets/images/share.png"
  };

  Widget gameList = Align(
      alignment: Alignment(0.0, 0.95),
      child: Container(
          alignment: Alignment.center,
          width: 350.0 * model.screenWRatio,
          height: 390.0 * model.screenHRatio,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: scoreMark
                ? [
                    c,
                    s,
                    getShareContainer(nmap),
                    socialMediaButtons(),
                    _buildWidget("GameDone", nmap)
                  ]
                : [
                    c,
                    s,
                    SizedBox(height: shareHeight),
                    _buildWidget("GameTryAgain", nmap),
                    _buildWidget("GameDone", nmap)
                  ],
          )));
  slw.add(gameList);
  nmap["gameCompleteList"] = slw;
  Widget gameComplete = GameComplete(nmap);

  closeResultDialog(parm, model, controller);
  List<Widget> stackList = fsm["stackList"];
  stackList.add(gameComplete);
  _notifyStack(stackList, controller, map);
}

repeatGame(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  Map<String, dynamic> map = parm["map"] as Map<String, dynamic>;
  Map<String, dynamic> fsm = model.fsm;
  String fsmName = fsm["fsmName"];

  Map<String, dynamic> nParm = {"map": map, "fsmName": fsmName};
  controller.doAction("initFSM", nParm);
  nParm = {"map": map, "event": "next"};
  controller.doAction("handleFSMEvent", nParm);
}

_notifyStack(List<Widget> stackList, ProcessController controller,
    Map<String, dynamic> map) {
  Map<String, dynamic> nParm = {
    "map": map,
    "notifier": "°/stackListNoti",
    "value": stackList
  };
  controller.doAction("valueNotify", nParm);
}

getBaseNaviRow(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  print("getBaseNaviRow");
  Map<String, dynamic> map = parm["map"] as Map<String, dynamic>;
  Map<String, dynamic> fsm = model.fsm;
  String iName = controller.getContent("*/item", map);
  Map<String, dynamic> item = fsm[iName];
  String title = controller.getContent(item["title"], map);
  Widget tw = Align(
      alignment: Alignment(-0.9, 0.0),
      child: Text(
        title,
        style: SliderTextStyle,
      ));
  if (viewMore == null) {
    String vm = controller.getContent(fsm["ViewMore"], map);
    viewMore = Align(
        alignment: Alignment(0.9, 0.0),
        child: Text(
          vm,
          style: ViewMoreStyle,
        ));
  }
  Map<String, dynamic> bMap = {
    "elements": {
      "wrapper": "WrappedContainer",
      "height": model.screenHRatio * 38.0,
      "width": model.screenWRatio * 360.0,
      "mainAxisAlignment": "spaceBetween",
      "crossAxisAlignment": "center",
      "children": [tw, viewMore]
    },
    "actions": {"hratio": "height"},
    "builder": {"name": "Row"}
  };

  Map<String, dynamic> cMap = {
    "elements": {
      "bheight": 400.0,
      "height": model.screenHRatio * 125.0,
      "wrapper": "WrappedContainer",
      "alignment": Alignment.centerLeft,
      "itemRef": item["itemList"],
      "onTap": {"routing": {}},
      "child": "CatCol",
      "direction": "horizontal",
      "physics": clampingScrollPhysics,
    },
    "builder": {"name": "TapListItem"}
  };
  map["children"] = [_buildWidget(bMap, map), _buildWidget(cMap, map)];
}

Widget viewMore;

getCatView(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  Map<String, dynamic> map = parm["map"] as Map<String, dynamic>;
  Map<String, dynamic> fsm = model.fsm;
  String iName = controller.getContent("*/item", map);
  Map<String, dynamic> item = fsm[iName];
  String s = controller.getContent(item["title"], map);
  map["title"] = s;
  map["init"] = item["init"];
  map["reset"] = item["reset"];
  Widget tw = Text(
    s,
    style: SliderBoldTextStyle,
  );
  s = controller.getContent(item["icon"], map);

  double a = item["iconShift"];
  AlignmentGeometry al;
  if (a != null) {
    al = Alignment(a, 0.0);
  }
  double hc = model.screenHRatio * 100.0;
  double w = model.screenWRatio * 80.0;
  Map<String, dynamic> iMap = {
    "elements": {
      "boxDecoration": "^/shadowDecoration",
      "alignment": al ?? Alignment.center,
      "height": hc,
      "width": w,
      "child": Icon(myIcons[s],
          size: model.screenWRatio * 45, color: Color(0xFF1785C1))
    },
    "builder": "Container"
  };
  Widget ic = _buildWidget(iMap, map);

  List<dynamic> il = item["itemList"];
  double h = model.screenWRatio * 17.0;
  if (il == null) {
    bool b = (item["init"] == null)
        ? false
        : _checkProgress(item["init"]["progId"], model.progNoti.value);
    if (b) {
      Widget pi = Positioned(
        top: hc * 0.70,
        left: w * 0.70,
        child: Icon(myIcons["correct"], size: h, color: Color(0xFF4DC591)),
      );
      ic = Stack(
        alignment: Alignment.center,
        children: [ic, pi],
      );
    }
  } else {
    int i = 0;
    for (var s in il) {
      Map<String, dynamic> itm = fsm[s as String];
      bool bi = (itm["init"] == null)
          ? false
          : _checkProgress(itm["init"]["progId"], model.progNoti.value);
      if (bi) {
        i++;
      }
    }
    double hp = 15 * model.screenHRatio;
    bool full = (i == il.length);
    Widget pi = (i == 0)
        ? null
        : Container(
            width: full ? w : w * i / il.length,
            height: hp,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10)),
              gradient: greenGradient,
            ));

    Widget pc = Positioned(
        top: hc * 0.85,
        left: 0.0,
        child: (i == 0)
            ? Container(
                width: w,
                height: hp,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                    border: Border.all(color: colorMap["correct"], width: 1)),
              )
            : Container(
                alignment: Alignment.centerLeft,
                width: w,
                height: hp,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                    border: Border.all(color: colorMap["correct"], width: 1)),
                child: pi,
              ));
    ic = Stack(
      alignment: Alignment.center,
      children: [ic, pc],
    );
  }
  map["children"] = [
    ic,
    SizedBox(
      height: 2,
    ),
    tw
  ];
}

routing(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  Map<String, dynamic> map = parm["map"] as Map<String, dynamic>;
  Map<String, dynamic> fsm = model.fsm;
  String iName = controller.getContent("*/item", map);
  Map<String, dynamic> item = fsm[iName];
  String fsmName = item["fsmName"];
  String routePath = item["routePath"] ?? "GameScaffold";
  if (fsmName != null) {
    Map<String, dynamic> actions = {
      "pushFSM": {},
      "initFSM": {"fsmName": fsmName},
      "route": {"path": routePath}
    };
    String entity = item["entity"];
    if (entity != null) {
      map["entity"] = controller.getContent(item["entity"], map);
    }
    map["fsmName"] = fsmName;
    controller.performActions(actions, map);
  }
}

multiAnswer(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  Map<String, dynamic> map = parm["map"] as Map<String, dynamic>;
  Map<String, dynamic> fsm = model.fsm;
  int index = fsm["selIndex"];
  int ansIndex = controller.getContent("*/ansIndex", map);
  List<dynamic> list = controller.getContent("*/list", map);
  map["item"] = list[index];
  List<Widget> stackList = fsm["stackList"];
  Map<String, dynamic> nparm;
  List<Widget> choiceList = fsm["choiceList"];
  if (index == ansIndex) {
    nparm = {"mode": "success", "map": map};
    Widget w = _buildWidget("CorrChoiceElement", map);
    choiceList[index] = w;
    stackList.add(fsm["corrDialog"]);
  } else {
    nparm = {"mode": "fail", "map": map};
    Widget w = _buildWidget("IncorrChoiceElement", map);
    choiceList[index] = w;
    int lives = controller.getContent("/userProfile/lives", map);
    Map<String, dynamic> actions = {
      "buildResultDialog": {"resultDesc": "failDesc", "key": "failDialog"}
    };
    List<dynamic> l = fsm["progress"];
    bool notRepeat = true;
    int i = 0;
    while (notRepeat && (i < l.length) && (l[i] != -1)) {
      if (l[i] > 1) {
        notRepeat = false;
      } else {
        i++;
      }
    }
    if ((lives > 0) && (notRepeat)) {
      lives--;
      actions = {
        "buildResultDialog": {"resultDesc": "lifeDesc", "key": "failDialog"},
        "setContent": {"key": "/userProfile/lives", "content": lives}
      };
      ValueNotifier<String> ln = controller.getContent("^/livesNoti", map);
      ln.value = lives.toString();
    }
    controller.performActions(actions, map);
    stackList.add(fsm["failDialog"]);
  }
  setProgRow(nparm, model, controller);
  ValueNotifier<List<Widget>> cn = fsm["gridViewNoti"];
  cn.value = choiceList;
  //ValueNotifier<List<Widget>> sn = fsm["stackListNoti"];
  //sn.value = stackList;
  _notifyStack(stackList, controller, map);
}

vSliderAnswer(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  Map<String, dynamic> map = parm["map"] as Map<String, dynamic>;
  Map<String, dynamic> fsm = model.fsm;
  Map<String, dynamic> item = controller.getContent("*/gameItem", map);
  String scale1 = fsm["scale1"];
  String scale2 = fsm["scale2"];
  int ans1 = item[scale1.toLowerCase()];
  int ans2 = item[scale2.toLowerCase()];
  int top1 = fsm[scale1 + "Top"];
  int bottom1 = fsm[scale1 + "Bottom"];
  int top2 = fsm[scale2 + "Top"];
  int bottom2 = fsm[scale2 + "Bottom"];
  int des = 0;
  int per = 0;
  if (ans1 == null) {
    ans1 = ((ans2 - top2) * (bottom1 - top1) / (bottom2 - top2) + top1).toInt();
    des = ans2 - fsm["in2"];
    per = (des * 100 ~/ (bottom2 - top2)).abs();
  }
  if (ans2 == null) {
    ans2 = ((ans1 - top1) * (bottom2 - top2) / (bottom1 - top1) + top2).toInt();
    des = ans1 - fsm["in1"];
    per = (des * 100 ~/ (bottom1 - top1)).abs();
  }
  fsm["ans1"] = ans1;
  fsm["ans2"] = ans2;
  ValueNotifier<int> vn = fsm["sliderNoti"];
  if (des == 0) {
    fsm["resStatus"] = "g";
    Map<String, dynamic> actions = {
      "setProgRow": {"mode": "success"},
      "buildSliderResult": {},
      "handleList": {
        "type": "add",
        "list": "°/stackList",
        "value": "°/corrDialog"
      },
      "valueNotify": {"value": "°/stackList", "notifier": "°/stackListNoti"}
    };
    vn.value = 1;
    controller.performActions(actions, map);
  } else {
    fsm["A%"] = per.toString();
    if (per <= fsm["almostPer"]) {
      fsm["resStatus"] = "o";
      Map<String, dynamic> actions = {
        "setProgRow": {"mode": "success"},
        "buildResultDialog": {"resultDesc": "almostDesc"}
      };
      vn.value = 2;
      controller.performActions(actions, map);
    } else {
      int lives = controller.getContent("/userProfile/lives", map);
      fsm["resStatus"] = "r";
      Map<String, dynamic> actions = {
        "setProgRow": {"mode": "fail"},
        "buildResultDialog": {"resultDesc": "failDesc"}
      };
      List<dynamic> l = fsm["progress"];
      bool notRepeat = true;
      int i = 0;
      while (notRepeat && (i < l.length) && (l[i] != -1)) {
        if (l[i] > 1) {
          notRepeat = false;
        } else {
          i++;
        }
      }
      if ((lives > 0) && (notRepeat)) {
        lives--;
        actions = {
          "setProgRow": {"mode": "fail"},
          "buildResultDialog": {"resultDesc": "lifeDesc"},
          "setContent": {"key": "/userProfile/lives", "content": lives}
        };
        ValueNotifier<String> ln = controller.getContent("^/livesNoti", map);
        ln.value = lives.toString();
      }
      vn.value = 2;
      controller.performActions(actions, map);
    }
  }
}

threeSliderAnswer(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  Map<String, dynamic> map = parm["map"] as Map<String, dynamic>;
  Map<String, dynamic> fsm = model.fsm;
  Map<String, dynamic> item = controller.getContent("*/gameItem", map);
  String scale = fsm["scale1"];
  double ans1 = item[scale];
  fsm["ans1"] = ans1;
  scale = fsm["scale2"];
  fsm["ans2"] = item[scale];
  scale = fsm["scale3"];
  fsm["ans3"] = item[scale];
  double per = ((ans1 - fsm["in1"]) / ans1 * 100.00).abs();
  ValueNotifier<int> vn = fsm["sliderNoti"];
  fsm["A%"] = per.toStringAsFixed(2);
  if (per <= fsm["corrPer"]) {
    fsm["resStatus"] = "g";
    Map<String, dynamic> actions = {
      "setProgRow": {"mode": "success"},
      "buildResultDialog": {"resultDesc": "corrDesc"}
    };
    Map<String, dynamic> nparm = {"type": "horizontal"};
    buildSliderResult(nparm, model, controller);
    vn.value = 1;
    controller.performActions(actions, map);
  } else {
    if (per <= fsm["almostPer"]) {
      fsm["resStatus"] = "o";
      Map<String, dynamic> actions = {
        "setProgRow": {"mode": "success"},
        "buildResultDialog": {"resultDesc": "almostDesc"}
      };
      vn.value = 2;
      controller.performActions(actions, map);
    } else {
      int lives = controller.getContent("/userProfile/lives", map);
      fsm["resStatus"] = "r";
      Map<String, dynamic> actions = {
        "setProgRow": {"mode": "fail"},
        "buildResultDialog": {"resultDesc": "failDesc"}
      };
      List<dynamic> l = fsm["progress"];
      bool notRepeat = true;
      int i = 0;
      while (notRepeat && (i < l.length) && (l[i] != -1)) {
        if (l[i] > 1) {
          notRepeat = false;
        } else {
          i++;
        }
      }
      if ((lives > 0) && (notRepeat)) {
        lives--;
        actions = {
          "setProgRow": {"mode": "fail"},
          "buildResultDialog": {"resultDesc": "lifeDesc"},
          "setContent": {"key": "/userProfile/lives", "content": lives}
        };
        ValueNotifier<String> ln = controller.getContent("^/livesNoti", map);
        ln.value = lives.toString();
      }
      vn.value = 2;
      controller.performActions(actions, map);
    }
  }
}

showAnswer(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  Map<String, dynamic> map = parm["map"] as Map<String, dynamic>;
  closeResultDialog(parm, model, controller);
  Map<String, dynamic> nparm = {"resultDesc": "answerDesc", "map": map};
  buildResultDialog(nparm, model, controller);
}

sliderShowAnswer(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  Map<String, dynamic> map = parm["map"] as Map<String, dynamic>;
  Map<String, dynamic> fsm = model.fsm;
  closeResultDialog(parm, model, controller);
  String type = parm["type"];
  Map<String, dynamic> actions = (type == null)
      ? {
          "buildSliderResult": {},
        }
      : {
          "buildSliderResult": {"type": type},
        };
  if (fsm["resStatus"] == "o") {
    actions["buildResultDialog"] = {"resultDesc": "almostAnswerDesc"};
  } else {
    actions["buildResultDialog"] = {"resultDesc": "failAnswerDesc"};
  }
  controller.performActions(actions, map);
  ValueNotifier<int> vn = fsm["sliderNoti"];
  vn.value = 1;
}

buildResultDialog(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  Map<String, dynamic> map = parm["map"] as Map<String, dynamic>;
  Map<String, dynamic> fsm = model.fsm;
  Map<String, dynamic> rd = fsm[parm["resultDesc"]];
  String title = controller.getContent(rd["title"], map);
  String subTitle = rd["subTitle"];
  if (subTitle != null) {
    subTitle = controller.getContent(subTitle, map);
    subTitle = _overwrite(subTitle, fsm, map, controller);
  }
  double w = rd["width"] ?? 350.0;
  w = w * model.screenWRatio;
  double h = rd["height"] ?? 148.0;
  h = h * model.screenHRatio;
  Widget bt = Align(
    alignment: Alignment(-0.8, 0.0),
    child: (subTitle == null)
        ? Text(
            title,
            style: BannerTxtStyle,
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                title,
                style: BannerTxtStyle,
              ),
              Text(
                subTitle,
                style: SelButnTxtStyle,
              )
            ],
          ),
  );
  Widget banner = Container(
    height: 59.0 * model.screenHRatio,
    width: w,
    decoration: rd["decoration"],
    child: bt,
  );
  String rt = rd["resultText"];
  double rth = rd["resTxtHeight"] ?? 20.0;
  rth = rth * model.screenHRatio;
  var rtsd = rd["resTxtStyle"];
  TextStyle rts = (rtsd is String) ? controller.getContent(rtsd, map) : rtsd;
  if (rt != null) {
    rt = controller.getContent(rt, map);
    rt = _overwrite(rt, fsm, map, controller);
  }
  Widget rtc = Container(
    height: rth,
    width: w,
    alignment: Alignment.center,
    color: Colors.white,
    child: (rt != null) ? Text(rt, style: rts ?? ResTxtStyle) : null,
  );
  var btn = rd["btn"];
  Widget btns;
  if (btn is String) {
    btns = controller.getContent("^/" + btn, map) as Widget;
  } else {
    List<dynamic> lb = btn as List<dynamic>;
    List<Widget> lw = [];
    for (int i = 0; i < lb.length; i++) {
      lw.add(controller.getContent("^/" + lb[i], map));
    }
    btns = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: lw,
    );
  }
  Map<String, dynamic> resColSpec = {
    "elements": {
      "mainAxisAlignment": "spaceBetween",
      "wrapper": "ClipRRect",
      "borderRadius": {"radius": 18, "type": "circular"},
      "children": "*/children"
    },
    "builder": {"name": "Column"}
  };
  Map<String, dynamic> nmap = {
    "parent": map,
    "children": <Widget>[
      banner,
      rtc,
      btns,
      SizedBox(
        height: 5.0,
      )
    ]
  };

  Widget resDialog = Align(
    alignment: Alignment(0.0, 0.99),
    child: Container(
      alignment: Alignment.center,
      height: h,
      width: w,
      decoration: controller.getContent("^/diaDecoration", map),
      child: _buildWidget(resColSpec, nmap),
    ),
  );
  String key = parm["key"];
  if (key != null) {
    fsm[key] = resDialog;
  } else {
    List<Widget> stackList = fsm["stackList"];
    stackList.add(resDialog);
    _notifyStack(stackList, controller, map);
  }
}

String _overwrite(String str, Map<String, dynamic> fsm,
    Map<String, dynamic> map, ProcessController controller) {
  String s = str;
  while (s.contains("#")) {
    String s1 = s.substring(s.indexOf("#") + 1);
    int i = s1.indexOf("#");
    String t = s1.substring(0, i);
    String r = fsm[t];
    r = (r != null) ? controller.getContent(r, map) : "";
    s = s.replaceFirst("#" + t + "#", r);
  }
  return s;
}

buildSliderResult(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  Map<String, dynamic> map = parm["map"] as Map<String, dynamic>;
  Map<String, dynamic> fsm = model.fsm;
  bool isVert = (parm["type"] == "horizontal") ? false : true;
  Color c = (fsm["resStatus"] == "g")
      ? colorMap["correct"]
      : (fsm["resStatus"] == "o")
          ? colorMap["almost"]
          : colorMap["incorrect"];
  TextStyle ts = SliderTextStyle.copyWith(color: c);
  TextStyle ts1 = ComplTextStyle.copyWith(color: c);
  List<Widget> wl = isVert
      ? [
          Text(
            fsm["scale1"],
            style: ts,
          ),
          Text(
            fsm["ans1"].toString(),
            style: ts1,
          ),
        ]
      : [
          Text(
            fsm["ans1"].toString() + fsm["suffix1"],
            style: ts,
          ),
        ];
  Map<String, dynamic> m1 = {
    "parent": map,
    "resColor": c,
    "resCol": Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: wl,
        ))
  };
  Widget w1 = _buildWidget("VSliderResValue", m1);
  wl = isVert
      ? [
          Text(
            fsm["scale2"],
            style: ts,
          ),
          Text(
            fsm["ans2"].toString(),
            style: ts1,
          ),
        ]
      : [
          Text(
            fsm["ans2"].toString() + fsm["suffix2"],
            style: ts,
          ),
        ];
  m1["resCol"] = Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(left: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: wl,
      ));
  Widget w2 = _buildWidget("VSliderResValue", m1);
  Widget ansC = Container(
    width: 60.0,
    height: 16.0,
    //margin: EdgeInsets.only(left: 15.0),
    color: Colors.white,
    alignment: Alignment(-0.9, 0.0),
    child: Text(
      controller.getContent("/text/Answer", map),
      style: ts,
    ),
  );

  if (isVert) {
    Widget ansW = Align(alignment: Alignment(-0.2, 1.0), child: ansC);
    Widget w = Align(
        alignment: Alignment(1.0, 0.0),
        child: Container(
            width: 50.0 * model.screenWRatio,
            height: 170.0 * model.screenHRatio,
            child: OverflowBox(
                maxWidth: 160.0,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.topLeft,
                        children: [SizedBox(height: 60.0), w2, ansW],
                      ),
                      Stack(
                          alignment: Alignment.topLeft,
                          children: [SizedBox(height: 60.0), w1, ansW])
                    ]))));
    List<Widget> stackList = fsm["stackList"];
    stackList.add(w);
  } else {
    Widget ansW = Align(alignment: Alignment(-0.3, -1.0), child: ansC);
    fsm["res1"] = Container(
        width: 80.0 * model.screenWRatio,
        height: 60.0 * model.screenHRatio,
        child: OverflowBox(
            maxWidth: 180.0,
            child: Stack(alignment: Alignment.topLeft, children: [w1, ansW])));
    fsm["res2"] = Container(
        width: 80.0 * model.screenWRatio,
        height: 60.0 * model.screenHRatio,
        child: OverflowBox(
            maxWidth: 180.0,
            child: Stack(alignment: Alignment.topLeft, children: [w2, ansW])));
    wl = [
      Text(
        fsm["ans3"].toString() + fsm["suffix3"],
        style: ts,
      ),
    ];
    m1["resCol"] = Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: wl,
        ));
    fsm["res3"] = Container(
        width: 80.0 * model.screenWRatio,
        height: 60.0 * model.screenHRatio,
        child: OverflowBox(
            maxWidth: 180.0,
            child: Stack(
                alignment: Alignment.topLeft,
                children: [_buildWidget("VSliderResValue", m1), ansW])));
  }
}

closeResultDialog(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  Map<String, dynamic> fsm = model.fsm;
  List<Widget> stackList = fsm["stackList"];
  int stackLength = fsm["stackLength"];
  while (stackList.length > stackLength) {
    stackList.removeLast();
  }
}

getGroupBody(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  Map<String, dynamic> map = parm["map"] as Map<String, dynamic>;
  Map<String, dynamic> fsm = model.fsm;
  String iName = controller.getContent("*/item", map);
  Map<String, dynamic> item = fsm[iName];
  String title = controller.getContent(item["title"], map);
  Widget tc = Text(
    title,
    style: QuestionTextStyle,
  );
  Map<String, dynamic> cMap = {
    "elements": {
      "bheight": 400.0,
      "height": model.screenHRatio * 240.0,
      "wrapper": "WrappedContainer",
      "alignment": Alignment.centerLeft,
      "crossAxisCount": 3,
      "itemRef": item["itemList"],
      "onTap": {"routing": {}},
      "child": "CatCol",
      "physics": clampingScrollPhysics,
    },
    "builder": {"name": "TapListItem"}
  };
  Map<String, dynamic> nmap = {"parent": map, "topicDialogChild": tc};
  Map<String, dynamic> bodySpec = {
    "elements": {"color": "#FFFFFF", "alignment": "topCenter"},
    "widgets": {
      "child": {
        "elements": {
          "crossAxisAlignment": "center",
          "mainAxisAlignment": "spaceBetween",
          "mainAxisSize": "max",
          "children": [
            _buildWidget("TopicContainer", nmap),
            ValueListenableBuilder<List<int>>(
              valueListenable: model.progNoti,
              builder: (BuildContext context, List<int> value, Widget child) =>
                  _buildWidget(cMap, map),
            )
          ]
        },
        "builder": {"name": "ListView"}
      }
    },
    "builder": "Container"
  };

  map["body"] = _buildWidget(bodySpec, map);
}

bool _checkProgress(int p, List<int> prog) {
  if ((p == null) || (prog == null)) {
    return false;
  }
  int n = p & 15;
  if (n >= prog.length) {
    return null;
  }
  return p == prog[n] & p;
}

progNotify(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  List<int> pn =
      model.map["userProfile"]["progress"].map<int>((e) => e as int).toList();
  model.progNoti.value = pn;
}
