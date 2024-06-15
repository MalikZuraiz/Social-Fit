// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class NavHome extends StatefulWidget {
  int selectedIndex = 0;
  void Function(int) onTap;

  NavHome({super.key, required this.selectedIndex, required this.onTap});

  @override
  _NavHomeState createState() => _NavHomeState();
}

class _NavHomeState extends State<NavHome> with TickerProviderStateMixin {
  final iconList = <IconData>[
    Icons.food_bank_rounded,
    Icons.water_drop_rounded,   
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedBottomNavigationBar(
      gapLocation: GapLocation.none,
      leftCornerRadius: 32,
      rightCornerRadius: 32,
      icons: iconList,
      activeColor: Colors.white,
      inactiveColor: Colors.grey,
      backgroundColor: const Color.fromARGB(255, 109, 117, 218),
      activeIndex: widget.selectedIndex,
      onTap: (index) => widget.onTap(index),
    );
  }
}
