import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> userSetup(String email) async {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth auth = FirebaseAuth.instance;
  String? uid = auth.currentUser?.uid.toString();
  final DocumentReference<Object?> docUser = users.doc(uid);
  final Map<String, dynamic> userMap = {
    'first_name': 'Stewy',
    'last_name': 'Jones',
    'email': email,
    'uid': uid,
    'profile_pic': "",
    'invited': [],
    'attending': [],
    'contacts': {},
    'tags': [],
    'accountType': 'private',
  };

  await docUser.set(userMap);
  
  return;
}