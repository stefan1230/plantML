// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';
// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:plantdiseaseidentifcationml/app_color.dart';
// import 'package:plantdiseaseidentifcationml/screens/community_screen.dart';
// import 'package:plantdiseaseidentifcationml/screens/diagnosis_screen.dart';
// import 'package:plantdiseaseidentifcationml/screens/disease_detection_scree.dart';
// import 'package:plantdiseaseidentifcationml/screens/disease_detection_screen.dart';
// // import 'package:plantdiseaseidentifcationml/screens/disease_detection_screen2.dart';
// import 'package:plantdiseaseidentifcationml/screens/home_screen.dart';
// import 'package:plantdiseaseidentifcationml/screens/menu_screen.dart';
// import 'package:plantdiseaseidentifcationml/screens/progress_tracker_screen.dart';
// // import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:camera/camera.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:image/image.dart' as img;

// class ControllerScreen extends StatefulWidget {
//   const ControllerScreen({super.key});

//   @override
//   State<ControllerScreen> createState() => _ControllerScreenState();
// }

// class _ControllerScreenState extends State<ControllerScreen> {
//   int _selectedIndex = 0;
//   CameraController? _cameraController;
//   XFile? _imageFile;
//   final ImagePicker picker = ImagePicker();
//   late Interpreter _interpreter;
//   bool _isProcessing = false;
//   List<dynamic> _diseaseData = []; // Initialize as an empty list

//   static final List<Widget> _widgetOptions = <Widget>[
//     const HomeScreen(),
//     const ProgressTrackerScreen(),
//     const ProgressTrackerScreen(),
//     const CommunityScreen(),
//     const MenuScreen(),
//   ];

//   @override
//   void dispose() {
//     _cameraController?.dispose();
//     super.dispose();
//     _loadModel();
//     _loadDiseaseData();
//   }

//   Future<void> _loadModel() async {
//     _interpreter = await Interpreter.fromAsset(
//         'assets/second_final_model_quantized_compatible.tflite');
//   }

//   Future<void> _loadDiseaseData() async {
//     final String dataString =
//         await rootBundle.loadString('assets/disease_info.json');
//     final Map<String, dynamic> jsonData = json.decode(dataString);
//     setState(() {
//       _diseaseData = jsonData['diseases'];
//     });
//   }

//   Future<void> _openCamera() async {
//     final cameras = await availableCameras();
//     final firstCamera = cameras.first;

//     _cameraController = CameraController(
//       firstCamera,
//       ResolutionPreset.high,
//     );

//     await _cameraController!.initialize();

//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) =>
//             CameraScreen(cameraController: _cameraController!),
//       ),
//     );
//   }

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   // Future<void> _pickImage(ImageSource source) async {
//   //   try {
//   //     final XFile? selectedImage = await picker.pickImage(source: source);

//   //     if (selectedImage != null) {
//   //       setState(() {
//   //         _imageFile = selectedImage;
//   //       });
//   //       _detectDisease(File(selectedImage.path)); // Call the detection method
//   //     } else {
//   //       print('No image selected.');
//   //     }
//   //   } catch (e) {
//   //     print("Error picking image: $e");
//   //   }
//   // }

//   // Future<void> _pickImage(ImageSource source) async {
//   //   final XFile? selectedImage = await picker.pickImage(source: source);
//   //   if (selectedImage != null) {
//   //     setState(() {
//   //       _imageFile = selectedImage;
//   //     });
//   //     _detectDisease(File(selectedImage.path)); // Call detection function
//   //   }
//   // }

//   // void _showImagePickerOptions() {
//   //   Navigator.push(
//   //     context,
//   //     MaterialPageRoute(builder: (context) => DiseaseDetectionScreen4()),
//   //   );
//   // showModalBottomSheet(
//   //   context: context,
//   //   builder: (BuildContext context) {
//   //     return SafeArea(
//   //       child: Wrap(
//   //         children: <Widget>[
//   //           ListTile(
//   //             leading: Icon(Icons.photo_library),
//   //             title: Text('Photo Library'),
//   //             onTap: () {
//   //               Navigator.of(context).pop();
//   //               _pickImage(ImageSource.gallery);
//   //             },
//   //           ),
//   //           ListTile(
//   //             leading: Icon(Icons.photo_camera),
//   //             title: Text('Camera'),
//   //             onTap: () {
//   //               Navigator.of(context).pop();
//   //               _pickImage(ImageSource.camera);
//   //             },
//   //           ),
//   //         ],
//   //       ),
//   //     );
//   //   },
//   // );
//   // }

