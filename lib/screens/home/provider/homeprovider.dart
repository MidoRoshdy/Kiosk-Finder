// ignore_for_file: constant_pattern_never_matches_value_type, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kiosk_finder/core/enum.dart';
import 'package:kiosk_finder/screens/home/components/favorites.dart';
import 'package:kiosk_finder/screens/home/components/home.dart';
import 'package:kiosk_finder/screens/home/components/profile/profile.dart';

import 'homestate.dart';

class HomeProvider extends ChangeNotifier {
  void init() {
    notifyListeners();
  }

  // ignore: unused_field
  final HomeState state = HomeState();

  void onNavigationTap(int value) {
    switch (value) {
      case 0:
        state.chosenNavigationItem = ChosenNavigationItem.home;
        break;
      case 1:
        state.chosenNavigationItem = ChosenNavigationItem.favorites;
        break;
      case 2:
        state.chosenNavigationItem = ChosenNavigationItem.profile;
        break;
    }
    notifyListeners();
  }

  Widget chosenPage() {
    switch (state.chosenNavigationItem) {
      case ChosenNavigationItem.home:
        return HomeScreen();
      case ChosenNavigationItem.favorites:
        return FavoritesScreen();

      case ChosenNavigationItem.profile:
        return ProfileScreen();
      default:
        return const SizedBox();
    }
  }

  void returnHome() {
    state.chosenNavigationItem = ChosenNavigationItem.home;
    state.navigationIndex = 0;
    notifyListeners();
  }
}
