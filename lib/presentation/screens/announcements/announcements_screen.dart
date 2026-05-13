import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_constants.dart';
import '../../../../../../core/theme/app_theme.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  String? _selectedSource;

  static const _sources = [
    (label: '全部', value: null),
    (label: '嘉義市政府', value: AppConstants.announcementChiayiCity),
    (label: '嘉義縣政府', value: AppConstants.announcementChiayiCounty),
    (label: '系統公告', value: AppConstants.announcementSystem),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('公告')),
      body: Column(
        children: [
          SizedBox(
            height: 52,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _sources.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final s = _sources[i];
                return ChoiceChip(
                  label: Text(s.label),
                  selected: _selectedSource == s.value,
                  onSelected: (_) =>
                      setState(() => _selectedSource = s.value),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: 8,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) => _AnnouncementTile(
                source: i % 3 == 0
                    ? '嘉義市政府'
                    : i % 3 == 1
                    ? '嘉義縣政府'
                    : '系統公告',
                title: '公告標題 ${i + 1}',
                date: '2025-05-${(i + 1).toString().padLeft(2, '0')}',
                onTap: () => _showDetail(context, i),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDetail(BuildContext context, int i) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('公告標題 ${i + 1}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text('2025-05-12',
                  style: TextStyle(color: AppTheme.textSecondary)),
              const Divider(height: 24),
              const Text(
                '這裡是公告的完整內容。包含旅遊政策更新、文化觀光動態及各類藝文與體育活動資訊等。',
                style: TextStyle(height: 1.8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnnouncementTile extends StatelessWidget {
  final String source;
  final String title;
  final String date;
  final VoidCallback onTap;

  const _AnnouncementTile({
    required this.source,
    required this.title,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.campaign, color: AppTheme.primary, size: 20),
      ),
      title: Text(title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      subtitle: Text('$source · $date',
          style:
          const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }
}