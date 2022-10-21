
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Model/drawLineModel.dart';

class DrawerMyApp extends CustomPainter {
  //final point, selectedColor, selectedWidth;

//  DrawnLine(this.point, this.selectedColor, this.selectedWidth);

  List<DrawnLine> lines;

  DrawerMyApp({required this.lines});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.redAccent
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;
    // Path path = Path();
    for (int i = 0; i < lines.length; ++i) {
      if (lines[i] == null) continue;
      for (int j = 0; j < lines[i].path.length - 1; ++j) {
        paint.color = lines[i].selectedColor!;
        paint.strokeWidth = lines[i].selectedWidth!;
        canvas.drawLine(lines[i].path[j], lines[i].path[j + 1], paint);
      }
    }
    // path.moveTo(100, 100);
    // path.addOval(Rect.fromCircle(center: const Offset(100, 100), radius: 25));
    //
    // path = Path();
    // path.moveTo(100, 100);
    // path.addOval(Rect.fromCircle(center: const Offset(100, 100), radius: 25));
    // canvas.drawPath(path, paintSun);
    //canvas.drawLine(startPoint, endPoint, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
