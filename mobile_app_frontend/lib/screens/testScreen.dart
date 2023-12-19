import 'package:flutter/material.dart';
import 'dart:async';
import 'package:coffee_orderer/providers/testScreenProvider.dart'
    show TestScreenProvider;
import 'package:provider/provider.dart';
import 'package:coffee_orderer/components/profileInformationScreen/deleteUserDialog.dart'
    show showDeleteConfirmationDialog;
import 'package:coffee_orderer/utils/logger.dart' show LOGGER;

// only for debugging a mini test
class TestScreen extends StatefulWidget {
  const TestScreen({Key key}) : super(key: key);

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  void startWaitingTimer({
    @required BuildContext context,
    @required int seconds,
  }) {
    Timer(Duration(seconds: seconds), () {
      context.read<TestScreenProvider>().changeFlag();
    });
  }

  Future<String> displayDialog({@required BuildContext context}) async {
    Future.delayed(
      Duration(milliseconds: 300),
      () {
        try {
          showDeleteConfirmationDialog(
            context: context,
            title: "Formular completion",
            msg: "Make your drink better?\nTell us what we can improve",
            proccedIconData: Icons.delete,
            proceedText: "Rate",
            cancelText: "Cancel",
            cancelFn: () {},
            proceedFn: () {},
          );
        } catch (error) {
          LOGGER.e("Error displaying dialog: ${error}");
          throw (Exception(error));
        }
      },
    );
    return "Displaying a random message";
  }

  @override
  Widget build(BuildContext context) {
    // should be triggered from other place with using callbacks
    startWaitingTimer(
      context: context,
      seconds: 10,
    );
    return Scaffold(
      body: Center(
        child: context.watch<TestScreenProvider>().flag
            ? FutureBuilder<String>(
                future: displayDialog(context: context),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  String data = snapshot.data;
                  return Text(data);
                },
              )
            : Text("Waiting for change..."),
      ),
    );
  }
}
