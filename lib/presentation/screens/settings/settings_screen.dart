import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../routes/app_router.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppTheme.primary.withOpacity(0.15),
                  child: const Icon(Icons.person,
                      size: 48, color: AppTheme.primary),
                ),
                if (_isEditing)
                  Container(
                    decoration: const BoxDecoration(
                      color: AppTheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt,
                          color: Colors.white, size: 18),
                      onPressed: () {/* TODO: pick image */},
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),

            // Fields
            _SettingField(
              label: '名稱',
              value: '使用者名稱',
              enabled: _isEditing,
            ),
            _SettingField(
              label: '手機/郵件',
              value: '09XX-XXX-XXX',
              enabled: _isEditing,
              helperText: _isEditing ? '需經認證才能修改' : null,
            ),
            if (_isEditing) ...[
              _SettingField(label: '舊密碼', value: '', enabled: true, obscure: true),
              _SettingField(label: '新密碼', value: '', enabled: true, obscure: true),
            ] else
              const _SettingField(label: '密碼', value: '••••••••', enabled: false),
            _SettingField(
              label: '性別',
              value: '男',
              enabled: _isEditing,
            ),
            _SettingField(
              label: '生日',
              value: '1990-01-01',
              enabled: false,
              helperText: '生日不可修改',
            ),
            const SizedBox(height: 20),

            // Edit / Confirm buttons
            Row(
              children: [
                if (_isEditing) ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => setState(() => _isEditing = false),
                      child: const Text('取消'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: save to Firestore
                        setState(() => _isEditing = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('資料已更新')));
                      },
                      child: const Text('確認'),
                    ),
                  ),
                ] else
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.edit),
                      label: const Text('編輯'),
                      onPressed: () => setState(() => _isEditing = true),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 12),

            // Register store button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.storefront),
                label: const Text('註冊店家'),
                onPressed: () => context.push(AppRoutes.registerStore),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingField extends StatelessWidget {
  final String label;
  final String value;
  final bool enabled;
  final bool obscure;
  final String? helperText;

  const _SettingField({
    required this.label,
    required this.value,
    required this.enabled,
    this.obscure = false,
    this.helperText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        initialValue: value,
        enabled: enabled,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          helperText: helperText,
          helperStyle: const TextStyle(color: Colors.orange, fontSize: 11),
        ),
      ),
    );
  }
}