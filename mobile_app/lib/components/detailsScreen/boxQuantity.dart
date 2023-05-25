import 'package:flutter/material.dart';

Column boxQuantity(ValueNotifier<int> quantityCountNotifier) {
  return Column(
    children: [
      Text(
        "Quantity",
        style: const TextStyle(fontFamily: 'varela', color: Color(0xFF473D3A))
            .copyWith(fontSize: 18, fontWeight: FontWeight.w700),
      ),
      Row(
        children: [
          TextButton(
            child: ValueListenableBuilder<int>(
              valueListenable: quantityCountNotifier,
              builder: (BuildContext context, int quantityCount, Widget child) {
                return CircleAvatar(
                  radius: 16,
                  backgroundColor:
                      quantityCount >= 2 ? Colors.brown.shade200 : Colors.grey,
                  child: Text(
                    "-",
                    textScaleFactor: 1.5,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                            fontFamily: "varela", color: Colors.white)
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
            onPressed: () {
              if (quantityCountNotifier.value > 1) {
                quantityCountNotifier.value -= 1;
              }
            },
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              final position =
                  Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
                      .animate(animation);
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: position,
                  child: child,
                ),
              );
            },
            child: ValueListenableBuilder<int>(
              valueListenable: quantityCountNotifier,
              builder: (BuildContext context, int quantityCount, Widget child) {
                return Text(
                  quantityCount.toString(),
                  textScaleFactor: 2.0,
                  style:
                      TextStyle(fontFamily: 'varela', color: Color(0xFF473D3A))
                          .copyWith(fontWeight: FontWeight.bold),
                );
              },
            ),
          ),
          TextButton(
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.brown.shade200,
              child: Text(
                "+",
                textScaleFactor: 1.5,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontFamily: 'varela', color: Colors.white)
                        .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            onPressed: () {
              quantityCountNotifier.value += 1;
            },
          ),
        ],
      ),
    ],
  );
}
