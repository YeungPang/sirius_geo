import 'package:flutter/material.dart';

class InProgress extends StatelessWidget {
  final String title;
  InProgress({this.title});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return IgnorePointer(
        child: Container(
      width: screenSize.width,
      height: screenSize.height,
      alignment: Alignment.center,
      color: Color.fromARGB(100, 0, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircularProgressIndicator(),
          Text(title,
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ],
      ),
    ));
  }
}
