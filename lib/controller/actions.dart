import 'package:flutter/material.dart';
import 'package:json_theme/json_theme.dart';
import 'package:sirius_geo/builder/comp_builder.dart';
import 'package:sirius_geo/builder/decode_theme.dart';
import 'package:sirius_geo/controller/process_controller.dart';
import 'package:sirius_geo/model/main_model.dart';
import 'package:sirius_geo/locator.dart';
import 'package:sirius_geo/controller/fsm_action.dart';
import 'package:sirius_geo/resources/app_actions.dart';
import 'dart:math';
import 'package:sirius_geo/resources/basic_resources.dart';

Map<String, dynamic> getMapParent(String t, Map<String, dynamic> map) {
  Map<String, dynamic> m = map;
  while ((m != null) && (m[t] == null)) {
    m = m["parent"] as Map<String, dynamic>;
  }
  return m;
}

Map<String, dynamic> getMap(List<String> token, Map<String, dynamic> map) {
  int l = token.length;
  if (l == 1) {
    return map;
  }
  Map<String, dynamic> m = map;
  for (String s in token) {
    if (l == 1) {
      return m;
    } else {
      dynamic ms = m[s];
      if ((ms != null) && (ms is Map<String, dynamic>)) {
        m = ms;
        l--;
      } else {
        return null;
      }
    }
  }
  return null;
}

dynamic getMapContent(String spec, Map<String, dynamic> map) {
  List<String> token = spec.split("/");
  Map<String, dynamic> m = getMap(token, map);
  if (m == null) {
    return null;
  }
  return (m[token[token.length - 1]]);
}

dynamic getSpecContent(
    String spec, Map<String, dynamic> widgetMap, MainModel model) {
  switch (spec[0]) {
    case '/':
      {
        return getMapContent(spec.substring(1), model.map);
      }
    case '.':
      if (spec == "...") {
        break;
      }
      return getMapContent(spec.substring(2), widgetMap);
    case '*':
      {
        String s = spec.substring(2);
        List<String> t = s.split('/');
        Map<String, dynamic> m = getMapParent(t[0], widgetMap);
        if (m != null) {
          return getMapContent(s, m);
        }
        return null;
      }
    case '^':
      return getMapContent(spec.substring(2), model.stateData);
    case '°':
      return getMapContent(spec.substring(2), model.fsm);
      break;
    default:
      break;
  }
  return spec;
}

swap(Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  String key = parm["key"] as String;
  Map<String, dynamic> map = parm["map"] as Map<String, dynamic>;
  String d = parm["data"] as String;
  dynamic s1 = map[key];
  map[key] = map[d];
  map[d] = s1;
}

pushFSM(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  model.fsmList.add(model.fsm);
}

route(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  String path = parm["path"] as String;
  Map<String, dynamic> map = parm["map"] as Map<String, dynamic>;
  Navigator.pushNamed(model.context, path, arguments: {"map": map});
}

popRoute(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  bool mode = parm["mode"] ?? true;
  if (mode) {
    int l = model.fsmList.length;
    if (l > 0) {
      model.fsm = model.fsmList[l - 1];
      model.fsmList.removeLast();
    }
  }
  Navigator.of(model.context).pop(mode);
}

upperCase(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  String key = parm["key"] as String;
  Map<String, dynamic> map = parm["map"] as Map<String, dynamic>;
  if (cSet.contains(key[0]) || (key.startsWith("pattern"))) {
    String s = getSpecContent(key, map, model);
    if (s != null) {
      parm["content"] = s.toUpperCase();
      setContent(parm, model, controller);
    }
  } else {
    String s = map[key] as String;
    if (s != null) {
      map[key] = s.toUpperCase();
    }
  }
}

lowerCase(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  String key = parm["key"] as String;
  Map<String, dynamic> map = parm["map"] as Map<String, dynamic>;
  if (cSet.contains(key[0])) {
    String s = getSpecContent(key, map, model);
    if (s != null) {
      parm["content"] = s.toLowerCase();
      setContent(parm, model, controller);
    }
  } else {
    String s = map[key] as String;
    if (s != null) {
      map[key] = s.toLowerCase();
    }
  }
}

