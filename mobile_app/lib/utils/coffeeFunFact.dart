import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;

Future<String> generateFunFact() async {
  String funFact = null;
  try {
    String content =
        await rootBundle.loadString('assets/files/coffeeFunFact.txt');
    List<String> lines = content.split("\n");
    Random random = Random();
    int randomIndex = random.nextInt(lines.length);
    funFact = lines[randomIndex];
  } catch (e) {
    return 'Error reading file: $e';
  }
  return funFact;
}
