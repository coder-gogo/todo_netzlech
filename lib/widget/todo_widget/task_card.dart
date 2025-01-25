import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final bool isCompleted;
  final DateTime? completedAt;

  const TaskCard({
    super.key,
    required this.title,
    required this.isCompleted,
    this.completedAt,
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
              color: isCompleted ? Colors.blue[100] : Colors.blue[50],
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isCompleted ? Icons.check : Icons.square_outlined,
              color: isCompleted ? Colors.blue : Colors.black,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isCompleted ? Colors.blue[100] : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                if (isCompleted && completedAt != null)
                  Text(
                    "Completed at ${completedAt.toString().split('.')[0]}",
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
