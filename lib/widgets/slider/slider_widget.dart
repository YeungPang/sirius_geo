import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sirius_geo/resources/basic_resources.dart';
import 'package:sirius_geo/resources/fonts.dart';

class SliderWidget extends StatefulWidget {
  final Map<String, dynamic> map;
  SliderWidget(this.map);
  @override
  _SliderWidgetState createState() => _SliderWidgetState(map);
}

class _SliderWidgetState extends State<SliderWidget>
    with SingleTickerProviderStateMixin {
  //final _key = new GlobalKey<_SliderWidgetState>();
  final Map<String, dynamic> map;
  bool _isSwitched = false;
  AnimationController rotationController;
  double _totalEarthLandArea = 148.32;
  double _totalEarthArea = 510.1;
  double _earthSurfaceArea = 0.0;
  double _earthLandSurfaceArea = 0.0;
  double _absoluteSize = 0.0;
  LinearGradient _sliderGradient = LinearGradient(
      colors: <Color>[colorMap["btnBlue"], colorMap["btnBlueGradEnd"]]);

  _SliderWidgetState(this.map);

  @override
  void initState() {
    rotationController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _totalEarthArea = map["totalArea"] ?? 510.1;
    _totalEarthLandArea = map["totalLand"] ?? 148.32;

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.only(bottom: 20),
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
              gradient: _sliderGradient,
            ),
            child: Stack(
              children: [
                Positioned(
                    top: MediaQuery.of(context).size.height * 0.14,
                    left: 1,
                    child: Image.asset(
                      'assets/images/circles_background.png',
                    )),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sliderCard(),
                      Center(
                        child: RotationTransition(
                            turns: Tween(begin: 0.0, end: 0.5)
                                .animate(rotationController),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    if (_isSwitched) {
                                      _isSwitched = false;
                                      rotationController.forward(from: 0.0);
                                    } else {
                                      _isSwitched = true;
                                      rotationController.reverse(from: 1.0);
                                    }
                                  });
                                },
                                child: Image.asset(
                                  'assets/images/switch.png',
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  width:
                                      MediaQuery.of(context).size.height * 0.05,
                                ),
                              ),
                            )),
                      ),
                      _selectionCard(),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget _sliderCard() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.20,
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
                  'Your Selection',
                  style: SmallSemiTextStyle,
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: width * 0.04,
                ),
                child: Text(
                  _isSwitched
                      ? '$_earthSurfaceArea%'
                      : '$_absoluteSize Million km\u{00B2}',
                  style: SliderTextStyle,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: width * 0.04, top: height * 0.02),
                child: Text(
                  _isSwitched ? '% of Earth Surface Area' : 'Absolute size',
                  style: SliderSmallTextStyle,
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: width * 0.01,
                ),
                child: FlutterSlider(
                  values: [_absoluteSize],
                  step: FlutterSliderStep(isPercentRange: false, step: 0.01),
                  max: 50,
                  min: 0,
                  handlerHeight: 20,
                  handlerWidth: 20,
                  handler: FlutterSliderHandler(
                    child: Container(
                      child: Image.asset('assets/images/slider_circle.png'),
                    ),
                  ),
                  trackBar: FlutterSliderTrackBar(
                      activeTrackBar: BoxDecoration(gradient: _sliderGradient)),
                  onDragging: (handlerIndex, lowerValue, upperValue) {
                    setState(() {
                      _absoluteSize = lowerValue;
                      _earthSurfaceArea =
                          double.parse(_getEarthSurfaceArea(_absoluteSize));
                      _earthLandSurfaceArea =
                          double.parse(_getEarthLandSurfaceArea(_absoluteSize));
                    });
                  },
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: width * 0.04, right: 10),
                  child: Row(
                    children: [
                      Text(
                        _isSwitched ? '0%' : '0 km\u{00B2}',
                        style: SliderSmallTextStyle,
                      ),
                      Spacer(),
                      Text(
                        _isSwitched ? '100%' : '50M km\u{00B2}',
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
            children: [
              Container(
                margin: EdgeInsets.only(left: width * 0.04, top: height * 0.02),
                child: Text(
                  'Your Selection',
                  style: SliderBoldTextStyle,
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: width * 0.04,
                ),
                child: Text(
                  _isSwitched
                      ? '$_absoluteSize Million km\u{00B2}'
                      : '$_earthSurfaceArea%',
                  style: SliderTextStyle,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: width * 0.04, top: height * 0.01),
                child: Text(
                  _isSwitched ? 'Absolute size' : '% of Earth Surface Area',
                  style: SliderSmallTextStyle,
                ),
              ),
              if (!_isSwitched)
                Container(
                  margin: EdgeInsets.only(left: width * 0.03, top: 5),
                  child: LinearPercentIndicator(
                    width: MediaQuery.of(context).size.width * 0.75,
                    animation: true,
                    lineHeight: 5.0,
                    animationDuration: 1,
                    percent: _earthLandSurfaceArea / 100,
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    // progressColor: Colors.green,
                    linearGradient: _sliderGradient,
                  ),
                ),
              if (_isSwitched)
                Container(
                  margin: EdgeInsets.only(left: width * 0.03, top: 5),
                  child: LinearPercentIndicator(
                    width: MediaQuery.of(context).size.width * 0.75,
                    animation: true,
                    lineHeight: 5.0,
                    animationDuration: 1,
                    percent: _absoluteSize * 2 / 100,
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    // progressColor: Colors.green,
                    linearGradient: _sliderGradient,
                  ),
                ),
              Container(
                  margin:
                      EdgeInsets.only(left: width * 0.04, top: 5, right: 10),
                  child: Row(
                    children: [
                      Text(
                        _isSwitched ? '0 km\u{00B2}' : '0%',
                        style: SliderSmallTextStyle,
                      ),
                      Spacer(),
                      Text(
                        _isSwitched ? '50M km\u{00B2}' : '100%',
                        style: SliderSmallTextStyle,
                      ),
                    ],
                  )),
              Container(
                color: Colors.grey.shade700,
                height: 1,
                margin: EdgeInsets.only(top: 10),
              ),
              Container(
                margin: EdgeInsets.only(left: width * 0.04, top: height * 0.02),
                child: Text(
                  'Your Selection',
                  style: SliderBoldTextStyle,
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: width * 0.04,
                ),
                child: Text(
                  '$_earthLandSurfaceArea%',
                  style: SliderTextStyle,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: width * 0.04, top: height * 0.01),
                child: Text(
                  "% of Earth's Land Surface Area",
                  style: SliderSmallTextStyle,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: width * 0.03, top: 5),
                child: LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width * 0.75,
                  animation: true,
                  lineHeight: 5.0,
                  animationDuration: 1,
                  percent: _earthLandSurfaceArea / 100,
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  // progressColor: Colors.green,
                  linearGradient: _sliderGradient,
                ),
              ),
              Container(
                  margin:
                      EdgeInsets.only(left: width * 0.04, top: 5, right: 10),
                  child: Row(
                    children: [
                      Text(
                        '0%',
                        style: SliderSmallTextStyle,
                      ),
                      Spacer(),
                      Text(
                        '100%',
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

  //get the earth's surface area percentage W.R.T input area from slider
  String _getEarthSurfaceArea(double inputArea) {
    double _earthSurfaceArea = 0.0;
    _earthSurfaceArea = 100 / _totalEarthArea * inputArea;
    return _earthSurfaceArea.toStringAsFixed(2);
  }

  //get the earth's land surface area percentage W.R.T input area from slider
  String _getEarthLandSurfaceArea(double inputArea) {
    double _earthLandSurfaceArea = 0.0;
    _earthLandSurfaceArea = 100 / _totalEarthLandArea * inputArea;
    return _earthLandSurfaceArea.toStringAsFixed(2);
  }
}
