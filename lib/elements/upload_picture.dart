import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

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
    }

    // Clipdrop APIS (only depth map right now)
    var dio = Dio();
    dio.options.headers['x-api-key'] =
        '9b6a9609d06fc627e98744d01e2b4688d1a7a6c37328efa7efc6cf60302e0fd4776825d6815d08942fcd50a9db7c4475';

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
      final Uint8List depthUint8List = Uint8List.fromList(codeUnits);

      XFile finalXImg = XFile.fromData(depthUint8List);
      var finalImg = Image.memory(depthUint8List);

      widget.changePicture(image);
      print(finalImg);
      postImageAndDepth(depthUint8List);
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
    } */
  }

  Future<void> postImageAndDepth(Uint8List depthUint8List) async {
    // Set the endpoint URL
    final url = Uri.parse('https://mesh-api.herokuapp.com/api/mesh');

    // Load the image file
    final imageBytes = await rootBundle.load('assets/image_50.jpg');
    final imageUpload = http.MultipartFile.fromBytes(
        'image', imageBytes.buffer.asUint8List(),
        filename: 'image_50.jpg');

    // Load the depth file
    final depthBytes = await rootBundle.load('assets/depth_50.jpg');
    final depthUpload = http.MultipartFile.fromBytes(
        'depth', depthBytes.buffer.asUint8List(),
        filename: 'depth_50.png');

    // Create a new multipart request
    final request = http.MultipartRequest('POST', url)
      ..files.add(imageUpload)
      ..files.add(depthUpload);

    // Send the request and retrieve the response
    final response = await request.send();

    final tempDir = await getTemporaryDirectory();
    final path = await tempDir.path;
    final file = await File('$path/test.obj');

    // Open the file and write the response to it
    await response.stream.pipe(file.openWrite());

    // Print a message indicating that the file has been saved
    print('File saved to ${file.path}');
    print(file.path);
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
