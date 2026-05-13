import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../routes/app_router.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _selectedFilter = 'all';

  static const _filters = [
    (label: '全部', value: 'all'),
    (label: '住宿', value: 'hotel'),
    (label: '餐廳', value: 'restaurant'),
    (label: '咖啡廳', value: 'cafe'),
    (label: '公車站', value: 'bus_stop'),
    (label: '景點', value: 'attraction'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: '請輸入關鍵字',
            border: InputBorder.none,
            hintStyle: TextStyle(color: AppTheme.textSecondary),
          ),
          onChanged: (v) => ref.read(searchQueryProvider.notifier).state = v,
        ),
      ),
      body: Column(
        children: [
          // Filter chips
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final f = _filters[i];
                final selected = _selectedFilter == f.value;
                return ChoiceChip(
                  label: Text(f.label),
                  selected: selected,
                  onSelected: (_) =>
                      setState(() => _selectedFilter = f.value),
                  selectedColor: AppTheme.primary.withOpacity(0.2),
                );
              },
            ),
          ),
          const Divider(height: 1),
          // Results list
          Expanded(
            child: _SearchResultsList(
              query: _controller.text,
              filter: _selectedFilter,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchResultsList extends StatelessWidget {
  final String query;
  final String filter;

  const _SearchResultsList({required this.query, required this.filter});

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Text('輸入關鍵字搜尋景點、餐廳、咖啡廳...',
            style: TextStyle(color: AppTheme.textSecondary)),
      );
    }
    // TODO: replace with real search results from Firestore
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) => _SearchResultCard(
        name: '搜尋結果 ${index + 1}',
        address: '嘉義市東區範例路 ${index + 1} 號',
        type: filter == 'all' ? 'restaurant' : filter,
        rating: 4.5 - index * 0.2,
        onTap: () => context.push('${AppRoutes.spotDetail}/stub-$index'),
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final String name;
  final String address;
  final String type;
  final double rating;
  final VoidCallback onTap;

  const _SearchResultCard({
    required this.name,
    required this.address,
    required this.type,
    required this.rating,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppTheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.restaurant, color: AppTheme.primary),
        ),
        title: Text(name,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(address,
            style: const TextStyle(
                fontSize: 12, color: AppTheme.textSecondary)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 16),
            Text(rating.toStringAsFixed(1),
                style: const TextStyle(fontSize: 12)),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}