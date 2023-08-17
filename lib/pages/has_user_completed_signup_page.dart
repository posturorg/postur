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
  bool hasName = false;
  bool hasUsername = false;
  bool emailVerified = false;
  bool hasCompletedFetch = false;

  Future<void> fetchRelevantInfo() async {
    showDialog(
      context: context,
      builder: (context) {
        return const InternalSplashScreen();
      },
    );
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser.uid)
            .get();

        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          hasName = userData['hasAllowedContacts'];
          hasUsername = userData['hasUsername'];
          emailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
          hasCompletedFetch = true;
        });
      } else {
        await FirebaseAuth.instance.signOut();
        setState(() {
          hasCompletedFetch = true;
        });
      }
      Navigator.pop(context);
    } catch (e) {
      await FirebaseAuth.instance.signOut(); //this might not really work
      print(e.toString());
      Navigator.pop(context);
      setState(() {
        hasCompletedFetch = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    Future.delayed(Duration.zero, () {
      //might be unneccessary tbh
      this.fetchRelevantInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!hasCompletedFetch) {
      return const InternalSplashScreen();
    } else if (hasName && hasUsername && emailVerified) {
      return const HomePage();
    } else {
      return const VerifyEmailPage();
    }
  }
}
