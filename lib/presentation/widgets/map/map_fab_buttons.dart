import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../../core/constants/app_constants.dart';
import '../../../../../../core/theme/app_theme.dart';

class MapFabButtons extends StatelessWidget {
  final MapController mapController;

  const MapFabButtons({super.key, required this.mapController});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Zoom in
        _MapFab(
          icon: Icons.add,
          onTap: () => mapController.move(
            mapController.camera.center,
            mapController.camera.zoom + 1,
          ),
        ),
        const SizedBox(height: 8),
        // Zoom out
        _MapFab(
          icon: Icons.remove,
          onTap: () => mapController.move(
            mapController.camera.center,
            mapController.camera.zoom - 1,
          ),
        ),
        const SizedBox(height: 8),
        // Back to Chiayi
        _MapFab(
          icon: Icons.my_location,
          onTap: () => mapController.move(
            const LatLng(AppConstants.chiaYiLat, AppConstants.chiaYiLng),
            AppConstants.defaultZoom,
          ),
        ),
      ],
    );
  }
}

class _MapFab extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _MapFab({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
          ],
        ),
        child: Icon(icon, size: 20, color: AppTheme.textPrimary),
      ),
    );
  }
}