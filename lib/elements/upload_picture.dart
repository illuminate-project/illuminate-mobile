import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class UploadPicture extends StatefulWidget {
  final XFile? selectedImage;
  final Function changeOriginalImage;
  final Function changePicture;
  const UploadPicture(
      {super.key,
      this.selectedImage,
      required this.changeOriginalImage,
      required this.changePicture});

  @override
  State<UploadPicture> createState() => _UploadPictureState();
}

class _UploadPictureState extends State<UploadPicture> {
  void _getImage() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      widget.changePicture(image);
      widget.changeOriginalImage(image);
      //widget.changePicture(XFile('assets/images/depth.png'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 200,
        margin: const EdgeInsets.only(left: 40, right: 40, top: 0, bottom: 0),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 56, 56, 56),
          borderRadius: BorderRadius.circular(7.5),
        ),
        child: Column(
          children: [
            SizedBox(height: 30),
            Container(
              margin: EdgeInsets.only(left: 35, right: 35),
              child: Text('Click here to select a photo and get started!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  )),
            ),
            SizedBox(height: 40),
            ElevatedButton(
                onPressed: () => {_getImage()},
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(270, 55),
                  backgroundColor: Color.fromARGB(255, 255, 220, 128),
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(15.0),
                  ),
                ),
                child: Text(
                  'Import Photo',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.25),
                ))
          ],
        ));
  }
}
