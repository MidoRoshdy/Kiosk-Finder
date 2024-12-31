// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kiosk_finder/screens/home/provider/homeprovider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBar();
}

class _BottomNavBar extends State<BottomNavBar> {
  int _currIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: context.watch<HomeProvider>().chosenPage(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 20.sp,
        selectedFontSize: 9.5.sp,
        unselectedFontSize: 9.5.sp,
        selectedIconTheme: IconThemeData(color: Colors.blue),
        selectedItemColor: Colors.blue,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        unselectedIconTheme: IconThemeData(color: Colors.grey),
        unselectedItemColor: Colors.grey,
        enableFeedback: false,
        backgroundColor: Colors.white,
        currentIndex: _currIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Iconsax.home4),
              activeIcon: Icon(Iconsax.home_15),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Iconsax.heart),
              activeIcon: Icon(Iconsax.heart4),
              label: "Favorites"),
          BottomNavigationBarItem(
              icon: Icon(Iconsax.frame_1),
              activeIcon: Icon(Iconsax.frame5),
              label: "Profile")
        ],
        onTap: (value) {
          setState(() {
            _currIndex = value;
            context.read<HomeProvider>().onNavigationTap(value);
          });
        },
      ),
    );
  }
}
