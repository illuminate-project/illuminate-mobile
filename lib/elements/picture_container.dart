import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PictureContainer extends StatefulWidget with PreferredSizeWidget {
  final XFile? selectedImage;
  final double blur;

  PictureContainer(this.selectedImage, this.blur, {super.key});

  @override
  State<PictureContainer> createState() => _PictureContainerState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _PictureContainerState extends State<PictureContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 389,
        margin: const EdgeInsets.only(top: 0, bottom: 0.0),
        child: ImageFiltered(
            imageFilter: ImageFilter.blur(
                sigmaY: widget.blur,
                sigmaX:
                    widget.blur), //SigmaX and Y are just for X and Y directions
            child: Image.file(
              File(widget.selectedImage!.path),
              fit: BoxFit.cover,
            )) //here you can use any widget you'd like to blur .
        );
  }
}
