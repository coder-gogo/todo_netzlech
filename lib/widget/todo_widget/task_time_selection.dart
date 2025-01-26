import 'package:flutter/material.dart';
import 'package:todo_netzlech/gen/assets.gen.dart';
import 'package:todo_netzlech/utils/extension.dart';

class TaskTimeSelection extends StatelessWidget {
  const TaskTimeSelection({
    super.key,
    required this.selectedDate,
    required this.onSelectDate,
  });

  final DateTime selectedDate;
  final void Function(DateTime date) onSelectDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 20.0,
      ).copyWith(top: 12.0),
      child: Row(
        children: [
          Assets.svg.task.svg(),
          const SizedBox(width: 10.0),
          const Text('Date'),
          const Spacer(),
          GestureDetector(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(1970),
                lastDate: DateTime(2050),
              );
              if (date != null) {
                onSelectDate(date);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 25.0,
              ),
              decoration: BoxDecoration(
                color: const Color(0XFFF8FBFF),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                selectedDate.toFormatHumanReadable(),
                style: const TextStyle(
                  color: Color(0XFF318FFF),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
