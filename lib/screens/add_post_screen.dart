import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantdiseaseidentifcationml/commonComponents/common_appbar.dart';
import 'dart:io';
import 'package:plantdiseaseidentifcationml/services/firestore_service.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  XFile? _image;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  void _addPost() async {
    if (_titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _image != null) {
      try {
        await FirestoreService().addPost(
          'UserName', // Replace with actual user name
          _titleController.text,
          _descriptionController.text,
          _image!.path,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Post added successfully')),
        );
        _titleController.clear();
        _descriptionController.clear();
        setState(() {
          _image = null;
        });
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add post: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields and select an image')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Add Post',
        leading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _image == null
                    ? const Center(
                        child: Text(
                          'Tap to add image',
                          style: TextStyle(color: Colors.black54),
                        ),
                      )
                    : Image.file(
                        File(_image!.path),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Main Question',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addPost,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Add Post'),
            ),
          ],
        ),
      ),
    );
  }
}
