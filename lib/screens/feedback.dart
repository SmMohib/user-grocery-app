import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_core/firebase_core.dart';

class FeedbackPage extends StatefulWidget {
  static const routenamed = '/feedback';
  FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('feedback'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: TextField(
                  controller: _namecontroller,
                  decoration: InputDecoration(
                    labelText: 'Enter your name',
                    // use the getter variable defined above
                    //errorText: _errorText,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: TextField(
                  controller: _emailcontroller,
                  decoration: InputDecoration(
                    labelText: 'Enter Email',
                    // use the getter variable defined above
                    //errorText: _errorText,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: TextFormField(
                  controller: _controller,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    hintText: 'Enter your feedback here',
                    filled: true,
                  ),
                  maxLines: 5,
                  maxLength: 4096,
                  textInputAction: TextInputAction.done,
                  validator: (String? text) {
                    if (text == null || text.isEmpty) {
                      return 'Please enter a value';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 200,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: ElevatedButton(
                  child: Text('Send'),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String message;

                      try {
                        // Get a reference to the `feedback` collection
                        final collection =
                            FirebaseFirestore.instance.collection('feedback');

                        // Write the server's timestamp and the user's feedback
                        await collection.doc().set({
                          'timestamp': FieldValue.serverTimestamp(),
                          'comments': _controller.text,
                          'name': _namecontroller.text,
                          'email': _emailcontroller.text,
                        });

                        message = 'Feedback sent successfully';
                      } catch (e) {
                        message = 'Error when sending feedback';
                      }

                      // Show a snackbar with the result
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(message)));
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
              // AlertDialog(
              //   content: Form(
              //     key: _formKey,
              //     child: Stack(
              //       children: [
              //         TextFormField(
              //           style: text16(),
              //           controller: _controller,
              //           keyboardType: TextInputType.multiline,
              //           decoration: const InputDecoration(
              //             hintText: 'Enter your feedback here',
              //             filled: true,
              //           ),
              //           maxLines: 5,
              //           maxLength: 4096,
              //           textInputAction: TextInputAction.done,
              //           validator: (String? text) {
              //             if (text == null || text.isEmpty) {
              //               return 'Please enter a value';
              //             }
              //             return null;
              //           },
              //         ),
              //         Positioned(
              //             right: -15,
              //             top: -10,
              //             child: IconButton(
              //               icon: Icon(Icons.clear),
              //               onPressed: () {
              //                 Navigator.pop(context);
              //               },
              //             ))
              //       ],
              //     ),
              //   ),
              //   actions: [
              //     // TextButton(
              //     //   child: const Text('Cancel'),
              //     //   onPressed: () => Navigator.pop(context),
              //     // ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
