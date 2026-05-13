import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_constants.dart';
import '../../../../../../core/theme/app_theme.dart';

class CategoryFilterBar extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onSelected;

  const CategoryFilterBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  static const _categories = [
    (label: '飯店', value: AppConstants.typeHotel, icon: Icons.hotel),
    (label: '餐廳', value: AppConstants.typeRestaurant, icon: Icons.restaurant),
    (label: '咖啡廳', value: AppConstants.typeCafe, icon: Icons.coffee),
    (label: '公車站', value: AppConstants.typeBusStop, icon: Icons.directions_bus),
    (label: 'UBike', value: AppConstants.typeUbike, icon: Icons.pedal_bike),
    (label: '火車站', value: AppConstants.typeTrainStation, icon: Icons.train),
    (label: '景點', value: AppConstants.typeAttraction, icon: Icons.place),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = selected == cat.value;
          return GestureDetector(
            onTap: () => onSelected(cat.value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primary : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2)),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    cat.icon,
                    size: 14,
                    color: isSelected ? Colors.white : AppTheme.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    cat.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color:
                      isSelected ? Colors.white : AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}