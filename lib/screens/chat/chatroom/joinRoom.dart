// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, sort_child_properties_last, avoid_print, prefer_typing_uninitialized_variables, library_private_types_in_public_api, use_key_in_widget_constructors

import 'dart:math';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_groceryapp/common/utils/colors.dart';
import 'package:user_groceryapp/common/utils/textStyle.dart';
import 'package:user_groceryapp/screens/chat/chatroom/authScreen.dart';
import 'package:user_groceryapp/screens/chat/chatroom/chatScreen.dart';

class JoinRoom extends StatefulWidget {
  @override
  _JoinRoomState createState() => _JoinRoomState();
}

class _JoinRoomState extends State<JoinRoom> {
  final _formKey = GlobalKey<FormState>();

  var randomId = TextEditingController();
  var roomId;
  late int randomRoomID;
  Color background = Color(0xff125589);
  Color button = Color(0xffeeeeee);

  void generateRoomId() {
    // ignore: unnecessary_new
    Random random = new Random();
    setState(() {
      randomId.text = random.nextInt(99999).toString();
    });
  }



  void submit() async {
    final valid = _formKey.currentState?.validate();

    if (valid!) {
      _formKey.currentState?.save();
      print(roomId);
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('room', roomId);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreens(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: Text(
          'Chat',
          style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 17,
              fontWeight: FontWeight.bold,
              letterSpacing: 1),
        ),
        //textTheme: TextTheme(bodyText1: TextStyle(color: textColor)),
        elevation: 0,
        backgroundColor: appBarColor,
        centerTitle: true,
        leading: Container(),
        // actions: [
        //   DropdownButton(
        //     elevation: 4,
        //     onChanged: (item) {
        //       if (item == 'logout') {
        //         logout();
        //       }
        //     },
        //     icon: Icon(
        //       Icons.more_vert,
        //       color: Color.fromARGB(255, 255, 255, 255),
        //     ),
        //     items: [
        //       DropdownMenuItem(
        //         child: Row(
        //           children: [
        //             Icon(
        //               Icons.exit_to_app,
        //               color: blackColor,
        //             ),
        //             SizedBox(width: 25),
        //             Text(
        //               'Logout',
        //               style: text16(),
        //             ),
        //           ],
        //         ),
        //         value: 'logout',
        //       ),
        //     ],
        //   )
        // ],
      ),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            SizedBox(height: 20),
            Container(
              color: appBarColor,
              width: 250,
              height: 250,
              child: Card(
                color: greyColor,
                elevation: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Chat',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          style: text16(),
                          controller: randomId,
                          key: ValueKey('Enter Private Key'),
                          validator: (value) {
                            if (value!.length < 5 || value.length > 5) {
                              return 'Please enter 5 digit room ID';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            roomId = value;
                          },
                          onChanged: (value) {
                            roomId = value;
                          },
                          keyboardType: TextInputType.number,
                          decoration:
                              InputDecoration(hintText: 'Enter Room ID'),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            generateRoomId();
                          },
                          child: Text(
                            'Generate',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              submit();
                            },
                            child: Text(
                              'Join',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0)),
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
