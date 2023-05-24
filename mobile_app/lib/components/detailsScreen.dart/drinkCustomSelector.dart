import 'package:flutter/material.dart';

SizedBox customizer(BuildContext context) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.72,
    child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.cancel_sharp,
                      size: 40,
                    ))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                temperature(),
                quantity(),
              ],
            ),
          ),
          const SizedBox(height: 5.0),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(height: 1, thickness: 0.3, color: Colors.black38),
          ),
          const SizedBox(height: 5.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: chooseCoffeeSizes(),
          ),
          const SizedBox(height: 5.0),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(height: 1, thickness: 0.3, color: Colors.black38),
          ),
          const SizedBox(height: 5.0),
          Column(
            children: [
              Container(
                height: 80,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: ExtraIngredientWidget(
                  "Sugar",
                  "cubes",
                  AssetImage("assets/images/sugar.png").assetName,
                ),
              ),
              Container(
                height: 80,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: ExtraIngredientWidget(
                  "Ice",
                  "cubes",
                  AssetImage("assets/images/ice.png").assetName,
                ),
              ),
              Container(
                height: 80,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: ExtraIngredientWidgetBinary(
                  "Cream",
                  AssetImage("assets/images/cream.png").assetName,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5.0),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(height: 1, thickness: 0.3, color: Colors.black38),
          ),
          const SizedBox(height: 5.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            margin: const EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total",
                      style: const TextStyle(
                              fontFamily: 'varela', color: Color(0xFF473D3A))
                          .copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.brown.shade500),
                      textScaleFactor: 1.6,
                    ),
                    Text(
                      "\$9.50",
                      style: TextStyle(
                              fontFamily: 'varela', color: Color(0xFF473D3A))
                          .copyWith(fontWeight: FontWeight.w900),
                      textScaleFactor: 1.9,
                    ),
                  ],
                ),
                SizedBox(
                  height: 60,
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFF473D3A)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    child: Text(
                      "Add to Orders",
                      textScaleFactor: 1.5,
                      style:
                          TextStyle(fontFamily: 'varela', color: Colors.white)
                              .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}

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

Widget chooseCoffeeSizes() {
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

Widget temperature() {
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

Column quantity() {
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
