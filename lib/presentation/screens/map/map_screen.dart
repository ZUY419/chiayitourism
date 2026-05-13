import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../../core/constants/app_constants.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../routes/app_router.dart';
import '../../widgets/map/category_filter_bar.dart';
import '../../widgets/map/map_fab_buttons.dart';
import '../../widgets/map/side_drawer.dart';
import '../../widgets/map/map_marker_layer.dart';

// Provider for selected category filter
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

// Provider for auth state (stub)
final isLoggedInProvider = StateProvider<bool>((ref) => false);

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final MapController _mapController = MapController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const SideDrawer(),
      body: Stack(
        children: [
          // ── OpenStreetMap ──
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: LatLng(
                AppConstants.chiaYiLat,
                AppConstants.chiaYiLng,
              ),
              initialZoom: AppConstants.defaultZoom,
            ),
            children: [
              TileLayer(
                urlTemplate:
                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.chiayitourism',
              ),
              MapMarkerLayer(selectedCategory: selectedCategory),
            ],
          ),

          // ── Top bar: search + category filter ──
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Row(
                    children: [
                      // Search button
                      _TopBarButton(
                        icon: Icons.search,
                        onTap: () => context.push(AppRoutes.search),
                      ),
                      const Spacer(),
                      // User / drawer button
                      _TopBarButton(
                        icon: ref.watch(isLoggedInProvider)
                            ? Icons.person
                            : Icons.person_outline,
                        onTap: () {
                          if (ref.read(isLoggedInProvider)) {
                            _scaffoldKey.currentState?.openEndDrawer();
                          } else {
                            context.push(AppRoutes.login);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Category filter chips
                CategoryFilterBar(
                  selected: selectedCategory,
                  onSelected: (category) {
                    ref.read(selectedCategoryProvider.notifier).state =
                    category == selectedCategory ? null : category;
                  },
                ),
              ],
            ),
          ),

          // ── Bottom FABs ──
          Positioned(
            right: 16,
            bottom: 100,
            child: MapFabButtons(mapController: _mapController),
          ),

          // ── Categories shortcut (bottom-left) ──
          Positioned(
            left: 16,
            bottom: 100,
            child: FloatingActionButton.small(
              heroTag: 'categories',
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.primary,
              onPressed: () => context.push(AppRoutes.categories),
              child: const Icon(Icons.grid_view_rounded),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _TopBarButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
          ],
        ),
        child: Icon(icon, color: AppTheme.textPrimary, size: 22),
      ),
    );
  }
}