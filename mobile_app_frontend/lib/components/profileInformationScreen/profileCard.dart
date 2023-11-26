import 'package:flutter/material.dart';

Card ProfileCard({
  @required String name,
  @required IconData icon,
  @required VoidCallback onTapCallback,
}) {
  return Card(
    color: Colors.white,
    margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    child: ListTile(
      onTap: onTapCallback,
      leading: Icon(icon, color: Colors.black54),
      title: Text(
        name,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      trailing: Icon(Icons.arrow_forward_ios_outlined, color: Colors.black54),
    ),
  );
}
