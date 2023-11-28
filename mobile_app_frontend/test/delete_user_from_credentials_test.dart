import 'package:coffee_orderer/controllers/UserController.dart'
    show UserController;

void main() async {
  UserController userController = UserController();
  String expected = null;
  Map<String, String> content = {
    "name": "Ruben",
    "username": "darieglanda@outlook.com"
  };
  String actual = await userController.deleteUserFromCredentials(content);
  assert(expected == actual, "Error, actual: ${actual}");
}
