import 'dart:convert';
import 'package:sirius_geo/controller/process_controller.dart';
import 'package:sirius_geo/model/main_model.dart';
import 'package:flutter/material.dart';
import 'package:sirius_geo/builder/comp_builder.dart';
import 'package:sirius_geo/locator.dart';
import 'package:sirius_geo/resources/app_actions.dart';

class HomePage extends StatelessWidget {
  final CompBuilder compBuilder = locator<CompBuilder>();
  final MainModel model = locator<MainModel>();
  final ProcessController controller = locator<ProcessController>();

  @override
  Widget build(BuildContext context) {
    model.screenHeight = MediaQuery.of(context).size.height;
    model.screenWidth = MediaQuery.of(context).size.width;
    print("Screen width: " + model.screenWidth.toString());
    print("Screen height: " + model.screenHeight.toString());
/*     return BaseView<MainModel>(
        builder: (context, child, model) => BusyOverlay(
            show: model.state == ViewState.busy,
            child: _getWidget(context, model))); */
    return _getWidget(context);
  }

  Widget _getWidget(BuildContext context) {
    if (model.stateData["mainWidget"] == null) {
      return FutureBuilder<String>(
          future: model.getJson(context),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? _getBodyUi(model, snapshot.data)
                : Center(
                    child: CircularProgressIndicator(),
                  );
          });
    }
    model.addCount();
    print("Non-future call count: " + model.count.toString());
    return model.stateData["mainWidget"];
  }

  Widget _getBodyUi(MainModel model, String jsonStr) {
    print("Decoding jsonStr!!");
    var map = json.decode(jsonStr);
    model.stateData["map"] = map;
    model.addCount();
    model.init();
    model.appActions = AppActionBuild();
    print("Future call count: " + model.count.toString());
    Map<String, dynamic> mm = controller.getContent("/schema/MainModel", map);
    if ((mm != null) && (mm["actions"] != null)) {
      controller.performActions(mm["actions"], model.stateData);
    }
    Widget w = compBuilder.buildWiget(map["mainView"]);
    //compBuilder.buildWiget("TIScaffold");
    model.stateData["mainWidget"] = w;
    return w;
  }
}
