import 'package:auth_test/pages/has_user_completed_signup_page.dart';
import 'package:auth_test/pages/verify_email_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:auth_test/pages/home_page.dart';

import 'login_or_register_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        //user logged in
        if (snapshot.hasData) {
          return const HasUserCompletedSignupPage(); //get specific data about the user...
        }
        //user NOT logged in
        else {
          return const LoginOrRegisterPage();
        }
      },
    ));
  }
}
