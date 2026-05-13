import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../routes/app_router.dart';
import '../../screens/map/map_screen.dart';

class SideDrawer extends ConsumerWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      width: 220,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User avatar area
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppTheme.primary.withOpacity(0.15),
                    child: const Icon(Icons.person,
                        color: AppTheme.primary, size: 28),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('使用者名稱',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      SizedBox(height: 2),
                      Text('user@email.com',
                          style: TextStyle(
                              fontSize: 12, color: AppTheme.textSecondary)),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            _DrawerItem(
              icon: Icons.settings,
              label: '設定',
              onTap: () {
                Navigator.pop(context);
                context.push(AppRoutes.settings);
              },
            ),
            _DrawerItem(
              icon: Icons.card_giftcard,
              label: '集點',
              onTap: () {
                Navigator.pop(context);
                context.push(AppRoutes.stamps);
              },
            ),
            _DrawerItem(
              icon: Icons.favorite_border,
              label: '收藏',
              onTap: () {
                Navigator.pop(context);
                context.push(AppRoutes.favorites);
              },
            ),
            _DrawerItem(
              icon: Icons.event,
              label: '活動',
              onTap: () {
                Navigator.pop(context);
                context.push(AppRoutes.activities);
              },
            ),
            _DrawerItem(
              icon: Icons.local_offer_outlined,
              label: '優惠券',
              onTap: () {
                Navigator.pop(context);
                context.push(AppRoutes.coupons);
              },
            ),
            _DrawerItem(
              icon: Icons.campaign_outlined,
              label: '公告',
              onTap: () {
                Navigator.pop(context);
                context.push(AppRoutes.announcements);
              },
            ),
            const Spacer(),
            const Divider(),
            _DrawerItem(
              icon: Icons.logout,
              label: '登出',
              color: AppTheme.error,
              onTap: () {
                ref.read(isLoggedInProvider.notifier).state = false;
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppTheme.textPrimary;
    return ListTile(
      leading: Icon(icon, color: c, size: 22),
      title: Text(label,
          style: TextStyle(color: c, fontWeight: FontWeight.w500)),
      onTap: onTap,
      dense: true,
    );
  }
}