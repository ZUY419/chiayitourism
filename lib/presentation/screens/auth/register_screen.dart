import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/theme/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _useEmail = false;
  String? _gender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('註冊帳號')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Avatar upload
            GestureDetector(
              onTap: () {/* TODO: pick image */},
              child: CircleAvatar(
                radius: 45,
                backgroundColor: AppTheme.primary.withOpacity(0.1),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt, color: AppTheme.primary),
                    Text('上傳頭貼',
                        style: TextStyle(
                            fontSize: 11, color: AppTheme.primary)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const TextField(
              decoration: InputDecoration(labelText: '姓名'),
            ),
            const SizedBox(height: 16),
            // Toggle phone / email
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _useEmail = false),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: !_useEmail
                            ? AppTheme.primary.withOpacity(0.1)
                            : Colors.transparent,
                        border: Border.all(
                          color: !_useEmail
                              ? AppTheme.primary
                              : AppTheme.divider,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(child: Text('電話號碼')),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _useEmail = true),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _useEmail
                            ? AppTheme.primary.withOpacity(0.1)
                            : Colors.transparent,
                        border: Border.all(
                          color:
                          _useEmail ? AppTheme.primary : AppTheme.divider,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(child: Text('電子郵件')),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: _useEmail ? '電子郵件' : '電話號碼',
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: '密碼'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: '性別'),
                    value: _gender,
                    items: const [
                      DropdownMenuItem(value: 'male', child: Text('男')),
                      DropdownMenuItem(value: 'female', child: Text('女')),
                      DropdownMenuItem(value: 'other', child: Text('其他')),
                    ],
                    onChanged: (v) => setState(() => _gender = v),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: '生日',
                      suffixIcon: Icon(Icons.calendar_today),
                      helperText: '※ 注册後無法修改',
                    ),
                    onTap: () async {
                      await showDatePicker(
                        context: context,
                        initialDate: DateTime(2000),
                        firstDate: DateTime(1920),
                        lastDate: DateTime.now(),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Firebase register
                  context.pop();
                },
                child: const Text('確認註冊'),
              ),
            ),
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('返回登入'),
            ),
          ],
        ),
      ),
    );
  }
}