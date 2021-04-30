import 'package:sirius_geo/controller/actions.dart';
import 'package:sirius_geo/model/main_model.dart';

class ProcessController {
  MainModel _model;

  get model => _model;

  setModel(MainModel model) {
    _model = model;
  }

  performAction(String action, dynamic value, Map<String, dynamic> map) {
    if (value is Map<String, dynamic>) {
      Map<String, dynamic> parm = {"map": map};
      parm.addAll(value);
      doAction(action, parm);
    } else {
      Map<String, dynamic> parm = {"map": map, "key": value};
      doAction(action, parm);
    }
  }

  performActions(Map<String, dynamic> actions, Map<String, dynamic> map) {
    if ((actions != null) && (map != null)) {
      actions.forEach((a, value) {
        if (value is List<dynamic>) {
          for (var d in value) {
            performAction(a, d, map);
          }
        } else {
          performAction(a, value, map);
        }
      });
    }
  }

  doAction(String action, Map<String, dynamic> parm) {
    Function a = actions[action];
    if (a == null) {
      a = _model.appActions.getAction(action);
    }
    if (a != null) {
      String traceName = parm["trace"];
      if (traceName != null) {
        trace(traceName, parm["map"]);
      }
      a(parm, _model, this);
    }
  }

  dynamic getContent(String spec, Map<String, dynamic> widgetMap) {
    return getSpecContent(spec, widgetMap, model);
  }

  mergeJData(Map<String, dynamic> j1, Map<String, dynamic> j2) {
    j2.forEach((key, value) {
      dynamic d = j1[key];
      if ((d is Map<String, dynamic>) && (value is Map<String, dynamic>)) {
        mergeJData(d, value);
      } else if (value is Map<String, dynamic>) {
        Map<String, dynamic> sd = {};
        mergeJData(sd, value);
        j1[key] = sd;
      } else {
        j1[key] = value;
      }
    });
  }

  trace(String dname, map) {
    print("Trace: " + dname);
    if (cSet.contains(dname[0])) {
      dynamic traceData = getSpecContent(dname, map, _model);
      print(traceData.toString());
    }
  }
}
