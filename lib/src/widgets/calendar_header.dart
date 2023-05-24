import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weekview_calendar/src/widgets/select_month.dart';
import 'package:weekview_calendar/src/widgets/select_year.dart';

import '../customization/header_style.dart';
import '../shared/utils.dart' show CalendarFormat, DayBuilder, isSameDay;
import '../style/select_month_options.dart';
import '../style/select_year_options.dart';
import 'custom_icon_button.dart';
import 'format_button.dart';

class CalendarHeader extends StatelessWidget {
  final dynamic locale;
  final DateTime focusedMonth;
  final CalendarFormat calendarFormat;
  final HeaderStyle headerStyle;
  final VoidCallback onLeftChevronTap;
  final VoidCallback onRightChevronTap;
  final VoidCallback onHeaderTap;
  final VoidCallback onHeaderLongPress;
  final ValueChanged<CalendarFormat> onFormatButtonTap;
  final Map<CalendarFormat, String> availableCalendarFormats;
  final DayBuilder? headerTitleBuilder;
  Function(int selectedYear, DateTime selectedDate) onYearChanged;
  Function(int selectedMonth, DateTime selectedDate) onMonthChanged;
  Function() onDateReset;
  final DateTime firstDate;
  final DateTime lastDate;
  final bool isToday;

  CalendarHeader(
      {Key? key,
      this.locale,
      required this.focusedMonth,
      required this.calendarFormat,
      required this.headerStyle,
      required this.onLeftChevronTap,
      required this.onRightChevronTap,
      required this.onHeaderTap,
      required this.onHeaderLongPress,
      required this.onFormatButtonTap,
      required this.availableCalendarFormats,
      this.headerTitleBuilder,
      required this.onYearChanged,
      required this.onMonthChanged,
      required this.firstDate,
      required this.lastDate,
      required this.isToday,
      required this.onDateReset})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textYear =
        headerStyle.titleTextFormatter?.call(focusedMonth, locale) ??
            DateFormat.y(locale).format(focusedMonth);
    final textMonth =
        headerStyle.titleTextFormatter?.call(focusedMonth, locale) ??
            DateFormat.MMM(locale).format(focusedMonth);
    print(focusedMonth.year);
    return Container(
      decoration: headerStyle.decoration,
      margin: headerStyle.headerMargin,
      padding: headerStyle.headerPadding,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (headerStyle.leftChevronVisible)
            CustomIconButton(
              icon: headerStyle.leftChevronIcon,
              onTap: onLeftChevronTap,
              margin: headerStyle.leftChevronMargin,
              padding: headerStyle.leftChevronPadding,
            ),
          Expanded(
            child: Row(
              mainAxisAlignment: headerStyle.titleCentered
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                headerTitleBuilder?.call(context, focusedMonth) ??
                    GestureDetector(
                      onTap: headerStyle.monthYearChangeable
                          ? () {
                              showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (BuildContext mmm) {
                                  return SelectMonth(
                                    onHeaderChanged: onMonthChanged,
                                    monthStyle: MonthOptions(
                                        //font: CalendarOptions.of(context).font,
                                        selectedColor: headerStyle
                                            .selectMonthYearHighlightColor,
                                        backgroundColor: Colors.white),
                                    focusedMonth: focusedMonth,
                                    firstDate: firstDate,
                                    lastDate: lastDate,
                                  );
                                },
                              );
                            }
                          : null,
                      onLongPress: onHeaderLongPress,
                      child: Text(
                        textMonth,
                        style: headerStyle.titleTextStyle,
                        textAlign: headerStyle.titleCentered
                            ? TextAlign.center
                            : TextAlign.start,
                      ),
                    ),
                SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: headerStyle.monthYearChangeable
                      ? () {
                          showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (BuildContext mmm) {
                              return SelectYear(
                                focusedMonth: focusedMonth,
                                onHeaderChanged: onYearChanged,
                                firstDate: firstDate,
                                lastDate: lastDate,
                                yearStyle: YearOptions(
                                    // font:  yearStyle?.font,
                                    selectedColor: headerStyle
                                        .selectMonthYearHighlightColor,
                                    backgroundColor: Colors.white),
                              );
                            },
                          );
                        }
                      : null,
                  onLongPress: onHeaderLongPress,
                  child: Text(
                    textYear,
                    style: headerStyle.titleTextStyle,
                    textAlign: headerStyle.titleCentered
                        ? TextAlign.center
                        : TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
          buildRefreshView(context),
          if (headerStyle.formatButtonVisible &&
              availableCalendarFormats.length > 1)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: FormatButton(
                onTap: onFormatButtonTap,
                availableCalendarFormats: availableCalendarFormats,
                calendarFormat: calendarFormat,
                decoration: headerStyle.formatButtonDecoration,
                padding: headerStyle.formatButtonPadding,
                textStyle: headerStyle.formatButtonTextStyle,
                showsNextFormat: headerStyle.formatButtonShowsNext,
                showIcon: headerStyle.showIcon,
              ),
            ),
          if (headerStyle.rightChevronVisible)
            CustomIconButton(
              icon: headerStyle.rightChevronIcon,
              onTap: onRightChevronTap,
              margin: headerStyle.rightChevronMargin,
              padding: headerStyle.rightChevronPadding,
            ),
        ],
      ),
    );
  }

  buildRefreshView(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: !isToday ? 1 : 0,
      child: InkWell(
        customBorder: CircleBorder(),
        onTap: onDateReset,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Icon(
            Icons.restore,
            size: 24,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
