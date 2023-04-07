import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../home_page.dart';

class TopAppBar extends StatefulWidget with PreferredSizeWidget {
  final Function changePicture;
  final Function sceneCapture;
  final Function saveImage;
  final Function allLightToggle;
  final Function hideMovableLight;
  final XFile? selectedImage;
  const TopAppBar(
    this.changePicture,
    this.sceneCapture,
    this.allLightToggle,
    this.saveImage,
    this.hideMovableLight,
    this.selectedImage, {
    super.key,
  });

  @override
  State<TopAppBar> createState() => _TopAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TopAppBarState extends State<TopAppBar> {
  HomePageState imageInstance = HomePageState();
  bool allLightsOn = true;
  bool movableLightOn = true;

  @override
  Widget build(BuildContext context) {
    void removeImage() async {
      widget.changePicture(null);
      print("Hit");
      final tempDir = await getTemporaryDirectory();
      tempDir.deleteSync(recursive: true);
      tempDir.create();
    }

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
                  {removeImage()}
                else
                  {
                    imageInstance.saveImage(),
                    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                      backgroundColor: Color.fromARGB(255, 105, 241, 143),
                      content: Text('Saved to Camera Roll!',
                          style: TextStyle(
                              color: Color.fromARGB(255, 26, 47, 24))),
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
              icon: const Icon(CupertinoIcons.xmark),
              color: const Color.fromARGB(255, 255, 140, 140),
              onPressed: () => showModal('Remove Photo?', 1)),
          IconButton(
            icon: allLightsOn
                ? const Icon(CupertinoIcons.eye_fill)
                : const Icon(CupertinoIcons.eye_slash_fill),
            color: Color.fromARGB(255, 255, 255, 255),
            onPressed: () => {
              widget.hideMovableLight(),
              setState(() {
                allLightsOn = !allLightsOn;
              })
            },
          ),
          IconButton(
            icon: movableLightOn
                ? const Icon(CupertinoIcons.lightbulb_fill)
                : const Icon(CupertinoIcons.lightbulb),
            color: Color.fromARGB(255, 255, 255, 255),
            onPressed: () => {
              widget.allLightToggle(),
              setState(() {
                movableLightOn = !movableLightOn;
              })
            },
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.square_arrow_down),
            color: const Color.fromARGB(255, 227, 174, 111),
            onPressed: () =>
                {widget.sceneCapture(), showModal('Save to Camera Roll?', 2)},
          ),
        ],
      ),
    );
  }
}
