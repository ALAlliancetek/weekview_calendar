import 'package:flutter/material.dart';
import 'package:weekview_calendar/weekview_calendar.dart';

class WeekViewBasicsExample extends StatefulWidget {
  @override
  _WeekViewBasicsExampleState createState() => _WeekViewBasicsExampleState();
}

class _WeekViewBasicsExampleState extends State<WeekViewBasicsExample> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WeekView Calendar - Basics'),
      ),
      body: WeekviewCalendar(
        /*firstDay: kFirstDay,
        lastDay: kLastDay,*/
        firstDay: DateTime.now().add(const Duration(days: -365)),
        lastDay: DateTime.now().add(const Duration(days: 365)),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        headerStyle: HeaderStyle(
            titleTextStyle:
                TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            titleCentered: true),
        selectedDayPredicate: (day) {
          // Use `selectedDayPredicate` to determine which day is currently selected.
          // If this returns true, then `day` will be marked as selected.

          // Using `isSameDay` is recommended to disregard
          // the time-part of compared DateTime objects.
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            // Call `setState()` when updating the selected day
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          }
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            // Call `setState()` when updating calendar format
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          // No need to call `setState()` here
          _focusedDay = focusedDay;
        },
      ),
    );
  }
}
