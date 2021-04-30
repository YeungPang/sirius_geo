import 'package:sirius_geo/model/base_model.dart';

class DynamicModel extends BaseModel {
  bool blocked = false;

  setState(dynamic state) {
    if (!blocked) {
      stateData["prevState"] = stateData["currState"];
      stateData["currState"] = state;
      notifyListeners();
      stateData["currState"] = state;
    }
  }

  setValue(String name, dynamic value, bool notify) {
    stateData[name] = value;
    if ((!blocked) && notify) {
      notifyListeners();
      stateData[name] = value;
    }
  }

  doAction(dynamic d) {}
}

DynamicModel getDynamicModel(
    Map<String, dynamic> parm, Map<String, dynamic> map) {
  DynamicModel dm = DynamicModel();
  dm.stateData["name"] = parm["name"];
  dm.stateData["fsm"] = parm["fsm"];
  dm.stateData["currState"] = parm["state"];
  return dm;
}

const Map<String, Function> models = {
  "DynamicModel": getDynamicModel,
};
