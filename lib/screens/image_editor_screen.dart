import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'saved_image.dart';
import 'package:dio/dio.dart';

class ImageEditorScreen extends StatefulWidget {
  @override
  _ImageEditorScreenState createState() => _ImageEditorScreenState();
}

class _ImageEditorScreenState extends State<ImageEditorScreen> {
  Color selectedColor = Colors.black;
  Color pickerColor = Colors.black;
  double strokeWidth = 3.0;
  List<DrawingPoints> points = List();
  bool showBottomList = false;
  double opacity = 1.0;
  StrokeCap strokeCap = (Platform.isAndroid) ? StrokeCap.butt : StrokeCap.round;
  SelectedMode selectedMode = SelectedMode.StrokeWidth;
  File _imageFile;
  ScreenshotController _screenshotController = ScreenshotController();
  Dio dio = new Dio();
  //Create an instance of ScreenshotController

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _gestDetect(),
      persistentFooterButtons: <Widget>[
        FlatButton(
          child: Text('Clear'),
          onPressed: () {
            print('clearing');
            _clearPoints();
          },
        ),
        FlatButton(
          child: Text('Save'),
          onPressed: () async {
            await _getScreenshot();
            await _postChange();
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SavedImage(
                        imageFile: _imageFile,
                      ),
                ));
          },
        )
      ],
    );
  }

  Widget _gestDetect() {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          RenderBox renderBox = context.findRenderObject();
          points.add(DrawingPoints(
              points: renderBox.globalToLocal(details.globalPosition),
              paint: Paint()
                ..strokeCap = strokeCap
                ..isAntiAlias = true
                ..color = selectedColor.withOpacity(opacity)
                ..strokeWidth = strokeWidth));
        });
      },
      onPanStart: (details) {
        setState(() {
          RenderBox renderBox = context.findRenderObject();
          points.add(DrawingPoints(
              points: renderBox.globalToLocal(details.globalPosition),
              paint: Paint()
                ..strokeCap = strokeCap
                ..isAntiAlias = true
                ..color = selectedColor.withOpacity(opacity)
                ..strokeWidth = strokeWidth));
        });
      },
      onPanEnd: (details) {
        setState(() {
          points.add(null);
        });
      },
      child: Screenshot(
        controller: _screenshotController,
        child: CustomPaint(
          foregroundPainter: Painter(pointsList: points),
          size: Size.infinite,
          child: Center(
            child: RotatedBox(
              quarterTurns: 5,
              child: Image.asset('assets/order.png'),
            ),
          ),
        ),
      ),
    );
  }

  _getScreenshot() async {
    await _screenshotController.capture().then((File image) {
      //print("Capture Done");
      setState(() {
        _imageFile = image;
      });
    }).catchError((onError) {
      print(onError);
    });
  }

  _postChange() async {
    FormData formData = new FormData.from({
      "image[image]": new UploadFileInfo(_imageFile, _imageFile.path),
    });
    await dio.put("http://192.168.0.2:3000/images/1", data: formData);
  }

  void _clearPoints() {
    setState(() {
      points.clear();
    });
  }
}

// rect painter not ready
class Painter extends CustomPainter {
  Painter({this.pointsList});
  List<DrawingPoints> pointsList;
  List<Offset> offsetPoints = List();

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < pointsList.length - 1; i++) {
      if (pointsList[i] != null && pointsList[i + 1] != null) {
        canvas.drawLine(pointsList[i].points, pointsList[i + 1].points,
            pointsList[i].paint);
      } else if (pointsList[i] != null && pointsList[i + 1] == null) {
        print(offsetPoints);
        offsetPoints.clear();
        offsetPoints.add(pointsList[i].points);
        offsetPoints.add(Offset(
            pointsList[i].points.dx + 0.1, pointsList[i].points.dy + 0.1));
        canvas.drawPoints(
            ui.PointMode.points, offsetPoints, pointsList[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(Painter oldDelegate) => true;
}

class DrawingPoints {
  Paint paint;
  Offset points;
  DrawingPoints({this.points, this.paint});
}

enum SelectedMode { StrokeWidth, Opacity, Color }
