// ignore_for_file: unused_local_variable, use_build_context_synchronously, avoid_print, non_constant_identifier_names, prefer_const_constructors, depend_on_referenced_packages, prefer_const_literals_to_create_immutables, use_super_parameters

import 'package:kiosk_finder/core/app_routes.dart';
import 'package:kiosk_finder/screens/user%20handel/register/provider/signupprovder.dart';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/Assets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => RegisterScreenstate();
}

class RegisterScreenstate extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    Future<void> AddUser() {
      // Call the user's CollectionReference to add a new user
      return users
          .add({
            "username": context
                .read<RegisterScreenProvider>()
                .state
                .UsernameController
                .text,
            "email": context
                .read<RegisterScreenProvider>()
                .state
                .emailController
                .text,
            "password": context
                .read<RegisterScreenProvider>()
                .state
                .passwordController
                .text,
            "birthday": context
                .read<RegisterScreenProvider>()
                .state
                .birthdayController
                .text,
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Stack(children: [
                  Container(
                    height: 100.h,
                    width: 100.w,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.white, Colors.white])),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
                      child: Column(children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: const Icon(
                                    Iconsax.arrow_left4,
                                    color: Colors.black,
                                  )),
                              Image.asset(
                                Assets.logo,
                                height: 4.h,
                              )
                            ]),
                        Divider(
                          height: 1.h,
                          color: Colors.transparent,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Register",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24.05,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 2.h,
                          color: Colors.transparent,
                        ),
                        SizedBox(
                          width: 100.w,
                          height: 80.h,
                          child: Padding(
                            padding: EdgeInsets.only(left: 5.w, right: 5.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Divider(
                                  color: Colors.transparent,
                                  height: 1.5.h,
                                ),

                                Container(
                                  padding: EdgeInsets.all(1.w),
                                  margin: EdgeInsets.only(bottom: 2.h),
                                  alignment: Alignment.center,
                                  height: 8.h,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          width: 1.sp,
                                          color: context
                                                      .watch<
                                                          RegisterScreenProvider>()
                                                      .state
                                                      .name ==
                                                  null
                                              ? Colors.grey
                                              : context
                                                          .watch<
                                                              RegisterScreenProvider>()
                                                          .state
                                                          .usernameErrorMessage !=
                                                      null
                                                  ? Colors.red
                                                  : Colors.blue)),
                                  child: TextField(
                                    controller: context
                                        .read<RegisterScreenProvider>()
                                        .state
                                        .UsernameController,
                                    onChanged: context
                                        .read<RegisterScreenProvider>()
                                        .nameChange,
                                    onSubmitted: context
                                        .read<RegisterScreenProvider>()
                                        .nameChange,
                                    style: TextStyle(fontSize: 13.sp),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Username",
                                      prefixIcon: const Icon(
                                        Iconsax.user,
                                      ),
                                      prefixIconColor: context
                                                  .watch<
                                                      RegisterScreenProvider>()
                                                  .state
                                                  .email ==
                                              null
                                          ? Colors.grey
                                          : context
                                                      .watch<
                                                          RegisterScreenProvider>()
                                                      .state
                                                      .emailErrorMessage !=
                                                  null
                                              ? Colors.red
                                              : Colors.blue,
                                    ),
                                  ),
                                ),
                                //! email text field
                                Container(
                                  padding: EdgeInsets.all(1.w),
                                  margin: EdgeInsets.only(bottom: 2.h),
                                  alignment: Alignment.center,
                                  height: 8.h,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          width: 1.sp,
                                          color: context
                                                      .watch<
                                                          RegisterScreenProvider>()
                                                      .state
                                                      .email ==
                                                  null
                                              ? Colors.grey
                                              : context
                                                          .watch<
                                                              RegisterScreenProvider>()
                                                          .state
                                                          .emailErrorMessage !=
                                                      null
                                                  ? Colors.red
                                                  : Colors.blue)),
                                  child: TextField(
                                    controller: context
                                        .read<RegisterScreenProvider>()
                                        .state
                                        .emailController,
                                    onChanged: context
                                        .read<RegisterScreenProvider>()
                                        .onEmailChange,
                                    onSubmitted: context
                                        .read<RegisterScreenProvider>()
                                        .onEmailChange,
                                    style: TextStyle(fontSize: 13.sp),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Email",
                                      prefixIcon: const Icon(
                                        Iconsax.sms4,
                                      ),
                                      prefixIconColor: context
                                                  .watch<
                                                      RegisterScreenProvider>()
                                                  .state
                                                  .email ==
                                              null
                                          ? Colors.grey
                                          : context
                                                      .watch<
                                                          RegisterScreenProvider>()
                                                      .state
                                                      .emailErrorMessage !=
                                                  null
                                              ? Colors.red
                                              : Colors.blue,
                                    ),
                                  ),
                                ),
                                //! password text field
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
                                                      .watch<
                                                          RegisterScreenProvider>()
                                                      .state
                                                      .password ==
                                                  null
                                              ? Colors.grey
                                              : context
                                                          .watch<
                                                              RegisterScreenProvider>()
                                                          .state
                                                          .passwordErrorMessage !=
                                                      null
                                                  ? Colors.red
                                                  : Colors.blue)),
                                  child: TextField(
                                    obscureText: context
                                        .watch<RegisterScreenProvider>()
                                        .state
                                        .hidePass,
                                    controller: context
                                        .read<RegisterScreenProvider>()
                                        .state
                                        .passwordController,
                                    onChanged: context
                                        .read<RegisterScreenProvider>()
                                        .onPasswordChange,
                                    onSubmitted: context
                                        .read<RegisterScreenProvider>()
                                        .onPasswordChange,
                                    style: TextStyle(fontSize: 13.sp),
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Password",
                                        prefixIcon: const Icon(
                                          Iconsax.lock,
                                        ),
                                        prefixIconColor: context
                                                    .watch<
                                                        RegisterScreenProvider>()
                                                    .state
                                                    .password ==
                                                null
                                            ? Colors.grey
                                            : context
                                                        .watch<
                                                            RegisterScreenProvider>()
                                                        .state
                                                        .passwordErrorMessage !=
                                                    null
                                                ? Colors.red
                                                : Colors.blue,
                                        suffixIcon: IconButton(
                                          onPressed: () => context
                                              .read<RegisterScreenProvider>()
                                              .showPassword(),
                                          icon: context
                                                      .watch<
                                                          RegisterScreenProvider>()
                                                      .state
                                                      .hidePass ==
                                                  true
                                              ? const Icon(Iconsax.eye_slash4)
                                              : const Icon(Iconsax.eye3),
                                        )),
                                  ),
                                ),
                                //! password error message
                                Text("Password must be at least 8 characters",
                                    style: TextStyle(
                                      fontSize: 9.5.sp,
                                      fontWeight: FontWeight.w400,
                                      color: context
                                                  .watch<
                                                      RegisterScreenProvider>()
                                                  .state
                                                  .password ==
                                              null
                                          ? Colors.grey
                                          : context
                                                      .watch<
                                                          RegisterScreenProvider>()
                                                      .state
                                                      .passwordErrorMessage !=
                                                  null
                                              ? Colors.red
                                              : Colors.blue,
                                    )),
                                Divider(
                                  height: 1.h,
                                  color: Colors.transparent,
                                ),
                                //retype password text field
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
                                                      .watch<
                                                          RegisterScreenProvider>()
                                                      .state
                                                      .Retypepassword ==
                                                  null
                                              ? Colors.grey
                                              : context
                                                          .watch<
                                                              RegisterScreenProvider>()
                                                          .state
                                                          .RetypepasswordErrorMessage !=
                                                      null
                                                  ? Colors.red
                                                  : Colors.blue)),
                                  child: TextField(
                                    obscureText: context
                                        .watch<RegisterScreenProvider>()
                                        .state
                                        .hidePass2,
                                    controller: context
                                        .read<RegisterScreenProvider>()
                                        .state
                                        .RetypepasswordController,
                                    onChanged: context
                                        .read<RegisterScreenProvider>()
                                        .RetypePasswordChange,
                                    onSubmitted: context
                                        .read<RegisterScreenProvider>()
                                        .RetypePasswordChange,
                                    style: TextStyle(fontSize: 13.sp),
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Retype Password",
                                        prefixIcon: const Icon(
                                          Iconsax.lock,
                                        ),
                                        prefixIconColor: context
                                                    .watch<
                                                        RegisterScreenProvider>()
                                                    .state
                                                    .Retypepassword ==
                                                null
                                            ? Colors.grey
                                            : context
                                                        .watch<
                                                            RegisterScreenProvider>()
                                                        .state
                                                        .RetypepasswordErrorMessage !=
                                                    null
                                                ? Colors.red
                                                : Colors.blue,
                                        suffixIcon: IconButton(
                                          onPressed: () => context
                                              .read<RegisterScreenProvider>()
                                              .showPassword2(),
                                          icon: context
                                                      .watch<
                                                          RegisterScreenProvider>()
                                                      .state
                                                      .hidePass2 ==
                                                  true
                                              ? const Icon(Iconsax.eye_slash4)
                                              : const Icon(Iconsax.eye3),
                                        )),
                                  ),
                                ),
                                //! password error message
                                Text(
                                    "Password must be same as the first password",
                                    style: TextStyle(
                                      fontSize: 9.5.sp,
                                      fontWeight: FontWeight.w400,
                                      color: context
                                                  .watch<
                                                      RegisterScreenProvider>()
                                                  .state
                                                  .password ==
                                              context
                                                  .watch<
                                                      RegisterScreenProvider>()
                                                  .state
                                                  .Retypepassword
                                          ? Colors.green
                                          : context
                                                      .watch<
                                                          RegisterScreenProvider>()
                                                      .state
                                                      .RetypepasswordErrorMessage !=
                                                  null
                                              ? Colors.red
                                              : Colors.blue,
                                    )),
                                Divider(
                                  height: 1.h,
                                  color: Colors.transparent,
                                ),
                                //phonr number

                                //birthday
                                Container(
                                  padding: EdgeInsets.all(1.w),
                                  margin: EdgeInsets.only(bottom: 2.h),
                                  alignment: Alignment.center,
                                  height: 8.h,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          width: 1.sp, color: Colors.grey)),
                                  child: TextField(
                                    readOnly: true,
                                    keyboardType: TextInputType.datetime,
                                    controller: context
                                        .read<RegisterScreenProvider>()
                                        .state
                                        .birthdayController,
                                    style: TextStyle(fontSize: 12.sp),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "BirthDay",
                                      suffixIcon: InkWell(
                                        onTap: () async {
                                          context
                                                  .read<RegisterScreenProvider>()
                                                  .state
                                                  .Datetime =
                                              await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(1900),
                                                  lastDate: DateTime.now());
                                          if (context
                                                  .read<
                                                      RegisterScreenProvider>()
                                                  .state
                                                  .Datetime !=
                                              null) {
                                            setState(() {
                                              context
                                                  .read<
                                                      RegisterScreenProvider>()
                                                  .state
                                                  .birthdayController
                                                  .text = DateFormat(
                                                      'yyyy-MM-dd')
                                                  .format(context
                                                          .read<
                                                              RegisterScreenProvider>()
                                                          .state
                                                          .Datetime ??
                                                      DateTime.now());
                                            });
                                          }
                                        },
                                        child: const Icon(
                                          Iconsax.calendar_2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                //! already a user
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Already have an account?",
                                        style: TextStyle(
                                            fontSize: 9.5.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey)),
                                    SizedBox(
                                      width: 1.w,
                                    ),
                                    InkWell(
                                      onTap: () => context
                                          .read<RegisterScreenProvider>()
                                          .navigateToLogin(context),
                                      child: Text("Login",
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
                                //create account button
                                SizedBox(
                                  width: 90.w,
                                  height: 7.h,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      AddUser();
                                      try {
                                        final credential = await FirebaseAuth
                                            .instance
                                            .createUserWithEmailAndPassword(
                                          email: context
                                              .read<RegisterScreenProvider>()
                                              .state
                                              .emailController
                                              .text,
                                          password: context
                                              .read<RegisterScreenProvider>()
                                              .state
                                              .passwordController
                                              .text,
                                        );
                                        FirebaseAuth.instance.currentUser!
                                            .sendEmailVerification();
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                                AppRoutes.congrats,
                                                (route) => false);
                                      } on FirebaseAuthException catch (e) {
                                        if (e.code == 'weak-password') {
                                          print(
                                              'The password provided is too weak.');
                                          AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.error,
                                            animType: AnimType.rightSlide,
                                            title: 'Error',
                                            desc:
                                                'The password provided is too weak.',
                                          ).show();
                                        } else if (e.code ==
                                            'email-already-in-use') {
                                          print(
                                              'The account already exists for that email.');
                                          AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.error,
                                            animType: AnimType.rightSlide,
                                            title: 'Error',
                                            desc:
                                                'The account already exists for that email.',
                                          ).show();
                                        }
                                      } catch (e) {
                                        print(e);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: context
                                                    .read<
                                                        RegisterScreenProvider>()
                                                    .validate() ==
                                                true
                                            ? Colors.blue
                                            : Colors.grey,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    child: Text(
                                      "Register",
                                      style: TextStyle(
                                          color: context
                                                      .read<
                                                          RegisterScreenProvider>()
                                                      .validate() ==
                                                  true
                                              ? Colors.white
                                              : Colors.white,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ]))
                ]))));
  }
}
