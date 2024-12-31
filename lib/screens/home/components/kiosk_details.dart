// Kiosk Detail Screen (For Viewing Kiosk Details)
// ignore_for_file: use_super_parameters, prefer_const_constructors

import 'package:flutter/material.dart';

class KioskDetailScreen extends StatelessWidget {
  final Map<String, dynamic> kiosk;

  const KioskDetailScreen({Key? key, required this.kiosk}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(kiosk['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                kiosk['image'],
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Name: ${kiosk['name']}',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Address: ${kiosk['address']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'City: ${kiosk['city']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Coordinates: (${kiosk['lat']}, ${kiosk['lng']})',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
