// ignore_for_file: constant_identifier_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kiosk_finder/screens/home/home_main.dart';
import 'package:kiosk_finder/screens/splash/splash.dart';
import 'package:kiosk_finder/screens/user%20handel/login/login.dart';
import 'package:kiosk_finder/screens/user%20handel/register/components/congrats.dart';
import 'package:kiosk_finder/screens/user%20handel/register/register.dart';

class AppRoutes {
  static const String splash = "/";
  //OnBoarding
  static const String login = "login";
  static const String register = "register";
  static const String congrats = "congrats";
  static const String home = "home";

  static Route<dynamic> onGenerateRoute(RouteSettings setting) {
    switch (setting.name) {
      case splash:
        return MaterialPageRoute(
          builder: (context) {
            return const SpalshScreen();
          },
        );
      case login:
        return MaterialPageRoute(
          builder: (context) {
            return const LoginScreen();
          },
        );
      case register:
        return MaterialPageRoute(
          builder: (context) {
            return const RegisterScreen();
          },
        );
      case congrats:
        return MaterialPageRoute(
          builder: (context) {
            return const CongratsScreen();
          },
        );
      case home:
        return MaterialPageRoute(
          builder: (context) {
            return Home();
          },
        );
      default:
        return MaterialPageRoute(
          builder: (context) {
            return Scaffold(
              body: Center(
                child: Text("No route defined for ${setting.name}"),
              ),
            );
          },
        );
    }
  }
}
