// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:kiosk_finder/core/app_routes.dart';
import 'package:sizer/sizer.dart';

class CongratsScreen extends StatelessWidget {
  const CongratsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    handleData(context);
    return Scaffold(
        body: SafeArea(
      child: Column(children: [
        Divider(
          height: 20.h,
          color: Colors.transparent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("congratiolations!",
                style: TextStyle(
                    fontSize: 23.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("You have been Registered",
                style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w400)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("successfuly",
                style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w400)),
          ],
        ),
        Divider(
          height: 5.h,
          color: Colors.transparent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100.sp,
              height: 100.0.sp,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check, color: Colors.white, size: 50.0),
            )
          ],
        ),
      ]),
    ));
  }

  Future<void> handleData(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));

    Navigator.of(context)
        .pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
  }
}
