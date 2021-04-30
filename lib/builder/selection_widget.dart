import 'package:flutter/cupertino.dart';
import 'package:sirius_geo/builder/get_widget.dart';
import 'package:sirius_geo/builder/wrappers.dart';
import 'package:sirius_geo/model/dynamic_model.dart';
import 'package:scoped_model/scoped_model.dart';

class SelectionWidget extends StatelessWidget {
  final Map<String, dynamic> map;

  SelectionWidget(this.map);

  @override
  Widget build(BuildContext context) {
    dynamic m = map["modelName"];
    DynamicModel model = (m is DynamicModel) ? m : null;
    if (model == null) {
      m = controller.getContent(m, map);
      Map<String, dynamic> parm = {};
      model = (m is DynamicModel) ? m : models[m as String](parm, map);
      map["model"] = model;
    }
    return ScopedModel<DynamicModel>(
      model: model,
      child: getWWidget("SelectionWidget", map),
    );
  }
}

class SelectionDescendant extends StatelessWidget {
  final Map<String, dynamic> map;

  SelectionDescendant(this.map);
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<DynamicModel>(
      builder: (context, child, model) => _getSelectionWidget(model),
    );
  }

  Widget _getSelectionWidget(DynamicModel model) {
    Widget w;
    if (map["model"] == null) {
      map["model"] = model;
      w = getWWidget("SelectionDescendant", map);
      map["widget"] = w;
      return w;
    }
    Map<String, dynamic> p = map["selAction"] as Map<String, dynamic>;
    controller.performActions(p, map);
    w = map["widget"];
    return w;
  }
}
