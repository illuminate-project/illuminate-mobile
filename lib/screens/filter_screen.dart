import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:io';
import 'package:photofilters/photofilters.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class FilterScreen extends StatefulWidget {
  final XFile? originalImage;
  final Function setSelectedImage;
  const FilterScreen(
      {super.key, required this.setSelectedImage, this.originalImage});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  List<Filter> filters = presetFiltersList;
  late XFile ig;
  late File imageFile;
  late String fileName;

  @override
  void initState() {
    super.initState();
    ig = widget.originalImage as XFile;
  }

  Future getImage(context) async {
    imageFile = new File(ig.path);
    fileName = basename(imageFile.path);
    var image = img.decodeImage(await imageFile.readAsBytes()) as img.Image;
    var imagefile = await Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new PhotoFilterSelector(
          appBarColor: const Color.fromARGB(255, 31, 31, 31),
          title: Text("Photo Filter"),
          image: image,
          filters: presetFiltersList,
          filename: fileName,
          loader: Center(child: CircularProgressIndicator()),
          fit: BoxFit.contain,
        ),
      ),
    );
    if (imagefile != null && imagefile.containsKey('image_filtered')) {
      setState(() {
        imageFile = imagefile['image_filtered'];
        widget.setSelectedImage(XFile(imageFile.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 50,
      ),
      ElevatedButton(
          onPressed: () => getImage(context),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(270, 55),
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(15.0),
            ),
          ),
          child: Text(
            'Apply Filter',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18.5),
          )),
    ]);
  }
}
