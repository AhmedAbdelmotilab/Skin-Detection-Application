import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SignInProvider extends ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FacebookAuth facebookAuth = FacebookAuth.instance;
  final GoogleSignIn googleSignin = GoogleSignIn();

  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  //has error
  bool _hasError = false;
  bool get hasError => _hasError;

  String? _errorCode;
  String? get errorCode => _errorCode;

  String? _provider;
  String? get provider => _provider;

  String? _uid;
  String? get uid => _uid;

  String? _name;
  String? get name => _name;

  String? _email;
  String? get email => _email;

  String? _imageurl;
  String? get imageurl => _imageurl;

  SignInProvider() {
    checkSignInUser();
  }

  Future checkSignInUser() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("signed_in") ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("signed_in", true);
    _isSignedIn = true;
    notifyListeners();
  }

  //Sign IN WITH GOOGLE
  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignin.signIn();
    if (googleSignInAccount != null) {
      //execute our authentication
      try {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        //sign in to firebase user instance
        final User userDetails =
            (await firebaseAuth.signInWithCredential(credential)).user!;

        //now save all the values

        _name = userDetails.displayName;
        _email = userDetails.email;
        _imageurl = userDetails.photoURL;
        _provider = "GOOGLE";
        _uid = userDetails.uid;
        notifyListeners();
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "account-exists-with-different-credential":
            _errorCode = "You are already have an account with us.";
            _hasError = true;
            notifyListeners();
            break;

          case "null":
            _errorCode = "unexpected error while trying to sign in";
            _hasError = true;
            notifyListeners();
            break;
          default:
            _errorCode = e.toString();
            _hasError = true;
            notifyListeners();
        }
      }
    } else {
      _hasError = true;
      notifyListeners();
    }
  }

// sign in with facebook
  Future signInWithFacebook() async {
    final LoginResult result = await facebookAuth.login();
    final graphResponse = await http.get(Uri.parse(
        'https://graph.facebook.com/v2.12/me?fields=name,picture.width(800).height(800),first_name,last_name,email&access_token=${result.accessToken!.token}'));

    final profile = jsonDecode(graphResponse.body);
    if (result.status == LoginStatus.success) {
      try {
        final OAuthCredential credential =
            FacebookAuthProvider.credential(result.accessToken!.token);
        await firebaseAuth.signInWithCredential(credential);
        // saving the values
        _name = profile['name'];
        _email = profile['email'];
        _imageurl = profile['picture']['data']['url'];
        _uid = profile['id'];
        _hasError = false;
        _provider = "FACEBOOK";
        notifyListeners();
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "account-exists-with-different-credential":
            _errorCode = "You are already have an account with us.";
            _hasError = true;
            notifyListeners();
            break;

          case "null":
            _errorCode = "unexpected error while trying to sign in";
            _hasError = true;
            notifyListeners();
            break;
          default:
            _errorCode = e.toString();
            _hasError = true;
            notifyListeners();
        }
      }
    } else {
      _hasError = true;
      notifyListeners();
    }
  }
  //Entry for cloudfirestore

  Future getUserDataFromFirestore(uid) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((DocumentSnapshot snapshot) => {
              _uid = snapshot['uid'],
              _name = snapshot['name'],
              _email = snapshot['email'],
              _imageurl = snapshot['image_url'],
              _provider = snapshot['provider'],
            });
  }

  Future saveDataToFirestore() async {
    final DocumentReference r =
        FirebaseFirestore.instance.collection("users").doc(uid);
    await r.set({
      "name": _name,
      "email": _email,
      "uid": _uid,
      "image_url": _imageurl,
      "provider": _provider,
    });
    notifyListeners();
  }

  Future saveDataToSharedPreferences() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString('name', _name!);
    await s.setString('email', _email!);
    await s.setString('uid', _uid!);
    await s.setString('image_url', _imageurl!);
    await s.setString('provider', _provider!);
    notifyListeners();
  }

  Future getDataFromSharedPrefernces() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _name = s.getString("name");
    _email = s.getString("email");
    _uid = s.getString("uid");
    _imageurl = s.getString("image_url");
    _provider = s.getString("provider");
    notifyListeners();
  }

  //cheack user exists or not in the database
  Future<bool> checkUserExists() async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    if (snap.exists) {
      print("EXISTING USER");
      return true;
    } else {
      print("NEW USER");
      return false;
    }
  }

  //signout functionality
  Future userSignOut() async {
    // ignore: await_only_futures
    await firebaseAuth.signOut;
    await googleSignin.signOut();
    _isSignedIn = false;
    notifyListeners();
    //clear all storage info
    clearStoreData();
  }

  Future clearStoreData() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.clear();
  }

  void phonNumberUser(User user, email, name) {
    _name = name;
    _email = email;
    _imageurl =
        "https://firebasestorage.googleapis.com/v0/b/blocauth-5963f.appspot.com/o/logo.png?alt=media&token=6e0b938b-e4be-4783-9562-1be95d46f0c3";
    _uid = user.phoneNumber;
    _provider = "PHONE";
    notifyListeners();
  }
}
