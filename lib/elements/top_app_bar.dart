import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

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
  void doNothing() {}

  Future<void> saveImage() async {
    await GallerySaver.saveImage(widget.selectedImage!.path);
  }

  @override
  Widget build(BuildContext context) {
    void showModal(String title, int type) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(title),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => {
                Navigator.pop(context, 'Yes'),
                if (type == 1) {widget.changePicture(null)} else {saveImage()}
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
            icon: const Icon(Icons.dangerous_outlined),
            color: const Color.fromARGB(255, 255, 140, 140),
            onPressed: () => {
              if (widget.selectedImage != null)
                {showModal('Are you sure you want to remove this photo?', 1)}
            },
          ),
          IconButton(
            icon: const Icon(Icons.dark_mode_outlined),
            onPressed: () => doNothing(),
          ),
          IconButton(
              icon: const Icon(Icons.remove_red_eye_outlined),
              onPressed: () => doNothing()),
          IconButton(
            icon: const Icon(Icons.check_circle_outline),
            color: const Color.fromARGB(255, 227, 174, 111),
            onPressed: () => {
              if (widget.selectedImage != null)
                {showModal('Save this photo to your camera roll ?', 2)}
            },
          )
        ],
      ),
    );
  }
}
