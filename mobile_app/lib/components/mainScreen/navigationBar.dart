import 'package:flutter/material.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';

FloatingNavbar bottomNavigationBar(int selectedIndex, Function callback) {
  return FloatingNavbar(
    currentIndex: selectedIndex,
    onTap: (int index) {
      callback(index);
    },
    backgroundColor: Color(0xFF473D3A),
    items: [
      FloatingNavbarItem(title: "Home", icon: Icons.home),
      FloatingNavbarItem(title: "Profile", icon: Icons.person),
      FloatingNavbarItem(title: "Orders", icon: Icons.history),
      FloatingNavbarItem(title: "Settings", icon: Icons.settings)
    ],
  );
}
