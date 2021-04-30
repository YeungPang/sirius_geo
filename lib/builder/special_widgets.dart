import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:sirius_geo/builder/widgets.dart';
import 'package:sirius_geo/locator.dart';
import 'package:sirius_geo/controller/process_controller.dart';
import 'package:sirius_geo/resources/basic_resources.dart';

import 'package:sirius_geo/builder/wrappers.dart';

class NaviScope extends StatelessWidget {
  final Map<String, dynamic> map;
  final ProcessController controller = locator<ProcessController>();

  NaviScope(this.map);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (controller.model.fsm["gameOver"]) {
            Navigator.of(context).pop(true);
            return true;
          }
          final value = await showDialog<bool>(
              context: context, builder: (context) => _build(context));
          return value == true;
        },
        child: getWWidget("WillPopScope", map));
  }

  Widget _build(BuildContext context) {
    return map["dialog"] ??
        AlertDialog(
          content: Text('Are you sure you want to exit?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Yes, exit'),
              onPressed: () {
                int l = controller.model.fsmList.length;
                if (l > 0) {
                  controller.model.fsm = controller.model.fsmList[l - 1];
                  controller.model.fsmList.removeLast();
                }
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
  }
}

class Bubble extends StatelessWidget {
  final Map<String, dynamic> map;
  final ProcessController controller = locator<ProcessController>();

  Bubble(this.map);
  @override
  Widget build(BuildContext context) {
    controller.model.context = context;
    return Align(
        alignment: map["align"],
        child: Material(
            type: MaterialType.transparency,
            child: SizedBox(
                height: map["bubbleHeight"],
                width: map["boxWidth"],
                child: Stack(children: [
                  Align(
                    alignment: map["boxAlign"],
                    child: Container(
                        height: map["boxHeight"],
                        decoration: shadowRCDecoration),
                  ),
                  Align(
                      alignment: map["arrowAlign"], child: map["bubbleArrow"]),
                  Align(
                      alignment: map["boxAlign"],
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: map["boxHeight"],
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.end,
                              children: map["bubbleBox"],
                            ),
                          )))
                ]))));
  }
}

Widget getDraggable(Map<String, dynamic> map) {
  return Draggable(
      data: map["data"],
      child: map["child"],
      feedback: Opacity(
        child: map["feedback"] ?? map["child"],
        opacity: 0.7,
      ),
      childWhenDragging: map["childWhenDragging"] ?? map["child"]);
}

Widget getDragTarget(Map<String, dynamic> map) {
  ProcessController controller = locator<ProcessController>();
  return DragTarget(
    onWillAccept: (data) {
      return true;
    },
    onAccept: (data) {
      Map<String, dynamic> actions = map["dropAction"];
      if (actions != null) {
        String key = map["key"];
        if (key != null) {
          map[key] = data;
        }
        controller.performActions(actions, map);
      }
    },
    builder: (context, incoming, rejected) {
      return map["target"];
    },
  );
}

class ImageBanner extends StatelessWidget {
  final String name;
  final double height;

  ImageBanner({@required this.name, this.height = 200.0});

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints.expand(height: height),
        decoration: BoxDecoration(color: Colors.grey),
        child: Image.asset(
          name,
          fit: BoxFit.cover,
        ));
  }
}

class InTextField extends StatelessWidget {
  final Map<String, dynamic> map;
  final ProcessController controller = locator<ProcessController>();

  InTextField(this.map);

  @override
  Widget build(BuildContext context) {
    TextEditingController tc = TextEditingController();
    return TextField(
      autocorrect: map["autocorrect"] ?? true,
      autofocus: map["autofocus"] ?? false,
      controller: tc,
      onEditingComplete: () => _completeEdit(tc, context),
      enabled: map["enabled"] ?? true,
      style: map["textStyle"],
      showCursor: map["showCursor"],
      maxLines: map["maxLines"] ?? 1,
      expands: map["expands"] ?? false,
      onSubmitted: map["onSubmitted"],
      keyboardType: map["keyboardType"],
      decoration: InputDecoration(
        border: map["inputBorder"],
        icon: map["icon"],
        hintText: map["hintText"],
        hintStyle: map["hintStyle"],
        labelText: map["labelText"],
        labelStyle: map["labelStyle"],
        prefixIcon: map["prefixIcon"],
        suffixIcon: map["suffixIcon"],
        filled: map["filled"],
        fillColor: map["fillColor"],
        contentPadding: map["padding"],
      ),
    );
  }

  _completeEdit(TextEditingController tc, BuildContext context) {
    String key = map["key"];
    String text = tc.text;
    if (key != null) {
      Map<String, dynamic> parm = {"key": key, "content": text, "map": map};
      controller.doAction("setContent", parm);
    }
    if (text.isNotEmpty) {
      Map<String, dynamic> actions = map["complete"];
      if (actions != null) {
        controller.performActions(actions, map);
      }
    } else {
      Map<String, dynamic> actions = map["incomplete"];
      if (actions != null) {
        controller.performActions(actions, map);
      }
    }
    FocusScope.of(context).requestFocus(new FocusNode());
  }
}

class RollingSwitch extends StatelessWidget {
  final Map<String, dynamic> map;
  final ProcessController controller = locator<ProcessController>();

  RollingSwitch(this.map);

  @override
  Widget build(BuildContext context) {
    return LiteRollingSwitch(
        value: map["onOff"] ?? false,
        textOn: map["textOn"] ?? "On",
        textOff: map["textOff"] ?? "Off",
        colorOn: map["colorOn"] ?? colorMap["correct"],
        colorOff: map["colorOff"] ?? colorMap["incorrect"],
        iconOn: map["iconOn"] ?? Icons.lightbulb_outline,
        iconOff: map["iconOff"] ?? Icons.power_settings_new,
        textSize: map["textSize"] ?? 14.0,
        onChanged: (bool state) => _switch(state, context));
  }

  _switch(bool state, BuildContext context) {
    print('turned ${(state) ? 'on' : 'off'}');
    Map<String, dynamic> actions = map["switchActions"];
    if (actions != null) {
      controller.performActions(actions, map);
    }
  }
}

class ValueText<T> extends StatelessWidget {
  final Map<String, dynamic> map;

  ValueText(this.map);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T>(
      valueListenable: map["notifier"],
      builder: (BuildContext context, T value, Widget child) =>
          _getListnerWidget(value),
    );
  }

  Widget _getListnerWidget(T value) {
    Function f = map["converter"];
    map["text"] = (f != null) ? f(value, map) : value.toString();
    map["widget"] = getTextWidger(map);
    return map["widget"];
  }
}
