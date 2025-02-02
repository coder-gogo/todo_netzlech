import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_netzlech/injectable/injectable.dart';
import 'package:todo_netzlech/model/task_model/task_model.dart';
import 'package:todo_netzlech/route_config/route_config.dart';
import 'package:todo_netzlech/screen/todo/bloc/todo_bloc.dart';
import 'package:todo_netzlech/screen/todo/bloc/todo_state.dart';
import 'package:todo_netzlech/widget/todo_widget/task_time_selection.dart';
import 'package:todo_netzlech/widget/todo_widget/todo_field.dart';
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
