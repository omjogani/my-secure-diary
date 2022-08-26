import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary/services/database_service.dart';
import 'package:diary/services/notebook_datebase_service.dart';
import 'package:diary/services/passwords_database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class AuthBase {
  User? get currentUser;
  Stream<User?> authStateChanges();
  Future<void> verifyPhoneNumber(
      BuildContext context, String phoneNumber, Function setData);
  Future<User?> signInWithPhoneNumber(String verificationId, String smsCode);
  void showSnackbar(BuildContext context, String msg);
  Future<void> signOut();
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> verifyPhoneNumber(
      BuildContext context, String phoneNumber, Function setData) async {
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) {
      showSnackbar(context, "Auto Verified!!");
    };
    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException exception) {
          print(exception.toString());
      showSnackbar(context, exception.toString());
    };
    PhoneCodeSent codeSent =
        (String verificationID, [int? forceResnedingtoken]) {
      showSnackbar(context, "Code sent!!");
      setData(verificationID);
    };
    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationID) {
      showSnackbar(context, "Time out!!");
    };
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<User?> signInWithPhoneNumber(
      String verificationId, String smsCode) async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      if (userCredential.additionalUserInfo!.isNewUser) {
        DatabaseService(uid: currentUser!.uid)
            .insertDummyData("User", "0000", false);
        NoteBookDatabaseService(uid: currentUser!.uid).insertDummyNotebookData();
        PasswordDatabaseService(uid: currentUser!.uid).insertDummyPasswordData();
      }
      return userCredential.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  void showSnackbar(BuildContext context, String msg) {
    final snackBar = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
