import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

// class PlantDiseaseDetector extends StatefulWidget {
//   final File image;

//   @override
//   _PlantDiseaseDetectorState createState() => _PlantDiseaseDetectorState();
// }

class PlantDiseaseDetector extends StatefulWidget {
  final File image;

  PlantDiseaseDetector({required this.image});

  @override
  _PlantDiseaseDetectorState createState() => _PlantDiseaseDetectorState();
}

class _PlantDiseaseDetectorState extends State<PlantDiseaseDetector> {
  final picker = ImagePicker();
  File? _image;
  Interpreter? _interpreter;
  List<String> _labels = [];
  String _result = 'No result';

  @override
  void initState() {
    super.initState();
    loadModelAndLabels();
    classifyImage(widget.image);
  }

  // Load the TFLite model and labels
  Future<void> loadModelAndLabels() async {
    try {
      _interpreter =
          await Interpreter.fromAsset('assets/plant_disease_model.tflite');
      print("Model loaded successfully");

      // Load labels
      final labelsData =
          await DefaultAssetBundle.of(context).loadString('assets/labels.txt');
      setState(() {
        _labels =
            labelsData.split('\n').where((label) => label.isNotEmpty).toList();
      });
    } catch (e) {
      print("Error loading model or labels: $e");
    }
  }

  // Pick an image from the gallery or camera
  Future<void> pickImage(ImageSource source) async {
    try {
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        await classifyImage(_image!);
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  // Preprocess the image and classify it
  Future<void> classifyImage(File image) async {
    try {
      // Load and preprocess the image
      var inputImage = img.decodeImage(File(image.path).readAsBytesSync())!;
      inputImage = img.copyResize(inputImage, width: 224, height: 224);

      // Convert image to a 4D input tensor
      var input = _imageToByteListFloat32(inputImage, 224, 224);

      // Prepare output tensor
      var output = List.filled(16, 0).reshape([1, 16]);

      // Run inference
      _interpreter?.run(input, output);

      // Get the result with the highest probability
      var scores = output[0] as List<double>;

      // Debugging: Print each score and corresponding label
      for (int i = 0; i < scores.length; i++) {
        print('${_labels[i]}: ${scores[i]}');
      }

      // Find the index of the highest score
      int maxScoreIndex = scores.indexWhere(
          (score) => score == scores.reduce((a, b) => a > b ? a : b));
      double confidenceThreshold = 0.6; // Set a confidence threshold

      setState(() {
        if (scores[maxScoreIndex] >= confidenceThreshold) {
          // If the confidence is above the threshold, show the result
          _result = _labels.isNotEmpty && maxScoreIndex < _labels.length
              ? _labels[maxScoreIndex]
              : "Unknown disease";
        } else {
          // If below threshold, show low confidence message
          _result = "Unknown disease (low confidence)";
        }
      });
    } catch (e) {
      print("Error during classification: $e");
    }
  }

  // Convert image to ByteData for input tensor
  Uint8List _imageToByteListFloat32(img.Image image, int width, int height) {
    var buffer = Float32List(width * height * 3);
    int pixelIndex = 0;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        var pixel = image.getPixel(x, y);
        buffer[pixelIndex++] = (img.getRed(pixel) / 255.0); // R
        buffer[pixelIndex++] = (img.getGreen(pixel) / 255.0); // G
        buffer[pixelIndex++] = (img.getBlue(pixel) / 255.0); // B
      }
    }
    return buffer.buffer.asUint8List();
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Plant Disease Detector")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image != null
                ? Image.file(_image!)
                : Text("Select an image", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text(
              "Result: $_result",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => pickImage(ImageSource.gallery),
              child: Text("Pick Image from Gallery"),
            ),
            ElevatedButton(
              onPressed: () => pickImage(ImageSource.camera),
              child: Text("Take a Photo"),
            ),
          ],
        ),
      ),
    );
  }
}
