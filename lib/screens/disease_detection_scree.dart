import 'package:flutter/material.dart';

class DiseaseDetectionScreen4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Confirm a diagnosis'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _buildInfoCard(),
          SizedBox(height: 16.0),
          _buildDiseaseCard(
            title: 'Healthy Plant',
            description: [
              'Dark green colored plant.',
              'Firm leaves.',
              'Brightly colored flowers.',
              'Well-shaped, good-colored, nutritious grains, pods or fruits.',
              'Root system is well developed.',
            ],
            images: [
              'assets/healthy.jpg',
              'assets/healthy1.jpg',
              'assets/healthy1.jpg',
            ],
            buttonText: 'Show more',
          ),
          SizedBox(height: 16.0),
          _buildDiseaseCard(
            title: 'Potato Beetle',
            description: [
              'Larva is orange to red with black spots, and can be 1/2 inches long when fully grown.',
              'Both the larva and adult eat the leaf margins and entire leaves of the plant.',
            ],
            images: [
              'assets/healthy.jpg',
              'assets/healthy.jpg',
              'assets/healthy.jpg',
            ],
            buttonText: 'See diagnosis',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Icon(Icons.info, color: Colors.blue),
          SizedBox(width: 8.0),
          Expanded(
            child: Text(
              'Please check if any of the below diseases match the damage on your crop',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiseaseCard({
    required String title,
    required List<String> description,
    required List<String> images,
    required String buttonText,
  }) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Row(
            children: [
              Icon(Icons.description, color: Colors.black),
              SizedBox(width: 4.0),
              Text(
                title == 'Healthy Plant' ? 'Characteristics' : 'Symptoms',
                style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          ...description.map((desc) => Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text('• $desc'),
              )),
          SizedBox(height: 8.0),
          Row(
            children: images.map((image) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: Image.asset(
                      image,
                      height: 80.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 16.0),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: Text(buttonText),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    title == 'Healthy Plant' ? Colors.blue[100] : Colors.blue,
                foregroundColor: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
