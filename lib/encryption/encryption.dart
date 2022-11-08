import 'package:encrypt/encrypt.dart' as encrypt;

// Note: I have removed the algorithm due to personal use (Don't want to make it open source right now)
// You may contact you need more information about encryption I have used
// I have used dual encryption where first message will be encrypted with Advance Encryption Algorithm and then encrypted by my custom algorithm
class Encryption {
  final String messageToBeEncrypted;

  Encryption({required this.messageToBeEncrypted});

  String encryptMe(int key) {
    return messageToBeEncrypted;
  }

  String decryptMe(int key) {
    return messageToBeEncrypted;
  }
}