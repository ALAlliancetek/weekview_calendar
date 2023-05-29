import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../shared/utils.dart' show CalendarFormat;

class FormatButton extends StatelessWidget {
  final CalendarFormat calendarFormat;
  final ValueChanged<CalendarFormat> onTap;
  final TextStyle textStyle;
  final BoxDecoration decoration;
  final EdgeInsets padding;
  final EdgeInsets iconButtonPadding;
  final bool showsNextFormat;
  final bool showIcon;
  final Map<CalendarFormat, String> availableCalendarFormats;

  const FormatButton({
    Key? key,
    required this.calendarFormat,
    required this.onTap,
    required this.textStyle,
    required this.decoration,
    required this.padding,
    required this.iconButtonPadding,
    required this.showsNextFormat,
    required this.showIcon,
    required this.availableCalendarFormats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final child = showIcon
        ? Icon(_formatIcon(), color: Colors.black)
        : Container(
            decoration: decoration,
            padding: padding,
            child: Text(
              _formatButtonText,
              style: textStyle,
            ),
          );

    final platform = Theme.of(context).platform;

    return !kIsWeb &&
            (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS)
        ? CupertinoButton(
            onPressed: () => onTap(_nextFormat()),
            padding: showIcon ? iconButtonPadding : padding,
            child: child,
          )
        : /*InkWell(
            borderRadius:
                decoration.borderRadius?.resolve(Directionality.of(context)),
            onTap: () => onTap(_nextFormat()),
            child: child,
          );*/
        InkWell(
            onTap: () => onTap(_nextFormat()),
            borderRadius: showIcon
                ? BorderRadius.circular(100.0)
                : decoration.borderRadius?.resolve(Directionality.of(context)),
            child: Padding(
              padding: showIcon ? iconButtonPadding : padding,
              child: child,
            ),
          );
  }

  String get _formatButtonText => showsNextFormat
      ? availableCalendarFormats[_nextFormat()]!
      : availableCalendarFormats[calendarFormat]!;

  IconData _formatIcon() {
    String format;
    if (showsNextFormat) {
      format = availableCalendarFormats[_nextFormat()]!;
    } else {
      format = availableCalendarFormats[calendarFormat]!;
    }
    if (format == 'Month') {
      return Icons.calendar_month_sharp;
    }
    if (format == 'Week') {
      return Icons.calendar_view_week;
    }
    if (format == '2 weeks') {
      return Icons.calendar_view_month;
    }
    return Icons.calendar_month_sharp;
  }

  CalendarFormat _nextFormat() {
    final formats = availableCalendarFormats.keys.toList();
    int id = formats.indexOf(calendarFormat);
    id = (id + 1) % formats.length;

    return formats[id];
  }
}
