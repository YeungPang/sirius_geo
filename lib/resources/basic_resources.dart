import 'package:flutter/material.dart';
import 'package:sirius_geo/resources/s_g_icons.dart';

const Map<String, Color> colorMap = {
  "almost": Color(0xFFFF9E50),
  "black": Colors.black,
  "blueGrey": Colors.blueGrey,
  "btnBlue": Color(0xFF1785C1),
  "btnBlueGradEnd": Color(0xFF3BAEED),
  "correct": Color(0xFF4DC591),
  "correctGradEnd": Color(0xFF82EFC0),
  "faint": Color.fromRGBO(125, 125, 125, 1.0),
  "incorrect": Color(0xFFF76F71),
  "incorrectGradEnd": Color(0xFFFF9DAC),
  "lightGreyText": Color(0xFF999FAE),
  "green": Colors.green,
  "greyText": Color(0xFFBDBDBD),
  "red": Colors.red,
  "white": Colors.white,
  "white38": Colors.white38,
};

const Map<String, dynamic> resources = {
  "textFieldBorder": textFieldBorder,
  "catBoxPadding": catBoxPadding,
  "catIconPadding": catIconPadding,
  "clampingScrollPhysics": clampingScrollPhysics,
  "vSliderResAlignment": vSliderResAlignment,
};

const textFieldBorder = OutlineInputBorder(
  borderSide: BorderSide(
    color: const Color(0xFF1785C1),
  ),
  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
);

const Icon incompleteProg = Icon(
  SGIcons.incomplete,
  color: Color(0xFF999FAD),
  size: 17,
);

const Icon completeProg = Icon(
  SGIcons.complete,
  color: Color(0xFF4DC591),
  size: 17,
);

const Icon incorrProg = Icon(
  SGIcons.complete,
  color: Color(0xFF999FAD),
  size: 17,
);

const Widget space10 = SizedBox(
  width: 10,
);

const Widget space2 = SizedBox(
  width: 2,
);

const Widget space5 = SizedBox(
  width: 5,
);

final Gradient blueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1785C1), Color(0xFF3BAEED)]);

final BoxDecoration shadowRCDecoration = BoxDecoration(
  color: Colors.white,
  boxShadow: [
    BoxShadow(color: Color(0xFFE0E0E0), blurRadius: 5.0, spreadRadius: 2.0)
  ],
  borderRadius: BorderRadius.circular(10),
);

final BoxDecoration rCDecoration = BoxDecoration(
  color: Colors.white,
  border: Border.all(color: Color(0xFF4DC591), width: 2),
  borderRadius: BorderRadius.circular(10),
);

const catBoxPadding = EdgeInsets.symmetric(vertical: 10.0);
const catIconPadding = EdgeInsets.symmetric(horizontal: 10.0);

const clampingScrollPhysics = ClampingScrollPhysics();

const vSliderResAlignment = Alignment(-0.4, 0.0);
