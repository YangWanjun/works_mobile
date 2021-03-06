import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:works_mobile/utils/ajax.dart';
import 'package:works_mobile/utils/constants.dart' as Constants;
import 'package:works_mobile/views/home/StatsListView.dart';

import 'common.dart' as common;

class Authentication {
  static Future<FirebaseApp> initializeFirebase({
    required BuildContext context,
  }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    var jwt = await common.jwtOrEmpty;

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null && jwt != '') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => StatsListView(
          ),
        ),
      );
    }

    return firebaseApp;
  }

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
    await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential = await auth.signInWithCredential(credential);
        user = userCredential.user;
        final response = await Ajax.getWithoutAuth('${Constants.API_GOOGLE_LOGIN}?access_token=${googleSignInAuthentication.accessToken}');
        if (response.statusCode == 200) {
          Map<String, dynamic> jwt = json.decode(response.body);
          await common.setJwt(jwt["token"]);
        } else {
          throw Exception('Failed to login EB Work');
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            common.errorSnackBar(
              content:
              'The account already exists with a different credential.',
            ),
          );
        }
        else if (e.code == 'invalid-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            common.errorSnackBar(
              content:
              'Error occurred while accessing credentials. Try again.',
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          common.errorSnackBar(
            content: 'Error occurred using Google Sign-In. Try again.',
          ),
        );
      }
    }

    return user;
  }

  static Future<void> signOut({required BuildContext context}) async {
    User? user = FirebaseAuth.instance.currentUser;
    // Delete all
    await common.clearStorage();
    if (user == null) {
      return;
    }
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        // Web????????????????????????
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        common.errorSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }

}
