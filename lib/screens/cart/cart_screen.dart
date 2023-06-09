import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:user_groceryapp/consts/firebase_consts.dart';
import 'package:user_groceryapp/screens/cart/cart_widget.dart';
import 'package:user_groceryapp/widgets/text_widget.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../payment/checkout.dart';
import '../../providers/cart_provider.dart';
import '../../providers/orders_provider.dart';
import '../../providers/products_provider.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../../widgets/empty_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItemsList =
        cartProvider.getCartItems.values.toList().reversed.toList();
    return cartItemsList.isEmpty
        ? const EmptyScreen(
            title: 'Your cart is empty',
            subtitle: 'Add something and make me happy :)',
            buttonText: 'Shop now',
            imagePath: 'assets/images/cart.png',
          )
        : Scaffold(
            appBar: AppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: TextWidget(
                  text: 'Card (${cartItemsList.length})',
                  color: color,
                  isTitle: true,
                  textSize: 22,
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      GlobalMethods.warningDialog(
                          title: 'Empty your cart?',
                          subtitle: 'Are you sure?',
                          fct: () async {
                            await cartProvider.clearOnlineCart();
                            cartProvider.clearLocalCart();
                          },
                          context: context);
                    },
                    icon: Icon(
                      IconlyBroken.delete,
                      color: color,
                    ),
                  ),
                ]),
            body: Column(
              children: [
                _checkout(ctx: context),
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItemsList.length,
                    itemBuilder: (ctx, index) {
                      return ChangeNotifierProvider.value(
                          value: cartItemsList[index],
                          child: CartWidget(
                            q: cartItemsList[index].quantity,
                          ));
                    },
                  ),
                ),
              ],
            ),
          );
  }

  Widget _checkout({required BuildContext ctx}) {
    final Color color = Utils(ctx).color;
    Size size = Utils(ctx).getScreenSize;
    final cartProvider = Provider.of<CartProvider>(ctx);
    final productProvider = Provider.of<ProductsProvider>(ctx);
    final ordersProvider = Provider.of<OrdersProvider>(ctx);
    double total = 0.0;
    cartProvider.getCartItems.forEach((key, value) {
      final getCurrProduct = productProvider.findProdById(value.productId);
      total += (getCurrProduct.isOnSale
              ? getCurrProduct.salePrice
              : getCurrProduct.price) *
          value.quantity;
    });
    return SizedBox(
      width: double.infinity,
      height: size.height * 0.1,
      // color: ,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(children: [
         Material(
            color: Colors.green,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () async {
                showModalBottomSheet<void>(
                    // context and builder are
                    // required properties in this widget
                    context: ctx,
                    builder: (BuildContext context) {
                      // we set up a container inside which
                      // we create center column and display text

                      // Returning SizedBox instead of a Container
                      return SizedBox(
                        height: 180,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextWidget(
                                  text: 'Payment System',
                                  color: color,
                                  textSize: 20),
                            ),
                            const Divider(
                              color: Color.fromARGB(96, 42, 40, 40),
                              thickness: 0.7,
                            ),
                            TextButton(
                                onPressed: () {
                                  User? user = authInstance.currentUser;
                                  final orderId = const Uuid().v4();
                                  final productProvider =
                                      Provider.of<ProductsProvider>(ctx,
                                          listen: false);

                                  cartProvider.getCartItems
                                      .forEach((key, value) async {
                                    final getCurrProduct =
                                        productProvider.findProdById(
                                      value.productId,
                                    );
                                    try {
                                      await FirebaseFirestore.instance
                                          .collection('orders')
                                          .doc(orderId)
                                          .set({
                                        'orderId': orderId,
                                        'userId': user!.uid,
                                        'productId': value.productId,
                                        'price': (getCurrProduct.isOnSale
                                                ? getCurrProduct.salePrice
                                                : getCurrProduct.price) *
                                            value.quantity,
                                        'totalPrice': total,
                                        'quantity': value.quantity,
                                        'imageUrl': getCurrProduct.imageUrl,
                                        'userName': user.displayName,
                                        // 'phoneNumber': user.phoneNumber,
                                        'email': user.email,
                                        //  'shipping-address': user,
                                        'orderDate': Timestamp.now(),
                                      });
                                      await cartProvider.clearOnlineCart();
                                      cartProvider.clearLocalCart();
                                      ordersProvider.fetchOrders();
                                      await Fluttertoast.showToast(
                                        msg: "Your order has been placed",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                      );
                                    } catch (error) {
                                      GlobalMethods.errorDialog(
                                          subtitle: error.toString(),
                                          context: ctx);
                                    } finally {}
                                  });
                                  Navigator.pop(context);
                                },
                                child: TextWidget(
                                    text: 'Cash on delivery',
                                    color: color,
                                    textSize: 16)),
                            TextButton(
                                onPressed: () {
                                Navigator.push(context, 
                                MaterialPageRoute(builder: (context) => CheckOutScreen(),));
                                },
                                child: TextWidget(
                                    text: 'Payment Now',
                                    color: color,
                                    textSize: 16))
                          ],
                        ),
                      );
                    });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextWidget(
                  text: 'Order Now',
                  textSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const Spacer(),
          FittedBox(
            child: TextWidget(
              text: 'Total: \৳ ${total.toStringAsFixed(2)}',
              color: color,
              textSize: 18,
              isTitle: true,
            ),
          ),
        ]),
      ),
    );
  }
}
