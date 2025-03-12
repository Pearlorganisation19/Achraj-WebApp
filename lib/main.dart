import 'dart:async';

import 'package:Finstoff/src/no_internet_page.dart';
import 'package:Finstoff/src/web_view_stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:splashify/splashify.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const WebViewApp(),
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
  bool isConnected = false;
  bool canNavigateBack = false;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse('https://finstoff.com/'),
      );
    _startListening();
    _checkNavigationState();
  }

  @override
  void dispose() {
    listener.cancel();
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
    controller.loadRequest(Uri.parse('https://finstoff.com/'));
  }

  void _checkNavigationState() async {
    canNavigateBack = await controller.canGoBack();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
    ));

    return PopScope(
      canPop: canNavigateBack,
      onPopInvoked: (bool didPop) async {
        if (didPop && canNavigateBack) {
          controller.goBack();
          _checkNavigationState();
        }
      },
      child: Splashify(
        navigateDuration: 4,
        imagePath: "assets/appstore.png",
        backgroundColor: Colors.black,
        imageFadeIn: true,
        imageSize: 300,
        child: Scaffold(
          body: SafeArea(
            child: isConnected
                ? RefreshIndicator(
              onRefresh: () async {
                loadWebView();
              },
              child: WebViewStack(controller: controller),
            )
                : NoInternetPage(
              onRetry: () {
                loadWebView();
              },
            ),
          ),
        ),
      ),
    );
  }
}