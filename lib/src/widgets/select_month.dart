import 'package:flutter/material.dart';

import '../style/select_month_options.dart';

class SelectMonth extends StatelessWidget {
  late List months;
  final DateTime focusedMonth;
  final DateTime firstDate;
  final DateTime lastDate;

  Function(int selectedMonth, DateTime selectedDate) onHeaderChanged;

  MonthOptions? monthStyle;

  SelectMonth(
      {required this.onHeaderChanged,
      this.monthStyle,
      required this.focusedMonth,
      required this.firstDate,
      required this.lastDate});

  late BoxDecoration selectedDecoration;

  late int currentMonth = focusedMonth.month;

  @override
  Widget build(BuildContext context) {
    selectedDecoration = BoxDecoration(
      color: monthStyle?.selectedColor,
      borderRadius: BorderRadius.circular(8),
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(26), topRight: Radius.circular(26)),
        color: monthStyle?.backgroundColor,
      ),
      height: 380,
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'Select a month',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                fontFamily: monthStyle?.font,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Table(
                      border: const TableBorder(
                        horizontalInside:
                            BorderSide(color: Colors.black12, width: 0.2),
                        verticalInside:
                            BorderSide(color: Colors.black12, width: 0.2),
                      ),
                      children: monthsWidgetMaker(context),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<int> getEnableMonths(int selectedYear) {
    List<int> enableMonths = [];
    int firstMonth = firstDate.month;
    int lastMonth = lastDate.month;
    int startYear = firstDate.year;
    int endYear = lastDate.year;
    for (int year = startYear; year <= endYear; year++) {
      int monthStart;
      int monthEnd;
      if (year == startYear) {
        monthStart = firstMonth;
      } else {
        monthStart = 1;
      }
      if (year == endYear) {
        monthEnd = lastMonth;
      } else {
        monthEnd = 12;
      }

      for (int month = monthStart; month <= monthEnd; month++) {
        if (!enableMonths.contains(month) && selectedYear == year) {
          enableMonths.add(month);
        }
      }
    }
    return enableMonths;
  }

  DateTime getSelectedDate(int month) {
    return DateTime(focusedMonth.year, month, focusedMonth.day);
  }

  List<TableRow> monthsWidgetMaker(context) {
    months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    List<Widget> _buildRowCells(int rowIndex) {
      List<int> enableMonths = getEnableMonths(focusedMonth.year);

      List<TableCell> widgets = [];
      for (var j = 0; j < 3; j++) {
        final int mMonth = (rowIndex * 3) + j + 1;
        widgets.add(
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: enableMonths.contains(mMonth)
                    ? (() {
                        DateTime selectedDate = getSelectedDate(mMonth);
                        Navigator.pop(context);
                        onHeaderChanged.call(mMonth, selectedDate);
                      })
                    : null,
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration:
                      mMonth == currentMonth ? selectedDecoration : null,
                  child: Center(
                      child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      months[(rowIndex * 3) + j].toString(),
                      style: TextStyle(
                        fontSize: 16,
                        color: enableMonths.contains(mMonth)
                            ? mMonth == currentMonth
                                ? Colors.white
                                : null
                            : Colors.grey,
                        fontFamily: monthStyle?.font,
                      ),
                      maxLines: 1,
                    ),
                  )),
                ),
              ),
            ),
          ),
        );
      }
      return widgets;
    }

    List<TableRow> monthsWidget = [];
    for (var i = 0; i < 4; i++) {
      monthsWidget.add(TableRow(children: _buildRowCells(i)));
    }

    return monthsWidget;
  }
}
