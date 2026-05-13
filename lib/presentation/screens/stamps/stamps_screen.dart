import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_constants.dart';
import '../../../../../../core/theme/app_theme.dart';

class StampsScreen extends StatelessWidget {
  const StampsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('集點'),
          bottom: const TabBar(
            tabs: [Tab(text: '咖啡廳'), Tab(text: '飯店'), Tab(text: '餐廳')],
          ),
        ),
        body: const TabBarView(
          children: [
            _StampTabContent(
              category: '咖啡廳',
              currentPoints: 14,
              targetPoints: AppConstants.cafePointsPerRedemption,
              reward: '100元抵用券',
              color: Colors.brown,
            ),
            _StampTabContent(
              category: '飯店',
              currentPoints: 6,
              targetPoints: AppConstants.hotelPointsPerRedemption,
              reward: '500元抵用券',
              color: Colors.purple,
            ),
            _StampTabContent(
              category: '餐廳',
              currentPoints: 3,
              targetPoints: AppConstants.restaurantPointsPerRedemption,
              reward: '100元抵用券',
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }
}

class _StampTabContent extends StatelessWidget {
  final String category;
  final int currentPoints;
  final int targetPoints;
  final String reward;
  final Color color;

  const _StampTabContent({
    required this.category,
    required this.currentPoints,
    required this.targetPoints,
    required this.reward,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Progress info
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  '$currentPoints / $targetPoints 點',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: color),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: currentPoints / targetPoints,
                    minHeight: 12,
                    backgroundColor: color.withOpacity(0.15),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
                const SizedBox(height: 12),
                Text('集滿可兌換 $reward',
                    style: const TextStyle(color: AppTheme.textSecondary)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Stamp grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: targetPoints,
            itemBuilder: (context, i) => Container(
              decoration: BoxDecoration(
                color: i < currentPoints
                    ? color
                    : color.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Icon(
                i < currentPoints ? Icons.check : Icons.circle_outlined,
                color: i < currentPoints ? Colors.white : color.withOpacity(0.3),
                size: 20,
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Add stamp button
          ElevatedButton.icon(
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('新增集點'),
            onPressed: () => _showStampDialog(context, color),
          ),
          const SizedBox(height: 16),
          const Text(
            '消費後點擊上方按鈕，輸入店家序號即可集點',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showStampDialog(BuildContext context, Color color) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.store, color: color),
            const SizedBox(width: 8),
            const Text('輸入店家序號'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('請向店員確認消費後，輸入店家提供的序號：'),
            const SizedBox(height: 16),
            const TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '店家序號',
                prefixIcon: Icon(Icons.pin),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('集點成功！')));
            },
            child: const Text('確認'),
          ),
        ],
      ),
    );
  }
}