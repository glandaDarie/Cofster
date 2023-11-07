import 'package:random_password_generator/random_password_generator.dart';
import 'dart:math';

String generateNewPassword(
    {double passwordLength = 10,
    double strengthPasswordThreshold = 0.7,
    bool checkPassword = true,
    bool letters = true,
    bool uppercase = true,
    bool numbers = true,
    bool specialChar = true}) {
  String newPassword = null;
  RandomPasswordGenerator password = RandomPasswordGenerator();
  while (true) {
    String newGeneratedPassword = password.randomPassword(
        letters: letters,
        uppercase: uppercase,
        numbers: numbers,
        specialChar: specialChar,
        passwordLength: passwordLength);
    if (checkPassword) {
      if (!(RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)")
          .hasMatch(newGeneratedPassword))) {
        continue;
      }
    }
    double passwordStrength =
        password.checkPassword(password: newGeneratedPassword);
    if (passwordStrength >= strengthPasswordThreshold) {
      newPassword = newGeneratedPassword;
      break;
    }
  }
  return newPassword;
}

String generateNewVerificationCode([lengthVerificationCode = 6]) {
  String verificationCode = "";
  for (int _ in Iterable.generate(lengthVerificationCode)) {
    int randomNumber = Random().nextInt(10);
    verificationCode += randomNumber.toString();
  }
  return verificationCode;
}
