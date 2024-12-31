// ignore_for_file: use_build_context_synchronously, avoid_print, prefer_const_constructors, unused_element, prefer_const_literals_to_create_immutables, prefer_final_fields, prefer_const_declarations

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kiosk_finder/screens/home/components/edit_kiosk.dart';
import 'package:kiosk_finder/screens/home/provider/homeprovider.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    await fetchUserLocation();
    await fetchMarkers();
    await fetchMarkersCairo();
    await fetchMarkersGiza();
  }

  Future<void> fetchUserLocation() async {
    try {
      bool serviceEnabled =
          await context.read<HomeProvider>().state.location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled =
            await context.read<HomeProvider>().state.location.requestService();
        if (!serviceEnabled) {
          print('Location services are disabled.');
          return;
        }
      }

      PermissionStatus permissionGranted =
          await context.read<HomeProvider>().state.location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await context
            .read<HomeProvider>()
            .state
            .location
            .requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          print('Location permission denied.');
          return;
        }
      }

      // Get user's location
      LocationData userLocation =
          await context.read<HomeProvider>().state.location.getLocation();
      setState(() {
        context.read<HomeProvider>().state.initialLocation =
            LatLng(userLocation.latitude!, userLocation.longitude!);
      });

      // Add marker for user's location
      Marker userLocationMarker = Marker(
        markerId: MarkerId('user_location'),
        position: context.read<HomeProvider>().state.initialLocation!,
        infoWindow: InfoWindow(title: 'Your Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure), // Optionally customize marker icon
      );

      // Update the markers with the user location
      setState(() {
        context.read<HomeProvider>().state.markers.add(userLocationMarker);
      });

      print(
          'User location: ${userLocation.latitude}, ${userLocation.longitude}');
    } catch (e) {
      print('Error fetching user location: $e');
    }
  }

  Future<void> fetchMarkers() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('kiosks').get();

      setState(() {
        context.read<HomeProvider>().state.kioskData = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            'id': doc.id,
            'name': data['name'],
            'address': data['address'],
            'city': data['city'].toString().toLowerCase(),
            'lat': data['lat'],
            'lng': data['lng'],
            'image': data['image'],
            'isFavorite': false, // Initially, mark all kiosks as not favorited
          };
        }).toList();

        _updateMarkers(context.read<HomeProvider>().state.kioskData);
      });
    } catch (e) {
      print('Error fetching markers: $e');
    }
  }

  Future<void> fetchMarkersCairo() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('kiosks')
          .where('city', isEqualTo: 'Cairo')
          .get();

      setState(() {
        context.read<HomeProvider>().state.kioskDataCairo =
            snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            'id': doc.id,
            'name': data['name'],
            'address': data['address'],
            'city': data['city'].toString().toLowerCase(),
            'lat': data['lat'],
            'lng': data['lng'],
            'image': data['image'],
            'isFavorite': false, // Initially, mark all kiosks as not favorited
          };
        }).toList();

        _updateMarkerscairo(context.read<HomeProvider>().state.kioskDataCairo);
      });
    } catch (e) {
      print('Error fetching markers: $e');
    }
  }

  Future<void> fetchMarkersGiza() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('kiosks')
          .where('city', isEqualTo: 'Giza')
          .get();

      setState(() {
        context.read<HomeProvider>().state.kioskDataGiza =
            snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            'id': doc.id,
            'name': data['name'],
            'address': data['address'],
            'city': data['city'].toString().toLowerCase(),
            'lat': data['lat'],
            'lng': data['lng'],
            'image': data['image'],
            'isFavorite': false, // Initially, mark all kiosks as not favorited
          };
        }).toList();

        _updateMarkersgiza(context.read<HomeProvider>().state.kioskDataGiza);
      });
    } catch (e) {
      print('Error fetching markers: $e');
    }
  }

  void _updateMarkers(List<Map<String, dynamic>> kiosks) async {
    setState(() {
      context.read<HomeProvider>().state.markers = kiosks.map((kiosk) {
        return Marker(
          markerId: MarkerId(kiosk['id']),
          position: LatLng(kiosk['lat'], kiosk['lng']),
          onTap: () async {
            // Check if the kiosk is in the user's favorites collection
            final userId = 'userId'; // Replace with actual user ID

            bool isFavorite = false;
            try {
              final userFavoritesRef = FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .collection('favorites');

              final docSnapshot = await userFavoritesRef.doc(kiosk['id']).get();
              isFavorite =
                  docSnapshot.exists; // Check if the kiosk exists in favorites
            } catch (e) {
              print('Error checking favorite status: $e');
            }

            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          kiosk['image'],
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Kiosk Name: ${kiosk['name']}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2.sp),
                      Text(
                        "Address: ${kiosk['address']}",
                        style: TextStyle(fontSize: 14),
                      ),
                      Divider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () async {
                              bool? isUpdated = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditKioskScreen(
                                    kioskData: kiosk,
                                  ),
                                ),
                              );
                              if (isUpdated == true) {
                                fetchMarkers();
                              }
                            },
                            child: Container(
                              height: 6.h,
                              width: 30.w,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Iconsax.edit,
                                      size: 15.sp,
                                      color: Colors.white,
                                    ),
                                    VerticalDivider(
                                      color: Colors.transparent,
                                      width: 2.sp,
                                    ),
                                    Text(
                                      "Edit Data",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              _updateFavoriteStatus(kiosk, isFavorite);
                            },
                            child: Container(
                              height: 6.h,
                              width: 30.w,
                              decoration: BoxDecoration(
                                color: isFavorite ? Colors.red : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Iconsax.heart,
                                    size: 10.sp,
                                    color:
                                        isFavorite ? Colors.white : Colors.red,
                                  ),
                                  VerticalDivider(
                                    color: Colors.transparent,
                                    width: 2.sp,
                                  ),
                                  Text(
                                    "Favorites",
                                    style: TextStyle(
                                      color: isFavorite
                                          ? Colors.white
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                              onTap: () async {
                                final destinationLat = kiosk['lat'];
                                final destinationLng = kiosk['lng'];
                                final googleMapsUrl =
                                    'https://www.google.com/maps/dir/?api=1&destination=$destinationLat,$destinationLng';
                                if (await canLaunchUrl(
                                    Uri.parse(googleMapsUrl))) {
                                  await launchUrl(Uri.parse(googleMapsUrl),
                                      mode: LaunchMode.externalApplication);
                                } else {
                                  print('Could not open Google Maps.');
                                }
                              },
                              child: Container(
                                height: 6.h,
                                width: 30.w,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Iconsax.location, color: Colors.white),
                                    VerticalDivider(
                                      color: Colors.transparent,
                                      width: 2.sp,
                                    ),
                                    Text(
                                      "Directions",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              ))
                        ],
                      )
                    ],
                  ),
                );
              },
            );
          },
        );
      }).toSet();
    });
  }

  void _updateMarkerscairo(List<Map<String, dynamic>> kiosksCairo) async {
    setState(() {
      context.read<HomeProvider>().state.markerscairo =
          kiosksCairo.map((kiosksCairo) {
        return Marker(
          markerId: MarkerId(kiosksCairo['id']),
          position: LatLng(kiosksCairo['lat'], kiosksCairo['lng']),
          onTap: () async {
            // Check if the kiosk is in the user's favorites collection
            final userId = 'userId'; // Replace with actual user ID

            bool isFavorite = false;
            try {
              final userFavoritesRef = FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .collection('favorites');

              final docSnapshot =
                  await userFavoritesRef.doc(kiosksCairo['id']).get();
              isFavorite =
                  docSnapshot.exists; // Check if the kiosk exists in favorites
            } catch (e) {
              print('Error checking favorite status: $e');
            }
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          kiosksCairo['image'],
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Kiosk Name: ${kiosksCairo['name']}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2.sp),
                      Text(
                        "Address: ${kiosksCairo['address']}",
                        style: TextStyle(fontSize: 14),
                      ),
                      Divider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () async {
                              bool? isUpdated = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditKioskScreen(
                                    kioskData: kiosksCairo,
                                  ),
                                ),
                              );
                              if (isUpdated == true) {
                                fetchMarkers();
                              }
                            },
                            child: Container(
                              height: 6.h,
                              width: 30.w,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Iconsax.edit,
                                      size: 15.sp,
                                      color: Colors.white,
                                    ),
                                    VerticalDivider(
                                      color: Colors.transparent,
                                      width: 2.sp,
                                    ),
                                    Text(
                                      "Edit Data",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              _updateFavoriteStatus(kiosksCairo, isFavorite);
                            },
                            child: Container(
                              height: 6.h,
                              width: 30.w,
                              decoration: BoxDecoration(
                                color: isFavorite ? Colors.red : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Iconsax.heart,
                                    size: 10.sp,
                                    color:
                                        isFavorite ? Colors.white : Colors.red,
                                  ),
                                  VerticalDivider(
                                    color: Colors.transparent,
                                    width: 2.sp,
                                  ),
                                  Text(
                                    "Favorites",
                                    style: TextStyle(
                                      color: isFavorite
                                          ? Colors.white
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                              onTap: () async {
                                final destinationLat = kiosksCairo['lat'];
                                final destinationLng = kiosksCairo['lng'];
                                final googleMapsUrl =
                                    'https://www.google.com/maps/dir/?api=1&destination=$destinationLat,$destinationLng';
                                if (await canLaunchUrl(
                                    Uri.parse(googleMapsUrl))) {
                                  await launchUrl(Uri.parse(googleMapsUrl),
                                      mode: LaunchMode.externalApplication);
                                } else {
                                  print('Could not open Google Maps.');
                                }
                              },
                              child: Container(
                                height: 6.h,
                                width: 30.w,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Iconsax.location, color: Colors.white),
                                    VerticalDivider(
                                      color: Colors.transparent,
                                      width: 2.sp,
                                    ),
                                    Text(
                                      "Directions",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              ))
                        ],
                      )
                    ],
                  ),
                );
              },
            );
          },
        );
      }).toSet();
    });
  }

  void _updateMarkersgiza(List<Map<String, dynamic>> kiosksgiza) async {
    setState(() {
      context.read<HomeProvider>().state.markersgiza =
          kiosksgiza.map((kiosksgiza) {
        return Marker(
          markerId: MarkerId(kiosksgiza['id']),
          position: LatLng(kiosksgiza['lat'], kiosksgiza['lng']),
          onTap: () async {
            // Check if the kiosk is in the user's favorites collection
            final userId = 'userId'; // Replace with actual user ID

            bool isFavorite = false;
            try {
              final userFavoritesRef = FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .collection('favorites');

              final docSnapshot =
                  await userFavoritesRef.doc(kiosksgiza['id']).get();
              isFavorite =
                  docSnapshot.exists; // Check if the kiosk exists in favorites
            } catch (e) {
              print('Error checking favorite status: $e');
            }

            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          kiosksgiza['image'],
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Kiosk Name: ${kiosksgiza['name']}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2.sp),
                      Text(
                        "Address: ${kiosksgiza['address']}",
                        style: TextStyle(fontSize: 14),
                      ),
                      Divider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () async {
                              bool? isUpdated = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditKioskScreen(
                                    kioskData: kiosksgiza,
                                  ),
                                ),
                              );
                              if (isUpdated == true) {
                                fetchMarkers();
                              }
                            },
                            child: Container(
                              height: 6.h,
                              width: 30.w,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Iconsax.edit,
                                      size: 15.sp,
                                      color: Colors.white,
                                    ),
                                    VerticalDivider(
                                      color: Colors.transparent,
                                      width: 2.sp,
                                    ),
                                    Text(
                                      "Edit Data",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              _updateFavoriteStatus(kiosksgiza, isFavorite);
                            },
                            child: Container(
                              height: 6.h,
                              width: 30.w,
                              decoration: BoxDecoration(
                                color: isFavorite ? Colors.red : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Iconsax.heart,
                                    size: 10.sp,
                                    color:
                                        isFavorite ? Colors.white : Colors.red,
                                  ),
                                  VerticalDivider(
                                    color: Colors.transparent,
                                    width: 2.sp,
                                  ),
                                  Text(
                                    "Favorites",
                                    style: TextStyle(
                                      color: isFavorite
                                          ? Colors.white
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                              onTap: () async {
                                final destinationLat = kiosksgiza['lat'];
                                final destinationLng = kiosksgiza['lng'];
                                final googleMapsUrl =
                                    'https://www.google.com/maps/dir/?api=1&destination=$destinationLat,$destinationLng';
                                if (await canLaunchUrl(
                                    Uri.parse(googleMapsUrl))) {
                                  await launchUrl(Uri.parse(googleMapsUrl),
                                      mode: LaunchMode.externalApplication);
                                } else {
                                  print('Could not open Google Maps.');
                                }
                              },
                              child: Container(
                                height: 6.h,
                                width: 30.w,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Iconsax.location, color: Colors.white),
                                    VerticalDivider(
                                      color: Colors.transparent,
                                      width: 2.sp,
                                    ),
                                    Text(
                                      "Directions",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              ))
                        ],
                      )
                    ],
                  ),
                );
              },
            );
          },
        );
      }).toSet();
    });
  }

  void _updateFavoriteStatus(
      Map<String, dynamic> kiosk, bool isFavorite) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      print('User is not logged in');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please log in to update favorites')),
      );
      return;
    }

    final userFavoritesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection(
            'favorites'); // Assuming each user has their own favorites collection

    try {
      if (isFavorite) {
        // Remove from favorites
        await userFavoritesRef.doc(kiosk['id']).delete();
        setState(() {
          kiosk['isFavorite'] = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Removed from favorites')),
        );
      } else {
        // Add to favorites
        await userFavoritesRef.doc(kiosk['id']).set({
          'name': kiosk['name'],
          'address': kiosk['address'],
          'city': kiosk['city'],
          'lat': kiosk['lat'],
          'lng': kiosk['lng'],
          'image': kiosk['image'],
          'uid': userId,
        });
        setState(() {
          kiosk['isFavorite'] = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Added to favorites')),
        );
      }
    } catch (e) {
      print('Error updating favorite status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating favorite status')),
      );
    }
  }

  String selectedCity = 'all';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: context.read<HomeProvider>().state.initialLocation == null
            ? Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  StreamBuilder<Set<Marker>>(
                    stream: _getMarkersStream(selectedCity),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      // Get markers from the stream
                      Set<Marker> markers = snapshot.data ?? Set<Marker>();

                      // If user location marker is not null, add it to the set of markers
                      if (context
                          .read<HomeProvider>()
                          .state
                          .markers
                          .isNotEmpty) {
                        markers
                            .addAll(context.read<HomeProvider>().state.markers);
                      }

                      return GoogleMap(
                        onMapCreated: (controller) {
                          context.read<HomeProvider>().state.mapController =
                              controller;
                        },
                        initialCameraPosition: CameraPosition(
                          target: context
                              .read<HomeProvider>()
                              .state
                              .initialLocation!,
                          zoom: 9,
                        ),
                        markers: markers,
                      );
                    },
                  ),
                  Positioned(
                    top: 4.h,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        height: 5.h,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildCityOption('All Kiosks', 'all'),
                            SizedBox(width: 1.w),
                            _buildCityOption('Cairo', 'Cairo'),
                            SizedBox(width: 1.w),
                            _buildCityOption('Giza', 'Giza'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildCityOption(String label, String city) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedCity = city;
        });
      },
      child: Flexible(
        child: Container(
          width: 30.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Checkbox(
                value: selectedCity == city,
                onChanged: (_) {
                  setState(() {
                    selectedCity = city;
                  });
                },
              ),
              Text(label),
            ],
          ),
        ),
      ),
    );

// A function that returns a stream of markers based on the selected city
  }

  Stream<Set<Marker>> _getMarkersStream(String city) {
    if (city == 'all') {
      return Stream.value(context.read<HomeProvider>().state.markers);
    } else if (city == 'Cairo') {
      return Stream.value(context.read<HomeProvider>().state.markerscairo);
    } else if (city == 'Giza') {
      return Stream.value(context.read<HomeProvider>().state.markersgiza);
    } else {
      return Stream.value(Set<Marker>());
    }
  }
}
