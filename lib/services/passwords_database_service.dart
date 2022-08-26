import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

class PasswordDatabaseService {
  final String uid;
  PasswordDatabaseService({required this.uid});

  //collection Reference
  final CollectionReference passwordCollection =
      FirebaseFirestore.instance.collection('password');

  Future insertDummyPasswordData() async {
    return await passwordCollection.doc(uid).set({
      'totalPasswords': 1,
      'lastUpdated': DateTime.now(),
      'passwords': FieldValue.arrayUnion([
        {
          "title": "Application Name",
          "password": "i92aluYW0MLiBPtYloAkgw==",
          "dateTime": DateTime.now(),
        }
      ]),
    });
  }

  Future updateTotalPasswords(int totalPasswords) async {
    return await passwordCollection.doc(uid).update({
      'totalPasswords': totalPasswords,
    });
  }

  Future insertPassword(
      String title, String password, DateTime lastUpdated) async {
    List newListToBeStored = [];
    newListToBeStored.add({
      "title": title,
      "password": password,
      'dateTime': DateTime.now(),
    });
    FirebaseFirestore.instance
        .collection('password')
        .doc(uid)
        .get()
        .then((snapshot) {
      updateTotalPasswords(snapshot['totalPasswords'] + 1);
    });
    return await passwordCollection.doc(uid).update({
      'passwords': FieldValue.arrayUnion(newListToBeStored),
      'lastUpdated': lastUpdated,
    });
  }

  // * NOTE: While implementing updateNotes I get to know that there is no any method of FieldValue to directly update the List<List> of Firebase so I have First Remove List and then add another one.
  // ? REQUEST: If you found any other good solution that is better then this one let me know or raise a issue. I would love to know that.
  Future updatePasswords(String title, String password, int index) async {
    return await FirebaseFirestore.instance
        .collection('password')
        .doc(uid)
        .get()
        .then((snapshot) {
      final retrievedDateTime =
          snapshot.data()!['passwords'][index]['dateTime'];
      final String retrievedTitle =
          snapshot.data()!['passwords'][index]['title'];
      final String retrievedPassword =
          snapshot.data()!['passwords'][index]['password'];
      List updatedListToBeStored = [], listToBeDeleted = [];
      listToBeDeleted.add({
        "title": retrievedTitle,
        "password": retrievedPassword,
        "dateTime": retrievedDateTime
      });

      updatedListToBeStored.add({
        "title": title,
        "password": password,
        'dateTime': retrievedDateTime,
      });

      passwordCollection.doc(uid).update({
        'passwords': FieldValue.arrayUnion(updatedListToBeStored),
        'lastUpdated': DateTime.now(),
      });

      passwordCollection.doc(uid).update({
        'passwords': FieldValue.arrayRemove(listToBeDeleted),
      });
    });
  }

  Future deletePassword(String title, String password, int index) async {
    List listToBeDeleted = [];
    return await FirebaseFirestore.instance
        .collection('password')
        .doc(uid)
        .get()
        .then((snapshot) {
      final int totalPasswords = snapshot.data()!['totalPasswords'];
      listToBeDeleted.add({
        "title": title,
        "password": password,
        "dateTime": snapshot.data()!['passwords'][index]['dateTime'],
      });
      passwordCollection.doc(uid).update({
        'passwords': FieldValue.arrayRemove(listToBeDeleted),
        'totalPasswords': totalPasswords - 1,
        'lastUpdated': DateTime.now(),
      });
    });
  }
}