changeColor(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  Map<String, dynamic> map;
  String key;
  dynamic d;
  parm.forEach((k, value) {
    if (k == "map") {
      map = value as Map<String, dynamic>;
    } else {
      key = k;
      d = value;
    }
  });
  var mk = map[key];
  if (mk != null) {
    Color c = ThemeDecoder.decodeColor(d, validate: false);
    if (mk is TextStyle) {
      map[key] = mk.copyWith(color: c);
    } else if (mk is BoxDecoration) {
      map[key] = mk.copyWith(color: c);
    }
  }
}

backgroundColor(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  Map<String, dynamic> map;
  String key;
  dynamic d;
  parm.forEach((k, value) {
    if (k == "map") {
      map = value as Map<String, dynamic>;
    } else {
      key = k;
      d = value;
    }
  });
  var mk = map[key];
  if (mk != null) {
    Color c = ThemeDecoder.decodeColor(d, validate: false);
    if (mk is TextStyle) {
      map[key] = mk.copyWith(backgroundColor: c);
    }
  }
}

setBorder(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  Map<String, dynamic> map;
  String key;
  dynamic d;
  parm.forEach((k, value) {
    if (k == "map") {
      map = value as Map<String, dynamic>;
    } else {
      key = k;
      d = value;
    }
  });
  var mk = map[key];
  if ((mk != null) && (mk is BoxDecoration)) {
    Border b = ThemeDecoder.decodeBoxBorder(d, validate: false);
    map[key] = mk.copyWith(border: b);
  }
}

expand(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  String key = parm["key"] as String;
  Map<String, dynamic> map = parm["map"] as Map<String, dynamic>;
  double height = double.infinity;
  dynamic d = parm["height"];
  if (d != null) {
    height = (d is String) ? map[d] : d as double;
  }
  d = parm["width"];
  double width = double.infinity;
  if (d != null) {
    width = (d is String) ? map[d] : d as double;
  }
  map[key] = BoxConstraints.expand(width: width, height: height);
}

decode(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  String key;
  Map<String, dynamic> map;
  Function f;
  dynamic d;
  parm.forEach((k, v) {
    switch (k) {
      case "key":
        key = v as String;
        break;
      case "map":
        map = v as Map<String, dynamic>;
        break;
      case "resource":
        d = resources[v];
        break;
      default:
        f = getThemeDecoder(k);
        d = v;
        break;
    }
  });
  map[key] = (f != null) ? f(d) : d;
}

hratio(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  String key = parm["key"] as String;
  Map<String, dynamic> map = parm["map"] as Map<String, dynamic>;
  double d = model.screenHRatio * (map[key] as double);
  map[key] = d;
}

wratio(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  String key = parm["key"] as String;
  Map<String, dynamic> map = parm["map"] as Map<String, dynamic>;
  double d = model.screenWRatio * (map[key] as double);
  map[key] = d;
}

setContent(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  Map<String, dynamic> m;
  List<String> token;
  String spec = parm["key"];
  dynamic content = parm["content"];
  Map<String, dynamic> map = parm["map"];
  switch (spec[0]) {
    case '/':
      token = spec.substring(1).split("/");
      m = getMap(token, model.map);
      break;
    case '.':
      int i = 1;
      while (spec[i] == '.') {
        map = map["parent"];
        i++;
      }
      token = spec.substring(i + 1).split("/");
      m = getMap(token, map);
      break;
    case '*':
      token = spec.substring(2).split("/");
      m = getMapParent(token[0], map);
      m = getMap(token, m);
      break;
    case '^':
      token = spec.substring(2).split("/");
      Map<String, dynamic> aModel = model.stateData;
      m = (token.length > 1) ? getMap(token, aModel) : aModel;
      break;
    case '°':
      token = spec.substring(2).split("/");
      if (token.length <= 1) {
        m = model.fsm;
      } else {
        m = getMap(token, model.fsm);
      }
      break;
    default:
      token = [spec];
      m = map;
      break;
  }
  if (m != null) {
    if (content is String) {
      content = (content == '¨') ? map : getSpecContent(content, map, model);
    }
    m[token[token.length - 1]] = content;
  }
}

