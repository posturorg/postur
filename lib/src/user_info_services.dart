import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

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

Future<void> setUsername(
  dynamic stateSetter,
  TextEditingController enteredUsernameController,
) async {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    final userDocRef =
        FirebaseFirestore.instance.collection('Users').doc(currentUser.uid);

    //print('clicked!');
    await userDocRef.update({
      'hasUsername': true,
      'username': enteredUsernameController.text.trim().toLowerCase(),
    });
    stateSetter();
  } else {
    //should sign user out if user doesnt exist...
    FirebaseAuth.instance.signOut();
  }
}

Future<void> setName(
  dynamic stateSetter,
  TextEditingController firstNameController,
  TextEditingController lastNameController,
) async {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    final userDocRef =
        FirebaseFirestore.instance.collection('Users').doc(currentUser.uid);

    //print('clicked!');
    await userDocRef.update({
      'hasName': true,
      'name': {
        'first': firstNameController.text.trim(),
        'last': lastNameController.text.trim(),
      },
    });
    stateSetter();
  } else {
    //should sign user out if user doesnt exist...
    FirebaseAuth.instance.signOut();
  }
}

Future<Set<String>> extractPhoneNumbers(List<Contact> contacts) async {
  final Set<String> phoneNumberSet = {};

  for (final contact in contacts) {
    if (contact.phones != null) {
      for (final phone in contact.phones!) {
        if (phone.number != null) {
          phoneNumberSet.add(phone.number!);
        }
      }
    }
  }

  return phoneNumberSet;
}
