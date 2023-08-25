import 'package:auth_test/pages/home_page.dart';
import 'package:auth_test/pages/internal_splash_screen.dart';
import 'package:auth_test/pages/verify_email_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HasUserCompletedSignupPage extends StatefulWidget {
  const HasUserCompletedSignupPage({super.key});

  @override
  State<HasUserCompletedSignupPage> createState() =>
      _HasUserCompletedSignupPageState();
}

class _HasUserCompletedSignupPageState
    extends State<HasUserCompletedSignupPage> {
  Future<bool> hasAllRequirements() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    DocumentSnapshot yourUserReference = await users.doc(uid).get();

    Map<String, dynamic> yourUserMap =
        yourUserReference.data() as Map<String, dynamic>;

    return yourUserMap['hasAllowedContacts'] &&
        yourUserMap['hasName'] &&
        yourUserMap['hasUsername'];
  }

  late Future<bool> hasSignupRequirements;

  @override
  void initState() {
    hasSignupRequirements = hasAllRequirements();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: hasSignupRequirements,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const InternalSplashScreen();
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('An Error Occured. Please try reloading the app'),
          );
        } else {
          return snapshot.data! ? const HomePage() : const VerifyEmailPage();
        }
      },
    );
  }
}