getRandom(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  String key = parm["key"];
  dynamic r = parm["range"];
  Map<String, dynamic> map = parm["map"];
  int range = (r is int) ? r : getSpecContent(r, map, model);

  dynamic ex = parm["exclude"];
  List<dynamic> exclude;
  exclude = (ex is String)
      ? getSpecContent(ex, map, model)
      : (ex != null)
          ? ex
          : [];
  Random random = new Random();
  int n = random.nextInt(range);
  while (exclude.contains(n)) {
    n++;
    if (n >= range) {
      n = 0;
    }
  }
  map[key] = n;
}

num calValue(
    bool isInt, List<dynamic> l, Map<String, dynamic> map, MainModel model) {
  dynamic l0 = l[0];
  String op = l[1];
  dynamic l2 = l[2];
  num d1 = (l0 is num)
      ? l0
      : (l0 is String)
          ? getSpecContent(l0, map, model)
          : calValue(isInt, l0, map, model);
  num d2 = (l2 is num)
      ? l2
      : (l2 is String)
          ? getSpecContent(l2, map, model)
          : calValue(isInt, l2, map, model);
  if (isInt) {
    d1 = (d1 is int) ? d1 : d1.toInt();
    d2 = (d2 is int) ? d2 : d2.toInt();
  } else {
    d1 = (d1 is double) ? d1 : d1.toDouble();
    d2 = (d2 is double) ? d2 : d2.toDouble();
  }
  switch (op) {
    case '+':
      return d1 + d2;
    case '-':
      return d1 - d2;
    case '/':
      return d1 / d2;
    case '*':
      return d1 * d2;
    default:
      return 0.0;
  }
}

compute(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  String key = parm["key"];
  List<dynamic> l = parm["formula"];
  Map<String, dynamic> map = parm["map"];
  bool isInt = parm["isInt"] ?? false;
  if ((key != null) && (map != null) && (l != null)) {
    map[key] = calValue(isInt, l, map, model);
  }
}

bool checkCondition(dynamic spec, Map<String, dynamic> map, MainModel model) {
  if (spec is String) {
    bool r = getSpecContent(spec, map, model);
    if (r == null) {
      return false;
    } else {
      return r;
    }
  }
  if (spec is List<dynamic>) {
    dynamic o1 = (spec[0] is List<dynamic>)
        ? checkCondition(spec[0], map, model)
        : (spec[0] is String)
            ? getSpecContent(spec[0], map, model)
            : spec[0];
    if (o1 is TextEditingController) {
      o1 = o1.text;
    }
    dynamic o2 = (spec.length < 3)
        ? null
        : (spec[2] is List<dynamic>)
            ? checkCondition(spec[2], map, model)
            : (spec[2] is String)
                ? getSpecContent(spec[2], map, model)
                : spec[2];
    if (o2 is TextEditingController) {
      o2 = o2.text;
    }
    switch (spec[1]) {
      case "||":
        return (o1 || o2);
      case "&&":
        return o1 && o2;
      case "==":
        return o1 == o2;
      case "!=":
        return o1 != o2;
      case "-==":
        return o1.toString().toLowerCase() == o2.toString().toLowerCase();
      case "-!=":
        return o1.toString().toLowerCase() != o2.toString().toLowerCase();
      case ">":
        return o1 > o2;
      case "<":
        return o1 < o2;
      case ">=":
        return o1 >= o2;
      case "<=":
        return o1 <= o2;
      case "contains":
        if (o1 is List<dynamic>) {
          return o1.contains(o2);
        }
        break;
      default:
        break;
    }
  }
  return false;
}

conAction(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  dynamic condSpec = parm["condition"];
  Map<String, dynamic> map = parm["map"];
  dynamic caction = checkCondition(condSpec, map, model)
      ? parm["trueAction"]
      : parm["falseAction"];
  if (caction != null) {
    controller.performActions(caction, map);
  }
}

build(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  String key = parm["key"];
  Map<String, dynamic> map = parm["map"];
  if ((parm["absence"] == null) || (map[key] == null)) {
    CompBuilder compBuilder = locator<CompBuilder>();
    dynamic builder = parm["builder"];
    if ((key != null) && (map != null) && (builder != null)) {
      dynamic mkey;
      if (builder is List<dynamic>) {
        mkey = compBuilder.builderBuildList(builder, map);
      } else {
        dynamic mapList = parm["mapList"];
        if (mapList != null) {
          if (mapList is String) {
            mapList = controller.getContent(mapList, map);
          }
          mkey = compBuilder.builderBuildMapList(builder, mapList, map);
        } else {
          mkey = compBuilder.builderBuild(builder, map);
        }
      }
      if (cSet.contains(key[0])) {
        parm["content"] = mkey;
        setContent(parm, model, controller);
      } else {
        map[key] = mkey;
      }
    }
  }
}

