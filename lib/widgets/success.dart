import 'package:flutter/material.dart';
import 'package:user_groceryapp/screens/home_screen.dart';
import 'package:user_groceryapp/widgets/empty.dart';
import 'package:quickalert/quickalert.dart';

class Success extends StatefulWidget {
  Success({Key? key}) : super(key: key);

  @override
  _SuccessState createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          EmptySection(
            emptyImg: null,
            emptyMsg: 'Successful !!',
          ),
          Text(
            'Your payment was done successfully',
          ),
          ElevatedButton(
            child: Text("Ok"),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
