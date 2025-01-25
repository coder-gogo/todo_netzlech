import 'package:flutter/material.dart';
import 'package:todo_netzlech/gen/assets.gen.dart';
import 'package:todo_netzlech/widget/todo_widget/todo_material_button.dart';

class CreateTodo extends StatelessWidget {
  const CreateTodo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: true, // Prevent resizing
      appBar: AppBar(
        title: Text(
          'New Task',
          style: theme.appBarTheme.titleTextStyle,
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(
                bottom: 16.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TodoMaterialButton(
                      onPressed: () {},
                      buttonColor: const Color(0XFFF8FBFF),
                      textColor: const Color(0XFF318FFF),
                      text: 'Cancel',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TodoMaterialButton(
                      onPressed: () {},
                      text: 'Save',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: const Column(
        children: [
          TodoField(),
          Divider(),
          TaskTimeSelection(),
          Divider(),
        ],
      ),
    );
  }
}

class TodoField extends StatelessWidget {
  const TodoField({super.key, this.focusNode});

  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12.0,
        horizontal: 20.0,
      ).copyWith(top: 16.0),
      child: TextField(
        focusNode: focusNode,
        autofocus: true,
        decoration: const InputDecoration(
          labelText: 'Task',
          isDense: true,
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0XFF318FFF),
            ),
          ),
        ),
      ),
    );
  }
}

class TaskTimeSelection extends StatelessWidget {
  const TaskTimeSelection({super.key});

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
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2050),
              );
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
              child: const Text(
                'Today',
                style: TextStyle(
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
