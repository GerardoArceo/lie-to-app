import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'cloud_api.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;

  GoogleSignInAccount? get user => _user;
  
  Future signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      _user = googleUser;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      final user = FirebaseAuth.instance.currentUser!;
      Map<String, String> data = {
        'email': user.email ?? "",
        'nickname': user.displayName ?? "",
      };
      await CloudApiProvider().sendPostRequest(context, 'saveUser', data);
      
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }

    notifyListeners();
  }

  void signOutGoogle() async {
    try {
      FirebaseAuth.instance.signOut();
      _googleSignIn.signOut();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }

    notifyListeners();
  }
}