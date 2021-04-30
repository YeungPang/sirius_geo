import 'package:flutter/material.dart';
import 'package:sirius_geo/resources/fonts.dart';

Widget topicWidget(Map<String, dynamic> map) {
  double h = map["height"];
  double w = map["width"];
  return Container(
    height: h,
    decoration: map["boxDecoration"],
    child: Stack(children: [
      Image.asset(
        'assets/images/top_background_circles.png',
      ),
      Container(
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: Image.asset(
                'assets/images/world.png',
                width: w * 0.4,
                height: h * 0.94,
              ),
            ),
            Container(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: h * 0.3),
                      child: Text(
                        map["topicSelection"],
                        style: TopicTxtStyle,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        map["knowYourWorld"],
                        style: SmallTextStyle.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      )
    ]),
  );
}
