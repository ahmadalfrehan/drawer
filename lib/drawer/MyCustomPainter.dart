import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Offset startPoint = const Offset(0, 0);
    Offset endPoint = Offset(size.width, size.height);
    Paint paintSun = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.deepOrangeAccent;
    Paint paint = Paint()..style = PaintingStyle.fill..color = Colors.brown;
    Path path = Path();
    path.moveTo(0, 250);
    path.lineTo(100, 200);
    path.lineTo(150, 150);
    path.lineTo(200, 50);
    path.lineTo(250, 150);
    path.lineTo(300, 200);
    path.lineTo(size.width, 250);
    path.lineTo(0, 250);
    path.moveTo(100, 100);
    path.addOval(Rect.fromCircle(center: Offset(100,100), radius: 25));
    canvas.drawPath(path, paint);
    path = Path();
    path.moveTo(100, 100);
    path.addOval(Rect.fromCircle(center: Offset(100, 100), radius: 25));
    canvas.drawPath(path, paintSun);
    //canvas.drawLine(startPoint, endPoint, paint);
    //canvas.drawCircle(startPoint, 34, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
