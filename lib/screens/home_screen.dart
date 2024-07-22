import 'package:flutter/material.dart';
import 'package:plantdiseaseidentifcationml/commonComponents/common_appbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> items = [
    {
      "title": "Card 1",
      "description": "This is the description for card 1",
    },
    {
      "title": "Card 2",
      "description": "This is the description for card 2",
    },
    {
      "title": "Card 3",
      "description": "This is the description for card 3",
    },
    {
      "title": "Card 4",
      "description": "This is the description for card 4",
    },
    {
      "title": "Card 1",
      "description": "This is the description for card 1",
    },
    {
      "title": "Card 2",
      "description": "This is the description for card 2",
    },
    {
      "title": "Card 3",
      "description": "This is the description for card 3",
    },
    {
      "title": "Card 4",
      "description": "This is the description for card 4",
    },
    {
      "title": "Card 1",
      "description": "This is the description for card 1",
    },
    {
      "title": "Card 2",
      "description": "This is the description for card 2",
    },
    {
      "title": "Card 3",
      "description": "This is the description for card 3",
    },
    {
      "title": "Card 4",
      "description": "This is the description for card 4",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'Home'),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(items[index]["title"]!),
              subtitle: Text(items[index]["description"]!),
              leading: Icon(Icons.info),
            ),
          );
        },
      ),
    );
  }
}
