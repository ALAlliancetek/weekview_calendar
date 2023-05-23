import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weekview_calendar/src/widgets/select_month.dart';
import 'package:weekview_calendar/src/widgets/select_year.dart';

import '../customization/header_style.dart';
import '../shared/utils.dart' show CalendarFormat, DayBuilder;
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
  Function(int selectedYear) onYearChanged;
  Function(int selectedMonth) onMonthChanged;

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
      required this.onMonthChanged})
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
              children: [
                headerTitleBuilder?.call(context, focusedMonth) ??
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (BuildContext mmm) {
                            return SelectMonth(
                              onHeaderChanged: onMonthChanged,
                              monthStyle: MonthOptions(
                                  //font: CalendarOptions.of(context).font,
                                  selectedColor: Colors.red,
                                  backgroundColor: Colors.white),
                              focusedMonth: focusedMonth,
                            );
                          },
                        );
                      },
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
                  onTap: () {
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (BuildContext mmm) {
                        return SelectYear(
                          focusedMonth: focusedMonth,
                          onHeaderChanged: onYearChanged,
                          yearStyle: YearOptions(
                              // font:  yearStyle?.font,
                              selectedColor: Colors.red,
                              backgroundColor: Colors.white),
                        );
                      },
                    );
                  },
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
}
