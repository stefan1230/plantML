import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PlantHelpScreen(),
    );
  }
}

class PlantHelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plantix Help'),
        backgroundColor: Colors.green[700],
      ),
      body: ListView(
        padding: EdgeInsets.all(12.0),
        children: [
          _buildUserPost(),
          SizedBox(height: 20),
          _buildExpertResponse(),
          SizedBox(height: 20),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildUserPost() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  AssetImage('assets/user_icon.png'), // Dummy user image
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sanjana Silva • Sri Lanka',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('26 d • 🌶 Capsicum & Chilli'),
              ],
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          'Help identifying problem with my Capsicum & Chilli',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 10),
        Text(
          'Plantix has detected a possible problem with my Capsicum & Chilli. I was given a few possibilities: '
          '🌿 Chilli Leaf Curl Virus, 🌿 Cucumber Mosaic Virus of Pepper, 🌿 Bacterial Spot of Pepper. '
          'Can you help me identifying the issue?',
        ),
        SizedBox(height: 10),
        Container(
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/plant_image.jpg'), // Dummy plant image
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
  }

  Widget _buildExpertResponse() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(
                    'assets/user_icon.png'), // Dummy user image for expert
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Venkat P',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('961756'),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            '@Sanjana Silva',
            style: TextStyle(color: Colors.blue),
          ),
          SizedBox(height: 8),
          Text.rich(
            TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(Icons.bookmark, color: Colors.blue, size: 20),
                ),
                TextSpan(
                  text: ' Chilli Thrips\n',
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      'Click on above mentioned green link that will divert us to Plantix library for detailed information along with effective precautionary and curative measures.\n\n'
                      'If you feel satisfied with our answer then please click on SOLVED button. Thank you 🙏🙏😊😊🌱',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Write your answer',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
        SizedBox(width: 8),
        IconButton(
          icon: Icon(Icons.send, color: Colors.green),
          onPressed: () {},
        ),
      ],
    );
  }
}
