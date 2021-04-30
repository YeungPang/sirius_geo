//import 'dart:convert';
import 'package:sirius_geo/builder/comp_builder.dart';
import 'package:sirius_geo/builder/get_widget.dart';
import 'package:sirius_geo/controller/process_controller.dart';
import 'package:sirius_geo/locator.dart';
import 'package:sirius_geo/model/main_model.dart';
import 'package:sirius_geo/pages/home_page.dart';
import 'package:flutter/material.dart';

const HomePageRoute = '/';
const LocationDetailRoute = '/location_detail';

class App extends StatelessWidget {
  final MainModel model = locator<MainModel>();
  final CompBuilder compBuilder = locator<CompBuilder>();
  final ProcessController controller = locator<ProcessController>();

  @override
  Widget build(BuildContext context) {
    setUp();
    return MaterialApp(
      onGenerateRoute: _routes(),
      //theme: _theme(context),
    );
  }

  RouteFactory _routes() {
    return (settings) {
      final Map<String, dynamic> arguments = settings.arguments;
      Widget screen;
      if (settings.name == HomePageRoute) {
        screen = HomePage();
      } else {
        Map<String, dynamic> map = arguments['map'];
        String builder = controller.getContent(settings.name, map);
        BaseBuilder bb = compBuilder.getBuilder(builder);
        if (bb == null) {
          return null;
        }
        Map<String, dynamic> m = bb.build(map);
        screen = getBuilderWidget(m);
      }

      return MaterialPageRoute(builder: (BuildContext context) => screen);
    };
  }

  setUp() {
    compBuilder.setModel(model);
  }

/*   void checkJson(BuildContext context) async {
    print('Loading Json');
    String data = await getJson(context, 'assets/themes/TitleTextStyle.json');
    print(data);
  }

  Future<String> getJson(BuildContext context, String fileName) {
    return DefaultAssetBundle.of(context).loadString(fileName);
  } */
}
