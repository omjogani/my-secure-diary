import 'package:cloud_firestore/cloud_firestore.dart';

class NoteBookDatabaseService {
  final String uid;
  NoteBookDatabaseService({required this.uid});

  //collection Reference
  final CollectionReference notebookCollection =
      FirebaseFirestore.instance.collection('notebook');

  Future insertDummyNotebookData() async {
    return await notebookCollection.doc(uid).set({
      'totalNotes': 1,
      'lastUpdated': DateTime.now(),
      'notes': FieldValue.arrayUnion([
        {
          "title": "Welcome to Secure Diary",
          "description":
              "Note: All the content of Notebook Section will not encrypt. So, Please Don't Insert Confidential Information in the Notebook Section. Enjoy the App!! --Om Jogani--",
          "dateTime": DateTime.now(),
        }
      ]),
    });
  }

  Future updateTotalNotes(int totalNotes) async {
    return await notebookCollection.doc(uid).update({
      'totalNotes': totalNotes,
    });
  }

  Future insertNotes(
      String title, String description, DateTime lastUpdated) async {
    List newListToBeStored = [];
    newListToBeStored.add({
      "title": title,
      "description": description,
      'dateTime': DateTime.now(),
    });
    FirebaseFirestore.instance
        .collection('notebook')
        .doc(uid)
        .get()
        .then((snapshot) {
      updateTotalNotes(snapshot['totalNotes'] + 1);
    });
    return await notebookCollection.doc(uid).update({
      'notes': FieldValue.arrayUnion(newListToBeStored),
      'lastUpdated': lastUpdated,
    });
  }

  // * NOTE: While implementing updateNotes I get to know that there is no any method of FieldValue to directly update the List<List> of Firebase so I have First Remove List and then add another one.
  // ? REQUEST: If you found any other good solution that is better then this one let me know or raise a issue. I would love to know that.
  Future updateNotes(String title, String description, int index) async {
    return await FirebaseFirestore.instance
        .collection('notebook')
        .doc(uid)
        .get()
        .then((snapshot) {
      final retrievedDateTime = snapshot.data()!['notes'][index]['dateTime'];
      final String retrievedTitle = snapshot.data()!['notes'][index]['title'];
      final String retrievedDescription =
          snapshot.data()!['notes'][index]['description'];
      List updatedListToBeStored = [], listToBeDeleted = [];
      listToBeDeleted.add({
        "title": retrievedTitle,
        "description": retrievedDescription,
        "dateTime": retrievedDateTime
      });

      updatedListToBeStored.add({
        "title": title,
        "description": description,
        'dateTime': retrievedDateTime,
      });

      notebookCollection.doc(uid).update({
        'notes': FieldValue.arrayUnion(updatedListToBeStored),
        'lastUpdated': DateTime.now(),
      });

      notebookCollection.doc(uid).update({
        'notes': FieldValue.arrayRemove(listToBeDeleted),
      });
    });
  }

  Future deleteNotes(String title, String description, int index) async {
    List listToBeDeleted = [];
    return await FirebaseFirestore.instance
        .collection('notebook')
        .doc(uid)
        .get()
        .then((snapshot) {
      final int totalNotes = snapshot.data()!['totalNotes'];
      listToBeDeleted.add({
        "title": title,
        "description": description,
        "dateTime": snapshot.data()!['notes'][index]['dateTime'],
      });
      notebookCollection.doc(uid).update({
        'notes': FieldValue.arrayRemove(listToBeDeleted),
        'totalNotes': totalNotes - 1,
        'lastUpdated': DateTime.now(),
      });
    });
  }
}
