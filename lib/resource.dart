import 'package:flutter/material.dart';

class Resource {
  static Resource instance = Resource();

  final AppColor appColor = AppColor();
  final AppText appText = AppText();
}

class AppColor {
  var primaryColor = const Color(0xFF4BB27B);
}

class AppText {
  var h1 = const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  var h2 = const TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white);
  var body = const TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
  var body2 = const TextStyle(
      fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white);
}
