import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<bool> isUsernameUnique(String queriedUsername) async {
  CollectionReference<Map<String, dynamic>> collection =
      FirebaseFirestore.instance.collection('Users');
  Query query = collection.where('username', isEqualTo: queriedUsername);

  try {
    QuerySnapshot querySnapshot = await query.get();
    if (querySnapshot.size > 0) {
      print('Username already exists');
      return false;
    } else {
      print('Username is available');
      return true;
    }
  } catch (error) {
    // Handle error
    print('Error: $error');
    return false;
  }
}

Future<void> setUsername(void stateSetter) async {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    final userDocRef =
        FirebaseFirestore.instance.collection('Users').doc(currentUser.uid);

    //print('clicked!');
    await userDocRef.update({
      'hasUsername': true,
    });
  } else {
    //should sign user out if user doesnt exist...
    FirebaseAuth.instance.signOut();
  }
}
