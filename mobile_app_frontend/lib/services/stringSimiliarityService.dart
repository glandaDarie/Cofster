List<String> padStringsToMatchLength(
    String s1, String s2, String paddingCharacter) {
  int maxLength = s1.length > s2.length ? s1.length : s2.length;
  s1 = s1.padRight(maxLength, paddingCharacter);
  s2 = s2.padRight(maxLength, paddingCharacter);
  return [s1, s2];
}

double scoreProbability(String s1, String s2) {
  List<String> strings = padStringsToMatchLength(s1, s2, "0");
  s1 = strings[0];
  s2 = strings[1];
  int matches = List.generate(
    s1.length,
    (i) => i,
    growable: false,
  ).where((i) => s1[i] == s2[i]).length;
  return matches / s1.length;
}
