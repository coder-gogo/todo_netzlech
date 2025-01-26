import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:todo_netzlech/widget/api_builder_widget.dart';

extension Localization on BuildContext {
  AppLocalizations get localization => AppLocalizations.of(this)!;

  double get width => MediaQuery.of(this).size.width;

  double get height => MediaQuery.of(this).size.height;
}

extension Refresh on GlobalKey<ApiBuilderWidgetState> {
  void refresh<T>(Future<T> value) => currentState?.refresh(value);
}

extension DateFormatting on DateTime {
  /// Converts a DateTime to a string in the "DD-MM-YYYY" format.
  String toFormattedString() {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(this);
  }

  String toFormatHumanReadable() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final comparisonDate = DateTime(year, month, day);

    if (comparisonDate == today) {
      return 'Today';
    } else if (comparisonDate == today.add(const Duration(days: 1))) {
      return 'Tomorrow';
    } else if (comparisonDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      return formatter.format(this);
    }
  }

  String toCompletedAtString(String value) {
    final dateFormatter = DateFormat('dd/MM/yyyy');
    final timeFormatter = DateFormat('hh:mm a');
    final formattedDate = dateFormatter.format(this);
    final formattedTime = timeFormatter.format(this);
    return '$value $formattedDate $formattedTime';
  }
}
