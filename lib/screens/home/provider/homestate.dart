// ignore_for_file: non_constant_identifier_names

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kiosk_finder/core/enum.dart';
import 'package:location/location.dart';

class HomeState {
  ChosenNavigationItem chosenNavigationItem = ChosenNavigationItem.home;
  int navigationIndex = 0;
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  Set<Marker> markerscairo = {};
  Set<Marker> markersgiza = {};
  List<Map<String, dynamic>> kioskData = []; // To store all kiosk data
  List<Map<String, dynamic>> kioskDataCairo = [];
  List<Map<String, dynamic>> kioskDataGiza = [];
  Location location = Location();
  LatLng? initialLocation;
  LoadingState loadingState = LoadingState.initial;
}
