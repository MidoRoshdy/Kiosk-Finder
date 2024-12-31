// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:kiosk_finder/core/Assets.dart';
import 'package:kiosk_finder/core/app_routes.dart';
import 'package:sizer/sizer.dart';

class SpalshScreen extends StatelessWidget {
  const SpalshScreen({super.key});

  @override
  Widget build(BuildContext context) {
    handleData(context);
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          Container(
            width: 100.w,
            height: 100.h,
            color: Colors.white,
          ),
          Center(
            child: Column(
              children: [
                Spacer(),
                Image.asset(Assets.logo),
                Text(
                  "Kiosk Finder",
                  style:
                      TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                ),
                Spacer(),
              ],
            ),
          )
        ],
      ),
    ));
  }

  Future<void> handleData(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.of(context)
        .pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
  }
}
