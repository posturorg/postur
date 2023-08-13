import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> userSetup(String email) async {
  // Collect 'User' collection from Firestore database
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  // Collect current user's user ID (uid)
  FirebaseAuth auth = FirebaseAuth.instance;
  String? uid = auth.currentUser?.uid.toString();
  // Initialize referene to current user's Document
  final DocumentReference<Object?> docUser = users.doc(uid);
  // Create map of initial user values
  final Map<String, dynamic> userMap = {
    'name': {'first':'', 'last':''},
    // Maybe use an encryption key to change default username to something more secure later
    'username': uid,
    'email': email,
    'uid': uid,
    'profile_pic': "",
    'contacts': {},
    'accountType': 'private',
    'hasName': false,
    'hasUsername': false,
    'hasAllowedContacts': false,
  };

  // Set map of values to user doc
  await docUser.set(userMap);

  return;
}