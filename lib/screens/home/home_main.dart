// ignore_for_file: must_be_immutable, unused_field, prefer_const_constructors, sized_box_for_whitespace, prefer_final_fields
import 'package:flutter/material.dart';
import 'package:kiosk_finder/screens/home/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:kiosk_finder/screens/home/provider/homeprovider.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: context.watch<HomeProvider>().chosenPage(),
        bottomNavigationBar: const BottomNavBar());
  }
}
