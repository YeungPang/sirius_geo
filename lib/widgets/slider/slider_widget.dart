import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sirius_geo/resources/basic_resources.dart';
import 'package:sirius_geo/resources/fonts.dart';

class ThreeSliderWidget extends StatefulWidget {
  final Map<String, dynamic> map;
  final Map<String, dynamic> fsm;

  ThreeSliderWidget(this.map, this.fsm);
  @override
  _ThreeSliderWidgetState createState() => _ThreeSliderWidgetState();
}

class _ThreeSliderWidgetState extends State<ThreeSliderWidget>
    with SingleTickerProviderStateMixin {
  //final _key = new GlobalKey<_SliderWidgetState>();
  double height;
  double width;
  int _res = 0;
  bool _isSwitched = false;
  AnimationController rotationController;
  List<Map<String, dynamic>> _scale = [{}, {}, {}];
  double _absoluteValue = 0.0;
  double _ratio12;
  double _ratio13;
  String _ys;
  //bool reset = false;

  @override
  void initState() {
    rotationController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    height = widget.map["height"];
    width = widget.map["width"];
    _scale[0]["text"] = widget.fsm["text1"];
    _scale[1]["text"] = widget.fsm["text2"];
    _scale[2]["text"] = widget.fsm["text3"];
    _scale[0]["start"] = widget.fsm["start1"];
    _scale[1]["start"] = widget.fsm["start2"];
    _scale[2]["start"] = widget.fsm["start3"];
    _scale[0]["end"] = widget.fsm["end1"];
    _scale[1]["end"] = widget.fsm["end2"];
    _scale[2]["end"] = widget.fsm["end3"];
    _ratio12 = widget.fsm["ratio12"];
    _ratio13 = widget.fsm["ratio13"];
    _scale[0]["s"] = widget.fsm["suffix1"];
    _scale[1]["s"] = widget.fsm["suffix2"];
    _scale[2]["s"] = widget.fsm["suffix3"];
    _ys = widget.fsm["yourSel"];
    _scale[0]["r"] = (_scale[0]["end"] - _scale[0]["start"]) / 100.0;
    _scale[1]["r"] = (_scale[1]["end"] - _scale[1]["start"]) / 100.0;
    _scale[2]["r"] = (_scale[2]["end"] - _scale[2]["start"]) / 100.0;
    _reset();
    super.initState();
  }

  _reset() {
    _absoluteValue = 0.0;
    _isSwitched = false;
    _scale[0]["value"] = 0.0;
    _scale[1]["value"] = 0.0;
    _scale[2]["value"] = 0.0;
    _scale[0]["t"] = _scale[0]["start"].toString() + _scale[0]["s"];
    _scale[1]["t"] = _scale[1]["start"].toString() + _scale[1]["s"];
    _scale[2]["t"] = _scale[2]["start"].toString() + _scale[2]["s"];
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: widget.fsm["sliderNoti"],
      builder: (BuildContext context, int value, Widget child) => Stack(
        clipBehavior: Clip.none,
        children: _getStackChildren(value),
      ),
    );
  }

  List<Widget> _getStackChildren(int r) {
    if ((_res != r) && (r == 0)) {
      _reset();
      //reset = false;
    }
    _res = r;
    List<Widget> cl = [
      Container(
          height: height * 0.6,
          width: width * 0.9,
          margin: EdgeInsets.only(bottom: 10),
          child: Card(
              elevation: 4,
              color: colorMap["btnBlueGradEnd"],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              margin: EdgeInsets.zero,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: blueGradient,
                  ),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (_res > 0) ? _percentCard() : _sliderCard(),
                        Center(
                          child: RotationTransition(
                              turns: Tween(begin: 0.0, end: 0.5)
                                  .animate(rotationController),
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 500),
                                child: InkWell(
                                  onTap: () {
                                    if (_res == 0) {
                                      setState(() {
                                        if (_isSwitched) {
                                          _isSwitched = false;
                                          _absoluteValue = _scale[0]["value"] /
                                              _scale[0]["r"];
                                          rotationController.forward(from: 0.0);
                                        } else {
                                          _isSwitched = true;
                                          _absoluteValue = _scale[1]["value"] /
                                              _scale[1]["r"];
                                          rotationController.reverse(from: 1.0);
                                        }
                                      });
                                    }
                                  },
                                  child: Image.asset(
                                    'assets/images/switch.png',
                                    height: height * 0.05,
                                    width: height * 0.05,
                                  ),
                                ),
                              )),
                        ),
                        _selectionCard(),
                      ],
                    ),
                  )))),
    ];
    _buildAnswer(cl);
    return cl;
  }

  Widget _percentCard() {
    //reset = true;
    return Container(
        height: height * 0.195,
        width: width * 0.9,
        margin: EdgeInsets.all(10),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 2,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  _isSwitched ? _getPercentWidgets(1) : _getPercentWidgets(0),
            ),
          ),
        ));
  }

  Widget _sliderCard() {
    return Container(
      height: height * 0.195,
      width: width * 0.9,
      margin: EdgeInsets.all(10),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 2,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: width * 0.04, top: height * 0.02),
                child: Text(
                  _ys,
                  style: SliderBoldTextStyle,
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: width * 0.04,
                ),
                child: Text(
                  _isSwitched ? _scale[1]["t"] : _scale[0]["t"],
                  style: SliderTextStyle,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: width * 0.04, top: height * 0.02),
                child: Text(
                  _isSwitched ? _scale[1]["text"] : _scale[0]["text"],
                  style: SliderSmallTextStyle,
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: width * 0.01,
                ),
                child: FlutterSlider(
                  values: [_absoluteValue],
                  step: FlutterSliderStep(isPercentRange: false, step: 0.01),
                  max: 100,
                  min: 0,
                  handlerHeight: 20,
                  handlerWidth: 20,
                  handler: FlutterSliderHandler(
                    child: Container(
                      child: Image.asset('assets/images/slider_circle.png'),
                    ),
                  ),
                  trackBar: FlutterSliderTrackBar(
                      activeTrackBar: BoxDecoration(gradient: blueGradient)),
                  onDragging: (handlerIndex, lowerValue, upperValue) {
                    if (widget.fsm["state"] != "edited") {
                      ValueNotifier<double> notifier =
                          widget.fsm["confirmNoti"];
                      notifier.value = 1.0;
                      widget.fsm["state"] = "edited";
                    }
                    setState(() {
                      _absoluteValue = lowerValue;
                      if (_isSwitched) {
                        _scale[1]["value"] = lowerValue * _scale[1]["r"];
                        _scale[0]["value"] = _scale[1]["value"] / _ratio12;
                        if (_scale[0]["value"] > _scale[0]["end"]) {
                          _scale[0]["value"] = _scale[0]["end"];
                        }
                        _scale[2]["value"] = _scale[0]["value"] * _ratio13;
                      } else {
                        _scale[0]["value"] = lowerValue * _scale[0]["r"];
                        _scale[1]["value"] = _scale[0]["value"] * _ratio12;
                        _scale[2]["value"] = _scale[0]["value"] * _ratio13;
                      }
                      double sv = _scale[1]["value"] + _scale[1]["start"];
                      _scale[1]["t"] = sv.toStringAsFixed(2) + _scale[1]["s"];
                      sv = _scale[0]["value"] + _scale[0]["start"];
                      widget.fsm["in1"] = sv;
                      _scale[0]["t"] = sv.toStringAsFixed(2) + _scale[0]["s"];
                      sv = _scale[2]["value"] + _scale[2]["start"];
                      _scale[2]["t"] = sv.toStringAsFixed(2) + _scale[2]["s"];
                    });
                  },
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: width * 0.04, right: 10),
                  child: Row(
                    children: [
                      Text(
                        _isSwitched
                            ? _scale[1]["start"].toString() + _scale[1]["s"]
                            : _scale[0]["start"].toString() + _scale[0]["s"],
                        style: SliderSmallTextStyle,
                      ),
                      Spacer(),
                      Text(
                        _isSwitched
                            ? _scale[1]["end"].toString() + _scale[1]["s"]
                            : _scale[0]["end"].toString() + _scale[0]["s"],
                        style: SliderSmallTextStyle,
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectionCard() {
    List<Widget> colList = _getPercentWidgets(_isSwitched ? 0 : 1);
    colList.add(
      Container(
        color: Colors.grey.shade700,
        height: 1,
        margin: EdgeInsets.only(top: 10),
      ),
    );
    colList.addAll(_getPercentWidgets(2));
    return Container(
      height: height * 0.3,
      width: width * 0.9,
      margin: EdgeInsets.only(left: 10, right: 10, top: 5),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 2,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: colList,
          ),
        ),
      ),
    );
  }

  List<Widget> _getPercentWidgets(int i) {
    double diff = 0.0;
    Color c;
    if (_res == 1) {
      String rs = widget.fsm["resStatus"];
      c = (rs == "g")
          ? colorMap["correct"]
          : (rs == "o")
              ? colorMap["almost"]
              : colorMap["incorrect"];
      double ans = widget.fsm["ans" + (i + 1).toString()];
      diff = ans - _scale[i]["value"] - _scale[i]["start"];
    }
    return [
      Container(
        margin: EdgeInsets.only(left: width * 0.04, top: height * 0.02),
        child: Text(
          _ys,
          style: SliderBoldTextStyle,
        ),
      ),
      Container(
        margin: EdgeInsets.only(
          left: width * 0.04,
        ),
        child: Text(
          _scale[i]["t"],
          style: SliderTextStyle,
        ),
      ),
      Container(
        margin: EdgeInsets.only(left: width * 0.04, top: height * 0.01),
        child: (_res != 1)
            ? Text(
                _scale[i]["text"],
                style: SliderSmallTextStyle,
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _scale[i]["text"],
                    style: SliderSmallTextStyle,
                  ),
                  Text(
                    diff.toStringAsFixed(2) + _scale[i]["s"],
                    style: SliderSmallTextStyle.copyWith(color: c),
                  )
                ],
              ),
      ),
      Container(
        margin: EdgeInsets.only(left: width * 0.03, top: 5),
        child: (_res == 1) ? _getResultIndicator(i, diff) : _getPerIndicator(i),
      ),
      Container(
          margin: EdgeInsets.only(left: width * 0.04, top: 5, right: 10),
          child: Row(
            children: [
              Text(
                _scale[i]["start"].toString() + _scale[i]["s"],
                style: SliderSmallTextStyle,
              ),
              Spacer(),
              Text(
                _scale[i]["end"].toString() + _scale[i]["s"],
                style: SliderSmallTextStyle,
              ),
            ],
          )),
    ];
  }

  _buildAnswer(List<Widget> cl) {
    if ((_res != 0) && (_res != 2)) {
      Widget aw = Positioned(
        top: height * 0.024,
        left: width * 0.69,
        child: _isSwitched ? widget.fsm["res2"] : widget.fsm["res1"],
      );
      cl.add(aw);
      aw = Positioned(
        top: height * 0.29,
        left: width * 0.69,
        child: _isSwitched ? widget.fsm["res1"] : widget.fsm["res2"],
      );
      cl.add(aw);
      aw = Positioned(
        top: height * 0.44,
        left: width * 0.69,
        child: widget.fsm["res3"],
      );
      cl.add(aw);
    }
  }

  Widget _getResultIndicator(int i, double diff) {
    String rs = widget.fsm["resStatus"];
    LinearGradient lg = (rs == "g")
        ? greenGradient
        : (rs == "o")
            ? orangeGradient
            : redGradient;
    if (diff == 0.0) {
      return _getPerIndicator(i);
    }
    double pos = (diff > 0.0) ? _scale[i]["value"] : _scale[i]["value"] + diff;
    pos = pos * width * 0.75 / _scale[i]["r"] / 100.0;
    double w = (diff.abs() * width * 0.75 / _scale[i]["r"] / 100.0);
    //pos = 2.0;
    print("pos: " + pos.toString());
    print("width:" + w.toString());
    return Container(
        height: 5,
        width: width * 0.75,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade200),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _getLengthContainer(pos, blueGradient),
            _getLengthContainer(w, lg)
          ],
        ));
  }

  LinearPercentIndicator _getPerIndicator(int i) {
    return LinearPercentIndicator(
      width: width * 0.75,
      animation: true,
      lineHeight: 5.0,
      animationDuration: 1,
      percent: _scale[i]["value"] / _scale[i]["r"] / 100,
      linearStrokeCap: LinearStrokeCap.roundAll,
      // progressColor: Colors.green,
      linearGradient: blueGradient,
    );
  }

  Widget _getLengthContainer(double w, LinearGradient lg) {
    return Container(
      width: w,
      height: 5.0,
      decoration: BoxDecoration(
          gradient: lg,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))),
    );
  }
}
