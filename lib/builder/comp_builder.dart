import 'package:flutter/material.dart';
import 'package:sirius_geo/builder/abstraction.dart';
import 'package:sirius_geo/model/main_model.dart';
import 'package:sirius_geo/builder/decode_theme.dart';
import 'package:sirius_geo/builder/get_widget.dart';

class CompBuilder {
  MainModel _model;

  setModel(MainModel model) {
    _model = model;
    controller.setModel(_model);
  }

  get model => _model;

  Map<String, dynamic> _schema;

  addCount() {
    _model.addCount();
  }

  Map<String, dynamic> getBuilderSpec(String name) {
    Map<String, dynamic> map = _model.stateData["map"];
    _schema ??= map["schema"] as Map<String, dynamic>;
    return _schema[name] as Map<String, dynamic>;
  }

  BaseBuilder getBuilder(dynamic ispec) {
    dynamic spec = ((ispec is String) && cSet.contains(ispec[0]))
        ? controller.getContent(ispec, null)
        : ispec;
    Map<String, dynamic> s;
    if (spec is String) {
      s = getBuilderSpec(spec);
      if (s == null) {
        return null;
      }
      return BaseBuilder(s, this, _model, spec);
    }
    s = spec as Map<String, dynamic>;
    return BaseBuilder(s, this, _model, null);
  }

  // a list of widgets with the same spec
  List<Map<String, dynamic>> mapList(
      dynamic mapList, BaseBuilder bb, Map<String, dynamic> parentMap) {
    List<Map<String, dynamic>> maps = [];
    Map<String, dynamic> bbMap = bb.map;
    if (mapList is Map<String, dynamic>) {
      mapList.forEach((key, value) {
        bb.map = {};
        if (bbMap != null) {
          controller.mergeJData(bb.map, bbMap);
        }
        bb.map["itemKey"] = key;
        bb.map["itemValue"] = value;
        Map<String, dynamic> m = bb.build(parentMap);
        maps.add(m);
      });
    } else {
      List<dynamic> ml = mapList as List<dynamic>;
      int index = 0;
      for (var e in ml) {
        bb.map = {};
        if (bbMap != null) {
          controller.mergeJData(bb.map, bbMap);
        }
        bb.map["item"] = e;
        bb.map["index"] = index++;
        Map<String, dynamic> m = bb.build(parentMap);
        maps.add(m);
      }
    }
    return maps;
  }

  List<Map<String, dynamic>> mapBuildList(
      dynamic mapList, List<dynamic> bl, Map<String, dynamic> map) {
    List<Map<String, dynamic>> maps = [];
    if (mapList is Map<String, dynamic>) {
      mapList.forEach((key, value) {
        for (var e in bl) {
          BaseBuilder bb = getBuilder(e);
          bb.map ??= {};
          bb.map["itemKey"] = key;
          bb.map["itemValue"] = value;
          Map<String, dynamic> m = bb.build(map);
          maps.add(m);
        }
      });
    } else {
      List<dynamic> l = mapList as List<dynamic>;
      int index = 0;
      for (var item in l) {
        for (var e in bl) {
          BaseBuilder bb = getBuilder(e);
          bb.map ??= {};
          bb.map["item"] = item;
          bb.map["index"] = index++;
          Map<String, dynamic> m = bb.build(map);
          maps.add(m);
        }
      }
    }
    return maps;
  }

  List<Map<String, dynamic>> buildMapList(
      List<dynamic> list, Map<String, dynamic> parentMap) {
    List<Map<String, dynamic>> maps = [];
    for (var e in list) {
      BaseBuilder bb = getBuilder(e);
      Map<String, dynamic> w = bb.build(parentMap);
      maps.add(w);
    }
    return maps;
  }

  Widget buildWiget(String name) {
    BaseBuilder bb = getBuilder(name);
    Map<String, dynamic> m = bb.build(null);
    return getBuilderWidget(m);
  }

  Widget builderBuild(dynamic builder, Map<String, dynamic> parentMap) {
    BaseBuilder bb = getBuilder(builder);
    Map<String, dynamic> m = bb.build(parentMap);
    return getBuilderWidget(m);
  }

  List<Widget> builderBuildList(
      List<dynamic> builder, Map<String, dynamic> parentMap) {
    List<dynamic> ml = buildMapList(builder, parentMap);
    return getBuilderWidgetList(ml);
  }

  List<Widget> builderBuildMapList(
      dynamic builder, dynamic inmapList, Map<String, dynamic> parentMap) {
    BaseBuilder bb = getBuilder(builder);
    List<dynamic> ml = mapList(inmapList, bb, parentMap);
    return getBuilderWidgetList(ml);
  }
}

