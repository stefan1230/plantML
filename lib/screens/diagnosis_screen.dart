import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';

class DiagnosisScreen extends StatelessWidget {
  final List<String> imageUrls = [
    'https://via.placeholder.com/300.png',  // Replace with your actual image URLs
    'https://via.placeholder.com/300.png',
    'https://via.placeholder.com/300.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diagnosis'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // Share action
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // More action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chilli Cercospora Leaf Spot',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Fungus',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              // CarouselSlider(
              //   options: CarouselOptions(
              //     height: 200,
              //     enlargeCenterPage: true,
              //     enableInfiniteScroll: false,
              //     initialPage: 0,
              //   ),
              //   items: imageUrls.map((url) {
              //     return ClipRRect(
              //       borderRadius: BorderRadius.circular(8),
              //       child: Image.network(
              //         url,
              //         fit: BoxFit.cover,
              //         width: double.infinity,
              //       ),
              //     );
              //   }).toList(),
              // ),
              SizedBox(height: 8),
              Text(
                '3 photos',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 16),
              // Row(
              //   children: [
              //     Icon(Icons.audiotrack, color: Colors.blue),
              //     SizedBox(width: 8),
              //     Text(
              //       'Listen',
              //       style: TextStyle(
              //         color: Colors.blue,
              //         fontSize: 16,
              //       ),
              //     ),
              //   ],
              // ),
              // Divider(),
              Row(
                children: [
                  Icon(Icons.description, color: Colors.black),
                  SizedBox(width: 8),
                  Text(
                    'Symptoms',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                '• Large concentric brown spots on leaves with whitish center, dark ring and yellow halo (\'frog eye\').\n'
                '• Spots enlarge to become large lesions.\n'
                '• Yellowing and dropping of leaves, exposing fruits to sunscald.\n',
              ),
              SizedBox(height: 8),
              Text(
                'During the initial stage of infection, brownish circular spots with light-gray centers and reddish-brown margins appear on leaves. Later on, they develop into large circular tan spots, up to 1.5 cm in size, formed by dark concentric rings growing around a whitish center. A rough dark ring and a yellow halo gives the spots the characteristic \'frog-eye\' appearance. As the spots become more numerous, they gradually coalesce to form large leaf lesions. The white center often dries and falls out, leaving a \'shot-hole\' effect. At later stages...',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}