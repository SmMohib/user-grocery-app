import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:user_groceryapp/consts/theme_data.dart';
import 'package:user_groceryapp/inner_screens/cat_screen.dart';
import 'package:user_groceryapp/inner_screens/feeds_screen.dart';
import 'package:user_groceryapp/inner_screens/on_sale_screen.dart';
import 'package:user_groceryapp/inner_screens/product_details.dart';
import 'package:user_groceryapp/providers/cart_provider.dart';
import 'package:user_groceryapp/providers/dark_theme_provider.dart';
import 'package:user_groceryapp/providers/orders_provider.dart';
import 'package:user_groceryapp/providers/products_provider.dart';
import 'package:user_groceryapp/providers/viewed_prod_provider.dart';
import 'package:user_groceryapp/providers/wishlist_provider.dart';
import 'package:user_groceryapp/screens/auth/forget_pass.dart';
import 'package:user_groceryapp/screens/auth/login.dart';
import 'package:user_groceryapp/screens/auth/register.dart';
import 'package:user_groceryapp/screens/btm_bar.dart';
import 'package:user_groceryapp/screens/home_screen.dart';
import 'package:user_groceryapp/screens/orders/orders_screen.dart';
import 'package:user_groceryapp/screens/payment/payment.dart';
import 'package:user_groceryapp/screens/viewed_recently/viewed_recently.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'screens/wishlist/wishlist_screen.dart';

//future
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
     options: const FirebaseOptions(
    apiKey: "AIzaSyBtXqk_uaeSG80tcSlekConNZkP6hOZCPs",
            authDomain: "groceryapp-aac6a.firebaseapp.com",
            projectId: "groceryapp-aac6a",
            storageBucket: "groceryapp-aac6a.appspot.com",
            messagingSenderId: "136925704339",
            appId: "1:136925704339:web:f30630d0f9035feceb1d66",
            measurementId: "G-WP8EYED83N"
   ),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePrefs.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  final Future<FirebaseApp> _firebaseInitialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _firebaseInitialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                  body: Center(
                child: CircularProgressIndicator(),
              )),
            );
          } else if (snapshot.hasError) {
            const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                  body: Center(
                child: Text('An error occured'),
              )),
            );
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) {
                return themeChangeProvider;
              }),
              ChangeNotifierProvider(create: (_) => ProductsProvider()),
              ChangeNotifierProvider(
                create: (_) => CartProvider(),
              ),
              ChangeNotifierProvider(create: (_) => WishlistProvider()),
              ChangeNotifierProvider(create: (_) => ViewedProdProvider()),
              ChangeNotifierProvider(create: (_) => OrdersProvider()),
            ],
            child: Consumer<DarkThemeProvider>(
                builder: (context, themeProvider, child) {
              return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Flutter Demo',
                  theme: Styles.themeData(themeProvider.getDarkTheme, context),
                   home: BottomBarScreen(),
                //  home: Payment(),
                  routes: {
                    OnSaleScreen.routeName: (ctx) => const OnSaleScreen(),
                    FeedsScreen.routeName: (ctx) => const FeedsScreen(),
                    ProductDetails.routeName: (ctx) => const ProductDetails(),
                    WishlistScreen.routeName: (ctx) => const WishlistScreen(),
                    OrdersScreen.routeName: (ctx) => const OrdersScreen(),
                    ViewedRecentlyScreen.routeName: (ctx) =>
                        const ViewedRecentlyScreen(),
                    RegisterScreen.routeName: (ctx) => const RegisterScreen(),
                    LoginScreen.routeName: (ctx) => const LoginScreen(),
                    ForgetPasswordScreen.routeName: (ctx) =>
                        const ForgetPasswordScreen(),
                    CategoryScreen.routeName: (ctx) => const CategoryScreen(),
                  });
            }),
          );
        });
  }
}

class PaymentDemo extends StatelessWidget {
  const PaymentDemo({Key? key}) : super(key: key);
  Future<void> initPayment(
      {required String email,
      required double amount,
      required BuildContext context}) async {
    try {
      // 1. Create a payment intent on the server
      final response = await http.post(Uri.parse('Your function'), body: {
        'email': email,
        'amount': amount.toString(),
      });

      final jsonResponse = jsonDecode(response.body);
      log(jsonResponse.toString());
      // 2. Initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: jsonResponse['paymentIntent'],
        merchantDisplayName: 'Grocery Flutter course',
        customerId: jsonResponse['customer'],
        customerEphemeralKeySecret: jsonResponse['ephemeralKey'],
        // testEnv: true,
        // merchantCountryCode: 'SG',
      ));
      await Stripe.instance.presentPaymentSheet();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment is successful'),
        ),
      );
    } catch (errorr) {
      if (errorr is StripeException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occured ${errorr.error.localizedMessage}'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occured $errorr'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
        child: const Text('Pay 20\$'),
        onPressed: () async {
          await initPayment(
              amount: 50.0, context: context, email: 'email@test.com');
        },
      )),
    );
  }
}
