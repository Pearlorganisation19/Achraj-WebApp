import 'dart:async';
import 'package:achraj/src/no_internet_page.dart';
import 'package:achraj/src/web_view_stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:splashify/splashify.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home:  Splashify(
          imagePath: 'assets/applogo.png',
          imageSize: 400,
          navigateDuration: 4,
          child: const WebViewApp()),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class WebViewApp extends StatefulWidget {
  const WebViewApp({super.key});

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  late StreamSubscription<InternetStatus> listener;
  late final WebViewController controller;
  bool isConnected = true;
  bool isReday =false;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 3),(){
      setState(() {

        isReday=true;
      });
    });

    super.initState();
    _startListening();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse('https://www.dealmih.com/'),
      );
  }

  @override
  void dispose() {
    listener.cancel(); // Cancel the subscription when disposing
    super.dispose();
  }

  void _startListening() {
    listener = InternetConnection().onStatusChange.listen((InternetStatus status) {
      setState(() {
        isConnected = status == InternetStatus.connected;

        if (isConnected) {
          loadWebView();
        }

      });
    });
  }

  void loadWebView() {
    controller.loadRequest(Uri.parse('https://www.dealmih.com/'));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.blueAccent, // Use your desired color here
      statusBarIconBrightness: Brightness.light, // Use Brightness.dark if your status bar icons are light-colored
    ));
    print('isConnected: $isConnected');
    return Scaffold(
      body: isReday?SafeArea(
        child: isConnected
            ? RefreshIndicator(
          onRefresh: () async {
            loadWebView();
          },
          child: WebViewStack(controller: controller),
        )
            : const NoInternetPage(
          onRetry: null, // You can pass a retry function here
        ),
      ):Center(child: CircularProgressIndicator(),),
    );
  }
}
