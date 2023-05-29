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
  DateTime? firstDateOfWeek;
  DateTime? lastDateOfWeek;
  DateTime? firstDate;
  DateTime? lastDate;

  @override
  void initState() {
    //firstDate = DateTime.now().add(const Duration(days: -20));
    //lastDate = DateTime.now();
    //firstDateOfWeek = DateTime.now().add(const Duration(days: -3));
    //lastDateOfWeek = DateTime.now();
    firstDate = DateTime.now();
    lastDate = DateTime.now().add(const Duration(days: 20));
    firstDateOfWeek = DateTime.now();
    lastDateOfWeek = DateTime.now().add(const Duration(days: 3));

    super.initState();
  }

  _updateFirstLast(DateTime dateTime) {
    setState(() {
      firstDateOfWeek = dateTime.add(const Duration(days: -3));
      lastDateOfWeek = dateTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WeekView Calendar - Basics'),
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                setState(() {
                  firstDate = DateTime.now().add(const Duration(days: -20));
                  lastDate = DateTime.now();
                });
              },
              child: Text("Change to Completed")),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  firstDate = DateTime.now();
                  lastDate = DateTime.now().add(const Duration(days: 20));
                });
              },
              child: Text("Change to Pending")),
          WeekviewCalendar(
            /*firstDay: kFirstDay,
            lastDay: kLastDay,*/
            /*firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 365)),*/
            firstDay: firstDate!,
            lastDay: lastDate!,
            rangeStartDay: firstDateOfWeek,
            rangeEndDay: lastDateOfWeek,
            focusedDay: _focusedDay,
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
              CalendarFormat.week: 'Week',
            },
            calendarFormat: _calendarFormat,
            headerStyle: HeaderStyle(
                showIcon: true,
                titleTextStyle:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                monthYearChangeable: false,
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
                  _updateFirstLast(_selectedDay!);
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
        ],
      ),
    );
  }
}