class BaseBuilder {
  final CompBuilder compBuilder;
  final MainModel model;
  final String wname;

  Map<String, dynamic> map;
  Map<String, dynamic> jsonData;
  Map<String, dynamic> _widgets;
  Map<String, dynamic> _builder;
  Map<String, dynamic> _actions;
  Map<String, dynamic> _elements;

  bool _hasPattern = false;

  setMap(Map<String, dynamic> inMap) {
    map = inMap;
  }

  BaseBuilder(this.jsonData, this.compBuilder, this.model, this.wname);

  _setPattern(Map<String, dynamic> patSpec) {
    _hasPattern = true;
    patSpec.forEach((key, value) {
      switch (key) {
        case "trace":
          controller.trace(value.toString(), jsonData);
          break;
        case "elements":
          _elements ??= {};
          controller.mergeJData(_elements, value);
          break;
        case "widgets":
          _widgets ??= {};
          controller.mergeJData(_widgets, value);
          break;
        case "actions":
          _actions ??= {};
          controller.mergeJData(_actions, value);
          break;
        case "builder":
          _builder ??= {};
          if (value is String) {
            _builder["name"] = value;
          } else {
            controller.mergeJData(_builder, value);
          }
          break;
        case "patterns":
          dynamic v = value;
          if ((v is String) && cSet.contains(v[0])) {
            v = controller.getContent(v, map);
          }
          addPatterns(v, null);
          break;
        default:
          handleSpec(key, value);
          break;
      }
    });
  }

  addPattern(String pat, Map<String, dynamic> parentMap) {
    String v = cSet.contains(pat[0]) ? controller.getContent(pat, map) : pat;
    Map<String, dynamic> patSpec = compBuilder.getBuilderSpec(v);
    map ??= {};
    if (parentMap != null) {
      map["parent"] = parentMap;
    }
    _setPattern(patSpec);
  }

  addPatterns(List<dynamic> patterns, Map<String, dynamic> parentMap) {
    for (String pat in patterns) {
      addPattern(pat, parentMap);
    }
  }

  Map<String, dynamic> build(Map<String, dynamic> parentMap) {
    String traceName = jsonData["trace"];
    if (traceName != null) {
      controller.trace(traceName, jsonData);
    }
    map ??= {};
    if (wname != null) {
      map["wName"] = wname;
    }
    if (parentMap != null) {
      String parent = jsonData["parent"];
      if (parent != null) {
        if (parent != "null") {
          Map<String, dynamic> m = parentMap;
          while ((m != null) && (m["wname"] != parent)) {
            m = m["parent"] as Map<String, dynamic>;
          }
          if (m != null) {
            map["parent"] = m;
          }
        }
      } else {
        map["parent"] = parentMap;
      }
    }
    if (jsonData["patterns"] != null) {
      _setPattern(jsonData);
    }
    if (_hasPattern) {
      String order = jsonData["patOrder"];
      if (order != null) {
        for (int i = 0; i < order.length; i++) {
          switch (order[i]) {
            case 'e':
              setElements(_elements);
              break;
            case 'a':
              controller.performActions(_actions, map);
              break;
            case 'w':
              buildWidgets(_widgets);
              break;
            default:
              _handleBuild(_builder);
              break;
          }
        }
      } else {
        if (_elements != null) {
          setElements(_elements);
        }
        if (_actions != null) {
          controller.performActions(_actions, map);
        }
        if (_widgets != null) {
          buildWidgets(_widgets);
        }
        _handleBuild(_builder);
      }
    } else {
      jsonData.forEach((key, value) => handleSpec(key, value));
    }
    if (map["builder"] == null) {
      return null;
    }
    return map;
  }

  handleSpec(String key, dynamic value) {
    switch (key) {
      case "mapping":
        {
          mapData(value as Map<String, dynamic>);
          break;
        }
      case "elements":
        {
          setElements(value as Map<String, dynamic>);
          break;
        }
      case "widgets":
        {
          buildWidgets(value as Map<String, dynamic>);
          break;
        }
      case "actions":
        {
          controller.performActions(value as Map<String, dynamic>, map);
          break;
        }
      case "builder":
        {
          dynamic d = jsonData["builder"];
          if (d is String) {
            map["builder"] = d;
          } else {
            _handleBuild(jsonData["builder"]);
          }
          break;
        }
      case "ref": // Use the spec with the ref name of an ancestor
        {
          _handleRef(value as String);
          break;
        }
      default:
        {
          if (key.startsWith("actions")) {
            controller.performActions(value as Map<String, dynamic>, map);
          }
          break;
        }
    }
  }

