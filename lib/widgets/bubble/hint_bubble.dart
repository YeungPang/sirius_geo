import 'package:flutter/material.dart';
import 'package:sirius_geo/controller/process_controller.dart';
import 'package:sirius_geo/resources/basic_resources.dart';
import 'package:sirius_geo/resources/fonts.dart';
import 'package:sirius_geo/resources/s_g_icons.dart';

Widget getHints(String hints) {
  return Expanded(
      child: Container(
    alignment: Alignment(-0.8, 0.0),
    child: Text(
      hints,
      style: CorrTxtStyle,
    ),
  ));
}

Widget getHintBanner(Map<String, dynamic> map) {
  double boxWidth = map["boxWidth"];
  ProcessController controller = map["controller"];
  return Container(
      height: map["bannerHeight"],
      width: boxWidth,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colorMap["correct"], colorMap["correctGradEnd"]]),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(10),
          topLeft: Radius.circular(10),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 7,
          ),
          Expanded(
            child: Text(
              map["hintText"],
              style: SelButnTxtStyle,
            ),
          ),
          GestureDetector(
            onTap: () {
              Map<String, dynamic> actionMap =
                  controller.getContent("*/onCancel", map);
              controller.performActions(actionMap, map);
            },
            child: Row(
              children: const [
                Text('   '),
                Icon(
                  SGIcons.cancel,
                  size: 16,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ));
}

Widget getPrevNext(bool hasPrev, bool last, Map<String, dynamic> map) {
  ProcessController controller = map["controller"];
  return Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      height: map["bannerHeight"],
      width: map["boxWidth"],
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment(-0.6, 0.0),
            child: !hasPrev
                ? const Text('  ')
                : GestureDetector(
                    onTap: () {
                      Map<String, dynamic> actionMap =
                          controller.getContent("*/onPrev", map);
                      controller.performActions(actionMap, map);
                    },
                    child: Row(
                      children: [
                        space5,
                        Icon(
                          Icons.arrow_back_ios,
                          size: 16,
                          color: Color(0xFFBDBDBD),
                        ),
                        Text(
                          map["prevHint"],
                          style: DragButnTxtStyle,
                        ),
                      ],
                    ),
                  ),
          ),
          Align(
              alignment: Alignment(0.6, 0.0),
              child: last
                  ? GestureDetector(
                      onTap: () {
                        Map<String, dynamic> actionMap =
                            controller.getContent("*/onTryTeachMode", map);
                        controller.performActions(actionMap, map);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white38,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          border: Border.all(
                            color: colorMap["btnBlue"],
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text(
                            map["tryTeachMode"],
                            style: ChoiceButnTxtStyle,
                          ),
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        Map<String, dynamic> actionMap =
                            controller.getContent("*/onNext", map);
                        controller.performActions(actionMap, map);
                      },
                      child: Row(
                        children: [
                          Text(
                            map["nextHint"],
                            style: DragButnTxtStyle,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Color(0xFFBDBDBD),
                          ),
                          space5
                        ],
                      ),
                    )),
        ],
      ),
    ),
  );
}

Widget getBubbleBanner(Map<String, dynamic> map) {
  double boxWidth = map["boxWidth"];
  ProcessController controller = map["controller"];
  return Container(
    height: map["bannerHeight"],
    width: boxWidth,
    alignment: map["alignCancel"],
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(10),
        topLeft: Radius.circular(10),
      ),
    ),
    child: GestureDetector(
      onTap: () {
        Map<String, dynamic> actionMap =
            controller.getContent("*/onCancel", map);
        controller.performActions(actionMap, map);
      },
      child: Icon(
        SGIcons.cancel,
        size: 16,
        color: Color(0xFF999FAE),
      ),
    ),
  );
}

Widget getBubbleText(String text1, String text2) {
  return Expanded(
      child: Container(
    alignment: Alignment(-0.7, 0.0),
    child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        const SizedBox(
          width: 20,
        ),
        Text(
          text1,
          style: NormalTextStyle,
        )
      ]),
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        const SizedBox(
          width: 20,
        ),
        Text(
          text2,
          style: NormalSTextStyle,
        )
      ]),
      const SizedBox(
        height: 10,
      ),
    ]),
  ));
}
