import 'package:flutter/material.dart';


class NetworkErrorScreen extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const NetworkErrorScreen({
    super.key,
    this.message = "No Internet Connection",
    this.onRetry,
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off, size: 80, color: Colors.orange),
              const SizedBox(height: 20),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              if (onRetry != null)
                ElevatedButton(
                  onPressed: onRetry,
                  child: const Text("Retry"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
