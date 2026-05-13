import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme.dart';

class UbikeDetailScreen extends StatelessWidget {
  final String stationId;

  const UbikeDetailScreen({super.key, required this.stationId});

  @override
  Widget build(BuildContext context) {
    // TODO: fetch real TDX data
    return Scaffold(
      appBar: AppBar(
        title: const Text('YouBike 站點'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.secondary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.pedal_bike,
                      color: AppTheme.secondary, size: 32),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('YouBike 嘉義公園',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('更新時間：${DateTime.now().hour}:${DateTime.now().minute}',
                        style:
                        const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text('可借車輛',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _BikeCountCard(
                    label: 'YouBike 2.0',
                    count: 8,
                    icon: Icons.directions_bike,
                    color: AppTheme.secondary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _BikeCountCard(
                    label: 'YouBike 2.0E\n（電輔車）',
                    count: 3,
                    icon: Icons.electric_bike,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _BikeCountCard(
              label: '可停空位',
              count: 14,
              icon: Icons.local_parking,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

class _BikeCountCard extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;
  final Color color;

  const _BikeCountCard({
    required this.label,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 8),
          Text(
            '$count',
            style: TextStyle(
                fontSize: 36, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 4),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 13, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}