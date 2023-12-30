void main() {
  String fileContent =
      'Question 1: On a scale of 1 to 10, with 1 being the lowest and 10 being the highest, how would you rate the taste of your last coffee drink?\n' +
          'Options 1: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10\n' +
          'Question 2: What changes, if there are any, would you make to that coffee drink, to make it taste better for you?\n' +
          'Options 2: None\n';
  Map<String, List<String>> expected = {
    "Question 1": [
      "On a scale of 1 to 10, with 1 being the lowest and 10 being the highest, how would you rate the taste of your last coffee drink?",
      "1, 2, 3, 4, 5, 6, 7, 8, 9, 10"
    ],
    "Question 2": [
      "What changes, if there are any, would you make to that coffee drink, to make it taste better for you?",
      "None"
    ]
  };
  List<String> lines = fileContent.split("\n");
  Map<String, List<String>> processedLines = {};

  for (int i = 0; i < lines.length - 1; i += 2) {
    List<String> question = lines[i].split(": ");
    String questionKey = question[0];
    String questionValue = question[1];
    String option = lines[i + 1].split(": ")[1];
    processedLines[questionKey] = [questionValue, option];
  }
  Map<String, List<String>> actual = {...processedLines};
  bool mapsAreEqual = true;
  if (actual.length == expected.length) {
    for (String key in actual.keys) {
      if (!expected.containsKey(key) || actual[key] != expected[key]) {
        mapsAreEqual = false;
        break;
      }
    }
  } else {
    mapsAreEqual = false;
  }

  assert(mapsAreEqual, "Error, actual: $actual, expected: $expected");
}
