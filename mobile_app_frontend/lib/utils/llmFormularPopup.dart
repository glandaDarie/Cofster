import 'package:coffee_orderer/utils/formularDialog.dart';
import 'package:flutter/material.dart';

class LlmFormularPopup {
  static void create({
    @required void Function(void Function(Duration duration)) postFrameCallback,
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
  }) {
    msg = msg.replaceAllMapped(RegExp(r"\n\s*"), (match) => "\n" + " " * 8);
    postFrameCallback((_) {
      formularDialog(
        context: context,
        title: title,
        msg: msg,
        proccedIconData: proccedIconData,
        proceedText: proceedText,
        cancelText: cancelText,
        titleSize: titleSize,
        msgSize: msgSize,
        proceedFn: proceedFn,
        cancelFn: cancelFn,
        cancelIconData: cancelIconData,
      );
    });
  }
}
