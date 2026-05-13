import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../routes/app_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              // App Logo
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text('諸羅',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ),
              const SizedBox(height: 32),
              const Text('探索諸羅',
                  style:
                  TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('登入您的帳號',
                  style: TextStyle(color: AppTheme.textSecondary)),
              const SizedBox(height: 40),
              // Account field
              const TextField(
                decoration: InputDecoration(
                  labelText: '帳號（電話或電子郵件）',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 16),
              // Password field
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '密碼',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => context.push(AppRoutes.forgotPassword),
                  child: const Text('忘記密碼？'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go(AppRoutes.map),
                  child: const Text('登入'),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.push(AppRoutes.register),
                child: const Text('前往註冊'),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}