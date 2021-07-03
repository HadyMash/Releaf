import 'package:encrypt/encrypt.dart';

class EncryptService {
  final String uid;
  final Key key;
  EncryptService(this.uid) : key = Key.fromUtf8('${uid}abcd');

  // encrypt
  String encrypt(String text) {
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));

    final encrypted = encrypter.encrypt(text, iv: iv);
    return encrypted.base64;
  }

  // decrypt
  String decrypt(String encryptedText) {
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));

    final encrypted = Encrypted.from64(encryptedText);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);

    return decrypted;
  }

  // TODO encrypt image

  // TODO decrypt image
}
