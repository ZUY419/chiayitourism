import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_constants.dart';
import '../../../../../../core/theme/app_theme.dart';

class StationDetailScreen extends StatefulWidget {
  final String stationId;
  final String type; // bus_stop | train_station

  const StationDetailScreen({
    super.key,
    required this.stationId,
    required this.type,
  });

  @override
  State<StationDetailScreen> createState() => _StationDetailScreenState();
}

class _StationDetailScreenState extends State<StationDetailScreen> {
  String _direction = AppConstants.directionNorthbound;
  String _trainTypeFilter = 'all';

  bool get _isTrain => widget.type == AppConstants.typeTrainStation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isTrain ? '火車站資訊' : '公車站資訊'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {/* TODO */},
          ),
        ],
      ),
      body: Column(
        children: [
          // Station name header
          Container(
            padding: const EdgeInsets.all(16),
            color: AppTheme.primary.withOpacity(0.08),
            child: Row(
              children: [
                Icon(
                  _isTrain ? Icons.train : Icons.directions_bus,
                  color: AppTheme.primary,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isTrain ? '嘉義火車站' : '嘉義轉運站',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Text('嘉義市西區中山路',
                        style: TextStyle(color: AppTheme.textSecondary)),
                  ],
                ),
              ],
            ),
          ),

          if (_isTrain) ...[
            // Train type filter
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['all', '自強', '區間', '莒光', '復興']
                      .map((t) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(t == 'all' ? '全部' : t),
                      selected: _trainTypeFilter == t,
                      onSelected: (_) =>
                          setState(() => _trainTypeFilter = t),
                    ),
                  ))
                      .toList(),
                ),
              ),
            ),
            // Direction tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  _DirectionButton(
                    label: '北上',
                    selected:
                    _direction == AppConstants.directionNorthbound,
                    onTap: () => setState(
                            () => _direction = AppConstants.directionNorthbound),
                  ),
                  const SizedBox(width: 8),
                  _DirectionButton(
                    label: '南下',
                    selected:
                    _direction == AppConstants.directionSouthbound,
                    onTap: () => setState(
                            () => _direction = AppConstants.directionSouthbound),
                  ),
                ],
              ),
            ),
          ],

          // Schedule list
          Expanded(
            child: _isTrain
                ? _TrainScheduleList(
              direction: _direction,
              typeFilter: _trainTypeFilter,
            )
                : _BusArrivalList(stopId: widget.stationId),
          ),
        ],
      ),
    );
  }
}

class _DirectionButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DirectionButton(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary : Colors.transparent,
          border: Border.all(
              color: selected ? AppTheme.primary : AppTheme.divider),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
              color: selected ? Colors.white : AppTheme.textPrimary,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _TrainScheduleList extends StatelessWidget {
  final String direction;
  final String typeFilter;

  const _TrainScheduleList(
      {required this.direction, required this.typeFilter});

  @override
  Widget build(BuildContext context) {
    // TODO: fetch real TDX data
    final stubs = List.generate(
        8,
            (i) => (
        type: i % 2 == 0 ? '自強' : '區間',
        no: '${3000 + i * 7}',
        time: '${10 + i}:${(i * 7) % 60 < 10 ? '0${(i * 7) % 60}' : '${(i * 7) % 60}'}',
        dest: i % 2 == 0 ? '台北' : '台南',
        ));

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: stubs.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final s = stubs[i];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: s.type == '自強'
                      ? Colors.red.shade50
                      : Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(s.type,
                    style: TextStyle(
                        color: s.type == '自強' ? Colors.red : Colors.blue,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Text(s.no, style: const TextStyle(fontWeight: FontWeight.w500)),
              const Spacer(),
              Text(s.dest,
                  style: const TextStyle(color: AppTheme.textSecondary)),
              const SizedBox(width: 16),
              Text(s.time,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        );
      },
    );
  }
}

class _BusArrivalList extends StatelessWidget {
  final String stopId;

  const _BusArrivalList({required this.stopId});

  @override
  Widget build(BuildContext context) {
    // TODO: fetch real TDX data
    final stubs = List.generate(
        6,
            (i) => (
        busNo: '市區${i + 1}號',
        eta: i * 3 + 1,
        direction: i % 2 == 0 ? '往嘉義大學' : '往火車站',
        ));

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: stubs.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final b = stubs[i];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(b.busNo,
                    style: const TextStyle(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Expanded(
                  child: Text(b.direction,
                      style:
                      const TextStyle(color: AppTheme.textSecondary))),
              Text('${b.eta} 分鐘',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: AppTheme.primary)),
            ],
          ),
        );
      },
    );
  }
}