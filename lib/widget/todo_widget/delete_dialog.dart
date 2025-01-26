import 'package:flutter/material.dart';

import 'todo_material_button.dart';

class DeleteTaskDialog extends StatelessWidget {
  final VoidCallback onDelete;
  final VoidCallback onCancel;

  const DeleteTaskDialog({
    Key? key,
    required this.onDelete,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Delete Task',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Are you sure you want to delete this task?',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TodoMaterialButton(
                    onPressed: onCancel,
                    buttonColor: const Color(0XFFF8FBFF),
                    textColor: const Color(0XFF318FFF),
                    text: 'No',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TodoMaterialButton(
                    buttonColor: const Color(0XFFED3A3A),
                    onPressed: onDelete,
                    text: 'Delete',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
