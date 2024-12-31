// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print, unnecessary_cast, library_private_types_in_public_api, prefer_const_declarations

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kiosk_finder/screens/home/components/kiosk_details.dart';
import 'package:sizer/sizer.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Map<String, dynamic>> favoriteKiosks = [];

  @override
  void initState() {
    super.initState();
    fetchFavoriteKiosks();
  }

  Future<void> fetchFavoriteKiosks() async {
    final userId =
        FirebaseAuth.instance.currentUser!.uid; // Replace with actual user ID

    try {
      final userFavoritesRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites');

      final snapshot = await userFavoritesRef.get();
      final kiosks = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'name': data['name'],
          'address': data['address'],
          'city': data['city'],
          'lat': data['lat'],
          'lng': data['lng'],
          'image': data['image'],
        };
      }).toList();

      setState(() {
        favoriteKiosks = kiosks;
      });
    } catch (e) {
      print('Error fetching favorite kiosks: $e');
    }
  }

  Future<void> removeFavorite(String kioskId) async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;

      // Reference to the user's favorites collection
      final userFavoritesRef = FirebaseFirestore.instance
          .collection('users') // Replace with your Firestore structure
          .doc(userId)
          .collection('favorites');

      // Find and delete the specific favorite kiosk
      await userFavoritesRef.doc(kioskId).delete();

      // Update the UI to remove the kiosk from the list
      setState(() {
        favoriteKiosks.removeWhere((kiosk) => kiosk['id'] == kioskId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kiosk removed from favorites')),
      );
    } catch (e) {
      print('Error removing kiosk from favorites: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error removing kiosk')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: favoriteKiosks.isEmpty
            ? Center(child: Text('No favorites yet'))
            : ListView.builder(
                itemCount: favoriteKiosks.length,
                itemBuilder: (context, index) {
                  final kiosk = favoriteKiosks[index];
                  return Column(
                    children: [
                      Divider(
                        height: 1.h,
                        color: Colors.transparent,
                      ),
                      Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  kiosk['image'],
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      kiosk['name'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Address: ${kiosk['address']}',
                                      style: TextStyle(fontSize: 14),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'City: ${kiosk['city']}',
                                      style: TextStyle(fontSize: 14),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            // Navigate to the Kiosk Detail Screen
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    KioskDetailScreen(
                                                  kiosk: kiosk,
                                                ),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 8),
                                            textStyle: TextStyle(fontSize: 12),
                                          ),
                                          child: Text('View Details'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            // Remove the kiosk from favorites
                                            removeFavorite(kiosk['id']);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 8),
                                            textStyle: TextStyle(fontSize: 12),
                                          ),
                                          child: Text('Remove'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