convert(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  Map<String, dynamic> map = parm["map"];
  String key = parm["key"];
  String type = parm["type"];
  try {
    dynamic value = parm["value"];
    if ((value is String) && cSet.contains(value[0])) {
      value = getSpecContent(value, map, model);
    }
    switch (type) {
      case "int":
        map[key] = int.parse(value);
        break;
      case "double":
        map[key] = double.parse(value);
        break;
      case "String":
        map[key] = value.toString();
        break;
      default:
        break;
    }
  } catch (e) {}
}

handleList(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  Map<String, dynamic> map = parm["map"];
  String type = parm["type"];
  dynamic pl = parm["list"];
  List<dynamic> list = (pl is String) ? getSpecContent(pl, map, model) : pl;
  dynamic value = parm["value"];
  value = ((value != null) && (value is String))
      ? getSpecContent(value, map, model)
      : value;
  switch (type) {
    case "length":
      String key = parm["key"] as String;
      if ((key != null) && (list != null)) {
        if (cSet.contains(key[0])) {
          parm["content"] = list.length;
          setContent(parm, model, controller);
        } else {
          map[key] = list.length;
        }
      }
      break;
    case "get":
      String key = parm["key"] as String;
      var i = parm["index"];
      int index = (i is int) ? i : getSpecContent(i, map, model);
      if ((key != null) && (index != null) && (list != null)) {
        if (cSet.contains(key[0])) {
          parm["content"] = list[index];
          setContent(parm, model, controller);
        } else {
          map[key] = list[index];
        }
      }
      break;
    case "add":
      list.add(value);
      break;
    case "addAll":
      list.addAll(value);
      break;
    case "insert":
      list.insert(0, value);
      break;
    case "insertAll":
      list.insertAll(0, value);
      break;
    case "insertAt":
      var i = parm["index"];
      int index = (i is int) ? i : getSpecContent(i, map, model);
      list.insert(index, value);
      break;
    case "insertAllAt":
      var i = parm["index"];
      int index = (i is int) ? i : getSpecContent(i, map, model);
      list.insertAll(index, value);
      break;
    case "remove":
      list.remove(value);
      break;
    case "removeAt":
      list.removeAt(value as int);
      break;
    case "removeLast":
      list.removeLast();
      break;
    case "removeRange":
      var i = parm["start"];
      int start = (i is int) ? i : getSpecContent(i, map, model);
      i = parm["end"];
      int end = (i is int) ? i : getSpecContent(i, map, model);
      list.removeRange(start, end);
      break;
    case "replace":
      var i = parm["index"];
      int index = (i is int) ? i : getSpecContent(i, map, model);
      list[index] = value;
      break;
    case "table":
      List<dynamic> rList = [];
      int nl = list.length;
      List<List<dynamic>> ll = [];
      for (int n = 0; n < nl; n++) {
        List<dynamic> l = getSpecContent(list[n], map, model) as List<dynamic>;
        ll.add(l);
      }
      List<dynamic> l0 = ll[0];
      for (int i = 0; i < l0.length; i++) {
        rList.add(l0[i]);
        for (int n = 1; n < nl; n++) {
          rList.add(ll[n][i]);
        }
      }
      String key = parm["key"] as String;
      dynamic rl = rList;
      String lt = parm["listType"];
      if (lt != null) {
        switch (lt) {
          case "widget":
            rl = <Widget>[];
            for (int i = 0; i < rList.length; i++) {
              rl.add(rList[i]);
            }
            break;
          case "String":
            rl = <String>[];
            for (int i = 0; i < rList.length; i++) {
              rl.add(rList[i]);
            }
            break;
          default:
            break;
        }
      }
      if (cSet.contains(key[0])) {
        parm["content"] = rl;
        setContent(parm, model, controller);
      } else {
        map[key] = rl;
      }
      break;
    case "tableCol":
      dynamic t = parm["totalCol"];
      int tc = (t is String) ? getSpecContent(t, map, model) : t;
      t = parm["col"];
      int c = (t is String) ? getSpecContent(t, map, model) : t;
      List<dynamic> l = [];
      while (c < list.length) {
        l.add(list[c]);
        c += tc;
      }
      String key = parm["key"] as String;
      if (cSet.contains(key[0])) {
        parm["content"] = l;
        setContent(parm, model, controller);
      } else {
        map[key] = l;
      }
      break;
    case "position":
      String key = parm["key"] as String;
      if (cSet.contains(key[0])) {
        parm["content"] = list.indexOf(value);
        setContent(parm, model, controller);
      } else {
        map[key] = list.indexOf(value);
      }
      break;
    case "copy":
      String lt = parm["listType"] ?? "default";
      dynamic l;
      switch (lt) {
        case "Widget":
          List<Widget> lw = [];
          for (int i = 0; i < list.length; i++) {
            lw.add(list[i] as Widget);
          }
          l = lw;
          break;
        case "String":
          List<String> lw = [];
          for (int i = 0; i < list.length; i++) {
            lw.add(list[i] as String);
          }
          l = lw;
          break;
        case "int":
          List<int> lw = [];
          for (int i = 0; i < list.length; i++) {
            lw.add(list[i] as int);
          }
          l = lw;
          break;
        case "double":
          List<double> lw = [];
          for (int i = 0; i < list.length; i++) {
            lw.add(list[i] as double);
          }
          l = lw;
          break;
        case "bool":
          List<bool> lw = [];
          for (int i = 0; i < list.length; i++) {
            lw.add(list[i] as bool);
          }
          l = lw;
          break;
        default:
          List<dynamic> lw = [];
          for (int i = 0; i < list.length; i++) {
            lw.add(list[i]);
          }
          l = lw;
          break;
      }
      String key = parm["key"] as String;
      if (cSet.contains(key[0])) {
        parm["content"] = l;
        setContent(parm, model, controller);
      } else {
        map[key] = l;
      }
      break;
    default:
      break;
  }
}

