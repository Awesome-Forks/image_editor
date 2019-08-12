import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:screenshot/screenshot.dart';
import 'screens/saved_image.dart';
import 'screens/image_editor_screen.dart';

const directoryName = 'Signature';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  noSuchMethod(Invocation i) => super.noSuchMethod(i);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ImageEditorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
