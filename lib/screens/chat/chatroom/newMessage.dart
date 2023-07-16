import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_groceryapp/common/utils/colors.dart';
import 'package:user_groceryapp/common/utils/textStyle.dart';

class NewMessages extends StatefulWidget {
  @override
  _NewMessagesState createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  var _enteredMessage;
  final _controller = new TextEditingController();
  
  final _fullNameController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passTextController = TextEditingController();
  final _addressTextController = TextEditingController();
  final _mobileTextController = TextEditingController();
  final _passFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  final _mobileFocusNode = FocusNode();
  bool _obscureText = true;
  @override
  void dispose() {
    _fullNameController.dispose();
    _emailTextController.dispose();
    _mobileTextController.dispose();
    _passTextController.dispose();
    _addressTextController.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _mobileFocusNode.dispose();
    _addressFocusNode.dispose();
    super.dispose();
  }

  Color button = Color(0xff125589);

  void _sendMessage() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    SharedPreferences pref = await SharedPreferences.getInstance();
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser?.uid)
        .get();
    FocusScope.of(context).unfocus();
    FirebaseFirestore.instance
        .collection('chat/rooms/${pref.getString('room')}')
        .add({
      'text': _enteredMessage,
      'time': DateTime.now(),
      'userId': auth.currentUser?.uid,
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: text16(),
              keyboardType: TextInputType.text,
              controller: _controller,
              cursorColor: button,
              decoration: InputDecoration(
                hintText: 'Send Message',
                hintStyle: TextStyle(color: appBarColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: appBarColor),
            onPressed: _enteredMessage.toString().trim().isEmpty
                ? null
                : () {
                    _sendMessage();
                  },
          ),
        ],
      ),
    );
  }
}
