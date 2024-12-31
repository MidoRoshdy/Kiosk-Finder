// ignore_for_file: non_constant_identifier_names

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:kiosk_finder/core/app_routes.dart';
import 'package:kiosk_finder/screens/user%20handel/register/provider/signupstate.dart';

class RegisterScreenProvider extends ChangeNotifier {
  // ignore: unused_field
  final RegisterScreenState state = RegisterScreenState();

  void onEmailChange(String value) {
    value.isEmpty
        ? state.emailErrorMessage = "You must enter a mail"
        : EmailValidator.validate(value)
            ? state.emailErrorMessage = null
            : state.emailErrorMessage = "Enter a valid mail";
    state.email = value;
    notifyListeners();
  }

  void onPasswordChange(String value) {
    value.isEmpty
        ? state.passwordErrorMessage = "You must enter a password"
        : value.length < 8
            ? state.passwordErrorMessage =
                "Password must be at least 8 characters"
            : state.passwordErrorMessage = null;
    state.password = value;
    notifyListeners();
  }

  void RetypePasswordChange(String value) {
    value != state.password
        ? state.RetypepasswordErrorMessage = "You must enter a same  password"
        : state.RetypepasswordErrorMessage = null;
    state.Retypepassword = value;
    notifyListeners();
  }

  void nameChange(String value) {
    value.isEmpty
        ? state.usernameErrorMessage = "You must enter a Username"
        : state.usernameErrorMessage = null;
    state.name = value;
    notifyListeners();
  }

  void birthdayChange(String value) {
    value.isEmpty
        ? state.birthdayErrorMessage = "You must enter a birthday"
        : state.birthdayErrorMessage = null;
    state.name = value;
    notifyListeners();
  }

  void genderChange(String value) {
    value.isEmpty
        ? state.birthdayErrorMessage = "You must enter a birthday"
        : state.birthdayErrorMessage = null;
    state.name = value;
    notifyListeners();
  }

  void showPassword() {
    state.hidePass == true ? state.hidePass = false : state.hidePass = true;
    notifyListeners();
  }

  void showPassword2() {
    state.hidePass2 == true ? state.hidePass2 = false : state.hidePass2 = true;
    notifyListeners();
  }

  navigateToLogin(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(AppRoutes.login);
  }

  bool validate() {
    if (state.emailErrorMessage == null &&
        state.passwordErrorMessage == null &&
        state.RetypepasswordErrorMessage == null &&
        state.email != null &&
        state.password != null &&
        state.Retypepassword != null &&
        state.password == state.Retypepassword) {
      return true;
    } else {
      return false;
    }
  }
}
