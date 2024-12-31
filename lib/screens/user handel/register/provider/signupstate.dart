// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterScreenState {
  //! vars
  String? name;
  String? email;
  String? password;
  String? Retypepassword;
  String? birthday = "0000-00-00";
  DateTime? Datetime;

  //! controllers

  TextEditingController UsernameController = TextEditingController();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController RetypepasswordController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();

  //! errors
  String? usernameErrorMessage;
  String? emailErrorMessage;
  String? passwordErrorMessage;
  String? RetypepasswordErrorMessage;
  String? birthdayErrorMessage;

  //! bools
  bool hidePass = true;
  bool hidePass2 = true;
}
