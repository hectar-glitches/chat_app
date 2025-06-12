import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSeparator extends StatelessWidget {
  final DateTime date;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;

  const DateSeparator({
    super.key,
    required this.date,
    this.padding,
    this.textStyle,
  });

  // Helper to strip time from date
  DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = _dateOnly(now);
    final yesterday = today.subtract(const Duration(days: 1));
    final target = _dateOnly(date);

    if (target == today) {
      return 'Today';
    } else if (target == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat.yMMMd().format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Message date: ${_formatDate(date)}',
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withOpacity(0.7),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Text(
            _formatDate(date),
            style: textStyle ??
                TextStyle(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
          ),
        ),
      ),
    );
  }
}
