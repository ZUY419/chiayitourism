import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme.dart';

class RegisterStoreScreen extends StatefulWidget {
  const RegisterStoreScreen({super.key});

  @override
  State<RegisterStoreScreen> createState() => _RegisterStoreScreenState();
}

class _RegisterStoreScreenState extends State<RegisterStoreScreen> {
  String? _storeType;
  bool _joinStamps = false;
  final List<String> _customTags = [];
  final List<Map<String, String>> _menuItems = [];

  bool get _isFood =>
      _storeType == 'cafe' || _storeType == 'restaurant';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('註冊店家')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Store type
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: '店家類型'),
              value: _storeType,
              items: const [
                DropdownMenuItem(value: 'restaurant', child: Text('餐廳')),
                DropdownMenuItem(value: 'cafe', child: Text('咖啡廳')),
                DropdownMenuItem(value: 'hotel', child: Text('飯店')),
              ],
              onChanged: (v) => setState(() => _storeType = v),
            ),
            const SizedBox(height: 14),
            const TextField(
                decoration: InputDecoration(labelText: '店家名稱')),
            const SizedBox(height: 14),
            const TextField(
                decoration: InputDecoration(labelText: '店家位址')),
            const SizedBox(height: 14),
            const TextField(
              maxLines: 3,
              decoration: InputDecoration(labelText: '店家描述'),
            ),
            const SizedBox(height: 20),

            // Photos
            const Text('店家照片',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {/* TODO: image picker */},
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.divider),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate,
                          color: AppTheme.textSecondary, size: 32),
                      SizedBox(height: 4),
                      Text('新增照片',
                          style:
                          TextStyle(color: AppTheme.textSecondary)),
                    ],
                  ),
                ),
              ),
            ),

            // Food-specific: menu + banner photo
            if (_isFood) ...[
              const SizedBox(height: 20),
              const Text('招牌照片',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.divider),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text('新增招牌照片',
                        style:
                        TextStyle(color: AppTheme.textSecondary)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('菜單',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('新增品項'),
                    onPressed: () => _showAddMenuItemDialog(context),
                  ),
                ],
              ),
              ..._menuItems.map((item) => ListTile(
                title: Text(item['name'] ?? ''),
                trailing: Text(
                    'NT\$ ${item['price'] ?? ''}',
                    style:
                    const TextStyle(color: AppTheme.primary)),
                dense: true,
              )),
            ],

            const SizedBox(height: 20),
            // Custom tags
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('店家標籤',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('新增標籤'),
                  onPressed: () => _showAddTagDialog(context),
                ),
              ],
            ),
            Wrap(
              spacing: 8,
              children: _customTags
                  .map((t) => Chip(
                label: Text(t),
                onDeleted: () =>
                    setState(() => _customTags.remove(t)),
              ))
                  .toList(),
            ),

            const SizedBox(height: 20),
            // Join stamps
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('參與集點合作',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text(
                    '加入集點合作後，顧客消費可累積點數兌換優惠券。',
                    style: TextStyle(
                        fontSize: 13, color: AppTheme.textSecondary),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text('了解合作須知'),
                      ),
                      Switch(
                        value: _joinStamps,
                        onChanged: (v) =>
                            setState(() => _joinStamps = v),
                        activeColor: AppTheme.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: save to Firestore
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('店家註冊成功！')),
                  );
                  Navigator.pop(context);
                },
                child: const Text('確認送出'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddMenuItemDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('新增菜單品項'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: '品項名稱')),
            const SizedBox(height: 12),
            TextField(
                controller: priceCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: '價格')),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消')),
          ElevatedButton(
            onPressed: () {
              setState(() => _menuItems.add(
                  {'name': nameCtrl.text, 'price': priceCtrl.text}));
              Navigator.pop(context);
            },
            child: const Text('新增'),
          ),
        ],
      ),
    );
  }

  void _showAddTagDialog(BuildContext context) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('新增標籤'),
        content: TextField(
            controller: ctrl,
            decoration: const InputDecoration(labelText: '標籤名稱')),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消')),
          ElevatedButton(
            onPressed: () {
              if (ctrl.text.isNotEmpty) {
                setState(() => _customTags.add(ctrl.text));
              }
              Navigator.pop(context);
            },
            child: const Text('新增'),
          ),
        ],
      ),
    );
  }
}