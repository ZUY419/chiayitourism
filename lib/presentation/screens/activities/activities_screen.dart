import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../../../core/theme/app_theme.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _isListView = false;

  // Stub event days
  final Map<DateTime, List<String>> _events = {
    DateTime.utc(DateTime.now().year, DateTime.now().month, 15): ['活動A'],
    DateTime.utc(DateTime.now().year, DateTime.now().month, 20): ['活動B', '活動C'],
  };

  List<String> _eventsForDay(DateTime day) {
    return _events[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('活動'),
        actions: [
          IconButton(
            icon: Icon(_isListView ? Icons.calendar_today : Icons.list),
            onPressed: () => setState(() => _isListView = !_isListView),
            tooltip: _isListView ? '切換日曆' : '切換清單',
          ),
        ],
      ),
      body: _isListView ? _buildListView() : _buildCalendarView(),
    );
  }

  Widget _buildCalendarView() {
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2024, 1, 1),
          lastDay: DateTime.utc(2026, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          eventLoader: _eventsForDay,
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.4),
              shape: BoxShape.circle,
            ),
            selectedDecoration: const BoxDecoration(
              color: AppTheme.primary,
              shape: BoxShape.circle,
            ),
            markerDecoration: const BoxDecoration(
              color: AppTheme.secondary,
              shape: BoxShape.circle,
            ),
          ),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            final events = _eventsForDay(selectedDay);
            if (events.isNotEmpty) _showDayEventsSheet(context, selectedDay, events);
          },
          onFormatChanged: (format) =>
              setState(() => _calendarFormat = format),
          onPageChanged: (focusedDay) => _focusedDay = focusedDay,
        ),
        const Divider(),
        if (_selectedDay != null)
          Expanded(
            child: _ActivityListForDay(
                events: _eventsForDay(_selectedDay!)),
          )
        else
          const Expanded(
            child: Center(
              child: Text('點選日期查看活動',
                  style: TextStyle(color: AppTheme.textSecondary)),
            ),
          ),
      ],
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 8,
      itemBuilder: (context, i) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.event, color: AppTheme.primary),
          ),
          title: Text('活動名稱 ${i + 1}'),
          subtitle: Text('活動內容說明 · 主辦：店家${i + 1}'),
          trailing: IconButton(
            icon: const Icon(Icons.notifications_none, color: AppTheme.primary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('已加入行事曆')),
              );
            },
          ),
          onTap: () {},
        ),
      ),
    );
  }

  void _showDayEventsSheet(
      BuildContext context, DateTime day, List<String> events) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${day.month}月${day.day}日的活動',
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...events.map((e) => ListTile(
              title: Text(e),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            )),
          ],
        ),
      ),
    );
  }
}

class _ActivityListForDay extends StatelessWidget {
  final List<String> events;

  const _ActivityListForDay({required this.events});

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const Center(
          child: Text('今日無活動', style: TextStyle(color: AppTheme.textSecondary)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: events.length,
      itemBuilder: (context, i) => Card(
        child: ListTile(
          title: Text(events[i]),
          subtitle: const Text('活動說明 · 主辦方'),
          trailing: IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}