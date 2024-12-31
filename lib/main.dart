// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kiosk_finder/core/app_routes.dart';
import 'package:kiosk_finder/screens/home/provider/homeprovider.dart';
import 'package:kiosk_finder/screens/splash/provider/splashprovider.dart';
import 'package:kiosk_finder/screens/user%20handel/login/provider/loginprovider.dart';
import 'package:kiosk_finder/screens/user%20handel/register/provider/signupprovder.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, DeviceType deviceType) {
      print(orientation);
      return MultiProvider(
        providers: [
          ListenableProvider<SplashProvider>(create: (_) => SplashProvider()),
          ListenableProvider<LoginProvider>(create: (_) => LoginProvider()),
          ListenableProvider<RegisterScreenProvider>(
              create: (_) => RegisterScreenProvider()),
          ListenableProvider<HomeProvider>(create: (_) => HomeProvider()),
        ],
        child: MaterialApp(
          title: "Kiosk Finder",
          initialRoute: AppRoutes.splash,
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          onGenerateRoute: AppRoutes.onGenerateRoute,
        ),
      );
    });
  }
}
