import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
        _onItemTapped(value);
      },
      items: const [
        BottomNavigationBarItem(
          label: 'Light',
          icon: Icon(Icons.lightbulb_outlined),
        ),
        BottomNavigationBarItem(
          label: 'Ambience',
          icon: Icon(Icons.wb_sunny_outlined),
        ),
        BottomNavigationBarItem(
          label: 'Background',
          icon: Icon(Icons.filter),
        ),
        BottomNavigationBarItem(
          label: 'Filter',
          icon: Icon(Icons.filter_b_and_w),
        ),
      ],
      currentIndex: _selectedIndex,
    );
  }
}
