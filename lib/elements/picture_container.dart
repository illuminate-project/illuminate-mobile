import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PictureContainer extends StatefulWidget with PreferredSizeWidget {
  final XFile? selectedImage;
  final Function changePicture;

  PictureContainer(this.selectedImage, this.changePicture, {super.key});

  @override
  State<PictureContainer> createState() => _PictureContainerState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _PictureContainerState extends State<PictureContainer> {
  void _getImage() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

    widget.changePicture(image);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
          width: double.infinity,
          height: 350,
          margin: const EdgeInsets.only(
              left: 30.0, right: 30.0, top: 30.0, bottom: 0.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(217, 217, 217, 217),
            border: Border.all(
              width: 2.5,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: widget.selectedImage != null
              ? Image.file(
                  File(widget.selectedImage!.path),
                  width: double.infinity,
                  height: double.infinity,
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 100,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Add Image',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
      onTap: () {
        if (widget.selectedImage == null) {
          _getImage();
        }
      },
    );
  }
}