//   // Future<void> _detectDisease(File image) async {
//   //   // Placeholder for the disease detection logic
//   //   print("Disease detection called with image: ${image.path}");
//   //   // Navigate to disease detection screen or call detection model here
//   //   Navigator.push(
//   //     context,
//   //     MaterialPageRoute(
//   //       builder: (context) => PlantDiseaseDetector(image: image),
//   //     ),
//   //   );
//   // }

//   // Future<void> _detectDisease(File image) async {
//   //   setState(() {
//   //     _isProcessing = true; // Show processing indicator
//   //   });

//   //   // Preprocess the image and run model prediction
//   //   var input = processImage(image);
//   //   var output = List.filled(1 * _diseaseData.length, 0.0)
//   //       .reshape([1, _diseaseData.length]); // Adjust output size
//   //   _interpreter.run(input, output);

//   //   setState(() {
//   //     _isProcessing = false; // Hide processing indicator
//   //   });

//   //   // Get the highest confidence label and retrieve its info
//   //   int detectedIndex =
//   //       output[0].indexWhere((element) => element == output[0].reduce(max));
//   //   final diseaseData =
//   //       getDiseaseInfo(detectedIndex); // Function to get disease info

//   //   Navigator.push(
//   //     context,
//   //     MaterialPageRoute(
//   //       builder: (context) => DiagnosisScreen(plantData: diseaseData),
//   //     ),
//   //   );
//   // }

//   // void _showImagePickerOptions() {
//   //   showModalBottomSheet(
//   //     context: context,
//   //     builder: (context) => SafeArea(
//   //       child: Wrap(
//   //         children: <Widget>[
//   //           ListTile(
//   //             leading: const Icon(Icons.photo_library),
//   //             title: const Text('Photo Library'),
//   //             onTap: () {
//   //               Navigator.of(context).pop();
//   //               _pickImage(ImageSource.gallery);
//   //             },
//   //           ),
//   //           ListTile(
//   //             leading: const Icon(Icons.photo_camera),
//   //             title: const Text('Camera'),
//   //             onTap: () {
//   //               Navigator.of(context).pop();
//   //               _pickImage(ImageSource.camera);
//   //             },
//   //           ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }

//   // List<dynamic> processImage(File image) {
//   //   // Load and resize the image
//   //   final img.Image? originalImage = img.decodeImage(image.readAsBytesSync());
//   //   final img.Image resizedImage =
//   //       img.copyResize(originalImage!, width: 224, height: 224);

//   //   // Convert the image to a normalized input format
//   //   var input = List.generate(224, (y) {
//   //     return List.generate(224, (x) {
//   //       final pixel = resizedImage.getPixel(x, y);
//   //       return [
//   //         (pixel & 0xFF) / 255.0,
//   //         ((pixel >> 8) & 0xFF) / 255.0,
//   //         ((pixel >> 16) & 0xFF) / 255.0
//   //       ];
//   //     });
//   //   });

//   //   return [input];
//   // }

//   Map<String, dynamic> getDiseaseInfo(int index) {
//     // Retrieve the disease data based on the detected index
//     if (index >= 0 && index < _diseaseData.length) {
//       return _diseaseData[index];
//     }
//     throw Exception("Invalid index for disease data");
//   }

//   Future<void> _pickImage(ImageSource source) async {
//     if (_diseaseData.isEmpty) {
//       await _loadDiseaseData(); // Ensure data is loaded
//     }

//     final XFile? selectedImage = await picker.pickImage(source: source);
//     if (selectedImage != null) {
//       setState(() {
//         _imageFile = selectedImage;
//       });
//       _detectDisease(File(selectedImage.path));
//     }
//   }

//   Future<void> _detectDisease(File image) async {
//     if (_diseaseData.isEmpty) {
//       print("Disease data is not loaded yet.");
//       return;
//     }

//     setState(() {
//       _isProcessing = true;
//     });

//     var input = processImage(image);
//     var output = List.filled(1 * _diseaseData.length, 0.0)
//         .reshape([1, _diseaseData.length]);
//     _interpreter.run(input, output);

//     setState(() {
//       _isProcessing = false;
//     });

//     int detectedIndex =
//         output[0].indexWhere((element) => element == output[0].reduce(max));
//     final diseaseData = getDiseaseInfo(detectedIndex);

//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => DiagnosisScreen(plantData: diseaseData),
//       ),
//     );
//   }

//   List<dynamic> processImage(File image) {
//     final img.Image? originalImage = img.decodeImage(image.readAsBytesSync());
//     final img.Image resizedImage =
//         img.copyResize(originalImage!, width: 224, height: 224);

