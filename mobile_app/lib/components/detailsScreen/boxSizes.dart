import 'package:flutter/material.dart';
import 'package:coffee_orderer/utils/boxProperties.dart' show sizes;

Widget boxSizes(ValueNotifier selectedSizeNotifier) {
  List<String> sizesAvailable = sizes.keys.cast<String>().toList();
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
                if (selectedSizeNotifier != e) {
                  selectedSizeNotifier.value = e;
                }
              },
              child: SizeLabel(selectedSizeNotifier, e),
            ),
          );
        }).toList(),
      )
    ],
  );
}

Widget SizeLabel(
    final ValueNotifier<String> selectedSizeNotifier, final String size) {
  return ValueListenableBuilder(
      valueListenable: selectedSizeNotifier,
      builder: (BuildContext context, String selectedSize, Widget child) {
        return Text(
          size,
          style: selectedSize == size
              ? const TextStyle(fontFamily: 'varela', color: Color(0xFF473D3A))
                  .copyWith(fontSize: 22, fontWeight: FontWeight.w700)
              : const TextStyle(
                      fontFamily: 'varela',
                      color: Color.fromARGB(255, 177, 160, 152))
                  .copyWith(fontSize: 16, fontWeight: FontWeight.w700),
        );
      });
}
