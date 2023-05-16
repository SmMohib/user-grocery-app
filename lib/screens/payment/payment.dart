import 'package:flutter/material.dart';
import 'package:user_groceryapp/consts/payment_const.dart';
import 'package:user_groceryapp/screens/payment/payment_detail.dart';
import 'package:user_groceryapp/widgets/header.dart';
import 'package:user_groceryapp/widgets/success.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class Payment extends StatefulWidget {
  Payment({Key? key}) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  int value = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.amber,
      appBar: AppBar(
        title: Text('Payment'),
      ),
      // appBar: DefaultAppBar(
      //   title: 'Payment',
      //   child: DefaultBackButton(),

      body: Column(
        children: [
          HeaderLabel(
            headerText: 'Choose your payment method',
          ),
          Expanded(
            child: ListView.separated(
              itemCount: paymentLabels.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Radio(
                    activeColor: kPrimaryColor,
                    value: index,
                    groupValue: value,
                    onChanged: (i) => setState(() => value = i!),
                  ),
                  title: Text(
                    paymentLabels[index],
                    //  style: TextStyle(color: Colors.black),
                  ),
                  // trailing: Icon(paymentIcons[index], color: Colors.black),
                );
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
            ),
          ),
          ElevatedButton(
            child: Text('Pay Now'),
            onPressed: () {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.success,
                text: 'Transaction Completed Successfully!',
                autoCloseDuration: const Duration(seconds: 2),
              );
              Image.network(
                  "https://cdn-icons-png.flaticon.com/512/148/148767.png");
              Title(color: Colors.black54, child: Text("fgh"));
            },

            // title: 'Success',
            // text: 'Transaction Completed Successfully!',
            //leadingImage: 'assets/success.gif',
          ),

          // Navigator.of(context).push(
          // MaterialPageRoute(
          //   builder: (context) => PaymentDetails(),
        ],
      ),
    );
  }
}
