import 'package:coffee_orderer/models/orderInformation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:coffee_orderer/screens/addNoteScreen.dart';
import 'package:coffee_orderer/data_access/FirebaseOrderInformationDao.dart'
    show FirebaseOrderInformationDao;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _second;
  TextEditingController _third;
  TextEditingController _fourth;
  TextEditingController _fifth;

  _HomeState() {
    this._second = TextEditingController();
    this._third = TextEditingController();
    this._fourth = TextEditingController();
    this._fifth = TextEditingController();
  }

  var l;
  var g;
  var k;
  @override
  Widget build(BuildContext context) {
    final reference = FirebaseDatabase.instance.ref().child('Orders');

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo[900],
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => AddNotePage(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      appBar: AppBar(
        title: const Text(
          'Todos',
          style: TextStyle(
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.indigo[900],
      ),
      body: FirebaseAnimatedList(
        query: reference,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          var v = snapshot.value.toString();
          g = v.replaceAll(
              RegExp(
                  "{|}|communication: |coffeeName: |coffeeStatus: |coffeeFinishTimeEstimation: "),
              "");
          g.trim();
          l = g.split(',');
          // Fluttertoast.showToast(
          //     msg: "v: ${v.toString()}",
          //     toastLength: Toast.LENGTH_SHORT,
          //     backgroundColor: Color.fromARGB(255, 71, 66, 65),
          //     textColor: Color.fromARGB(255, 220, 217, 216),
          //     fontSize: 16);
          // print("v: ${v.toString()}");
          return GestureDetector(
            onTap: () {
              setState(() {
                k = snapshot.key;
              });
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: TextField(
                      controller: this._second,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        hintText: 'communication',
                      ),
                    ),
                  ),
                  content: Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: TextField(
                      controller: this._third,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        hintText: 'coffeeName',
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    MaterialButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      color: const Color.fromARGB(255, 0, 22, 145),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () async {
                        List<OrderInformation> ordersList =
                            await FirebaseOrderInformationDao
                                .getAllOrdersInformation("Orders");
                        for (OrderInformation order in ordersList) {
                          print(order.coffeeName);
                        }
                        // await update();
                        // Navigator.of(ctx).pop();
                      },
                      color: const Color.fromARGB(255, 0, 22, 145),
                      child: const Text(
                        "Update",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  tileColor: Colors.indigo[100],
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Color.fromARGB(255, 255, 0, 0),
                    ),
                    onPressed: () {
                      reference.child(snapshot.key).remove();
                    },
                  ),
                  title: Text(
                    l[1],
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    l[0],
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  dynamic update() async {
    DatabaseReference reference = FirebaseDatabase.instance.ref();

    String newOrderKey = reference.push().key;

    Map<String, dynamic> newOrderData = {
      newOrderKey: {
        "communication": this._second.text,
        "coffeeName": this._third.text,
        "coffeeStatus": this._fourth.text,
        "coffeeFinishTimeEstimation": this._fifth.text
      }
    };

    await reference.update(newOrderData);
    this._second.clear();
    this._third.clear();
    this._fourth.clear();
    this._fifth.clear();
  }
}
