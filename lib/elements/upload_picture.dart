import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

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
      image = await ImagePicker().pickImage(
          source: ImageSource.gallery, maxHeight: 1024, maxWidth: 1024);
    } else {
      image = await ImagePicker().pickImage(source: ImageSource.camera);
    }

    if (image != null) {
      print(File(image.path).lengthSync());
      print(File(image.path).lengthSync());
      File imageNew = await compressImage(image);
      print(File(imageNew.path).lengthSync());
      print(File(imageNew.path).lengthSync());

      widget.changePicture(image);
      widget.changeOriginalImage(image);

      final imgDir = await getTemporaryDirectory();
      final path = await imgDir.path;
      final imgBytes = await imageNew.readAsBytes();
      final textBytes = await image.readAsBytes();
      // final selectedImage = img.encodeJpg(imgBytes);
      final storeImage = await File('$path/selectedImage.jpg');
      await storeImage.writeAsBytes(imgBytes);
      final storeTexture = await File('$path/texture.jpg');
      await storeTexture.writeAsBytes(textBytes);
      print(storeImage);

      clipdropImage(imageNew);
    }
  }

  Future<File> compressImage(XFile image) async {
    File imageFile = File(image.path);

    final filePath = imageFile.absolute.path;
    final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";

    File? result = await FlutterImageCompress.compressAndGetFile(
      imageFile.absolute.path,
      outPath,
      quality: 20,
    );
    return result!;
  }

  Future<void> clipdropImage(File imageFile) async {
    /* final testBytes = await imageFile.readAsBytes();
    final depthImage = img.decodeJpg(testBytes);
    print(depthImage); */

    final url = 'https://clipdrop-api.co/portrait-depth-estimation/v1';
    final headers = {
      'x-api-key':
          '895d0874697a0f23c39182ed12ab5891c62865f4fe93254bc36ac620e1659c35e543f29d2b68c0d81cf0024c19322045',
    };
    final request = http.MultipartRequest('POST', Uri.parse(url))
      ..headers.addAll(headers)
      ..files.add(
        await http.MultipartFile.fromPath('image_file', imageFile.path),
      );

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseBytes = await response.stream.toBytes();
      final image =
          img.decodeImage(responseBytes); // decode the bytes as an image
      final depthImage = img.encodeJpg(image!);
      final tempDir = await getTemporaryDirectory();
      final path = await tempDir.path;
      final depthFile = await File('$path/depthImg.jpg');
      await depthFile.writeAsBytes(depthImage);
      // await File('assets/sakun.jpg').writeAsBytes(depthImage);

      postImageAndDepth(
          depthImage); // encode the image as PNG and write it to a file
    }
  }

  Future<void> postImageAndDepth(depthFile) async {
    // Set the endpoint URL
    final url = Uri.parse('https://mesh-api.herokuapp.com/api/mesh');

    // Load the image file
    final imageBytes = await rootBundle.load('assets/image_50.jpg');
    final imageUpload = http.MultipartFile.fromBytes(
        'image', imageBytes.buffer.asUint8List(),
        filename: 'image_50.jpg');

    // Load the depth file
    // final depthBytes = await rootBundle.load('assets/depth_50.jpg');
    final depthUpload = http.MultipartFile.fromBytes('depth', depthFile,
        filename: 'imageDepth.jpg');

    // Create a new multipart request
    final request = http.MultipartRequest('POST', url)
      ..files.add(imageUpload)
      ..files.add(depthUpload);

    // Send the request and retrieve the response
    final response = await request.send();

    final tempDir = await getTemporaryDirectory();
    final path = await tempDir.path;
    final file = await File('$path/mesh.obj');

    // Open the file and write the response to it
    await response.stream.pipe(file.openWrite());

    // Print a message indicating that the file has been saved
    print('File saved to ${file.path}');
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
