import 'package:flutter/material.dart';

Column boxQuantity() {
  int count = 1;
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
            child: CircleAvatar(
              radius: 16,
              backgroundColor: count >= 2 ? Colors.brown.shade200 : Colors.grey,
              child: Text(
                "-",
                textScaleFactor: 1.5,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontFamily: 'varela', color: Colors.white)
                        .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            onPressed: () {
              if (count > 1) {
                // setState(() {
                count--;
                // });
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
            child: Text(
              count.toString(),
              textScaleFactor: 2.0,
              style: TextStyle(fontFamily: 'varela', color: Color(0xFF473D3A))
                  .copyWith(fontWeight: FontWeight.bold),
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
              // setState(() {
              count++;
              // });
            },
          ),
        ],
      ),
    ],
  );
}
