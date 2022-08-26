import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary/model/mpin_model.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  // collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future insertDummyData(String name, String mPin, bool isLocked) async {
    return await userCollection
        .doc(uid)
        .set({'name': name, 'mpin': mPin, 'isLocked': isLocked});
  }

  Future updateMPin(String mPin) async {
    return await userCollection.doc(uid).update({
      'mpin': mPin,
    });
  }

  Future updateName(String name) async {
    return await userCollection.doc(uid).update({
      'name': name,
    });
  }

  Future updateLockedStatus(bool isLocked) async {
    return await userCollection.doc(uid).update({
      'isLocked': isLocked,
    });
  }

  List<Mpin> _mPinFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Mpin(
        mpin: (doc.data() as dynamic)[mpin] ?? "0000",
      );
    }).toList();
  }


  Stream<QuerySnapshot> get mpin {
    return userCollection.snapshots();
  }
}
