import 'package:flutter/material.dart';
import 'package:todo_netzlech/model/task_model/task_model.dart';

class TaskCard extends StatelessWidget {
  final TaskModel model;

  const TaskCard({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: model.isDone() ? Colors.blue[100] : Colors.blue[50],
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              model.isDone() ? Icons.check : Icons.square_outlined,
              color: model.isDone() ? Colors.blue : Colors.black,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.title,
                  style: TextStyle(
                    color: model.isDone() ? Colors.blue[100] : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    decoration: model.isDone() ? TextDecoration.lineThrough : null,
                  ),
                ),
                if (model.isDone() && model.getUpdateDescription() != null)
                  Text(
                    model.getUpdateDescription().toString(),
                    style: TextStyle(
                      color: Colors.blue[100],
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
