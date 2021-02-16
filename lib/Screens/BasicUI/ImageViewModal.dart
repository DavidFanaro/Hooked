import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewModal extends StatelessWidget {

  ImageViewModal(this._image);

  final Image _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Viewer"),
      ),
      body: Container(
        child: PhotoView(imageProvider: _image.image,),
      ),
    );
  }
}