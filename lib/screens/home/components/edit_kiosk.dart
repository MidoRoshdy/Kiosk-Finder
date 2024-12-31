// ignore_for_file: use_super_parameters, use_build_context_synchronously, avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditKioskScreen extends StatefulWidget {
  final Map<String, dynamic> kioskData;

  const EditKioskScreen({Key? key, required this.kioskData}) : super(key: key);

  @override
  State<EditKioskScreen> createState() => _EditKioskScreenState();
}

class _EditKioskScreenState extends State<EditKioskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.kioskData['name']);
    _addressController =
        TextEditingController(text: widget.kioskData['address']);
    _cityController = TextEditingController(text: widget.kioskData['city']);
  }

  Future<void> _updateKiosk() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection('kiosks')
            .doc(widget.kioskData['id'])
            .update({
          'name': _nameController.text,
          'address': _addressController.text,
          'city': _cityController.text,
        });

        Navigator.pop(context, true);
      } catch (e) {
        print('Error updating kiosk: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Kiosk')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Kiosk Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a name' : null,
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter an address' : null,
              ),
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(labelText: 'City'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a city' : null,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _updateKiosk,
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
