import 'package:flutter/material.dart';
import 'package:coffee_orderer/utils/drinkMadeByOrderType.dart'
    show OrderType, orderTypes;

Widget boxDrinkMadeBy(ValueNotifier<OrderType> orderTypeNotifier) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "Drink Made By",
        style: TextStyle(fontFamily: "varela", color: Color(0xFF473D3A))
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
                orderTypeNotifier.value = OrderType.llm;
              },
              child: AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: ValueListenableBuilder<OrderType>(
                  valueListenable: orderTypeNotifier,
                  builder: (BuildContext context, OrderType orderType,
                      Widget child) {
                    return orderType.index == 0
                        ? SelectedTempChip(orderTypes[OrderType.llm])
                        : UnselectedTempChip(orderTypes[OrderType.llm]);
                  },
                ),
              ),
            ),
            InkWell(
              onTap: () {
                orderTypeNotifier.value = OrderType.recipe;
              },
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: ValueListenableBuilder<OrderType>(
                  valueListenable: orderTypeNotifier,
                  builder: (BuildContext context, OrderType orderType,
                      Widget child) {
                    return orderType.index == 0
                        ? UnselectedTempChip(orderTypes[OrderType.recipe])
                        : SelectedTempChip(orderTypes[OrderType.recipe]);
                  },
                ),
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
            .copyWith(fontWeight: FontWeight.bold)),
  );
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
