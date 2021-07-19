import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';

class EncryptService {
  final String uid;
  final Key key;
  final Key incorrectImageKey;
  EncryptService(this.uid)
      : key = Key.fromUtf8('${uid}abcd'),
        incorrectImageKey = Key.fromUtf8(
            '${String.fromCharCodes(uid.runes.toList().reversed)}1234');

  // encrypt
  String encrypt(String text, {bool? incorrect}) {
    final iv = IV.fromLength(16);
    final encrypter =
        Encrypter(AES((incorrect ?? false) == true ? incorrectImageKey : key));

    final encrypted = encrypter.encrypt(text, iv: iv);
    return encrypted.base64;
  }

  // decrypt
  String decrypt(String encryptedText, {bool? incorrect}) {
    final iv = IV.fromLength(16);
    final encrypter =
        Encrypter(AES((incorrect ?? false) == true ? incorrectImageKey : key));

    final encrypted = Encrypted.from64(encryptedText);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);

    return decrypted;
  }

  // encrypt image
  Uint8List encryptImage(Uint8List image) {
    // Properly Encrypt the Image
    List<String> encryptedImage = [];
    for (int bit in image) {
      encryptedImage.add(encrypt(bit.toString()));
    }

    // Incorrectly Decrypt the Image
    List<int> incorrectDecryption = [];
    for (String encryptedBit in encryptedImage) {
      incorrectDecryption
          .add(int.parse(decrypt(encryptedBit, incorrect: true)));
    }

    return Uint8List.fromList(incorrectDecryption);
  }

  // decrypt image
  Uint8List decryptImage(Uint8List encryptedImage) {
    List<String> incorrectDecryption = [];

    // Incorrectly Ecrypt the Image
    for (int bit in encryptedImage) {
      incorrectDecryption.add(encrypt(bit.toString(), incorrect: true));
    }

    // Correctly Decrypt Image
    List<int> decyrption = [];
    for (String bit in incorrectDecryption) {
      decyrption.add(int.parse(decrypt(bit)));
    }

    return Uint8List.fromList(decyrption);
  }
}
