import 'package:flutter/material.dart';

IconData createMyIcon(int code) {
  return IconData(code, fontFamily: "MyIcons", matchTextDirection: true);
}
class MyIcons {
  static IconData suijibofang = createMyIcon(0xe624);
  static IconData xunhuanbofang = createMyIcon(0xea75);
  static IconData shunxubofang = createMyIcon(0xe600);
  static IconData lajitong = createMyIcon(0xe615);
}