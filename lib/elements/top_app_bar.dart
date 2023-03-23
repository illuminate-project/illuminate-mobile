import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import '../home_page.dart';

class TopAppBar extends StatefulWidget with PreferredSizeWidget {
  final Function changePicture;
  final XFile? selectedImage;
  const TopAppBar(
    this.changePicture,
    this.selectedImage, {
    super.key,
  });

  @override
  State<TopAppBar> createState() => _TopAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TopAppBarState extends State<TopAppBar> {
  Future<bool> saveImage() async {
    print(testImage);
    await GallerySaver.saveImage(widget.selectedImage!.path)
        .catchError((error, stackTrace) => false);
    return true;
  }
  Uint8List? testImage;

  @override
  Widget build(BuildContext context) {
    void showModal(String title, int type) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(title),
          insetPadding: EdgeInsets.only(bottom: 150),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async => {
                Navigator.pop(context, 'Yes'),
                if (type == 1)
                  {widget.changePicture(null)}
                else
                  {
                    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                      content: Text(await saveImage() == true
                          ? 'Image Saved!'
                          : 'Failed to Save Image'),
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height - 193,
                          right: 31.5,
                          left: 31.5),
                    ))
                  }
              },
              child: const Text('Yes'),
            ),
          ],
        ),
      );
    }

    return AppBar(
      backgroundColor: const Color.fromARGB(255, 31, 31, 31),
      title: ButtonBar(
        alignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              icon: const Icon(Icons.cancel_outlined),
              color: const Color.fromARGB(255, 255, 140, 140),
              onPressed: () => showModal('Remove Photo?', 1)),
          IconButton(
            icon: const Icon(Icons.dark_mode_outlined),
            color: Color.fromARGB(255, 255, 255, 255),
            onPressed: () => {},
          ),
          IconButton(
            icon: const Icon(Icons.remove_red_eye_outlined),
            color: Color.fromARGB(255, 255, 255, 255),
            onPressed: () => {},
          ),
          IconButton(
            icon: const Icon(Icons.check_circle_outline),
            color: const Color.fromARGB(255, 227, 174, 111),
            onPressed: () => {
              testImage = HomePageState().sceneCapture(),
              showModal('Save to Camera Roll?', 2)
            },
          ),
        ],
      ),
    );
  }
}
