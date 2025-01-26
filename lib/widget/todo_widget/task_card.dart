import 'package:flutter/material.dart';
import 'package:todo_netzlech/model/task_model/task_model.dart';

import 'todo_check_box.dart';

class TaskCard extends StatelessWidget {
  final TaskModel model;
  final void Function(bool value, TaskModel model) onChange;
  final void Function() onClick;
  final bool allowDivider;

  const TaskCard({
    super.key,
    required this.model,
    required this.onChange,
    required this.onClick,
    this.allowDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onClick,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                TodoCheckBox(
                  key: UniqueKey(),
                  onChange: (value) => onChange(value, model),
                  value: model.isDone(),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.title,
                        maxLines: 2,
                        style: TextStyle(
                          color: model.isDone() ? Colors.blue[100] : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          decorationColor: Colors.blue[100],
                          decoration: model.isDone() ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      if (model.isDone() && model.getUpdateDescription() != null)
                        Text(
                          model.getUpdateDescription().toString(),
                          style: const TextStyle(
                            color: Color(0XFFA7A7A7),
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      if (!model.isDone())
                        Text(
                          model.getCreatedDescription().toString(),
                          style: const TextStyle(
                            color: Color(0XFFA7A7A7),
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (allowDivider) const Divider(),
        ],
      ),
    );
  }
}
