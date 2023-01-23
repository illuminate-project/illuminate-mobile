import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

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
    XFile? currImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    widget.changePicture(currImage);

    var dio = Dio();
    dio.options.headers['x-api-key'] =
        '53fd1fc49499393e445be00fb7c55a5608112b1b61973e8dd14691937af92f22d988ca52c7ae9599d023a906d59315bc';

    var formData = FormData.fromMap({
      'image_file': await MultipartFile.fromFile(currImage!.path,
          filename: currImage.name)
    });
    var response =
        await dio.post('https://clipdrop-api.co/portrait-surface-normals/v1',
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

      widget.changePicture(currImage);
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
    } */
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
    return GestureDetector(
      child: Container(
          width: double.infinity,
          height: double.infinity,
          margin: const EdgeInsets.only(
              left: 20.0, right: 20.0, top: 30.0, bottom: 125.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            border: Border.all(
              width: 2.5,
            ),
            borderRadius: BorderRadius.circular(5),
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
