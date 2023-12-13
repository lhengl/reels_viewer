import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final String? title;
  final String message;
  final VoidCallback? onRetry;

  const ErrorPage({
    super.key,
    this.title = 'Oops! Something went wrong',
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.white,
            size: 60,
          ),
          const SizedBox(height: 16),
          if (title != null)
            Text(
              title!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          if (onRetry != null)
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry',
                  style: TextStyle(
                    color: Colors.white,
                  )),
            ),
        ],
      ),
    );
  }
}
