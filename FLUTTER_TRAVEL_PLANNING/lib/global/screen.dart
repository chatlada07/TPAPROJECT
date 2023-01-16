import 'package:flutter/material.dart';

mediaQuery(context, String type, double value) {
  double _height = MediaQuery.of(context).size.height;
  double _width = MediaQuery.of(context).size.width;

  double widthScreen = 1080;
  double heightScreen = 1920;

  if (type == "h") {
    return (_height * (value / heightScreen));
  } else if (type == "w") {
    return (_width * (value / widthScreen));
  }
}
