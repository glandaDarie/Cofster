import 'package:flutter/material.dart';

Row ExtraIngredientWidget(ValueNotifier<int> quantityNotifier, String title,
    String measurement, String image) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Flexible(
        flex: 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child: Image.asset(image),
            ),
            Text(
              title,
              style: const TextStyle(
                      fontFamily: 'varela',
                      color: Color.fromARGB(255, 177, 160, 152))
                  .copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
      Flexible(
          flex: 3,
          child: IngredientCounterWidget(quantityNotifier, measurement))
    ],
  );
}

Container IngredientCounterWidget(
    ValueNotifier<int> quantityNotifier, String measure) {
  return Container(
    height: 50,
    padding: const EdgeInsets.all(1),
    decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: const BorderRadius.all(Radius.circular(30))),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          child: ValueListenableBuilder<int>(
              valueListenable: quantityNotifier,
              builder: (BuildContext context, int quantity, Widget child) {
                return CircleAvatar(
                  radius: 20,
                  backgroundColor:
                      quantity >= 1 ? Colors.brown.shade200 : Colors.grey,
                  child: Text(
                    "-",
                    textScaleFactor: 1.5,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                            fontFamily: 'varela', color: Colors.white)
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                );
              }),
          onTap: () {
            if (quantityNotifier.value > 0) {
              quantityNotifier.value -= 1;
            }
          },
        ),
        ValueListenableBuilder<int>(
            valueListenable: quantityNotifier,
            builder: (BuildContext context, int quantity, Widget child) {
              return SizedBox(
                child: Text(
                  "${quantity} ${measure} ",
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.6,
                  style: const TextStyle(
                          fontFamily: 'varela', color: Color(0xFF473D3A))
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              );
            }),
        InkWell(
          child: ValueListenableBuilder<int>(
            valueListenable: quantityNotifier,
            builder: (BuildContext context, int quantity, Widget child) {
              return CircleAvatar(
                radius: 20,
                backgroundColor: Colors.brown.shade200,
                child: Text(
                  "+",
                  textScaleFactor: 1.5,
                  textAlign: TextAlign.center,
                  style:
                      const TextStyle(fontFamily: 'varela', color: Colors.white)
                          .copyWith(fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
          onTap: () {
            quantityNotifier.value += 1;
          },
        ),
      ],
    ),
  );
}

Row ExtraIngredientWidgetBinary(
    ValueNotifier<int> creamNotifier, String title, String image) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Flexible(
        flex: 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              width: 55,
              child: Image.asset(
                image,
              ),
            ),
            Text(
              title,
              textScaleFactor: 1.1,
              style: const TextStyle(
                      fontFamily: 'varela',
                      color: Color.fromARGB(255, 177, 160, 152))
                  .copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
      Flexible(
        flex: 3,
        child: Container(
          height: 50,
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: const BorderRadius.all(Radius.circular(30))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                child: ValueListenableBuilder<int>(
                    valueListenable: creamNotifier,
                    builder: (BuildContext context, int cream, Widget child) {
                      print("Cream = ${cream}");
                      return CircleAvatar(
                        radius: 20,
                        backgroundColor:
                            cream == 1 ? Colors.brown.shade200 : Colors.grey,
                        child: Text(
                          "-",
                          textScaleFactor: 1.5,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                                  fontFamily: 'varela', color: Colors.white)
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      );
                    }),
                onTap: () {
                  if (creamNotifier.value == 1) {
                    creamNotifier.value -= 1;
                  }
                },
              ),
              ValueListenableBuilder(
                  valueListenable: creamNotifier,
                  builder: (BuildContext context, int cream, Widget child) {
                    return SizedBox(
                      child: Text(
                        cream == 0 ? "No" : "Yes",
                        textAlign: TextAlign.center,
                        textScaleFactor: 1.6,
                        style: const TextStyle(
                                fontFamily: 'varela', color: Color(0xFF473D3A))
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    );
                  }),
              InkWell(
                child: ValueListenableBuilder<int>(
                    valueListenable: creamNotifier,
                    builder: (BuildContext context, int cream, Widget child) {
                      return CircleAvatar(
                        radius: 20,
                        backgroundColor:
                            cream == 0 ? Colors.brown.shade200 : Colors.grey,
                        child: Text(
                          "+",
                          textScaleFactor: 1.5,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                                  fontFamily: 'varela', color: Colors.white)
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      );
                    }),
                onTap: () {
                  if (creamNotifier.value == 0) {
                    creamNotifier.value += 1;
                  }
                },
              ),
            ],
          ),
        ),
      )
    ],
  );
}
