import 'dart:io';

import 'package:flutter/material.dart';

class HomeBottomNavigationBar extends StatelessWidget {
  final int index;
  final Function(int) onTap;
  const HomeBottomNavigationBar(
      {super.key, required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: index,
      onTap: onTap,
      items: [
        const BottomNavigationBarItem(
          label: "Pagina Inicial",
          activeIcon: Icon(
            Icons.home,
          ),
          icon: Icon(
            Icons.home,
            color: Colors.grey,
          ),
        ),
        const BottomNavigationBarItem(
          label: "Configurações",
          activeIcon: Icon(
            Icons.settings,
          ),
          icon: Icon(
            Icons.settings,
            color: Colors.grey,
          ),
        ),
        if (Platform.isWindows)
          const BottomNavigationBarItem(
            label: "Serviço Windows",
            activeIcon: Icon(
              Icons.install_desktop,
            ),
            icon: Icon(
              Icons.install_desktop,
              color: Colors.grey,
            ),
          )
      ],
    );
  }
}
