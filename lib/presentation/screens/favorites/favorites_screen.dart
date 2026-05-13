import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/constants/app_constants.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../routes/app_router.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  String _selectedType = 'all';

  static const _types = [
    (label: '全部', value: 'all'),
    (label: '飯店', value: AppConstants.typeHotel),
    (label: '餐廳', value: AppConstants.typeRestaurant),
    (label: '景點', value: AppConstants.typeAttraction),
    (label: '咖啡廳', value: AppConstants.typeCafe),
    (label: '公車', value: AppConstants.typeBusStop),
    (label: 'UBike', value: AppConstants.typeUbike),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('收藏')),
      body: Column(
        children: [
          SizedBox(
            height: 52,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _types.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final t = _types[i];
                return ChoiceChip(
                  label: Text(t.label),
                  selected: _selectedType == t.value,
                  onSelected: (_) =>
                      setState(() => _selectedType = t.value),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 6,
              itemBuilder: (context, i) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.place, color: AppTheme.primary),
                  ),
                  title: Text('收藏地點 ${i + 1}'),
                  subtitle: const Text('嘉義市東區範例路',
                      style: TextStyle(fontSize: 12)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const Text('4.5'),
                      const SizedBox(width: 8),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                  onTap: () =>
                      context.push('${AppRoutes.spotDetail}/fav-$i'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}