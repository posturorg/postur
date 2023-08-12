import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> userSetup(String email) async {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth auth = FirebaseAuth.instance;
  String? uid = auth.currentUser?.uid.toString();
  final DocumentReference<Object?> docUser = users.doc(uid);
  final Map<String, dynamic> userMap = {
    'name': {'first':'', 'last':''},
    // Remove 'first_name' and 'last_name'
    'first_name': 'Stewy',
    'last_name': 'Jones',
    // Maybe use an encryption key to change default username to something more secure later
    'username': uid,
    'email': email,
    'uid': uid,
    // Rename "profile_pic" to profilePic
    'profile_pic': "",
    // Remove 'invited'
    'invited': [],
    // Remove 'attending'
    'attending': [],
    'contacts': {},
    'tags': [],
    'accountType': 'private',
    'hasName': false,
    'hasUsername': false,
  };

  await docUser.set(userMap);
  
  return;
}