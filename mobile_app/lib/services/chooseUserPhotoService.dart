import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:coffee_orderer/utils/toast.dart' show ToastUtils;

ImagePicker picker = ImagePicker();

void photoSelector(String selector, Function callback) async {
  if (selector == "gallery") {
    await picker
        .pickImage(source: ImageSource.gallery, imageQuality: 100)
        .then((value) async {
      if (value != null) {
        String response = await cropImage(File(value.path), callback);
        if (response != null) {
          ToastUtils.showToast("Could not crop the image");
          return null;
        }
      }
    });
  } else if (selector == "camera") {
    await picker
        .pickImage(source: ImageSource.camera, imageQuality: 100)
        .then((value) async {
      if (value != null) {
        String response = await cropImage(File(value.path), callback);
        if (response != null) {
          ToastUtils.showToast("Could not crop the image");
          return null;
        }
      }
    });
  } else {
    ToastUtils.showToast("Error when selecting available selectors");
    return null;
  }
}

Future<String> cropImage(File imgFile, Function callback) async {
  String errorMsg;
  try {
    final croppedFile = await ImageCropper().cropImage(
        sourcePath: imgFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: "Crop image",
              toolbarColor: Colors.brown,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: "Crop the image",
          )
        ]);
    if (croppedFile != null) {
      callback(croppedFile);
      imageCache.clear();
    }
  } catch (e) {
    ToastUtils.showToast("Image could not be updated, exception: ${e}");
    return null;
  }
  return errorMsg;
}

Future<bool> selectAccessPermissions() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.storage,
    Permission.camera,
  ].request();

  if (statuses[Permission.storage].isGranted &&
      statuses[Permission.camera].isGranted) {
    return true;
  }
  return false;
}
