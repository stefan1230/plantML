import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plantdiseaseidentifcationml/services/firestore_service.dart';

class AddProgressScreen extends StatefulWidget {
  final String plantId;

  AddProgressScreen({required this.plantId});

  @override
  _AddProgressScreenState createState() => _AddProgressScreenState();
}

class _AddProgressScreenState extends State<AddProgressScreen> {
  File? _selectedImage;
  final TextEditingController _noteController = TextEditingController();
  double _healthMeter = 5.0; // Initial health meter value

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Future<void> _uploadProgress() async {
  //   if (_selectedImage == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Please select an image')),
  //     );
  //     return;
  //   }

  //   try {
  //     showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (context) => Center(child: CircularProgressIndicator()),
  //     );

  //     // Upload image and get the download URL
  //     String imageUrl = await FirestoreService().uploadImage(_selectedImage!);

  //     // Add progress entry to Firestore
  //     await FirebaseFirestore.instance
  //         .collection('plants')
  //         .doc(widget.plantId)
  //         .update({
  //       'progressImages': FieldValue.arrayUnion([
  //         {
  //           'url': imageUrl,
  //           'note': _noteController.text,
  //           'healthMeter': _healthMeter,
  //           'date': FieldValue.serverTimestamp(),
  //         }
  //       ])
  //     });

  //     Navigator.of(context).pop(); // Close the loading dialog
  //     Navigator.of(context).pop(); // Close the AddProgressScreen

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Progress added successfully')),
  //     );
  //   } catch (e) {
  //     Navigator.of(context).pop(); // Close the loading dialog
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to upload progress: $e')),
  //     );
  //   }
  // }

  Future<void> _uploadProgress() async {
    if (_selectedImage != null) {
      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(child: CircularProgressIndicator()),
        );

        String note = _noteController.text;
        double healthMeter = _healthMeter;

        await FirestoreService().addProgressImage(
          widget.plantId,
          _selectedImage!,
          note,
          healthMeter,
        );

        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Progress image uploaded successfully')),
        );

        setState(() {
          _selectedImage = null;
        });
      } catch (e) {
        print(e);
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload progress image: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Progress'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Picker
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  image: _selectedImage != null
                      ? DecorationImage(
                          image: FileImage(_selectedImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _selectedImage == null
                    ? Center(
                        child: Icon(Icons.camera_alt,
                            size: 50, color: Colors.grey))
                    : null,
              ),
            ),
            SizedBox(height: 16),

            // Note input
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Add a note',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Health Meter
            Text('Health Meter', style: TextStyle(fontSize: 16)),
            Slider(
              value: _healthMeter,
              min: 0,
              max: 10,
              divisions: 10,
              label: _healthMeter.round().toString(),
              onChanged: (value) {
                setState(() {
                  _healthMeter = value;
                });
              },
            ),
            SizedBox(height: 16),

            // Upload Button
            ElevatedButton(
              onPressed: _uploadProgress,
              child: Text('Upload Progress'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