createNotifier(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  Map<String, dynamic> map = parm["map"];
  String key = parm["key"];
  String type = parm["type"];
  dynamic value = parm["value"];
  if (value is String) {
    value = getSpecContent(value, map, model);
  }
  if ((key != null) && (map != null) && (type != null)) {
    dynamic n;
    switch (type) {
      case "String":
        n = ValueNotifier<String>(value);
        break;
      case "map":
        n = ValueNotifier<Map<String, dynamic>>(value);
        break;
      case "int":
        n = ValueNotifier<int>(value ?? 0);
        break;
      case "double":
        n = ValueNotifier<double>(value ?? 0);
        break;
      case "bool":
        n = ValueNotifier<bool>(value ?? 0);
        break;
      case "widget":
        n = ValueNotifier<Widget>(value);
        break;
      case "widgetList":
        n = ValueNotifier<List<Widget>>(value);
        break;
      default:
        break;
    }
    if (cSet.contains(key[0])) {
      parm["content"] = n;
      setContent(parm, model, controller);
    } else {
      map[key] = n;
    }
  }
}

valueNotify(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  Map<String, dynamic> map = parm["map"];
  dynamic value = parm["value"];
  dynamic n = parm["notifier"];
  if ((value is String) && cSet.contains(value[0])) {
    value = getSpecContent(value, map, model);
  }
  if (value is String) {
    ValueNotifier<String> notifier =
        (n is String) ? getSpecContent(n, map, model) : n;
    notifier.value = value;
  } else if (value is Map<String, dynamic>) {
    ValueNotifier<Map<String, dynamic>> notifier =
        (n is String) ? getSpecContent(n, map, model) : n;
    notifier.value = value;
  } else if (value is int) {
    ValueNotifier<int> notifier =
        (n is String) ? getSpecContent(n, map, model) : n;
    notifier.value = value;
  } else if (value is double) {
    ValueNotifier<double> notifier =
        (n is String) ? getSpecContent(n, map, model) : n;
    notifier.value = value;
  } else if (value is bool) {
    ValueNotifier<bool> notifier =
        (n is String) ? getSpecContent(n, map, model) : n;
    notifier.value = value;
  } else if (value is Widget) {
    ValueNotifier<Widget> notifier =
        (n is String) ? getSpecContent(n, map, model) : n;
    notifier.value = value;
  } else if (value is List<dynamic>) {
    List<Widget> l = [];
    for (var w in value) {
      if (w is Widget) {
        l.add(w);
      }
    }
    ValueNotifier<List<Widget>> notifier =
        (n is String) ? getSpecContent(n, map, model) : n;
    notifier.value = l;
  }
}

