String coffeeNameToClassKey(String coffeeName) {
  List<String> words = coffeeName.split(" ");
  if (words.length > 1) {
    String firstWord = words[0];
    String restOfString = words.sublist(1).join(" ").replaceAllMapped(
          RegExp(r"([A-Z])"),
          (Match match) => " " + match.group(0),
        );
    return "${firstWord}${restOfString}".trim();
  }
  return coffeeName;
}
