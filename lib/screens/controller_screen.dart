import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantdiseaseidentifcationml/app_color.dart';
import 'package:plantdiseaseidentifcationml/screens/community_screen.dart';
import 'package:plantdiseaseidentifcationml/screens/home_screen.dart';
import 'package:plantdiseaseidentifcationml/screens/menu_screen.dart';
import 'package:plantdiseaseidentifcationml/screens/progress_tracker_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:camera/camera.dart';

class ControllerScreen extends StatefulWidget {
  const ControllerScreen({super.key});

  @override
  State<ControllerScreen> createState() => _ControllerScreenState();
}

class _ControllerScreenState extends State<ControllerScreen> {
  int _selectedIndex = 0;
  CameraController? _cameraController;
  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const ProgressTrackerScreen(),
    const ProgressTrackerScreen(),
    const CommunityScreen(),
    const MenuScreen(),
  ];

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _openCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _cameraController = CameraController(
      firstCamera,
      ResolutionPreset.high,
    );

    await _cameraController!.initialize();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CameraScreen(cameraController: _cameraController!),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showImagePickerOptions() {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: SizedBox(
          height: 150,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Photo Library'),
                onTap: () {
                  // _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () {
                  _openCamera();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        floatingActionButton: SizedBox(
          height: 65,
          width: 65,
          child: FloatingActionButton(
            onPressed: _showImagePickerOptions,
            backgroundColor: AppColors.MainGreen,
            shape: const CircleBorder(),
            child: SvgPicture.asset(
              'assets/scanner.svg',
              color: Colors.white,
              height: 40,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          // surfaceTintColor: const Color.fromARGB(255, 175, 47, 47),
          color: const Color(0xffffffff),
          shape: const CircularNotchedRectangle(),
          notchMargin: 5,
          elevation: 8,
          shadowColor: Colors.black.withOpacity(1),
          child: SizedBox(
            height: 50, // Reduced height for the bottom navigation bar
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    buildNavItem(0, 'assets/house-blank-filled.svg',
                        'assets/house-blank.svg', 'Home'),
                    buildNavItem(1, 'assets/plant-growth-filled.svg',
                        'assets/plant-growth.svg', 'Progress'),
                  ],
                ),
                const SizedBox(width: 40),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    buildNavItem(3, 'assets/users-people-filled.svg',
                        'assets/users-people.svg', 'Community'),
                    buildNavItem(
                        4, 'assets/menu-filled.svg', 'assets/menu.svg', 'More'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNavItem(
      int index, String activeIconPath, String inactiveIconPath, String label) {
    return MaterialButton(
      minWidth: 40,
      onPressed: () {
        _onItemTapped(index);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Material(
            shape: CircleBorder(),
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: SvgPicture.asset(
                _selectedIndex == index ? activeIconPath : inactiveIconPath,
                color:
                    _selectedIndex == index ? AppColors.MainGreen : Colors.grey,
                height: 24,
              ),
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color:
                  _selectedIndex == index ? AppColors.MainGreen : Colors.grey,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class CameraScreen extends StatefulWidget {
  final CameraController cameraController;

  CameraScreen({required this.cameraController});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  XFile? _imageFile;

  Future<void> _captureImage() async {
    try {
      final image = await widget.cameraController.takePicture();
      setState(() {
        _imageFile = image;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CameraPreview(widget.cameraController),
          Positioned(
            bottom: 25,
            left: 0,
            right: 0,
            child: Column(
              children: [
                if (_imageFile != null)
                  Image.file(
                    File(_imageFile!.path),
                    height: 100,
                    width: 100,
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.photo_library,
                          color: Colors.white, size: 30),
                      onPressed: () {
                        // Handle gallery action
                        _pickImage();
                      },
                    ),
                    FloatingActionButton(
                      onPressed: _captureImage,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.camera_alt, color: Colors.black),
                    ),
                    IconButton(
                      icon: Icon(Icons.help_outline,
                          color: Colors.white, size: 30),
                      onPressed: () {
                        // Handle help action
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Center(
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
