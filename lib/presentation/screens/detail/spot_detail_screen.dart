import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../data/models/models.dart';

class SpotDetailScreen extends ConsumerStatefulWidget {
  final String spotId;
  const SpotDetailScreen({super.key, required this.spotId});

  @override
  ConsumerState<SpotDetailScreen> createState() => _SpotDetailScreenState();
}

class _SpotDetailScreenState extends ConsumerState<SpotDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isFavorited = false;
  // Tabs vary by spot type; restaurant/cafe = 資訊/菜單/評論/活動
  // attraction = 資訊/評論/活動, hotel = 資訊/評論
  final _tabs = const ['資訊', '菜單', '評論', '活動'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: fetch real spot data from Firestore
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            leading: const BackButton(),
            actions: [
              IconButton(
                icon: Icon(
                  _isFavorited ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorited ? AppTheme.error : null,
                ),
                onPressed: () =>
                    setState(() => _isFavorited = !_isFavorited),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('店家名稱'),
              background: Container(
                color: AppTheme.primary.withOpacity(0.2),
                child: const Center(
                  child: Icon(Icons.image, size: 64, color: Colors.white54),
                ),
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              tabs: _tabs.map((t) => Tab(text: t)).toList(),
              labelColor: AppTheme.primary,
              unselectedLabelColor: AppTheme.textSecondary,
              indicatorColor: AppTheme.primary,
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _InfoTab(spotId: widget.spotId),
            _MenuTab(),
            _CommentsTab(spotId: widget.spotId),
            _ActivitiesTab(spotId: widget.spotId),
          ],
        ),
      ),
    );
  }
}

// ── Info Tab ──
class _InfoTab extends StatelessWidget {
  final String spotId;
  const _InfoTab({required this.spotId});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tags row
          Wrap(
            spacing: 8,
            children: ['有插座', '寵物友善', '免費Wi-Fi']
                .map((t) => Chip(label: Text(t)))
                .toList(),
          ),
          const SizedBox(height: 16),
          // Rating
          Row(children: [
            ...List.generate(5, (i) => const Icon(Icons.star, color: Colors.amber, size: 20)),
            const SizedBox(width: 8),
            const Text('4.5 (128 則評論)',
                style: TextStyle(color: AppTheme.textSecondary)),
          ]),
          const SizedBox(height: 16),
          // Address
          _InfoRow(icon: Icons.location_on, text: '嘉義市東區範例路1號'),
          _InfoRow(icon: Icons.phone, text: '05-XXX-XXXX'),
          const SizedBox(height: 16),
          const Text('店家介紹',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          const Text('這裡是店家的詳細介紹文字，包含環境、特色等資訊...'),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.primary),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

// ── Menu Tab ──
class _MenuTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, i) => ListTile(
        leading: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppTheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.fastfood, color: AppTheme.primary),
        ),
        title: Text('招牌菜 ${i + 1}'),
        trailing: Text('NT\$ ${80 + i * 20}',
            style: const TextStyle(
                color: AppTheme.primary, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

// ── Comments Tab ──
class _CommentsTab extends StatelessWidget {
  final String spotId;
  const _CommentsTab({required this.spotId});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.edit),
            label: const Text('撰寫評論'),
            onPressed: () => _showWriteCommentDialog(context),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 5,
            itemBuilder: (context, i) => _CommentCard(index: i),
          ),
        ),
      ],
    );
  }

  void _showWriteCommentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('撰寫評論'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  5,
                      (i) => IconButton(
                    icon: const Icon(Icons.star_border,
                        color: Colors.amber),
                    onPressed: () {},
                  )),
            ),
            const TextField(
              maxLines: 3,
              decoration: InputDecoration(hintText: '分享您的體驗...'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消')),
          ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('發送')),
        ],
      ),
    );
  }
}

class _CommentCard extends StatefulWidget {
  final int index;
  const _CommentCard({required this.index});

  @override
  State<_CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<_CommentCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => setState(() => _expanded = !_expanded),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppTheme.primary.withOpacity(0.15),
                    child: const Icon(Icons.person,
                        color: AppTheme.primary, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('用戶名稱 ${widget.index + 1}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold)),
                      Row(
                        children: List.generate(
                            5,
                                (i) => const Icon(Icons.star,
                                color: Colors.amber, size: 14)),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text('這家店超讚！環境舒適，服務也很好，下次還會再來。'),
              if (_expanded) ...[
                const Divider(),
                // Replies
                const Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('回覆 by 店家：謝謝您的評論！',
                          style: TextStyle(color: AppTheme.textSecondary)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('回覆'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── Activities Tab ──
class _ActivitiesTab extends StatelessWidget {
  final String spotId;
  const _ActivitiesTab({required this.spotId});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, i) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('活動名稱 ${i + 1}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    const Text('活動內容描述...',
                        style: TextStyle(color: AppTheme.textSecondary)),
                    const SizedBox(height: 4),
                    const Text('主辦方：店家名稱',
                        style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.notifications_none),
                color: AppTheme.primary,
                onPressed: () {
                  // TODO: add to calendar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('已加入行事曆')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}