import 'package:flutter/material.dart';
import 'package:kiosk_finder/screens/user%20handel/login/provider/loginstate.dart';

class LoginProvider extends ChangeNotifier {
  // ignore: unused_field
  final LoginState state = LoginState();

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

  void onUsernameChange(String value) {
    value.isEmpty
        ? state.usernameErrorMessage = "You must enter a username"
        : state.usernameErrorMessage = null;
    state.email = value;
    notifyListeners();
  }

  void showPassword() {
    state.hidePass == true ? state.hidePass = false : state.hidePass = true;
    notifyListeners();
  }

  bool validate() {
    if (state.passwordErrorMessage == null &&
        state.usernameErrorMessage == null &&
        state.password != null &&
        state.email != null) {
      return true;
    } else {
      return false;
    }
  }

  void onChangeRememberMe(bool? value) async {
    state.rememberMe = value!;

    notifyListeners();
  }
}
