import 'package:flutter/material.dart';
import 'package:coffee_orderer/models/orderInformation.dart';
import 'package:coffee_orderer/services/communicationSubscriberService.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:coffee_orderer/services/passwordGeneratorService.dart'
    show generateNewPassword;

class FirebaseCommunicationSubscriberService
    implements CommunicationSubscriberService {
  DatabaseReference _databaseReference;

  static final FirebaseCommunicationSubscriberService _instance =
      FirebaseCommunicationSubscriberService._internal();

  factory FirebaseCommunicationSubscriberService() => _instance;

  FirebaseCommunicationSubscriberService._internal();

  Future<DatabaseReference> _initDatabaseReference(
      DatabaseReference databaseReference) async {
    if (databaseReference == null) {
      await Firebase.initializeApp();
      return FirebaseDatabase.instance.ref().child('your_data_path');
    }
    return databaseReference;
  }

  Future<CommunicationSubscriberService> publish(
      OrderInformation content) async {
    DatabaseReference reference;
    try {
      String id = generateNewPassword();
      reference = FirebaseDatabase.instance
          .ref()
          .child("oder_id_${id}")
          .child("Orders");
      await reference.set(content);
    } catch (error) {
      Fluttertoast.showToast(
          msg: "Error when publishing the data to the broker: ${error}",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Color.fromARGB(255, 71, 66, 65),
          textColor: Color.fromARGB(255, 220, 217, 216),
          fontSize: 16);
      return null;
    }

    return this;

    // .child("id_${_generateRandomNumber().toString()}");

    // await ref.set({
    //   "communication": this._second.text,
    //   "coffeeName": this._third.text,
    //   "coffeeStatus": this._fourth.text,
    //   "coffeeFinishTimeEstimation": _estimatedOrderTime()
    // });
  }

  @override
  Future<CommunicationSubscriberService> listen() async {
    this._databaseReference =
        await this._initDatabaseReference(this._databaseReference);
    // Set up the real-time listener

    // this._databaseReference.onValue.listen((Event event) {
    //   // Handle real-time database changes
    // });
    return this;
  }
}
