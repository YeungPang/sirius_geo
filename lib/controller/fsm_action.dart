//import 'package:flutter/material.dart';
import 'package:sirius_geo/controller/process_controller.dart';
//import 'package:sirius_geo/model/dynamic_model.dart';
import 'package:sirius_geo/model/main_model.dart';
//import 'package:sirius_geo/builder/get_widget.dart';
import 'package:sirius_geo/controller/actions.dart';

doFSMEventAction(String event, Map<String, dynamic> fsm,
    Map<String, dynamic> map, MainModel model, ProcessController controller) {
  String state = fsm["state"];
  Map<String, dynamic> s = fsm[state];
  dynamic m = (s != null) ? s[event] : null;
  if (m == null) {
    s = fsm["*"];
    m = (s != null) ? s[event] : null;
  }
  if (m is Map<String, dynamic>) {
    m.forEach((key, v) {
      switch (key) {
        case "newState":
          fsm["state"] = v;
          break;
        case "actions":
          if (v is Map<String, dynamic>) {
            controller.performActions(v, map);
          }
          break;
        case "events":
          if (v is List<dynamic>) {
            for (String e in v) {
              doFSMEventAction(e, fsm, map, model, controller);
            }
          } else {
            doFSMEventAction(v, fsm, map, model, controller);
          }
          break;
        default:
          print("Unknown FSM event " + key);
          break;
      }
    });
  }
}

/* 
handleModelEvent(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  Map<String, dynamic> map = parm["map"] as Map<String, dynamic>;
  DynamicModel dmodel = getDModel(parm, model, map);
  String state = map["state"] ?? "*";
  Map<String, dynamic> s = parm[state];
  Map<String, dynamic> m = (s != null) ? s[dmodel.event] : null;
  if ((m == null) && (state != "*")) {
    s = parm["*"];
    m = (s != null) ? s[dmodel.event] : null;
  }
  if (m != null) {
    map["state"] = m["newState"] ?? state;
    Map<String, dynamic> actions = m["actions"];
    if (actions != null) {
      controller.performActions(actions, map);
    }
  }
  Map<String, dynamic> fsm = dmodel.fsm;
  if (fsm != null) {
    doFSMEventAction(dmodel.event, fsm, map, model, controller);
  }
} */

handleFSMEvent(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  Map<String, dynamic> map = parm["map"] as Map<String, dynamic>;
  Map<String, dynamic> fsm = model.fsm;

  if (fsm != null) {
    dynamic event = parm["event"];
    if (event is String) {
      doFSMEventAction(event, fsm, map, model, controller);
    } else if (event is List<dynamic>) {
      for (String s in event) {
        doFSMEventAction(s, fsm, map, model, controller);
      }
    }
  }
}

mergeInit(Map<String, dynamic> j1, Map<String, dynamic> j2,
    Map<String, dynamic> parm, ProcessController controller) {
  Map<String, dynamic> map = parm["map"] as Map<String, dynamic>;
  j2.forEach((key, value) {
    if (key == "actions") {
      controller.performActions(value, map);
    } else {
      dynamic d = j1[key];
      if ((d is Map<String, dynamic>) && (value is Map<String, dynamic>)) {
        mergeInit(d, value, parm, controller);
      } else if (value is Map<String, dynamic>) {
        Map<String, dynamic> sd = {};
        mergeInit(sd, value, parm, controller);
        j1[key] = sd;
      } else {
        if (value is List<dynamic>) {
          j1[key] = value.toList();
        } else if ((value is String) && (cSet.contains(value[0]))) {
          j1[key] = controller.getContent(value, map);
        } else {
          j1[key] = value;
        }
      }
    }
  });
}

initFSM(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  Map<String, dynamic> map = parm["map"] as Map<String, dynamic>;
  String fsmName = getSpecContent(parm["fsmName"], map, model);
  if ((fsmName != null) &&
      ((model.fsm == null) || (model.fsm["fsmName"] != fsmName))) {
    buildFSM(parm, model, controller);
  }
  Map<String, dynamic> init = model.fsm["init"];
  Map<String, dynamic> minit = map["init"];
  if (minit != null) {
    if (init != null) {
      mergeInit(init, minit, parm, controller);
    } else {
      model.fsm["init"] = init;
      init = minit;
    }
  }
  if (init != null) {
    mergeInit(model.fsm, init, parm, controller);
  }
}

buildFSM(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  Map<String, dynamic> map = parm["map"] as Map<String, dynamic>;
  String fsmName = getSpecContent(parm["fsmName"], map, model);
  Map<String, dynamic> fsm = {};
  fsm["fsmName"] = fsmName;
  mergeFSMSpec(fsm, fsmName, model, controller);
  //String key = parm["key"] ?? "fsm";
  //map[key] = fsm;
  model.fsm = fsm;
}

resetFSM(
    Map<String, dynamic> parm, MainModel model, ProcessController controller) {
  Map<String, dynamic> map = parm["map"] as Map<String, dynamic>;
  Map<String, dynamic> reset = model.fsm["reset"];
  Map<String, dynamic> mreset = controller.getContent("*/reset", map);
  if (mreset != null) if (reset != null) {
    mergeInit(reset, mreset, parm, controller);
  } else {
    model.fsm["reset"] = mreset;
    reset = mreset;
  }
  if (reset != null) {
    mergeInit(model.fsm, reset, parm, controller);
  }
}

mergeFSMSpec(Map<String, dynamic> fsm, dynamic spec, MainModel model,
    ProcessController controller) {
  Map<String, dynamic> m;
  if (spec is String) {
    m = model.map["fsm"][spec];
  } else if (spec is List<dynamic>) {
    m = {};
    for (dynamic s in spec) {
      mergeFSMSpec(m, s, model, controller);
    }
  } else if (spec is Map<String, dynamic>) {
    m = spec;
  }
  List<dynamic> l = m["patterns"];
  if (l != null) {
    Map<String, dynamic> mm = {};
    for (dynamic s in l) {
      mergeFSMSpec(mm, s, model, controller);
    }
    controller.mergeJData(mm, m);
    m = mm;
    m["patterns"] = null;
  }
  controller.mergeJData(fsm, m);
}
