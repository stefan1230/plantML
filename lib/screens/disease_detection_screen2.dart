import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class DiseaseDetectionScreen extends StatefulWidget {
  final File image;

  DiseaseDetectionScreen({required this.image});

  @override
  _DiseaseDetectionScreenState createState() => _DiseaseDetectionScreenState();
}

class _DiseaseDetectionScreenState extends State<DiseaseDetectionScreen> {
  late Interpreter _interpreter;
  List<String> _labels = [];
  String _result = "Detecting...";

  @override
  void initState() {
    super.initState();
    loadModelAndLabels();
    classifyImage(widget.image);
  }

  Future<void> loadModelAndLabels() async {
    try {
      // Load TFLite model
      _interpreter =
          await Interpreter.fromAsset('assets/plant_disease_model.tflite');

      // Load labels
      final labelsData =
          await DefaultAssetBundle.of(context).loadString('assets/labels.txt');
      _labels =
          labelsData.split('\n').where((label) => label.isNotEmpty).toList();
      print(_labels);
    } catch (e) {
      print("Error loading model or labels: $e");
    }
  }

  Future<void> classifyImage(File image) async {
    try {
      // Load and preprocess the image
      var inputImage = img.decodeImage(image.readAsBytesSync())!;
      inputImage = img.copyResize(inputImage, width: 224, height: 224);

      // Convert image to a 4D input tensor
      var input = imageToByteListFloat32(inputImage, 224, 224);

      // Verify output size matches the labels
      if (_labels.isEmpty) {
        print("Error: Labels are not loaded or empty.");
        setState(() {
          _result = "Error: No labels found";
        });
        return;
      }

      var output = List.filled(_labels.length, 0).reshape([1, _labels.length]);

      // Run inference
      _interpreter.run(input, output);

      // Get the result with the highest probability
      var scores = output[0] as List<double>;
      int maxScoreIndex = scores.indexWhere(
          (score) => score == scores.reduce((a, b) => a > b ? a : b));

      setState(() {
        _result =
            "${_labels[maxScoreIndex]} (Confidence: ${(scores[maxScoreIndex] * 100).toStringAsFixed(2)}%)";
      });
    } catch (e) {
      print("Error during classification: $e");
      setState(() {
        _result = "Classification error. Check model and labels.";
      });
    }
  }

  Uint8List imageToByteListFloat32(img.Image image, int width, int height) {
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
    _interpreter.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Disease Detection")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.file(widget.image, height: 250),
            SizedBox(height: 20),
            Text(
              _result,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
