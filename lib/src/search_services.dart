import 'package:cloud_firestore/cloud_firestore.dart';

List<Map<String, String>> sortUsersByName(List<Map<String, String>> inputList) {
  List<Map<String, String>> sortedList = List.from(inputList);
  sortedList.sort((a, b) => a['name']!.compareTo(b['name']!));
  return sortedList;
}

//Want to get all users with a username greater than or equal to input string.

Stream<QuerySnapshot<Object?>> streamUsersWithMatchingUsername(
    String inputUsername) {
  inputUsername = inputUsername.toLowerCase().trim();

  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('Users');
  if (inputUsername == '') {
    return usersCollection.limit(40).snapshots();
  }
  final String firstLetter = inputUsername[0];
  final int charCode = firstLetter.codeUnitAt(0);
  final int nextCharCode = charCode + 1;
  final String nextLetter = String.fromCharCode(nextCharCode);

  var querySnapshot = usersCollection
      .where('username',
          isGreaterThanOrEqualTo: inputUsername, isLessThan: nextLetter)
      .orderBy('username')
      .limit(40)
      .snapshots();

  return querySnapshot;
}

Stream<QuerySnapshot<Object?>> streamTagsWithMatchingTagTitle(
    String inputTagTitle) {
  inputTagTitle = inputTagTitle.toLowerCase().trim();

  CollectionReference tagsCollection =
      FirebaseFirestore.instance.collection('Tags');

  if (inputTagTitle == '') {
    return tagsCollection.limit(40).snapshots();
  }
  final String firstLetter = inputTagTitle[0];
  final int charCode = firstLetter.codeUnitAt(0);
  final int nextCharCode = charCode + 1;
  final String nextLetter = String.fromCharCode(nextCharCode);

  var querySnapshot = tagsCollection
      .where('tagTitle',
          isGreaterThanOrEqualTo: inputTagTitle, isLessThan: nextLetter)
      .orderBy('tagTitle')
      .limit(40)
      .snapshots();

  return querySnapshot;
}

List<Stream<QuerySnapshot<Object?>>> completeSearch(String inputText) {
  //should be a list of two streams
  late String strippedPrefix =
      inputText.trim() == '' ? '' : inputText.trim().substring(1);
  if (strippedPrefix == '') {
    return [
      FirebaseFirestore.instance
          .collection('Users')
          .orderBy('username')
          .limit(40)
          .snapshots(),
      FirebaseFirestore.instance.collection('Tags').limit(40).snapshots()
    ]; //should order by full name
  } else if (inputText[0] == '@') {
    //searching users
    return [
      streamUsersWithMatchingUsername(strippedPrefix),
      FirebaseFirestore.instance.collection('Tags').limit(1).snapshots(),
    ];
  } else if (inputText[0] == '#') {
    //searching tags
    //search tags here
    return [
      FirebaseFirestore.instance.collection('Users').limit(1).snapshots(),
      streamTagsWithMatchingTagTitle(strippedPrefix),
    ];
    //this return is a placeholder
  } else {
    //search users by their fullName here & tags
    return [
      FirebaseFirestore.instance
          .collection('Users')
          .limit(40)
          .snapshots(), //Search by fullname here
      streamTagsWithMatchingTagTitle(strippedPrefix),
    ];
    //this return is a placeholder
  }
}
