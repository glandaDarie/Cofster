// import 'package:coffee_orderer/services/communicationSubscriberService.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_core/firebase_core.dart';

// class FirebaseCommunicationSubscriberService
//     implements CommunicationSubscriberService {
//   DatabaseReference _databaseReference;

//   FirebaseCommunicationSubscriberService(this._databaseReference);

//   @override
//   Future<CommunicationSubscriberService> start_listening() async {
//     await Firebase.initializeApp();

//     return this;
//   }
// }

import 'package:coffee_orderer/services/communicationSubscriberService.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

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
