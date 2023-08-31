import 'package:cloud_firestore/cloud_firestore.dart';

Future<Set<String>> getUidsFromCollection(
    CollectionReference<Map<String, dynamic>> collectionRef) async {
  try {
    QuerySnapshot<Map<String, dynamic>> snapshot = await collectionRef.get();

    Set<String> uids = <String>{};

    for (var document in snapshot.docs) {
      if (document.data().containsKey('uid')) {
        uids.add(document.data()['uid'] as String);
      }
    }

    return uids;
  } catch (e) {
    print(e.toString());
    return Set<String>.from({});
  }
}

Future<Set<String>> getTagIdsFromCollection(
    CollectionReference<Map<String, dynamic>> collectionRef) async {
  try {
    QuerySnapshot<Map<String, dynamic>> snapshot = await collectionRef.get();

    Set<String> tagIds = <String>{};

    for (var document in snapshot.docs) {
      if (document.data().containsKey('tagId')) {
        tagIds.add(document.data()['tagId'] as String);
      }
    }

    return tagIds;
  } catch (e) {
    print(e.toString());
    return Set<String>.from({});
  }
}
