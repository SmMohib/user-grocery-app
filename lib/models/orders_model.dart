import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class OrderModel with ChangeNotifier {
  final String orderId, userId, productId, userName, price, imageUrl, quantity;
 // String email, mobile, shippingaddress;
  final Timestamp orderDate;

  OrderModel(
      {required this.orderId,
      // required this.email,
      // required this.mobile,
      // required this.shippingaddress,
      required this.userId,
      required this.productId,
      required this.userName,
      required this.price,
      required this.imageUrl,
      required this.quantity,
      required this.orderDate});
}
