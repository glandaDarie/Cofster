import 'package:flutter/material.dart';

Widget profileInformation() {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: Container(
        color: Colors.brown.shade700,
        child: Column(
          children: [
            SizedBox(height: 70),
            Center(
              child: CircleAvatar(
                maxRadius: 65,
                backgroundImage:
                    AssetImage("assets/images/no_profile_image.jpg") ??
                        AssetImage("assets/images/no_profile_image.jpg"),
                // MemoryImage(SnapshotController) ??
                //     AssetImage("assets/images/no_profile_image.jpg"),
              ),
            ),
            SizedBox(height: 15),
            Center(
              child: Text(
                "Thomas Shelby",
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 26,
                    color: Colors.white),
              ),
            ),
            Center(
              child: Text(
                "@peakyBlinders", // email address if fetched from the local storage
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  _buildProfileCard(Icons.privacy_tip_sharp, "Privacy", () {
                    print("Privacy");
                  }),
                  _buildProfileCard(Icons.history, "Purchase History", () {
                    print("Purchase History");
                  }),
                  _buildProfileCard(Icons.help_outline, "Help & Support", () {
                    print("Help & Support");
                  }),
                  _buildProfileCard(Icons.privacy_tip_sharp, "Settings", () {
                    print("Settings");
                  }),
                  _buildProfileCard(Icons.add_reaction_sharp, "Invite a Friend",
                      () {
                    print("Invite a Friend");
                  }),
                  _buildProfileCard(Icons.logout, "Logout", () {
                    print("Logout");
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Card _buildProfileCard(
    IconData icon, String title, VoidCallback onTapCallback) {
  return Card(
    color: Colors.white,
    margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    child: ListTile(
      onTap: onTapCallback,
      leading: Icon(icon, color: Colors.black54),
      title: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      trailing: Icon(Icons.arrow_forward_ios_outlined, color: Colors.black54),
    ),
  );
}
