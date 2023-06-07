import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:user_groceryapp/common/widgets/custom_button.dart';


class TextFiledDemo extends StatefulWidget {
  const TextFiledDemo({super.key, required this.name,
    required this.uid,
    //  required this.isGroupChat,
    required this.profilePic,});
   final String name;
  final String uid;
  //final bool isGroupChat;
  final String profilePic;

  @override
  State<TextFiledDemo> createState() => _TextFiledDemoState();
}

class _TextFiledDemoState extends State<TextFiledDemo> {
  final _text = TextEditingController();

  bool _validate = false;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }
final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return  Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Enter text',
              ),
              textAlign: TextAlign.center,
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return 'Text is empty';
                }
                return null;
              },
            ),
            SizedBox(height: 10,),
            CustomButton(text: 'Submit', 
            onPressed: (){
               if (_formKey.currentState!.validate()) {
                  //  Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                   builder: ((context) => RsaMobileChatScreen(
                                          
                  //                         // isGroupChat:isGroupChat ,
                                         
                  //                       ))));

                  // TODO submit
                }
            }),
            
          ],
        ),
    
    );
  }
}
