// Import for Android features.
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';

//ignore: must_be_immutable
class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({Key? key}) : super(key: key);
  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  var baseUrl =
      'https://sandbox.sslcommerz.com/EasyCheckOut/testcdedd999ea3eb0dc35aa9350e0395941508';
  double _progress = 0;
  late InAppWebViewController inAppWebViewController;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var isLastPage = await inAppWebViewController.canGoBack();
        if (isLastPage) {
          inAppWebViewController.goBack();
          return false;
        }
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: InAppWebView(
            initialUrlRequest: URLRequest(
              url: Uri.parse(baseUrl)
            ),
            onWebViewCreated: (InAppWebViewController controller){
              inAppWebViewController = controller;
            },
            onProgressChanged: (InAppWebViewController controller , int progress){
              setState(() {
                _progress = progress / 100;
              });
            },
  ),
        ),
      ),
    );
  }
}
