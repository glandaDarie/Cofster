import 'package:flutter/material.dart';
import 'package:coffee_orderer/screens/orderScreen.dart';
import 'package:coffee_orderer/controllers/OrderInformationController.dart'
    show OrderInformationController;

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

  String _estimatedOrderTime() {
    DateTime currentTime = DateTime.now();
    DateTime estimatedTime = currentTime.add(Duration(seconds: 30));
    return "${estimatedTime.hour}:${estimatedTime.minute}:${estimatedTime.second}";
  }

  String _currentOrderTime() {
    DateTime currentTime = DateTime.now();
    return "${currentTime.hour}:${currentTime.minute}:${currentTime.second}";
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
                Map<String, dynamic> content = {
                  "coffeeName": "cold brew",
                  "coffeePrice": "4.29\$",
                  "quantity": 1,
                  "communication": "broadcast",
                  "coffeeStatus": 1,
                  "coffeeOrderTime": _currentOrderTime(),
                  "coffeeFinishTimeEstimation": _estimatedOrderTime(),
                };
                OrderInformationController.postOrderToOrdersInformation(
                    "Orders", content,
                    providerContext: context);
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => OrderPage()));
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
