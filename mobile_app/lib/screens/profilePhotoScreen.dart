import 'dart:io';
import 'dart:convert';
import 'package:coffee_orderer/controllers/AuthController.dart';
import 'package:coffee_orderer/controllers/UserController.dart';
import 'package:flutter/material.dart';
import 'package:coffee_orderer/services/chooseUserPhotoService.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:coffee_orderer/utils/localUserInformation.dart';
import 'package:coffee_orderer/screens/questionnaireScreen.dart';

class ProfilePhotoPage extends StatefulWidget {
  const ProfilePhotoPage({Key key}) : super(key: key);

  @override
  State<ProfilePhotoPage> createState() => _ProfilePhotoPageState();
}

class _ProfilePhotoPageState extends State<ProfilePhotoPage>
    with SingleTickerProviderStateMixin {
  File imageFile;
  AuthController authController;
  UserController userController;

  _ProfilePhotoPageState() {
    this.authController = AuthController();
    this.userController = UserController();
    this.imageFile = null;
  }

  callback(CroppedFile file) {
    setState(() {
      this.imageFile = File(file.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6E2D3),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 180),
            FutureBuilder<String>(
                future: this.authController.getNameFromCache(),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      "${snapshot.data}, please select a photo",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A3731),
                      ),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
            const SizedBox(
              height: 30.0,
            ),
            this.imageFile == null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(150.0),
                    child: Image.asset(
                      "assets/images/no_profile_image.jpg",
                      height: 300.0,
                      width: 300.0,
                    ))
                : ClipRRect(
                    borderRadius: BorderRadius.circular(150.0),
                    child: Image.file(
                      this.imageFile,
                      height: 300.0,
                      width: 300.0,
                      fit: BoxFit.fill,
                    )),
            const SizedBox(
              height: 50.0,
            ),
            ElevatedButton(
              onPressed: () async {
                bool correctPermissions = await selectAccessPermissions();
                correctPermissions
                    ? showImagePicker(context)
                    : Fluttertoast.showToast(
                        msg: "No permission provided",
                        toastLength: Toast.LENGTH_SHORT,
                        backgroundColor: Color.fromARGB(255, 102, 33, 12),
                        textColor: Color.fromARGB(255, 220, 217, 216),
                        fontSize: 16);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.photo_library),
                  SizedBox(width: 8),
                  Text(
                    "Select image",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF8C6F51),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            ElevatedButton(
              onPressed: () async {
                String cacheStr = await loadUserInformationFromCache();
                Map<String, String> cache = fromStringCachetoMapCache(cacheStr);
                List<int> photoToBytes = await this.imageFile.readAsBytes();
                String base64Photo = base64Encode(photoToBytes);
                Map<String, String> content = {
                  "filename": "${cache['name'].toLowerCase()}_photo.jpg",
                  "photo": base64Photo,
                };
                await this.userController.uploadUsersPhotoToS3(content);
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => QuestionnairePage()));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.photo_library),
                  SizedBox(width: 8),
                  Text(
                    "Save image",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF8C6F51),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Card(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 5.2,
                margin: const EdgeInsets.only(top: 8.0),
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: InkWell(
                      child: Column(
                        children: const [
                          Icon(
                            Icons.image,
                            color: Color(0xFF8C6F51),
                            size: 60.0,
                          ),
                          SizedBox(height: 12.0),
                          Text(
                            "Gallery",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.brown),
                          )
                        ],
                      ),
                      onTap: () {
                        photoSelector("gallery", callback);
                        Navigator.pop(context);
                      },
                    )),
                    Expanded(
                        child: InkWell(
                      child: SizedBox(
                        child: Column(
                          children: const [
                            Icon(
                              Icons.camera_alt,
                              color: Color(0xFF8C6F51),
                              size: 60.0,
                            ),
                            SizedBox(height: 12.0),
                            Text(
                              "Camera",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.brown),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        photoSelector("camera", callback);
                        Navigator.pop(context);
                      },
                    ))
                  ],
                )),
          );
        });
  }
}
