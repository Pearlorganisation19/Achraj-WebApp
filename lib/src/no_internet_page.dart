import 'package:flutter/material.dart';

class NoInternetPage extends StatelessWidget {
  final Function()? onRetry;

  const NoInternetPage({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, size: 100),
          SizedBox(height: 20),
          Text(
            'No Internet Connection',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 20)
        ],
      ),
    );
  }
}
