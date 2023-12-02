import 'package:flutter/material.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart'
    show IconsButton;
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart'
    show IconsOutlineButton;

Future<String> showDeleteConfirmationDialog({
  @required BuildContext context,
  final String title = "Delete Account",
  String msg =
      "Are you sure you want to delete your account?\nYou can't recover it later on!",
  final double titleSize = 24,
  final double msgSize = 14,
  final Function cancelFn = null,
  final Function deleteFn = null,
}) async {
  String errorMsg = null;
  msg = msg.replaceAllMapped(RegExp(r'\n\s*'), (match) => '\n' + ' ' * 15);
  try {
    await Dialogs.bottomMaterialDialog(
      context: context,
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
      actions: [
        IconsOutlineButton(
          onPressed: () {
            if (cancelFn != null) {
              cancelFn(context);
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
              await deleteFn(context);
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
    errorMsg = error.toString();
  }
  return errorMsg;
}