randomList(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  Map<String, dynamic> map = parm["map"];
  String key = parm["key"] as String;
  String ansKey = parm["ansKey"];
  String ansIndex = parm["ansIndex"];
  int size;
  int range;
  if (parm["size"] is String) {
    size = getSpecContent(parm["size"], map, model);
    range = getSpecContent(parm["range"], map, model);
  } else {
    size = parm["size"];
    range = parm["range"];
  }
  dynamic ex = parm["exclude"];
  List<dynamic> exclude;
  int ansPos = 0;
  int ansVal = 0;
  exclude = (ex is String)
      ? getSpecContent(ex, map, model)
      : (ex != null)
          ? ex
          : [];
  Random random = new Random();
  List<dynamic> rList = [];
  while (rList.length < size) {
    int n = random.nextInt(range);
    while (exclude.contains(n)) {
      n++;
      if (n >= range) {
        n = 0;
      }
    }
    if (rList.length == 0) {
      rList.add(n);
      if (ansKey != null) {
        map[ansKey] = n;
      }
      exclude = rList;
      ansVal = n;
    } else {
      int i = rList.length - 1;
      if (n > rList[i]) {
        rList.add(n);
      } else {
        while ((n < rList[i]) && (i > 0)) {
          i--;
        }
        if (n > rList[i]) {
          rList.insert(i + 1, n);
        } else {
          rList.insert(i, n);
        }
      }
      if (n < ansVal) {
        ansPos++;
      }
    }
  }
  map[key] = rList;
  if (ansIndex != null) {
    map[ansIndex] = ansPos;
  }
}

createTextController(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  Map<String, dynamic> map = parm["map"];
  String key = parm["key"] as String;
  if ((map != null) && (key != null)) {
    map[key] = TextEditingController();
  }
}

getText(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  Map<String, dynamic> map = parm["map"];
  String key = parm["key"] as String;
  TextEditingController tcontroller = parm["controller"];
  if ((map != null) && (key != null) && (tcontroller != null)) {
    map[key] = tcontroller.text;
  }
}

replaceText(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  Map<String, dynamic> map = parm["map"];
  String key = parm["key"] as String;
  String text = getSpecContent(key, map, model);
  String r = parm["replace"];
  String b = parm["by"];
  if ((text != null) && (r != null) && (b != null)) {
    b = (cSet.contains(b[0])) ? getSpecContent(b, map, model) : b;
    text = text.replaceFirst(r, b);
    if (cSet.contains(key[0])) {
      parm["content"] = text;
      setContent(parm, model, controller);
    } else {
      map[key] = text;
    }
  }
}

const Map<String, Function> actions = {
  "backgroundColor": backgroundColor,
  //"blockModel": blockModel,
  "build": build,
  "buildFSM": buildFSM,
  "changeColor": changeColor,
  //"changeModelState": changeModelState,
  "compute": compute,
  "conAction": conAction,
  "convert": convert,
  //"createModel": createModel,
  "createNotifier": createNotifier,
  "createTextController": createTextController,
  "decode": decode,
  "expand": expand,
  //"getModelState": getModelState,
  //"getModelValue": getModelValue,
  "getRandom": getRandom,
  "getText": getText,
  "handleFSMEvent": handleFSMEvent,
  "handleList": handleList,
  //"handleModelEvent": handleModelEvent,
  "hratio": hratio,
  "initFSM": initFSM,
  "lowerCase": lowerCase,
  //"modelDoAction": modelDoAction,
  "randomList": randomList,
  "replaceText": replaceText,
  "resetFSM": resetFSM,
  "route": route,
  "popRoute": popRoute,
  "pushFSM": pushFSM,
  //"selection": selection,
  "setContent": setContent,
  "setBorder": setBorder,
  //"setModelState": setModelState,
  //"setModelValue": setModelValue,
  "swap": swap,
  //"unblockModel": unblockModel,
  "upperCase": upperCase,
  "valueNotify": valueNotify,
  "wratio": wratio,
};
