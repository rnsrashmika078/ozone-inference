import 'package:flutter/material.dart';
import 'package:inference/screens/settings_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      
      backgroundColor: Colors.blue,
      leading: Builder(
        builder: (context) => IconButton(
          color: Colors.white,
          iconSize: 32,
          onPressed: () => Scaffold.of(context).openDrawer(),
          icon: const Icon(Icons.dehaze),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
          },
          icon: const Icon(Icons.settings, size: 32, color: Colors.white),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
