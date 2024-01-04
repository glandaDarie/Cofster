import 'package:flutter/material.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart'
    show IconsButton;
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart'
    show IconsOutlineButton;

Future<String> formularDialog({
  @required final BuildContext context,
  @required final String title,
  @required String msg,
  @required final IconData proccedIconData,
  @required final String proceedText,
  @required final String cancelText,
  final double titleSize = 24,
  final double msgSize = 14,
  final Function cancelFn = null,
  final Function proceedFn = null,
  IconData cancelIconData = Icons.cancel_outlined,
}) async {
  String errorMsg = null;
  msg = msg.replaceAllMapped(RegExp(r"\n\s*"), (match) => "\n" + " " * 15);
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
          text: cancelText,
          iconData: cancelIconData,
          color: Colors.white,
          textStyle: TextStyle(color: Colors.brown),
          iconColor: Colors.brown,
        ),
        IconsButton(
          onPressed: () async {
            if (proceedFn != null) {
              await proceedFn(context);
            }
          },
          text: proceedText,
          iconData: proccedIconData,
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
