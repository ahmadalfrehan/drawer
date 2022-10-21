import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../Model/drawLineModel.dart';
import '../drawer/drawer.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  State<DrawerScreen> createState() => _MyCustomPaiState();
}

class _MyCustomPaiState extends State<DrawerScreen> {
  final GlobalKey _globalKey = GlobalKey();
  StreamController<List<DrawnLine>> linesStreamController =
      StreamController<List<DrawnLine>>.broadcast();
  StreamController<DrawnLine> currentLineStreamController =
      StreamController<DrawnLine>.broadcast();
  bool showSlider = false;
  List<DrawnLine> lines = <DrawnLine>[];
  DrawnLine? line;
  Color selectedColor = Colors.black;
  Color? backGroundColor = Colors.yellow[100];
  double selectedWidth = 5.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: backGroundColor,
        child: Stack(
          children: [
            _drawAllPaths(context),
            _drawCurrentPAth(context),
            if (showSlider)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const SizedBox(width: 10),
                        const Text('1'),
                        Expanded(
                          child: Slider(
                              label: "$selectedWidth",
                              min: 1,
                              max: 25,
                              value: selectedWidth,
                              onChanged: (value) {
                                setState(() {
                                  selectedWidth = value;
                                });
                              }),
                        ),
                        Text("${selectedWidth.toInt()}"),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _saveAsPhoto();
              });
            },
            child: const Icon(Icons.save_alt),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                lines = [];
                line = null;
              });
            },
            child: const Icon(Icons.clear),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: MaterialPicker(
                            pickerColor: Colors.red,
                            onColorChanged: (Color color) {
                              setState(() {
                                backGroundColor = color;
                                Navigator.of(context).pop();
                              });
                            }),
                      );
                    });
              });
            },
            child: const Icon(Icons.color_lens),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: MaterialPicker(
                            pickerColor: Colors.red,
                            onColorChanged: (Color color) {
                              setState(() {
                                selectedColor = color;
                                Navigator.of(context).pop();
                              });
                            }),
                      );
                    });
              });
            },
            child: const Icon(Icons.colorize_outlined),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                showSlider = !showSlider;
              });
            },
            child: const Icon(Icons.mode_edit_outlined),
          ),
          if (showSlider) const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _drawCurrentPAth(BuildContext context) {
    return GestureDetector(
      onPanStart: _onUserStartDraw,
      onPanUpdate: _onUserStartUpdate,
      onPanEnd: _onUserFinishDrawn,
      child: RepaintBoundary(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(4.0),
          color: Colors.transparent,
          alignment: Alignment.topLeft,
          child: StreamBuilder<DrawnLine>(
            stream: currentLineStreamController.stream,
            builder: (context, snapshot) {
              return CustomPaint(
                painter: DrawerMyApp(
                  lines: [
                    line ??
                        DrawnLine(
                            [const Offset(0, 0)], selectedColor, selectedWidth)
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _drawAllPaths(BuildContext context) {
    return RepaintBoundary(
      key: _globalKey,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.transparent,
        padding: const EdgeInsets.all(4.0),
        alignment: Alignment.topLeft,
        child: StreamBuilder<List<DrawnLine>>(
          stream: linesStreamController.stream,
          builder: (context, snapshot) {
            return CustomPaint(
              painter: DrawerMyApp(
                lines: lines,
              ),
            );
          },
        ),
      ),
    );
  }

  _onUserStartDraw(DragStartDetails details) {
    log('user start drawing');
    final box = context.findRenderObject() as RenderBox;
    final point = box.globalToLocal(details.globalPosition);
    line = DrawnLine([point], selectedColor, selectedWidth);
    log(point.toString());
  }

  _onUserStartUpdate(DragUpdateDetails details) {
    final box = context.findRenderObject() as RenderBox;
    final point = box.globalToLocal(details.globalPosition);
    List<Offset> path = List.from(line!.path)..add(point);

    line = DrawnLine(path, selectedColor, selectedWidth);
    currentLineStreamController.add(line!);
    log(point.toString());
  }

  _saveAsPhoto() async {
    try {
      final boundary = _globalKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      log(image.toString());
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png) as ByteData;
      Uint8List pngBytes = byteData.buffer.asUint8List();
      log('$pngBytes');
      var fileName =
          DateTime.now().toString().replaceAll(' ', '').replaceAll(':', ' ');
      var l = await File('storage/emulated/0/Download/$fileName.png')
          .writeAsBytes(pngBytes);
     // Navigator.pop(context, pngBytes);
      log('saved');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('file saved at ${l.path}')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('error')));
      log(e.toString());
    }
  }

  _onUserFinishDrawn(DragEndDetails details) {
    lines = List.from(lines)..add(line!);
    linesStreamController.add(lines);
    log('User ended drawing');
  }
}
