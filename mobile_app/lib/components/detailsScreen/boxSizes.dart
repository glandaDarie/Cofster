import 'package:flutter/material.dart';

Widget boxSizes() {
  String selectedSize = "M";
  List sizesAvailable = ["S", "M", "L"];
  return Row(
    children: [
      Text(
        "Select Size",
        style: TextStyle(fontFamily: 'varela', color: Color(0xFF473D3A))
            .copyWith(fontSize: 18, fontWeight: FontWeight.w700),
      ),
      Spacer(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: sizesAvailable.map((e) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: InkWell(
              onTap: () {
                if (selectedSize != e) {
                  //callback here
                  // setState(() {
                  selectedSize = e;
                  // });
                }
              },
              child: SizeLabel(selectedSize, e),
            ),
          );
        }).toList(),
      )
    ],
  );
}

Widget SizeLabel(final String selectedSize, final String size) {
  return Text(
    size,
    style: selectedSize == size
        ? const TextStyle(fontFamily: 'varela', color: Color(0xFF473D3A))
            .copyWith(fontSize: 22, fontWeight: FontWeight.w700)
        : const TextStyle(
                fontFamily: 'varela', color: Color.fromARGB(255, 177, 160, 152))
            .copyWith(fontSize: 16, fontWeight: FontWeight.w700),
  );
}
