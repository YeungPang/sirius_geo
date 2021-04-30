import 'package:flutter/material.dart';
import 'package:sirius_geo/builder/color_button.dart';
import 'package:sirius_geo/builder/special_widgets.dart';
import 'package:sirius_geo/resources/basic_resources.dart';
import 'package:sirius_geo/resources/fonts.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:sirius_geo/controller/process_controller.dart';
import 'package:sirius_geo/locator.dart';
import 'package:sirius_geo/builder/comp_builder.dart';

class VertSlider extends StatelessWidget {
  final Map<String, dynamic> map;
  final ProcessController controller = locator<ProcessController>();
  final CompBuilder compBuilder = locator<CompBuilder>();
  final Map<String, dynamic> fsm;
  final double max = 200.0;
  final double lh = 13.0;

  VertSlider(this.map, this.fsm);

  @override
  Widget build(BuildContext context) {
    double h = map["height"] * 0.8;
    String scale1 = fsm["scale1"];
    String scale2 = fsm["scale2"];
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          map["largest"],
          style: SliderTextStyle,
        ),
        SizedBox(
          height: h,
          width: map["width"],
          child: Row(
            children: [
              _scaleWidget(scale1, h, true),
              _getSliderView(h),
              _scaleWidget(scale2, h, false),
              _buildScaleContainer(scale1, scale2)
            ],
          ),
        ),
        Text(
          map["smallest"],
          style: SliderTextStyle,
        )
      ],
    );
  }

  Widget _scaleWidget(String scale, double height, bool end) {
    int top = fsm[scale + "Top"];
    int bottom = fsm[scale + "Bottom"];
    int div = fsm["div"];
    int interval = (bottom - top) ~/ div;
    List<Widget> l = [];
    for (int i = 0; i <= div; i++) {
      int v = top + interval * i;
      l.add(Text(
        v.toString(),
        style: SliderBoldTextStyle,
      ));
    }
    return Container(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment:
            end ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
              alignment: Alignment.centerRight,
              height: 13.0,
              child: Text(
                scale,
                style: SliderBoldTextStyle,
              )),
          SizedBox(
              height: height - 13.0,
              child: Column(
                children: l,
                crossAxisAlignment:
                    end ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ))
        ],
      ),
    );
  }

  Widget _getSliderView(double h) {
    ValueNotifier<double> vn = fsm["scaleNoti"];
    return ValueListenableBuilder<int>(
      valueListenable: fsm["sliderNoti"],
      builder: (BuildContext context, int value, Widget child) => (value > 0)
          ? _getSliderStack(h, value)
          : _sliderWidget(h, vn.value, false),
    );
  }

  Widget _getSliderStack(double h, int sn) {
    ValueNotifier<double> vn = fsm["scaleNoti"];
    double value = vn.value;
    String scale1 = fsm["scale1"];
    int top = fsm[scale1 + "Top"];
    int bottom = fsm[scale1 + "Bottom"];
    double g = ((fsm["ans1"] - top) * max / (bottom - top)).abs();
    double o = (fsm["resStatus"] == "o") ? value : 0.0;
    double r = (fsm["resStatus"] == "r") ? value : 0.0;
    if (sn == 2) {
      return _sliderWidget(h, value, true);
    }
    return Stack(
      alignment: Alignment.topCenter,
      children: [_buildColorMeters(g, o, r, h), _sliderWidget(h, value, true)],
    );
  }

  Widget _sliderWidget(double h, double s, bool res) {
    double _absoluteSize = s;
    return Container(
      margin: res
          ? EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0)
          : EdgeInsets.only(top: 10.0),
      height: h - lh,
      child: FlutterSlider(
        values: [_absoluteSize],
        axis: Axis.vertical,
        max: max,
        min: 0,
        handlerHeight: res ? 5 : 20,
        handlerWidth: res ? 5 : 20,
        tooltip: FlutterSliderTooltip(
          disabled: true,
        ),
        handler: FlutterSliderHandler(
          opacity: res ? 0 : 1,
          disabled: res,
          child: res
              ? Container()
              : Container(
                  child: Image.asset('assets/images/slider_circle.png'),
                ),
        ),
        hatchMark: FlutterSliderHatchMark(
          labels: _getMarkerList(),
          labelsDistanceFromTrackBar: 1.2,
          linesAlignment: FlutterSliderHatchMarkAlignment.right,
          density: 0.5,
        ),
        trackBar: FlutterSliderTrackBar(
          activeTrackBar: BoxDecoration(
            gradient: blueGradient,
          ),
        ),
        onDragging: (handlerIndex, lowerValue, upperValue) {
          if (fsm["state"] != "edited") {
            ValueNotifier<double> notifier = fsm["confirmNoti"];
            notifier.value = 1.0;
            fsm["state"] = "edited";
          }
          _absoluteSize = lowerValue;
          //print(lowerValue);
          //print(upperValue);
          ValueNotifier<double> vn = fsm["scaleNoti"];
          if (vn != null) {
            vn.value = lowerValue;
          }
        },
      ),
    );
  }

  List<FlutterSliderHatchMarkLabel> _getMarkerList() {
    List<FlutterSliderHatchMarkLabel> l = [];
    for (int i = 0; i <= 20; i++) {
      l.add(FlutterSliderHatchMarkLabel(
          percent: i * 5.0,
          label: Container(
            height: 5,
            width: 5,
            margin: EdgeInsets.only(right: 1),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                )),
          )));
    }
    return l;
  }

  Widget _buildScaleContainer(String scale1, String scale2) {
    Map<String, dynamic> m1 = {
      "parent": map,
      "converter": scale1Converter,
      "notifier": fsm["scaleNoti"],
      "textStyle": SliderTextStyle
    };
    ValueText<double> v1 = ValueText<double>(m1);
    m1["sCol"] = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          scale1,
          style: SliderTextStyle,
        ),
        v1
      ],
    );
    Map<String, dynamic> m2 = {
      "parent": map,
      "converter": scale2Converter,
      "notifier": fsm["scaleNoti"],
      "textStyle": SliderTextStyle
    };
    ValueText<double> v2 = ValueText<double>(m2);
    m2["sCol"] = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          scale2,
          style: SliderTextStyle,
        ),
        v2
      ],
    );
    Widget s2 = compBuilder.builderBuild("VSliderScaleValue", m1);
    Widget s1 = compBuilder.builderBuild("VSliderScaleValue", m2);
    map["col"] = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          controller.getContent("/text/yourSel", map),
          style: ControlButtonTextStyle,
        ),
        s1,
        s2
      ],
    );
    return compBuilder.builderBuild("VSliderScaleContainer", map);
  }

  String scale1Converter(double value, Map<String, dynamic> smap) {
    String scale1 = fsm["scale1"];
    int top = fsm[scale1 + "Top"];
    int bottom = fsm[scale1 + "Bottom"];
    int v = (bottom - top) * value ~/ max + top;
    fsm["in1"] = v;
    return v.toString();
  }

  String scale2Converter(double value, Map<String, dynamic> smap) {
    String scale2 = fsm["scale2"];
    int top = fsm[scale2 + "Top"];
    int bottom = fsm[scale2 + "Bottom"];
    int v = (bottom - top) * value ~/ 200.0 + top;
    fsm["in2"] = v;
    return v.toString();
  }

  Widget _buildColorMeters(double g, double o, double r, double h) {
    double sh = (h - lh) / max;
    double gh = (g - o - r) * sh;

    Map<String, dynamic> gmap = {
      "parent": map,
      "beginColor": Color(0xFF4DC591),
      "endColor": Color(0xFF82EFC0),
      "btnBRadius": 4.0,
      "width": 20.0,
      "height": (gh > 0.0)
          ? gh
          : (g > 0.0)
              ? g * sh
              : 1.0,
    };
    Widget gc = ColorButton(gmap);
    double fh = (o > 0.0)
        ? o * sh
        : (r > 0.0)
            ? r * sh
            : 0.0;
    List<Widget> l;
    if (fh > 0.0) {
      Map<String, dynamic> fmap = {
        "parent": map,
        "beginColor": (o > 0.0) ? Color(0xFFFF9E50) : Color(0xFFF76F71),
        "endColor": (o > 0.0) ? Color(0xFFFDBD88) : Color(0xFFFF9DAC),
        "btnBRadius": 4.0,
        "width": 20.0,
        "height": (gh > 0.0) ? fh : -gh,
      };
      Widget fc = ColorButton(fmap);
      l = (gh > 0.0)
          ? [
              SizedBox(
                height: lh,
              ),
              fc,
              gc
            ]
          : [
              SizedBox(
                height: lh,
              ),
              gc,
              fc
            ];
    } else {
      l = [
        SizedBox(
          height: lh,
        ),
        gc
      ];
    }
    return Column(
      children: l,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }
}
