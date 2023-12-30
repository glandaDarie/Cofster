import 'package:steel_crypt/steel_crypt.dart';

String encryptPassword(String password, String fortunaKey, String iv) {
  final AesCrypt encryptor =
      AesCrypt(padding: PaddingAES.pkcs7, key: fortunaKey);
  String encrypted = encryptor.gcm.encrypt(inp: password, iv: iv);
  return encrypted;
}
