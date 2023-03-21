import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PictureContainer extends StatefulWidget with PreferredSizeWidget {
  final XFile? selectedImage;
  final Function changeOriginalImage;
  final Function changePicture;

  PictureContainer(
      this.selectedImage, this.changePicture, this.changeOriginalImage,
      {super.key});

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
        height: 350,
        margin:
            const EdgeInsets.only(left: 30, right: 30, top: 12.5, bottom: 0.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(217, 217, 217, 217),
          border: Border.all(
            width: 2.5,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.asset(
          'images/depth.png',
        ));
  }
}
