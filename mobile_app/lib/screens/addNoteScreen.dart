// import 'dart:math';

// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:coffee_orderer/screens/loginScreen.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// class AddNotePage extends StatefulWidget {
//   @override
//   _AddNoteState createState() => _AddNoteState();
// }

// class _AddNoteState extends State<AddNotePage> {
//   TextEditingController second = TextEditingController();
//   TextEditingController third = TextEditingController();

//   int _generateRandomNumber() {
//     var random = Random();
//     return random.nextInt(10000);
//   }

//   @override
//   Widget build(BuildContext context) {
//     var _reference;
//     try {
//       _reference = FirebaseDatabase.instance
//           .ref()
//           .child('Orders')
//           .child('$_generateRandomNumber');
//     } catch (error) {
//       Fluttertoast.showToast(
//           msg: error.toString(),
//           toastLength: Toast.LENGTH_SHORT,
//           backgroundColor: Color.fromARGB(255, 71, 66, 65),
//           textColor: Color.fromARGB(255, 220, 217, 216),
//           fontSize: 16);
//     }
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Add Todos"),
//         backgroundColor: Colors.indigo[900],
//       ),
//       body: Container(
//         child: Column(
//           children: [
//             SizedBox(
//               height: 10,
//             ),
//             Container(
//               decoration: BoxDecoration(border: Border.all()),
//               child: TextField(
//                 controller: second,
//                 decoration: InputDecoration(
//                   hintText: 'title',
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Container(
//               decoration: BoxDecoration(border: Border.all()),
//               child: TextField(
//                 controller: third,
//                 decoration: InputDecoration(
//                   hintText: 'sub title',
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             MaterialButton(
//               color: Colors.indigo[900],
//               onPressed: () async {
//                 print("YES?");
//                 try {
//                   _reference.set({
//                     "title": second.text,
//                     "subtitle": third.text,
//                   }).asStream();
//                   print("SUCCESS");
//                 } catch (error) {
//                   Fluttertoast.showToast(
//                       msg: error.toString(),
//                       toastLength: Toast.LENGTH_SHORT,
//                       backgroundColor: Color.fromARGB(255, 71, 66, 65),
//                       textColor: Color.fromARGB(255, 220, 217, 216),
//                       fontSize: 16);
//                   return;
//                 }
//                 Navigator.pushReplacement(
//                     context, MaterialPageRoute(builder: (_) => Home()));
//               },
//               child: Text(
//                 "save",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 20,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:coffee_orderer/screens/loginScreen.dart';

class AddNotePage extends StatefulWidget {
  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNotePage> {
  TextEditingController _second;
  TextEditingController _third;
  TextEditingController _fourth;

  _AddNoteState() {
    this._second = TextEditingController();
    this._third = TextEditingController();
    this._fourth = TextEditingController();
  }

  int _generateRandomNumber() {
    var random = Random();
    return random.nextInt(10000);
  }

  String _estimatedOrderTime() {
    DateTime currentTime = DateTime.now();
    DateTime estimatedTime = currentTime.add(Duration(seconds: 30));
    return "${estimatedTime.hour}:${estimatedTime.minute}:${estimatedTime.second}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Todos"),
        backgroundColor: Colors.indigo[900],
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(border: Border.all()),
              child: TextField(
                controller: this._second,
                decoration: InputDecoration(
                  hintText: 'communication',
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(border: Border.all()),
              child: TextField(
                controller: this._third,
                decoration: InputDecoration(
                  hintText: 'coffeeName',
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(border: Border.all()),
              child: TextField(
                controller: this._fourth,
                decoration: InputDecoration(
                  hintText: 'coffeeStatus',
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            MaterialButton(
              color: Colors.indigo[900],
              onPressed: () async {
                DatabaseReference ref = FirebaseDatabase.instance
                    .ref()
                    .child("Orders")
                    .child("id_${_generateRandomNumber().toString()}");
                await ref.set({
                  "communication": this._second.text,
                  "coffeeName": this._third.text,
                  "coffeeStatus": this._fourth.text,
                  "coffeeFinishTimeEstimation": this._estimatedOrderTime()
                });
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => Home()));
              },
              child: Text(
                "save",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
