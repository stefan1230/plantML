import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool leading;

  const CommonAppBar({
    required this.title,
    Key? key,
    this.leading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: leading ? 0 : 14,
      backgroundColor: Colors.white,
      elevation: 4, // Add elevation for shadow effect
      shadowColor: Colors.black.withOpacity(0.1), // Customize shadow color
      surfaceTintColor: Colors.transparent,
      leading: leading
          ? IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
      title: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      actions: [
        // Display notification icon if needed
        if (false)
          Container(
            margin: const EdgeInsets.only(top: 0),
            child: IconButton(
              icon: SvgPicture.asset(
                'assets/notification.svg',
                height: 27,
                color: Colors.black,
              ),
              onPressed: () {
                // Uncomment and add your navigation code
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => const NotificationsPage()),
                // );
              },
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
