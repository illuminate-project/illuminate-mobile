import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

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
  void _getImage(int type) async {
    XFile? image;
    if (type == 1) {
      image = await ImagePicker().pickImage(source: ImageSource.gallery);
    } else {
      image = await ImagePicker().pickImage(source: ImageSource.camera);
    }

    if (image != null) {
      widget.changePicture(image);
      widget.changeOriginalImage(image);
      //widget.changePicture(XFile('assets/images/depth.png'));
    }

    // Clipdrop APIS (only depth map right now)
    /* var dio = Dio();
    dio.options.headers['x-api-key'] =
        '53fd1fc49499393e445be00fb7c55a5608112b1b61973e8dd14691937af92f22d988ca52c7ae9599d023a906d59315bc';

    var formData = FormData.fromMap({
      'image_file':
          await MultipartFile.fromFile(image!.path, filename: image.name)
    });
    var response =
        await dio.post('https://clipdrop-api.co/portrait-depth-estimation/v1',
            data: formData,
            options: Options(
              responseType: ResponseType.plain,
            ));

    if (response.statusCode == 200) {
      var buffer = response.data;
      final List<int> codeUnits = buffer.codeUnits;
      final Uint8List uint8List = Uint8List.fromList(codeUnits);

      XFile finalXImg = XFile.fromData(uint8List);
      var finalImg = Image.memory(uint8List);

      widget.changePicture(image);
      print(finalImg);
    }

    // resused code for depth map
    /* response = await dio.post(
        'https://clipdrop-api.co/portrait-depth-estimation/v1',
        data: formData);

    if (response.statusCode == 200) {
      var buffer = response.data;
      final List<int> codeUnits = buffer.codeUnits;
      final Uint8List uint8List = Uint8List.fromList(codeUnits);

      XFile finalXImg = XFile.fromData(uint8List);
      var finalImg = Image.memory(uint8List);

      widget.changePicture(currImage);
      print(finalImg);
    } */ */
  }

  Future<void> postData() async {
    /* var url =
        Uri.https('https://clipdrop-api.co/portrait-surface-normals', 'v1');

    var form = new FormData();
    form.files.add(MapEntry("image_file", photo));

    var response = await http.post(
        'https://clipdrop-api.co/portrait-surface-normals/v1',
        headers: {'x-api-key': 53fd1fc49499393e445be00fb7c55a5608112b1b61973e8dd14691937af92f22d988ca52c7ae9599d023a906d59315bc},
        body: form);

    if (response.statusCode == 200) {
      var buffer = response.bodyBytes;
      // buffer here is a binary representation of the returned image
    } */
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 285,
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
            SizedBox(height: 30),
            ElevatedButton(
                onPressed: () => {_getImage(1)},
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(270, 55),
                  backgroundColor: Color.fromARGB(255, 255, 220, 128),
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(15.0),
                  ),
                ),
                child: Text(
                  'Upload Photo',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.5),
                )),
            SizedBox(height: 30),
            ElevatedButton(
                onPressed: () => {_getImage(2)},
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(270, 55),
                  backgroundColor: Color.fromARGB(255, 255, 220, 128),
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(15.0),
                  ),
                ),
                child: Text(
                  'Take Photo',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.5),
                ))
          ],
        ));
  }
}
