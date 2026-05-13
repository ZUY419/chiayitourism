import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('忘記密碼')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('請輸入您的電話或電子郵件，我們將發送重設密碼連結。',
                style: TextStyle(fontSize: 15)),
            const SizedBox(height: 24),
            const TextField(
              decoration:
              InputDecoration(labelText: '電話 或 電子郵件'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Firebase send reset
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('重設連結已發送')),
                  );
                  Navigator.pop(context);
                },
                child: const Text('發送重設連結'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}