import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PictureContainer extends StatefulWidget with PreferredSizeWidget {
  const PictureContainer({super.key});

  @override
  State<PictureContainer> createState() => _PictureContainerState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _PictureContainerState extends State<PictureContainer> {
  XFile? _selectedImage;

  void _getImage() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _selectedImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
          width: double.infinity,
          height: double.infinity,
          margin: const EdgeInsets.only(
              left: 30.0, right: 30.0, top: 30.0, bottom: 125.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(217, 217, 217, 217),
            border: Border.all(
              width: 2.5,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: _selectedImage != null
              ? Image.file(
                  File(_selectedImage!.path),
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
        if (_selectedImage == null) {
          _getImage();
        }
      },
    );
  }
}
