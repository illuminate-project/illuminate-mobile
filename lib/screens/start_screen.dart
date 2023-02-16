import 'package:flutter/material.dart';
import 'package:illuminate/elements/upload_picture.dart';
import 'package:image_picker/image_picker.dart';

class StartScreen extends StatefulWidget {
  final XFile? selectedImage;
  final Function changeOriginalImage;
  final Function changePicture;
  const StartScreen(
      {super.key,
      this.selectedImage,
      required this.changeOriginalImage,
      required this.changePicture});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.only(top: 60),
            child: ClipOval(
              child: SizedBox.fromSize(
                size: Size.fromRadius(60), // Image radius
                child: Image.asset('assets/images/luna.png',
                    fit: BoxFit.fitHeight),
              ),
            )),
        SizedBox(height: 75),
        UploadPicture(
          selectedImage: widget.selectedImage,
          changeOriginalImage: widget.changeOriginalImage,
          changePicture: widget.changePicture,
        )
      ],
    );
  }
}
