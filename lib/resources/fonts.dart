import 'package:flutter/material.dart';

const LargeTextSize = 22.0;
const MediumTextSize = 16.0;
const SmallTextSize = 12.0;

const String FontNameDefault = 'Montserrat';

const Color TextColorDark = Colors.black;
const Color TextColorLight = Colors.white;
const Color TextColorAccent = Colors.red;
const Color TextColorFaint = Color.fromRGBO(125, 125, 125, 1.0);
const Color BlueGrey = Colors.blueGrey;

const DefaultPaddingHorizontal = 12.0;

const AppBarTextStyle = TextStyle(
  fontFamily: FontNameDefault,
  fontWeight: FontWeight.w300,
  fontSize: MediumTextSize,
  color: Colors.white,
);

const TitleTextStyle = TextStyle(
  fontFamily: FontNameDefault,
  fontWeight: FontWeight.w300,
  fontSize: LargeTextSize,
  color: TextColorDark,
);

const SubTitleTextStyle = TextStyle(
  fontFamily: FontNameDefault,
  fontWeight: FontWeight.w300,
  fontSize: MediumTextSize,
  color: TextColorAccent,
);

const CaptionTextStyle = TextStyle(
  fontFamily: FontNameDefault,
  fontWeight: FontWeight.w300,
  fontSize: SmallTextSize,
  color: TextColorDark,
);

const Body1TextStyle = TextStyle(
  fontFamily: FontNameDefault,
  fontWeight: FontWeight.w300,
  fontSize: MediumTextSize,
  color: Colors.black,
);

const String FontNameAN = 'Lato';

const NormalTextStyle = TextStyle(
  fontFamily: FontNameAN,
  fontWeight: FontWeight.w500,
  fontSize: MediumTextSize,
  color: Color(0xFF999FAE),
);

const NormalSTextStyle = TextStyle(
  fontFamily: FontNameAN,
  fontWeight: FontWeight.w500,
  fontSize: 14,
  color: Color(0xFF999FAE),
);

const SmallTextStyle = TextStyle(
  fontFamily: FontNameAN,
  fontWeight: FontWeight.w300,
  fontSize: 12,
  color: Color(0xFF1785C1),
);

const MediumNormalTextStyle = TextStyle(
  fontFamily: FontNameAN,
  fontWeight: FontWeight.w500,
  fontSize: MediumTextSize,
  color: TextColorDark,
);

const SmallSemiTextStyle = TextStyle(
  fontFamily: FontNameAN,
  fontWeight: FontWeight.w500,
  fontSize: 12,
  color: Color(0xFF00344F),
);

const ControlButtonTextStyle = TextStyle(
  fontFamily: FontNameAN,
  fontWeight: FontWeight.w600,
  fontSize: MediumTextSize,
  color: Colors.white,
);

const SliderTextStyle = TextStyle(
  fontFamily: FontNameAN,
  fontWeight: FontWeight.w700,
  letterSpacing: 0.25,
  fontSize: 16,
  color: Color(0xFF00344F),
);

const SliderSmallTextStyle = TextStyle(
  fontFamily: FontNameAN,
  fontWeight: FontWeight.w500,
  letterSpacing: 0.25,
  fontSize: 10,
  color: Color(0xFF00344F),
);

const SliderBoldTextStyle = TextStyle(
  fontFamily: FontNameAN,
  fontWeight: FontWeight.w700,
  fontSize: 12,
  color: Color(0xFF00344F),
);

const QuestionTextStyle = TextStyle(
  fontFamily: FontNameAN,
  fontWeight: FontWeight.w400,
  fontSize: 24,
  color: Color(0xFF00344F),
);

const ChoiceButnTxtStyle = TextStyle(
  fontFamily: FontNameAN,
  fontWeight: FontWeight.w500,
  fontSize: MediumTextSize,
  color: Color(0xFF1785C1),
);

const DragButnTxtStyle = TextStyle(
  fontFamily: FontNameAN,
  fontWeight: FontWeight.w500,
  fontSize: MediumTextSize,
  color: Color(0xFF999FAE),
);

const SelButnTxtStyle = TextStyle(
  fontFamily: FontNameAN,
  fontWeight: FontWeight.w500,
  fontSize: MediumTextSize,
  color: Colors.white,
);

const IncorrTxtStyle = TextStyle(
  fontFamily: FontNameAN,
  fontWeight: FontWeight.w500,
  fontSize: MediumTextSize,
  color: Color(0xFFF76F71),
);

const ResTxtStyle = TextStyle(
  fontFamily: FontNameAN,
  fontWeight: FontWeight.w500,
  fontSize: 12.0,
  color: Color(0xFF999FAE),
);

const BannerTxtStyle = TextStyle(
  fontFamily: FontNameAN,
  fontWeight: FontWeight.w700,
  fontSize: 24.0,
  color: Colors.white,
);

const CorrTxtStyle = TextStyle(
  fontFamily: FontNameAN,
  fontWeight: FontWeight.w500,
  fontSize: MediumTextSize,
  color: Color(0xFF4DC591),
);

const ComplTextStyle = TextStyle(
  fontFamily: FontNameAN,
  fontWeight: FontWeight.w900,
  fontSize: 20,
  color: Color(0xFF1785C1),
);

const YourScoreStyle = TextStyle(
  fontFamily: FontNameAN,
  fontWeight: FontWeight.w700,
  fontSize: 12,
  color: Color(0xFF4DC591),
);

const TopicTxtStyle = TextStyle(
  fontFamily: FontNameAN,
  fontWeight: FontWeight.w700,
  fontSize: LargeTextSize,
  color: Colors.white,
);

const ViewMoreStyle = TextStyle(
  fontFamily: FontNameAN,
  fontWeight: FontWeight.w700,
  decoration: TextDecoration.underline,
  fontSize: SmallTextSize,
  color: Color(0xFF999FAE),
);

const Map<String, TextStyle> textStyle = {
  "AppBarTextStyle": AppBarTextStyle,
  "BannerTxtStyle": BannerTxtStyle,
  "Body1TextStyle": Body1TextStyle,
  "CaptionTextStyle": CaptionTextStyle,
  "ChoiceButnTxtStyle": ChoiceButnTxtStyle,
  "ControlButtonTextStyle": ControlButtonTextStyle,
  "CorrTxtStyle": CorrTxtStyle,
  "IncorrTxtStyle": IncorrTxtStyle,
  "MediumNormalTextStyle": MediumNormalTextStyle,
  "QuestionTextStyle": QuestionTextStyle,
  "ResTxtStyle": ResTxtStyle,
  "SelButnTxtStyle": SelButnTxtStyle,
  "SliderBoldTextStyle": SliderBoldTextStyle,
  "SliderSmallTextStyle": SliderSmallTextStyle,
  "SliderTextStyle": SliderTextStyle,
  "SmallSemiTextStyle": SmallSemiTextStyle,
  "SmallTextStyle": SmallTextStyle,
  "SubTitleTextStyle": SubTitleTextStyle,
  "TitleTextStyle": TitleTextStyle,
};
