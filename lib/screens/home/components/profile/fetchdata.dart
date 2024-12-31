// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FetchDataScreen extends StatefulWidget {
  @override
  _FetchDataScreenState createState() => _FetchDataScreenState();
}

class _FetchDataScreenState extends State<FetchDataScreen> {
  bool isUploading = false;

  // Function to load JSON from assets
  Future<List> loadJsonData(String filePath) async {
    String jsonString = await rootBundle.loadString(filePath);
    Map<String, dynamic> jsonData = json.decode(jsonString);
    return jsonData.values.toList();
  }

  // Function to upload data to Firestore
  Future<void> uploadDataToFirestore(
      List<Map<String, dynamic>> kiosks, String city) async {
    try {
      for (var kiosk in kiosks) {
        await FirebaseFirestore.instance.collection('kiosks').add({
          'name': kiosk['name'],
          'address': kiosk['address'],
          'city': city,
          'lat': kiosk['lat'],
          'lng': kiosk['lng'],
          'type': kiosk['type'],
          'image': kiosk['image'],
          'district': kiosk['districtName'],
        });
      }
    } catch (e) {
      throw Exception("Error uploading data: $e");
    }
  }

  // Function to handle JSON upload
  Future<void> handleUpload(String filePath, String city) async {
    setState(() {
      isUploading = true;
    });
    try {
      List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(await loadJsonData(filePath));
      await uploadDataToFirestore(data, city);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$city data uploaded successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
// Update complete here.
      );
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Upload JSON to Firestore',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Upload Data',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                UploadButton(
                  label: 'Upload Giza Data',
                  isLoading: isUploading,
                  onPressed: () async {
                    await handleUpload('assets/json/locaitonsA.json', 'Giza');
                  },
                ),
                SizedBox(height: 20),
                UploadButton(
                  label: 'Upload Cairo Data',
                  isLoading: isUploading,
                  onPressed: () async {
                    await handleUpload('assets/json/locaitonsA.json', 'Cairo');
                  },
                ),
                if (isUploading) ...[
                  SizedBox(height: 20),
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'Uploading data, please wait...',
                    style: TextStyle(
                      color: Colors.white70,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UploadButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onPressed;

  const UploadButton({
    required this.label,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onPressed,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        decoration: BoxDecoration(
          color: isLoading ? Colors.grey : Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isLoading ? Colors.black54 : Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            if (isLoading) ...[
              SizedBox(width: 10),
              SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
