import 'package:bcrypt/bcrypt.dart';

String encryptPassword(String password) {
  return BCrypt.hashpw(password, BCrypt.gensalt());
}

bool passwordIsMatchedWithHash(String password, String hashedPassword) {
  return BCrypt.checkpw(password, hashedPassword);
}
