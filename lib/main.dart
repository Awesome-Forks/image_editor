import 'package:flutter/material.dart';
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
