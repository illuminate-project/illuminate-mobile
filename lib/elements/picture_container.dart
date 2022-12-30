import 'package:flutter/material.dart';

class PictureContainer extends StatefulWidget with PreferredSizeWidget {
  const PictureContainer({super.key});

  @override
  State<PictureContainer> createState() => _PictureContainerState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _PictureContainerState extends State<PictureContainer> {
  void doNothing() {}

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        margin: const EdgeInsets.only(
            left: 30.0, right: 30.0, top: 30.0, bottom: 125.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(217, 217, 217, 217),
          border: Border.all(
            width: 2.5,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.add_photo_alternate_outlined),
              iconSize: 100,
              onPressed: () => doNothing(),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Add Image',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            )
          ],
        ));
  }
}
