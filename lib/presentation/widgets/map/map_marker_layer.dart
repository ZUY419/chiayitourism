import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../../core/constants/app_constants.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../routes/app_router.dart';

/// Stub data for markers — replace with real Firestore/TDX data
class _StubMarker {
  final String id;
  final String type;
  final String name;
  final double lat;
  final double lng;
  const _StubMarker(this.id, this.type, this.name, this.lat, this.lng);
}

const _stubMarkers = [
  _StubMarker('1', AppConstants.typeAttraction, '嘉義公園', 23.4801, 120.4550),
  _StubMarker('2', AppConstants.typeRestaurant, '方圓火雞肉飯', 23.4780, 120.4520),
  _StubMarker('3', AppConstants.typeCafe, '山海屯咖啡', 23.4820, 120.4480),
  _StubMarker('4', AppConstants.typeHotel, '嘉義大飯店', 23.4760, 120.4510),
  _StubMarker('5', AppConstants.typeTrainStation, '嘉義火車站', 23.4762, 120.4487),
  _StubMarker('6', AppConstants.typeBusStop, '嘉義轉運站', 23.4770, 120.4475),
  _StubMarker('7', AppConstants.typeUbike, 'YouBike 嘉義公園', 23.4808, 120.4542),
];

class MapMarkerLayer extends ConsumerWidget {
  final String? selectedCategory;

  const MapMarkerLayer({super.key, required this.selectedCategory});

  Color _colorForType(String type) {
    return switch (type) {
      AppConstants.typeRestaurant => Colors.orange,
      AppConstants.typeCafe => Colors.brown,
      AppConstants.typeHotel => Colors.purple,
      AppConstants.typeAttraction => AppTheme.primary,
      AppConstants.typeBusStop => Colors.blue,
      AppConstants.typeTrainStation => Colors.indigo,
      AppConstants.typeUbike => AppTheme.secondary,
      _ => Colors.grey,
    };
  }

  IconData _iconForType(String type) {
    return switch (type) {
      AppConstants.typeRestaurant => Icons.restaurant,
      AppConstants.typeCafe => Icons.coffee,
      AppConstants.typeHotel => Icons.hotel,
      AppConstants.typeAttraction => Icons.place,
      AppConstants.typeBusStop => Icons.directions_bus,
      AppConstants.typeTrainStation => Icons.train,
      AppConstants.typeUbike => Icons.pedal_bike,
      _ => Icons.location_on,
    };
  }

  String _routeForType(String type, String id) {
    return switch (type) {
      AppConstants.typeTrainStation ||
      AppConstants.typeBusStop =>
      '${AppRoutes.stationDetail}/$id/$type',
      AppConstants.typeUbike => '${AppRoutes.ubikeDetail}/$id',
      _ => '${AppRoutes.spotDetail}/$id',
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtered = selectedCategory == null
        ? _stubMarkers
        : _stubMarkers.where((m) => m.type == selectedCategory).toList();

    return MarkerLayer(
      markers: filtered
          .map(
            (m) => Marker(
          point: LatLng(m.lat, m.lng),
          width: 36,
          height: 36,
          child: GestureDetector(
            onTap: () => context.push(_routeForType(m.type, m.id)),
            child: Container(
              decoration: BoxDecoration(
                color: _colorForType(m.type),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2))
                ],
              ),
              child: Icon(
                _iconForType(m.type),
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
      )
          .toList(),
    );
  }
}