  _handleRef(String ref) {
    Map<String, dynamic> m = map["parent"];
    Map<String, dynamic> rMap = (m != null) ? m[ref] : null;
    while ((m != null) && (rMap == null)) {
      m = m["parent"];
      rMap = (m != null) ? m[ref] : null;
    }
    if (rMap != null) {
      rMap.forEach((key, value) => handleSpec(key, value));
    }
  }

  mapData(Map<String, dynamic> mapping) {
    if (mapping != null) {
      mapping.forEach((key, value) {
        map[key] = controller.getContent(value as String, map);
      });
    }
  }

  setElements(Map<String, dynamic> elem) {
    map ??= {};
    if (elem != null) {
      elem.forEach((k, v) => map[k] ??= mapElement(k, v));
    }
  }

  dynamic mapElement(String k, dynamic v) {
    if ((v is String) && cSet.contains(v[0])) {
      return controller.getContent(v, map);
    }
    Function f = getThemeDecoder(k);
    if (f != null) {
      return f(v);
    }
    return v;
  }

  buildWidgets(Map<String, dynamic> w) {
    if (w != null) {
      w.forEach((key, value) {
        if (value is List<dynamic>) {
          List<dynamic> ml = compBuilder.buildMapList(value, map);
          map[key] = getBuilderWidgetList(ml);
        } else {
          BaseBuilder builder = compBuilder.getBuilder(value);
          dynamic mapList = builder.jsonData["mapList"];
          if (mapList is String) {
            mapList = controller.getContent(mapList, map);
          }
          if (mapList != null) {
            dynamic bl = builder.jsonData["builder"];
            if (bl is List<dynamic>) {
              map[key] = getBuilderWidgetList(
                  compBuilder.mapBuildList(mapList, bl, map));
            } else {
              bl = (bl is String) ? compBuilder.getBuilder(bl) : builder;
              List<dynamic> ml = compBuilder.mapList(mapList, bl, map);
              map[key] = getBuilderWidgetList(ml);
            }
          } else {
            Map<String, dynamic> m = builder.build(map);
            map[key] = getBuilderWidget(m);
          }
        }
      });
    }
  }

  _handleBuild(Map<String, dynamic> build) {
    build.forEach((key, value) {
      switch (key) {
        case "name":
          map["builder"] = value;
          break;
        case "actions":
          map["buildActions"] = value;
          break;
        case "mapping":
          map["buildMapping"] = value;
          break;
        case "mapList":
          map["mapList"] =
              (value is String) ? controller.getContent(value, map) : value;
          break;
        default:
          if (value is List<dynamic>) {
            map[key] = DescendantListBuild(value, compBuilder, map);
          } else {
            if (value is Map<String, dynamic>) {
              dynamic mapList = value["mapList"];
              if (mapList != null) {
                map["mapList"] = mapList;
                map[key] =
                    DescendantListBuild(value["builder"], compBuilder, map);
              }
            }
            if (map[key] == null) {
              map[key] = DescendantBuild(value, compBuilder, map);
            }
          }
          break;
      }
    });
  }
}

class DescendantBuild implements Descendant {
  final CompBuilder compBuilder;
  final Map<String, dynamic> map;
  final dynamic spec;

  DescendantBuild(this.spec, this.compBuilder, this.map);

  Widget getWidget() {
    BaseBuilder bb = compBuilder.getBuilder(spec);
    Map<String, dynamic> m = bb.build(map);
    return getBuilderWidget(m);
  }
}

class DescendantListBuild implements DescendantList {
  final dynamic bl;
  final Map<String, dynamic> map;
  final CompBuilder compBuilder;

  DescendantListBuild(this.bl, this.compBuilder, this.map);

  List<Widget> getWidgetList() {
    List<Widget> widgetList = [];
    dynamic mapList = map["mapList"];
    if (mapList != null) {
      if (mapList is String) {
        mapList = controller.getContent(mapList, map);
      }
      if (bl is List<dynamic>) {
        List<Map<String, dynamic>> ml =
            compBuilder.mapBuildList(mapList, bl, map);
        widgetList.addAll(getBuilderWidgetList(ml));
      } else {
        BaseBuilder bb = compBuilder.getBuilder(bl);
        List<Map<String, dynamic>> ml = compBuilder.mapList(mapList, bb, map);
        widgetList.addAll(getBuilderWidgetList(ml));
      }
    } else {
      _buildWidgetList(bl, widgetList);
    }
    return widgetList;
  }

  _buildWidgetList(List<dynamic> bl, List<Widget> widgetList) {
    for (var spec in bl) {
      BaseBuilder bb = compBuilder.getBuilder(spec);
      Map<String, dynamic> m = bb.build(map);
      widgetList.add(getBuilderWidget(m));
    }
  }
}
