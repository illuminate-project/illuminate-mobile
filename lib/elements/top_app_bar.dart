import 'package:flutter/material.dart';

class TopAppBar extends StatefulWidget with PreferredSizeWidget {
  final Function changePicture;
  const TopAppBar(
    this.changePicture, {
    super.key,
  });

  @override
  State<TopAppBar> createState() => _TopAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TopAppBarState extends State<TopAppBar> {
  void doNothing() {}

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 31, 31, 31),
      title: ButtonBar(
        alignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.dangerous_outlined),
            color: const Color.fromARGB(255, 255, 140, 140),
            onPressed: () => widget.changePicture(null),
          ),
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: () => doNothing(),
          ),
          IconButton(
            icon: const Icon(Icons.redo),
            color: const Color.fromARGB(255, 144, 144, 144),
            onPressed: () => doNothing(),
          ),
          IconButton(
              icon: const Icon(Icons.remove_red_eye_outlined),
              onPressed: () => doNothing()),
          IconButton(
            icon: const Icon(Icons.check_circle_outline),
            color: const Color.fromARGB(255, 227, 174, 111),
            onPressed: () => doNothing(),
          )
        ],
      ),
    );
  }
}
