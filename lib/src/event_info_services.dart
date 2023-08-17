import 'package:cloud_firestore/cloud_firestore.dart';

Future<Set<String>> getUidsFromCollection(
    CollectionReference<Map<String, dynamic>> collectionRef) async {
  try {
    QuerySnapshot<Map<String, dynamic>> snapshot = await collectionRef.get();

    Set<String> uids = Set<String>();

    snapshot.docs.forEach((document) {
      if (document.data().containsKey('uid')) {
        uids.add(document.data()['uid'] as String);
      }
    });

    return uids;
  } catch (e) {
    print(e.toString());
    return Set<String>.from({});
  }
}
