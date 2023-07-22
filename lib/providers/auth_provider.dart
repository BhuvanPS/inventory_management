import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventory_management/user_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Status {
  uninitialised,
  authenticated,
  authenticating,
  authenticationError,
  authenticateCanceled,
}

String gstn = '';

class AuthProvider extends ChangeNotifier {
  final GoogleSignIn googleSignIn;

  final SharedPreferences prefs;

  Status _status = Status.uninitialised;
  Status get status => _status;

  AuthProvider({required this.googleSignIn, required this.prefs});

  String? getUserId() {
    return prefs.getString(UserConstants.uid);
  }

  Future<bool> isLoggedIn() async {
    bool isLoggedIn = await googleSignIn.isSignedIn();
    if (isLoggedIn && prefs.getString(UserConstants.uid)?.isNotEmpty == true) {
      return true;
    } else {
      return false;
    }
  }





  Future<bool> handleSignIn() async {
    _status = Status.authenticating;
    notifyListeners();

    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);
      User? currentUser =
          (await FirebaseAuth.instance.signInWithCredential(credential)).user;
      if (currentUser != null) {
        QuerySnapshot result = await FirebaseFirestore.instance
            .collection('users')
            .where('uid', isEqualTo: currentUser.uid)
            .get();
        final List<DocumentSnapshot> document = result.docs;
        if (document.isEmpty) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .set({
            'companyName': currentUser.displayName,
            'emailId': currentUser.email,
            'phoneNumber': currentUser.phoneNumber,
            'gstn': '33BBRPC7592Q1ZS',
            'companyID':currentUser.uid,
          });

          await prefs.setString(
              UserConstants.companyName, currentUser.displayName!);
          await prefs.setString(UserConstants.uid, currentUser.uid);

          await prefs.setString(UserConstants.gstn, gstn);
          await prefs.setString(UserConstants.emailId, currentUser.email!);

        } else {
          DocumentSnapshot documentSnapshot = document[0];
          Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
          await prefs.setString(UserConstants.companyName, data['companyName']);
          await prefs.setString(UserConstants.uid, data['companyId']);
          await prefs.setString(UserConstants.gstn, data['gstn']);
          await prefs.setString(UserConstants.emailId, data['emailId']);
          await prefs.setString(UserConstants.phoneNumber, data['phoneNumber']);
        }
      }
      _status = Status.authenticated;
      notifyListeners();
      return true;
    } else {
      _status = Status.authenticationError;
      notifyListeners();
      return false;
    }


  }
  Future<void> handleSignOut()async {
    _status= Status.uninitialised;
    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
    print('signed out');
  }
}



