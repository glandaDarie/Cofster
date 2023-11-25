import 'package:flutter/material.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart'
    show IconsButton;
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart'
    show IconsOutlineButton;

Future<String> showDeleteConfirmationDialog({
  @required BuildContext context,
  String title = "Delete Account",
  String msg =
      "Are you sure you want to delete your account?\nYou can't recover it later on!",
  double titleSize = 24,
  double msgSize = 14,
  Function cancelFn = null,
  Function deleteFn = null,
}) async {
  msg = msg.replaceAllMapped(RegExp(r'\n\s*'), (match) => '\n' + ' ' * 15);
  try {
    await Dialogs.materialDialog(
      title: title,
      msg: msg,
      color: Colors.white,
      titleStyle: TextStyle(
        color: Colors.brown,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
      msgStyle: TextStyle(
        color: Colors.black,
        fontSize: 14,
      ),
      context: context,
      actions: [
        IconsOutlineButton(
          onPressed: () async {
            if (cancelFn != null) {
              await cancelFn();
            }
          },
          text: "Cancel",
          iconData: Icons.cancel_outlined,
          color: Colors.white,
          textStyle: TextStyle(color: Colors.brown),
          iconColor: Colors.brown,
        ),
        IconsButton(
          onPressed: () async {
            if (deleteFn != null) {
              await deleteFn();
            }
          },
          text: "Delete",
          iconData: Icons.delete,
          color: Colors.brown,
          textStyle: TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
      ],
    );
  } catch (error) {
    return "${error}";
  }
  return null;
}
