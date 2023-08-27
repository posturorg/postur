import 'package:cloud_firestore/cloud_firestore.dart';

List<Map<String, String>> sortUsersByName(List<Map<String, String>> inputList) {
  List<Map<String, String>> sortedList = List.from(inputList);
  sortedList.sort((a, b) => a['name']!.compareTo(b['name']!));
  return sortedList;
}

//Want to get all users with a username greater than or equal to input string.

Stream<QuerySnapshot<Object?>> streamUsersWithMatchingUsername(
    String inputUsername) {
  //in progress...
  inputUsername = inputUsername.toLowerCase();
  final String firstLetter = inputUsername[0];
  final int charCode = firstLetter.codeUnitAt(0);
  final int nextCharCode = charCode + 1;
  final String nextLetter = String.fromCharCode(nextCharCode);

  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('Users');

  var querySnapshot = usersCollection
      .where('username',
          isGreaterThanOrEqualTo: inputUsername, isLessThan: nextLetter)
      .orderBy('username')
      .limit(40)
      .snapshots();

  return querySnapshot;
}
