import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uy_ishi_calendar/entities/bloc/event_bloc.dart';
import 'package:uy_ishi_calendar/entities/bloc/event_event.dart';
import 'package:uy_ishi_calendar/entities/bloc/event_state.dart';
import 'package:uy_ishi_calendar/interface_adapters/add_event_screen.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(_selectedDate.year, _selectedDate.month);
    // Load events for the current month on init
    context
        .read<EventBloc>()
        .add(LoadEvents(DateFormat('yyyy-MM-dd').format(_selectedDate)));
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildCalendar(),
            const SizedBox(height: 20), // Adjust spacing as needed
            _buildScheduleSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: _previousMonth,
        ),
        Flexible(
          child: Text(
            DateFormat('MMMM yyyy').format(_currentMonth),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: _nextMonth,
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    int daysInMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;

    return BlocBuilder<EventBloc, EventState>(
      builder: (context, state) {
        List<Map<String, dynamic>> events = [];
        if (state is EventLoaded) {
          events = state.events;
        }

        List<Widget> dayWidgets = List.generate(daysInMonth, (index) {
          DateTime day =
              DateTime(_currentMonth.year, _currentMonth.month, index + 1);
          bool isSelected = _selectedDate.isAtSameMomentAs(day);
          bool isToday = day.year == DateTime.now().year &&
              day.month == DateTime.now().month &&
              day.day == DateTime.now().day;

          // Check if the day has events
          bool hasEvent = events.any((event) =>
              event['eventDate'] == DateFormat('yyyy-MM-dd').format(day));

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = day;
              });
              context
                  .read<EventBloc>()
                  .add(LoadEvents(DateFormat('yyyy-MM-dd').format(day)));
            },
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: isSelected ? Colors.blue : Colors.grey),
                    borderRadius: BorderRadius.circular(50),
                    color: isSelected
                        ? Colors.blue.withOpacity(0.3)
                        : (isToday
                            ? Colors.blue.withOpacity(0.5)
                            : Colors.transparent),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      color: isSelected
                          ? Colors.blue
                          : (isToday ? Colors.white : Colors.black),
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                if (hasEvent)
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          );
        });

        return Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
            ),
            itemCount: daysInMonth,
            itemBuilder: (context, index) {
              return dayWidgets[index];
            },
          ),
        );
      },
    );
  }

  Widget _buildScheduleSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Schedule",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  final newEvent = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEventScreen(),
                    ),
                  );

                  // Check if an event was returned and process it
                  if (newEvent != null) {
                    // Add the event to the event list or dispatch to your Bloc
                    context.read<EventBloc>().add(AddEvent(newEvent));

                    // Reload the events in the calendar
                    context.read<EventBloc>().add(LoadEvents(
                        DateFormat('yyyy-MM-dd').format(_selectedDate)));
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text("Add Event"),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Add additional content for displaying the events
        ],
      ),
    );
  }
}
