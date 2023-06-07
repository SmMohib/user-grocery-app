import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:user_groceryapp/common/utils/colors.dart';
import 'package:user_groceryapp/screens/chat/chatroom/auth.dart';
import 'package:user_groceryapp/screens/chat/chatroom/joinRoom.dart';


class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var isLoading = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  var message;
  Color backGround = whiteColor;

  void _submitAuthForm(String email, String pass, String? username, File? image,
      bool isLogin, BuildContext ctx) async {
    UserCredential userCredential;
    try {
      setState(() {
        isLoading = true;
      });
      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: pass);

        if (auth.currentUser != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => JoinRoom()),
          );
        }
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: pass,
        );

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(_auth.currentUser!.uid + '.jpg');

        await ref.putFile(image!);

        final url = await ref.getDownloadURL();

        if (auth.currentUser != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => JoinRoom()),
          );
        }
        print("Hello" + '$userCredential');
        FirebaseFirestore.instance
            .collection('users2')
            .doc(userCredential.user!.uid)
            .set({'username': username, 'email': email, 'image_url': url});
      }
    } on PlatformException catch (err) {
      message = 'Please check again!';

      if (err.message != null) {
        message = err.message;
      }

      setState(() {
        isLoading = false;
      });
    } catch (err) {
      print(err);
      if (err.toString() ==
          '[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.') {}
      if (err.toString() ==
          '[firebase_auth/wrong-password] The password is invalid or the user does not have a password.') {}
      if (err.toString() ==
          '[firebase_auth/email-already-in-use] The email address is already in use by another account.') {}
      if (err.toString() ==
          '[firebase_auth/unknown] com.google.firebase.FirebaseException: An internal error has occurred. [ Unable to resolve host "www.googleapis.com":No address associated with hostname ]') {}
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backGround,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image(
                //   height: 300,
                //   width: 300,
                //   image: AssetImage(
                //     'assets/logo.png',
                //   ),
                // ),
              ],
            ),
            SizedBox(width: 10),
            Text(
              'Secure Chat',
              style: TextStyle(
                  color: appBarColor,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1),
            ),
            SizedBox(height: 10),
            AuthWidget(_submitAuthForm, isLoading),
          ],
        ),
      ),
    );
  }
}
