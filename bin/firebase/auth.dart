import 'dart:io';

import 'package:firedart/firedart.dart';

class AuthMethods {
  static const apiKey = 'AIzaSyAn6YwSVefUp0d77gb3pQah7uDRQnW8W2Y';
  static const projectId = 'flutterchatapp-43ce6';

  TokenStore tokenStore;
  FirebaseAuth _auth;

  signUpwithEmailAndPassword(String email, String password) {
    tokenStore = VolatileStore();
    _auth = FirebaseAuth(apiKey, tokenStore);
    try {
      _auth.signUp(email, password).then((user) {
        print(user);
      });
    } catch (e) {
      print('[Error] error in sign up :${e.toString()}');
    }
  }

  signInWithEmailAndPassword(
      String email, String password) async{
    tokenStore = VolatileStore();
    _auth = FirebaseAuth(apiKey, tokenStore);
    var flag = false;
    await _auth.signIn(email, password).then((value) {
      flag = true;
    }, onError: (e) {
      flag = false;
    });
    if (flag) {
      print('ok');
    } else {
      return null;
    }
  }
}
