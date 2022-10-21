import 'package:flutter/material.dart';

class DrawnLine {
  List<Offset> path;
  Color? selectedColor;
  double? selectedWidth;

  DrawnLine(this.path, this.selectedColor, this.selectedWidth);
}
