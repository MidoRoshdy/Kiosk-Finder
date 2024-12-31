// ignore_for_file: avoid_print, unused_local_variable, use_build_context_synchronously, dead_code, prefer_const_constructors, deprecated_member_use

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kiosk_finder/core/app_routes.dart';
import 'package:kiosk_finder/screens/user%20handel/login/provider/loginprovider.dart';

import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/Assets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: 100.w,
              height: 100.h,
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 8),
              child: Column(
                children: [
                  Divider(
                    height: 1.h,
                    color: Colors.transparent,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700),
                        ),
                        Spacer(),
                        Image.asset(
                          Assets.logo,
                          height: 5.h,
                        )
                      ],
                    ),
                  ),
                  Divider(
                    height: 10.h,
                    color: Colors.transparent,
                  ),
                  SizedBox(
                    width: 100.w,
                    height: 74.h,
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: 5.w, right: 5.w, bottom: 2.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(
                            color: Colors.transparent,
                            height: 1.5.h,
                          ),
                          ////////////////////////////////// email////////////////////////////////////////////////////
                          Container(
                            padding: EdgeInsets.all(1.w),
                            margin: EdgeInsets.only(top: 3.5.h, bottom: 2.h),
                            alignment: Alignment.center,
                            height: 8.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    width: 1.sp,
                                    color: context
                                                .watch<LoginProvider>()
                                                .state
                                                .email ==
                                            null
                                        ? Colors.grey
                                        : context
                                                    .watch<LoginProvider>()
                                                    .state
                                                    .usernameErrorMessage !=
                                                null
                                            ? Colors.red
                                            : Colors.blue)),
                            child: TextField(
                              controller: context
                                  .read<LoginProvider>()
                                  .state
                                  .emailController,
                              onChanged: context
                                  .read<LoginProvider>()
                                  .onUsernameChange,
                              onSubmitted: context
                                  .read<LoginProvider>()
                                  .onUsernameChange,
                              style: TextStyle(fontSize: 14.sp),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Email",
                                prefixIcon: const Icon(Iconsax.sms),
                                prefixIconColor: context
                                            .watch<LoginProvider>()
                                            .state
                                            .email ==
                                        null
                                    ? Colors.grey
                                    : context
                                                .watch<LoginProvider>()
                                                .state
                                                .usernameErrorMessage !=
                                            null
                                        ? Colors.red
                                        : Colors.blue,
                              ),
                            ),
                          ),
                          /////////////////////////////////////////////////// password////////////////////////////////
                          Container(
                            padding: EdgeInsets.all(1.w),
                            margin: EdgeInsets.only(bottom: 2.h),
                            alignment: Alignment.center,
                            height: 8.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    width: 1.sp,
                                    color: context
                                                .watch<LoginProvider>()
                                                .state
                                                .password ==
                                            null
                                        ? Colors.grey
                                        : context
                                                    .watch<LoginProvider>()
                                                    .state
                                                    .passwordErrorMessage !=
                                                null
                                            ? Colors.red
                                            : Colors.blue)),
                            child: TextField(
                              obscureText:
                                  context.watch<LoginProvider>().state.hidePass,
                              controller: context
                                  .read<LoginProvider>()
                                  .state
                                  .passwordController,
                              onChanged: context
                                  .read<LoginProvider>()
                                  .onPasswordChange,
                              onSubmitted: context
                                  .read<LoginProvider>()
                                  .onPasswordChange,
                              style: TextStyle(fontSize: 14.sp),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Password",
                                  prefixIcon: const Icon(
                                    Iconsax.lock,
                                  ),
                                  prefixIconColor: context
                                              .watch<LoginProvider>()
                                              .state
                                              .password ==
                                          null
                                      ? Colors.grey
                                      : context
                                                  .watch<LoginProvider>()
                                                  .state
                                                  .passwordErrorMessage !=
                                              null
                                          ? Colors.red
                                          : Colors.blue,
                                  suffixIcon: IconButton(
                                    onPressed: () => context
                                        .read<LoginProvider>()
                                        .showPassword(),
                                    icon: context
                                                .watch<LoginProvider>()
                                                .state
                                                .hidePass ==
                                            true
                                        ? const Icon(Iconsax.eye_slash4)
                                        : const Icon(Iconsax.eye3),
                                  )),
                            ),
                          ),
                          /////////////////////////////////////////////////Checkbox////////////////////////////
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                  child: Row(
                                children: [
                                  Checkbox(
                                      checkColor: Colors.white,
                                      fillColor: MaterialStateColor.resolveWith(
                                          (states) {
                                        return context
                                                .watch<LoginProvider>()
                                                .state
                                                .rememberMe
                                            ? Colors.blue
                                            : Colors.white;
                                      }),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      value: context
                                          .watch<LoginProvider>()
                                          .state
                                          .rememberMe,
                                      onChanged: context
                                          .read<LoginProvider>()
                                          .onChangeRememberMe),
                                  Text("Remember me",
                                      style: TextStyle(
                                          fontSize: 9.sp,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w400))
                                ],
                              )),
                              InkWell(
                                onTap: () {
                                  // Navigator.of(context)
                                  //     .pushNamed(AppRoutes.Parents_forgetPassword);
                                },
                                child: Text("Forgot password?",
                                    style: TextStyle(
                                        fontSize: 9.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.blue.withOpacity(0.8))),
                              )
                            ],
                          ),

                          const Spacer(),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't have an account?",
                                  style: TextStyle(
                                      fontSize: 9.5.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey)),
                              SizedBox(
                                width: 1.w,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(AppRoutes.register);
                                },
                                child: Text("Register",
                                    style: TextStyle(
                                        fontSize: 9.5.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.blue)),
                              )
                            ],
                          ),
                          Divider(
                            color: Colors.transparent,
                            height: 2.h,
                          ),
                          ///////////////////////////////////////////login button////////////////////////////////////
                          SizedBox(
                            width: 90.w,
                            height: 7.h,
                            child: ElevatedButton(
                              onPressed: () async {
                                String email = context
                                    .read<LoginProvider>()
                                    .state
                                    .emailController
                                    .text;
                                String password = context
                                    .read<LoginProvider>()
                                    .state
                                    .passwordController
                                    .text;

                                try {
                                  final credential = await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                    email: email,
                                    password: password,
                                  );

                                  if (credential.user!.emailVerified) {
                                    // Query the Firestore collection to check for matching email and password
                                    QuerySnapshot<Map<String, dynamic>>
                                        querySnapshot = await FirebaseFirestore
                                            .instance
                                            .collection('users')
                                            .where('email', isEqualTo: email)
                                            .where('password',
                                                isEqualTo: password)
                                            .get();

                                    if (querySnapshot.docs.isNotEmpty) {
                                      // Add UID to each document in the query result
                                      for (var doc in querySnapshot.docs) {
                                        await doc.reference.update(
                                            {'uid': credential.user!.uid});
                                      }

                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                        AppRoutes.home,
                                        (route) => false,
                                      );
                                    } else {
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.warning,
                                        animType: AnimType.rightSlide,
                                        title: 'Error',
                                        desc: 'Email or password is incorrect.',
                                      ).show();
                                    }
                                  } else {
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.warning,
                                      animType: AnimType.rightSlide,
                                      title: 'Error',
                                      desc: 'Email is not verified.',
                                    ).show();
                                  }
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'user-not-found' ||
                                      e.code == 'wrong-password') {
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.error,
                                      animType: AnimType.rightSlide,
                                      title: 'Error',
                                      desc: 'Invalid email or password.',
                                    ).show();
                                  } else {
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.error,
                                      animType: AnimType.rightSlide,
                                      title: 'Error',
                                      desc:
                                          'An error occurred. Please try again later.',
                                    ).show();
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    context.read<LoginProvider>().validate() ==
                                            true
                                        ? Colors.blue
                                        : Colors.grey.withOpacity(0.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  color: context
                                              .read<LoginProvider>()
                                              .validate() ==
                                          true
                                      ? Colors.white
                                      : Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
