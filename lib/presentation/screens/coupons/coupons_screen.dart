import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_constants.dart';
import '../../../../../../core/theme/app_theme.dart';

class CouponsScreen extends StatefulWidget {
  const CouponsScreen({super.key});

  @override
  State<CouponsScreen> createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<CouponsScreen> {
  String _stateFilter = AppConstants.couponAvailable;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('優惠券')),
      body: Column(
        children: [
          // State filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                (label: '可使用', value: AppConstants.couponAvailable),
                (label: '已使用', value: AppConstants.couponUsed),
                (label: '已過期', value: AppConstants.couponExpired),
              ]
                  .map((f) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(f.label),
                  selected: _stateFilter == f.value,
                  onSelected: (_) =>
                      setState(() => _stateFilter = f.value),
                ),
              ))
                  .toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 4,
              itemBuilder: (context, i) => _CouponCard(
                title: i == 0 ? '生日禮金 NT\$200' : '集點兌換 NT\$100',
                content: i == 0 ? '生日當月可使用' : '咖啡廳集點兌換',
                state: _stateFilter,
                type: i == 0
                    ? AppConstants.couponTypeBirthday
                    : AppConstants.couponTypeStamp,
                endDate: '2025-12-31',
                onUse: _stateFilter == AppConstants.couponAvailable
                    ? () => _showUseDialog(context, i)
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showUseDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber, color: Colors.orange),
            SizedBox(width: 8),
            Text('使用優惠券'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('注意事項：'),
            SizedBox(height: 8),
            Text('• 使用後無法復原'),
            Text('• 請確認店員已看到畫面'),
            Text('• 限當日使用'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消使用'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('優惠券已核銷')),
              );
            },
            child: const Text('確認使用'),
          ),
        ],
      ),
    );
  }
}

class _CouponCard extends StatelessWidget {
  final String title;
  final String content;
  final String state;
  final String type;
  final String endDate;
  final VoidCallback? onUse;

  const _CouponCard({
    required this.title,
    required this.content,
    required this.state,
    required this.type,
    required this.endDate,
    this.onUse,
  });

  Color get _typeColor => switch (type) {
    AppConstants.couponTypeBirthday => Colors.pink,
    AppConstants.couponTypeActivity => Colors.blue,
    _ => AppTheme.primary,
  };

  @override
  Widget build(BuildContext context) {
    final isAvailable = state == AppConstants.couponAvailable;

    return Opacity(
      opacity: isAvailable ? 1.0 : 0.5,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            // Left colored strip
            Container(
              width: 12,
              height: 100,
              decoration: BoxDecoration(
                color: _typeColor,
                borderRadius:
                const BorderRadius.horizontal(left: Radius.circular(16)),
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(content,
                        style: const TextStyle(color: AppTheme.textSecondary)),
                    const SizedBox(height: 8),
                    Text('使用期限：$endDate',
                        style: const TextStyle(
                            fontSize: 12, color: AppTheme.textSecondary)),
                  ],
                ),
              ),
            ),
            // Use button
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: state == AppConstants.couponAvailable
                  ? ElevatedButton(
                onPressed: onUse,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _typeColor,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('使用'),
              )
                  : Text(
                state == AppConstants.couponUsed ? '已使用' : '已過期',
                style: const TextStyle(color: AppTheme.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}