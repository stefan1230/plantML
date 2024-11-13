// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:plantdiseaseidentifcationml/app_color.dart';
// import 'package:plantdiseaseidentifcationml/screens/community_screen.dart';
// import 'package:plantdiseaseidentifcationml/screens/diagnosis_screen.dart';
// import 'package:plantdiseaseidentifcationml/screens/home_screen.dart';
// import 'package:plantdiseaseidentifcationml/screens/menu_screen.dart';
// import 'package:plantdiseaseidentifcationml/screens/progress_tracker_screen.dart';
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
//   bool _isProcessing = false;
//   Interpreter? _interpreter;

//   static final List<Widget> _widgetOptions = <Widget>[
//     const HomeScreen(),
//     const ProgressTrackerScreen(),
//     const ProgressTrackerScreen(),
//     const CommunityScreen(),
//     const MenuScreen(),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _loadModel();
//   }

//   @override
//   void dispose() {
//     _cameraController?.dispose();
//     _interpreter?.close();
//     super.dispose();
//   }

//   Future<void> _loadModel() async {
//     try {
//       _interpreter =
//           await Interpreter.fromAsset('final_model_quantized.tflite');
//       print('Model loaded successfully');
//     } catch (e) {
//       print('Error loading model: $e');
//     }
//   }

//   Future<void> _pickImage(ImageSource source) async {
//     try {
//       final XFile? selectedImage = await picker.pickImage(source: source);
//       if (selectedImage != null) {
//         setState(() {
//           _imageFile = selectedImage;
//           _isProcessing = true;
//         });
//         await _detectDisease(File(selectedImage.path));
//       }
//     } catch (e) {
//       print("Error picking image: $e");
//     }
//   }

//   Future<void> _detectDisease(File image) async {
//     if (_interpreter == null) {
//       print("Interpreter not loaded");
//       return;
//     }

//     final img.Image? imageInput = img.decodeImage(image.readAsBytesSync());
//     if (imageInput == null) {
//       print("Error decoding image");
//       return;
//     }

//     final img.Image resizedImage =
//         img.copyResize(imageInput, width: 224, height: 224);
//     var input = _imageToByteListFloat32(resizedImage, 224);
//     var output = List.filled(1 * 16, 0).reshape([1, 16]); // Assuming 16 classes

//     _interpreter!.run(input, output);

//     final resultIndex =
//         output[0].indexWhere((value) => value == output[0].reduce(max));
//     final diseaseName = await _getDiseaseName(resultIndex);

//     setState(() {
//       _isProcessing = false;
//     });

//     _navigateToDiagnosisScreen(diseaseName);
//   }

//   Uint8List _imageToByteListFloat32(img.Image image, int size) {
//     var convertedBytes = Float32List(size * size * 3);
//     var buffer = Float32List.view(convertedBytes.buffer);
//     int pixelIndex = 0;
//     for (int y = 0; y < size; y++) {
//       for (int x = 0; x < size; x++) {
//         final pixel = image.getPixel(x, y);
//         buffer[pixelIndex++] = img.getRed(pixel) / 127.5 - 1.0;
//         buffer[pixelIndex++] = img.getGreen(pixel) / 127.5 - 1.0;
//         buffer[pixelIndex++] = img.getBlue(pixel) / 127.5 - 1.0;
//       }
//     }
//     return convertedBytes.buffer.asUint8List();
//   }

//   Future<String> _getDiseaseName(int index) async {
//     // Implement a mapping between class index and disease names here
//     // You can load from your JSON or a Map
//     List<String> diseaseNames = [
//       "Pepper Bell - Bacterial Spot",
//       "Potato - Early Blight",
//       "Potato - Late Blight",
//       "Tomato - Bacterial Spot",
//       // Add other disease names as per your model classes
//     ];
//     return diseaseNames[index];
//   }

//   void _navigateToDiagnosisScreen(String diseaseName) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => DiagnosisScreen(diseaseName: diseaseName),
//       ),
//     );
//   }

//   void _showImagePickerOptions() {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return SafeArea(
//           child: Wrap(
//             children: <Widget>[
//               ListTile(
//                 leading: Icon(Icons.photo_library),
//                 title: Text('Photo Library'),
//                 onTap: () {
//                   Navigator.of(context).pop();
//                   _pickImage(ImageSource.gallery);
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.photo_camera),
//                 title: Text('Camera'),
//                 onTap: () {
//                   Navigator.of(context).pop();
//                   _pickImage(ImageSource.camera);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: _widgetOptions.elementAt(_selectedIndex),
//       ),
//       floatingActionButton: SizedBox(
//         height: 65,
//         width: 65,
//         child: FloatingActionButton(
//           onPressed: _showImagePickerOptions,
//           backgroundColor: AppColors.MainGreen,
//           shape: const CircleBorder(),
//           child: SvgPicture.asset(
//             'assets/scanner.svg',
//             color: Colors.white,
//             height: 40,
//           ),
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       bottomNavigationBar: BottomAppBar(
//         color: const Color(0xffffffff),
//         shape: const CircularNotchedRectangle(),
//         notchMargin: 5,
//         elevation: 8,
//         shadowColor: Colors.black.withOpacity(1),
//         child: SizedBox(
//           height: 50,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   buildNavItem(0, 'assets/house-blank-filled.svg',
//                       'assets/house-blank.svg', 'Home'),
//                   buildNavItem(1, 'assets/plant-growth-filled.svg',
//                       'assets/plant-growth.svg', 'Progress'),
//                 ],
//               ),
//               const SizedBox(width: 40),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   buildNavItem(3, 'assets/users-people-filled.svg',
//                       'assets/users-people.svg', 'Community'),
//                   buildNavItem(
//                       4, 'assets/menu-filled.svg', 'assets/menu.svg', 'More'),
//                 ],
//               ),
//             ],
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
