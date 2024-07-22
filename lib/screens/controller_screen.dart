import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:plantdiseaseidentifcationml/app_color.dart';
import 'package:plantdiseaseidentifcationml/screens/community_screen.dart';
import 'package:plantdiseaseidentifcationml/screens/home_screen.dart';
import 'package:plantdiseaseidentifcationml/screens/menu_screen.dart';
import 'package:plantdiseaseidentifcationml/screens/progress_tracker_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ControllerScreen extends StatefulWidget {
  const ControllerScreen({super.key});

  @override
  State<ControllerScreen> createState() => _ControllerScreenState();
}

class _ControllerScreenState extends State<ControllerScreen> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const ProgressTrackerScreen(),
    const ProgressTrackerScreen(),
    // const CameraScreen(),
    const CommunityScreen(),
    const MenuScreen(),
  ];

  // final ImagePicker _picker = ImagePicker();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showImagePickerOptions() {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Container(
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
                  // _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Future<void> _pickImage(ImageSource source) async {
  //   final XFile? image = await _picker.pickImage(source: source);
  //   if (image != null) {
  //     // Handle the picked image
  //     print('Image picked: ${image.path}');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      floatingActionButton: SizedBox(
        height: 65, // Increase the size
        width: 65, // Increase the size
        child: FloatingActionButton(
          onPressed: _showImagePickerOptions,
          backgroundColor: AppColors.MainGreen, // Increase icon size
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
        shape: CircularNotchedRectangle(),
        notchMargin: 5,
        child: Container(
          height: 60,
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
          SizedBox(height: 4), // Gap between icon and text
          Text(
            label,
            style: TextStyle(
              color:
                  _selectedIndex == index ? AppColors.MainGreen : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Search Screen',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
