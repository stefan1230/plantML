import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CommonAppBar({required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // titleSpacing: ,
      title: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
              color: Colors.black87, fontWeight: FontWeight.w600),
        ),
      ),
      actions: [
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
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => const NotificationsPage()),
                // );
              },
            ),
          ),
      ],
      // backgroundColor: AppColors.MainGreen,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
