import 'package:flutter/material.dart';

class SavedImage extends StatelessWidget {
  final imageFile;
  SavedImage({this.imageFile});

  @override
  Widget build(BuildContext context) {
    return imageFile != null ? Image.file(imageFile) : Container();
  }
}
