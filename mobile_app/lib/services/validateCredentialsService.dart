import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:password_strength_checker/password_strength_checker.dart';

class ValidateCredentialsService {
  ValidateCredentialsService() {}

  String validateUsername(String username) {
    String _username = username.trim();
    if (_username.isEmpty) {
      return "Please enter your email address";
    }
    if (!EmailValidator.validate(_username)) {
      return "Please enter a valid email address";
    }
    return null;
  }

  String validatePassword(String password) {
    String _password = password.trim();
    ValueNotifier<PasswordStrength> passwordNotifier =
        ValueNotifier<PasswordStrength>(null);
    passwordNotifier.value = PasswordStrength.calculate(text: _password);
    String strengthPassword = passwordNotifier.value.toString();
    if (_password.isEmpty) {
      return "Please enter a password";
    }
    if (!(RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)")
        .hasMatch(_password))) {
      return "Password should contain minimum a small, \nbig letter, number and a special character";
    }
    if (strengthPassword.contains("weak")) {
      return "Password is weak";
    }
    if (strengthPassword.contains("medium")) {
      return "Password is of strength medium";
    }
    return null;
  }

  String validateNameSurname(String name) {
    if (name.isEmpty) {
      return "Name is empty";
    }
    if (!RegExp(r'^[A-Z][a-z]*$').hasMatch(name)) {
      return "Name is not written correctly\nShould have only letters,\nwhere the first one must be uppercase";
    }
    return null;
  }
}
