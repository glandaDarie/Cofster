import 'package:flutter/material.dart';

Row ExtraIngredientWidget(String title, String measurement, String image) {
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
      Flexible(flex: 3, child: IngredientCounterWidget(measurement))
    ],
  );
}

Container IngredientCounterWidget(String measure) {
  int count = 1;
  return Container(
    height: 50,
    padding: const EdgeInsets.all(1),
    decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: const BorderRadius.all(Radius.circular(30))),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          child: CircleAvatar(
            radius: 20,
            backgroundColor: count >= 1 ? Colors.brown.shade200 : Colors.grey,
            child: Text(
              "-",
              textScaleFactor: 1.5,
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: 'varela', color: Colors.white)
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          onPressed: () {
            if (count > 0) {
              // setState(() {
              count--;
              // });
            }
          },
        ),
        SizedBox(
          child: Text(
            "$count ${measure} ",
            textAlign: TextAlign.center,
            textScaleFactor: 1.6,
            style:
                const TextStyle(fontFamily: 'varela', color: Color(0xFF473D3A))
                    .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        TextButton(
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.brown.shade200,
            child: Text(
              "+",
              textScaleFactor: 1.5,
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: 'varela', color: Colors.white)
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
  );
}

Row ExtraIngredientWidgetBinary(String title, String image) {
  int count = 1;
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
              TextButton(
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor:
                      count == 1 ? Colors.brown.shade200 : Colors.grey,
                  child: Text(
                    "-",
                    textScaleFactor: 1.5,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                            fontFamily: 'varela', color: Colors.white)
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () {
                  if (count == 1) {
                    // setState(() {
                    count--;
                    // });
                  }
                },
              ),
              SizedBox(
                child: Text(
                  count == 0 ? "No" : "Yes",
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.6,
                  style: const TextStyle(
                          fontFamily: 'varela', color: Color(0xFF473D3A))
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              TextButton(
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor:
                      count == 0 ? Colors.brown.shade200 : Colors.grey,
                  child: Text(
                    "+",
                    textScaleFactor: 1.5,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                            fontFamily: 'varela', color: Colors.white)
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () {
                  if (count == 0) {
                    // setState(() {
                    count++;
                    // });
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
