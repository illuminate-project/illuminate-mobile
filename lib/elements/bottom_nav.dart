import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  final Function changeScreen;
  final int selectedScreen;
  const BottomNav({
    super.key,
    required this.selectedScreen,
    required this.changeScreen,
  });

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color.fromARGB(255, 31, 31, 31),
      selectedItemColor: const Color.fromARGB(255, 227, 174, 111),
      unselectedItemColor:
          const Color.fromARGB(255, 131, 131, 131).withOpacity(.75),
      selectedFontSize: 12,
      unselectedFontSize: 12,
      onTap: (value) {
        widget.changeScreen(value);
      },
      items: const [
        BottomNavigationBarItem(
          label: 'Light',
          icon: Icon(CupertinoIcons.lightbulb_fill),
        ),
        BottomNavigationBarItem(
          label: 'Ambience',
          icon: Icon(CupertinoIcons.light_max),
        ),
        // BottomNavigationBarItem(
        //   label: 'Background',
        //   icon: Icon(Icons.filter),
        // ),
        /*BottomNavigationBarItem(
          label: 'Filter',
          icon: Icon(Icons.filter_b_and_w),
        ),*/
      ],
      currentIndex: widget.selectedScreen,
    );
  }
}
