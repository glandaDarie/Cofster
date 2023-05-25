import 'package:flutter/material.dart';

Widget boxTemperature() {
  bool hotSelected = true;
  toggleTemp() {
    // setState(() {
    hotSelected = !hotSelected;
    // });
  }

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "Temperature",
        style: TextStyle(fontFamily: 'varela', color: Color(0xFF473D3A))
            .copyWith(fontSize: 18, fontWeight: FontWeight.w700),
      ),
      const SizedBox(
        height: 10,
      ),
      Container(
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(25),
            ),
            color: Colors.grey.shade300),
        child: Row(
          children: [
            InkWell(
                onTap: () {
                  toggleTemp();
                },
                child: AnimatedSwitcher(
                  duration: const Duration(seconds: 1),
                  child: hotSelected
                      ? SelectedTempChip("Hot")
                      : UnselectedTempChip("Hot"),
                )),
            InkWell(
              onTap: () {
                toggleTemp();
              },
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: hotSelected
                    ? UnselectedTempChip("Cold")
                    : SelectedTempChip("Cold"),
              ),
            ),
          ],
        ),
      )
    ],
  );
}

Container SelectedTempChip(String tempTitle) {
  return Container(
      decoration: const BoxDecoration(
        color: Colors.brown,
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Text(tempTitle,
          style: TextStyle(fontFamily: 'varela', color: Colors.white)
              .copyWith(fontWeight: FontWeight.bold)));
}

Container UnselectedTempChip(String tempTitle) {
  return Container(
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(
        Radius.circular(25),
      ),
    ),
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
    child: Text(tempTitle,
        style: TextStyle(fontFamily: 'varela', color: Colors.white)
            .copyWith(fontWeight: FontWeight.bold)),
  );
}
