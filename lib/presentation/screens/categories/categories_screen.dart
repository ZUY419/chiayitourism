import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/constants/app_constants.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../routes/app_router.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String? _selectedType;
  final List<String> _selectedTags = [];
  String _sortBy = 'default'; // default | rating_desc | rating_asc

  static const _types = [
    (label: '飯店', value: AppConstants.typeHotel, icon: Icons.hotel),
    (label: '餐廳', value: AppConstants.typeRestaurant, icon: Icons.restaurant),
    (label: '景點', value: AppConstants.typeAttraction, icon: Icons.place),
    (label: '咖啡廳', value: AppConstants.typeCafe, icon: Icons.coffee),
    (label: '公車', value: AppConstants.typeBusStop, icon: Icons.directions_bus),
    (label: '火車', value: AppConstants.typeTrainStation, icon: Icons.train),
    (label: 'UBike', value: AppConstants.typeUbike, icon: Icons.pedal_bike),
  ];

  static const _allTags = ['有插座', '寵物友善', '免費Wi-Fi', '停車場', '景觀座位', '24小時'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('分類搜尋')),
      body: _selectedType == null
          ? _buildTypeGrid()
          : _buildResultsView(),
    );
  }

  Widget _buildTypeGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.6,
      ),
      itemCount: _types.length,
      itemBuilder: (context, i) {
        final t = _types[i];
        return GestureDetector(
          onTap: () => setState(() => _selectedType = t.value),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(t.icon, color: AppTheme.primary, size: 32),
                const SizedBox(height: 8),
                Text(t.label,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildResultsView() {
    final typeName = _types
        .firstWhere((t) => t.value == _selectedType)
        .label;

    return Column(
      children: [
        // Back to type selection + tag filters
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            children: [
              TextButton.icon(
                icon: const Icon(Icons.arrow_back_ios, size: 14),
                label: Text(typeName),
                onPressed: () => setState(() => _selectedType = null),
              ),
              const Spacer(),
              // Sort menu
              PopupMenuButton<String>(
                initialValue: _sortBy,
                onSelected: (v) => setState(() => _sortBy = v),
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'default', child: Text('系統預設')),
                  PopupMenuItem(value: 'rating_desc', child: Text('評分高到低')),
                  PopupMenuItem(value: 'rating_asc', child: Text('評分低到高')),
                ],
                child: Row(children: [
                  const Icon(Icons.sort, size: 18),
                  const SizedBox(width: 4),
                  Text(_sortBy == 'default' ? '預設排序' : '評分排序'),
                ]),
              ),
            ],
          ),
        ),
        // Tag chips
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            itemCount: _allTags.length,
            separatorBuilder: (_, __) => const SizedBox(width: 6),
            itemBuilder: (context, i) {
              final tag = _allTags[i];
              final selected = _selectedTags.contains(tag);
              return FilterChip(
                label: Text(tag),
                selected: selected,
                onSelected: (_) => setState(() {
                  selected
                      ? _selectedTags.remove(tag)
                      : _selectedTags.add(tag);
                }),
              );
            },
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 8,
            itemBuilder: (context, i) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.place, color: AppTheme.primary),
                ),
                title: Text('$typeName ${i + 1}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('嘉義市東區範例路',
                        style: TextStyle(fontSize: 12)),
                    const SizedBox(height: 2),
                    Row(children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      Text(' ${(4.8 - i * 0.1).toStringAsFixed(1)}'),
                    ]),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {},
                ),
                isThreeLine: true,
                onTap: () =>
                    context.push('${AppRoutes.spotDetail}/cat-$i'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}