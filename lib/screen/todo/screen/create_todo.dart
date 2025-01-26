import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_netzlech/gen/assets.gen.dart';
import 'package:todo_netzlech/injectable/injectable.dart';
import 'package:todo_netzlech/model/task_model/task_model.dart';
import 'package:todo_netzlech/route_config/route_config.dart';
import 'package:todo_netzlech/screen/todo/bloc/todo_bloc.dart';
import 'package:todo_netzlech/screen/todo/bloc/todo_state.dart';
import 'package:todo_netzlech/utils/extension.dart';
import 'package:todo_netzlech/widget/todo_widget/todo_material_button.dart';

class CreateTodo extends StatefulWidget {
  const CreateTodo({super.key});

  @override
  State<CreateTodo> createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {
  final formKey = GlobalKey<FormState>();
  TaskModel model = TaskModel(title: '');

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
                      onPressed: () => router.pop(),
                      buttonColor: const Color(0XFFF8FBFF),
                      textColor: const Color(0XFF318FFF),
                      text: 'Cancel',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TodoMaterialButton(
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          getIt<TodoBloc>().insert();
                          router.pop();
                        }
                      },
                      text: 'Save',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            TodoField(onChange: (value) {
              model = model.copyWith(title: value);
              getIt<TodoBloc>().onChangeAddTask(model);
            }),
            const Divider(),
            BlocConsumer<TodoBloc, TodoBlocState>(
              buildWhen: (previous, current) => previous.addTask != current.addTask,
              builder: (context, state) {
                return TaskTimeSelection(
                  selectedDate: state.addTask.createdAt,
                  onSelectDate: (DateTime date) {
                    model = model.copyWith(createdAt: date);
                    getIt<TodoBloc>().onChangeAddTask(model);
                  },
                );
              },
              listener: (context, state) {},
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}

class TodoField extends StatelessWidget {
  const TodoField({super.key, this.focusNode, required this.onChange});

  final FocusNode? focusNode;
  final void Function(String value) onChange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12.0,
        horizontal: 20.0,
      ).copyWith(top: 16.0),
      child: TextFormField(
        onChanged: onChange,
        focusNode: focusNode,
        autofocus: true,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please add a task before proceeding.';
          }
          return null; // Validation passed
        },
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