//     var input = List.generate(224, (y) {
//       return List.generate(224, (x) {
//         final pixel = resizedImage.getPixel(x, y);
//         return [
//           (pixel & 0xFF) / 255.0,
//           ((pixel >> 8) & 0xFF) / 255.0,
//           ((pixel >> 16) & 0xFF) / 255.0
//         ];
//       });
//     });

//     return [input];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         if (_selectedIndex != 0) {
//           setState(() {
//             _selectedIndex = 0;
//           });
//           return false;
//         }
//         return true;
//       },
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: Center(
//           child: _widgetOptions.elementAt(_selectedIndex),
//         ),
//         floatingActionButton: SizedBox(
//           height: 65,
//           width: 65,
//           child: FloatingActionButton(
//             onPressed: _showImagePickerOptions,
//             backgroundColor: AppColors.MainGreen,
//             shape: const CircleBorder(),
//             child: SvgPicture.asset(
//               'assets/scanner.svg',
//               color: Colors.white,
//               height: 40,
//             ),
//           ),
//         ),
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//         bottomNavigationBar: BottomAppBar(
//           color: const Color(0xffffffff),
//           shape: const CircularNotchedRectangle(),
//           notchMargin: 5,
//           elevation: 8,
//           shadowColor: Colors.black.withOpacity(1),
//           child: SizedBox(
//             height: 50,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     buildNavItem(0, 'assets/house-blank-filled.svg',
//                         'assets/house-blank.svg', 'Home'),
//                     buildNavItem(1, 'assets/plant-growth-filled.svg',
//                         'assets/plant-growth.svg', 'Progress'),
//                   ],
//                 ),
//                 const SizedBox(width: 40),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     buildNavItem(3, 'assets/users-people-filled.svg',
//                         'assets/users-people.svg', 'Community'),
//                     buildNavItem(
//                         4, 'assets/menu-filled.svg', 'assets/menu.svg', 'More'),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildNavItem(
//       int index, String activeIconPath, String inactiveIconPath, String label) {
//     return MaterialButton(
//       minWidth: 40,
//       onPressed: () {
//         _onItemTapped(index);
//       },
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Material(
//             shape: CircleBorder(),
//             color: Colors.transparent,
//             child: Padding(
//               padding: const EdgeInsets.all(0.0),
//               child: SvgPicture.asset(
//                 _selectedIndex == index ? activeIconPath : inactiveIconPath,
//                 color:
//                     _selectedIndex == index ? AppColors.MainGreen : Colors.grey,
//                 height: 24,
//               ),
//             ),
//           ),
//           SizedBox(height: 4),
//           Text(
//             label,
//             style: TextStyle(
//               color:
//                   _selectedIndex == index ? AppColors.MainGreen : Colors.grey,
//               fontSize: 10,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class CameraScreen extends StatefulWidget {
//   final CameraController cameraController;

//   CameraScreen({required this.cameraController});

//   @override
//   _CameraScreenState createState() => _CameraScreenState();
// }

// class _CameraScreenState extends State<CameraScreen> {
//   XFile? _imageFile;

//   Future<void> _captureImage() async {
//     try {
//       final image = await widget.cameraController.takePicture();
//       setState(() {
//         _imageFile = image;
//       });
//     } catch (e) {
//       print(e);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         children: [
//           CameraPreview(widget.cameraController),
//           Positioned(
//             bottom: 25,
//             left: 0,
//             right: 0,
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.photo_library,
//                           color: Colors.white, size: 30),
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                     ),
//                     FloatingActionButton(
//                       onPressed: _captureImage,
//                       backgroundColor: Colors.white,
//                       child: Icon(Icons.camera_alt, color: Colors.black),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantdiseaseidentifcationml/app_color.dart';
import 'package:plantdiseaseidentifcationml/screens/community_screen.dart';
import 'package:plantdiseaseidentifcationml/screens/diagnosis_screen.dart';
import 'package:plantdiseaseidentifcationml/screens/disease_detection_screen.dart';
import 'package:plantdiseaseidentifcationml/screens/home_screen.dart';
import 'package:plantdiseaseidentifcationml/screens/loading_screen.dart';
import 'package:plantdiseaseidentifcationml/screens/menu_screen.dart';
import 'package:plantdiseaseidentifcationml/screens/progress_tracker_screen.dart';
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class ControllerScreen extends StatefulWidget {
  const ControllerScreen({super.key});

  @override
  State<ControllerScreen> createState() => _ControllerScreenState();
}

class _ControllerScreenState extends State<ControllerScreen> {
  int _selectedIndex = 0;
  CameraController? _cameraController;
  XFile? _imageFile;
  final ImagePicker picker = ImagePicker();
  late Interpreter _interpreter;
  bool _isProcessing = false;
  List<dynamic> _diseaseData =
      []; // Initialize as empty list to avoid null issues

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const ProgressTrackerScreen(),
    const ProgressTrackerScreen(),
    const CommunityScreen(),
    const MenuScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadModel();
    _loadDiseaseData();
  }

  Future<void> _loadModel() async {
    _interpreter = await Interpreter.fromAsset(
        'assets/final_final_model_quantized_compatible.tflite');
  }

  Future<void> _loadDiseaseData() async {
    final String dataString =
        await rootBundle.loadString('assets/disease_info.json');
    final Map<String, dynamic> jsonData = json.decode(dataString);
    setState(() {
      _diseaseData = jsonData['diseases'];
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    if (_diseaseData.isEmpty) {
      await _loadDiseaseData(); // Ensure data is loaded if not already done
    }

    final XFile? selectedImage = await picker.pickImage(source: source);
    if (selectedImage != null) {
      setState(() {
        _imageFile = selectedImage;
      });
      _detectDisease(File(selectedImage.path));
      // _detectDisease();
    }
  }

  // Future<void> _detectDisease(File image) async {
  //   if (_diseaseData.isEmpty) {
  //     print("Disease data is not loaded yet.");
  //     return;
  //   }

  //   setState(() {
  //     _isProcessing = true;
  //   });

  //   // Preprocess the image and run model prediction
  //   var input = processImage(image);
  //   var output = List.filled(1 * _diseaseData.length, 0.0)
  //       .reshape([1, _diseaseData.length]);
  //   _interpreter.run(input, output);

  //   setState(() {
  //     _isProcessing = false;
  //   });

  //   int detectedIndex =
  //       output[0].indexWhere((element) => element == output[0].reduce(max));
  //   final diseaseData = getDiseaseInfo(detectedIndex);

  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => DiagnosisScreen(plantData: diseaseData),
  //     ),
  //   );
  // }

  Future<void> _detectDisease(File image) async {
    // showLoadingScreen(context);
    setState(() {
      _isProcessing = true; // Show loading indicator
    });

    // Simulate processing delay
    await Future.delayed(Duration(seconds: 2));

    // Dummy logic: randomly pick disease info for demonstration
    final diseaseData = _diseaseData[Random().nextInt(_diseaseData.length)];

    setState(() {
      _isProcessing = false; // Hide loading indicator
    });

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => DiagnosisScreen(plantData: diseaseData),
    //   ),
    // );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiagnosisScreen(
          plantData: diseaseData,
          imageFile: image,
          fromModelDetection: true, // Show Add Plant button
        ),
      ),
    );
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Photo Library'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Camera'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  List<dynamic> processImage(File image) {
    final img.Image? originalImage = img.decodeImage(image.readAsBytesSync());
    final img.Image resizedImage =
        img.copyResize(originalImage!, width: 224, height: 224);

    var input = List.generate(224, (y) {
      return List.generate(224, (x) {
        final pixel = resizedImage.getPixel(x, y);
        return [
          (pixel & 0xFF) / 255.0,
          ((pixel >> 8) & 0xFF) / 255.0,
          ((pixel >> 16) & 0xFF) / 255.0
        ];
      });
    });

    return [input];
  }

  Map<String, dynamic> getDiseaseInfo(int index) {
    if (index >= 0 && index < _diseaseData.length) {
      return _diseaseData[index];
    }
    throw Exception("Invalid index for disease data");
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _interpreter.close();
    super.dispose();
  }

  void showLoadingScreen(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevents the user from closing the dialog by tapping outside
      builder: (context) => LoadingScreen(),
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
        body: Stack(children: [
          Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          if (_isProcessing)
            AnimatedOpacity(
              opacity: _isProcessing ? 1.0 : 0.0,
              duration: Duration(milliseconds: 300),
              child: Container(
                color: Colors.black.withOpacity(0.6),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/detecting_icon.svg', // Replace with an icon or image asset path
                        height: 80,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Detecting...",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      CircularProgressIndicator(
                        color: AppColors.MainGreen,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ]),
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
          color: const Color(0xffffffff),
          shape: const CircularNotchedRectangle(),
          notchMargin: 5,
          elevation: 8,
          shadowColor: Colors.black.withOpacity(1),
          child: SizedBox(
            height: 50,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.photo_library,
                          color: Colors.white, size: 30),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FloatingActionButton(
                      onPressed: _captureImage,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.camera_alt, color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
