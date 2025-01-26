import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_netzlech/gen/assets.gen.dart';
import 'package:todo_netzlech/injectable/injectable.dart';
import 'package:todo_netzlech/model/task_model/task_model.dart';
import 'package:todo_netzlech/route_config/route_config.dart';
import 'package:todo_netzlech/screen/todo/bloc/todo_bloc.dart';
import 'package:todo_netzlech/screen/todo/bloc/todo_state.dart';
import 'package:todo_netzlech/widget/todo_widget/task_time_selection.dart';
import 'package:todo_netzlech/widget/todo_widget/todo_field.dart';
import 'package:todo_netzlech/widget/todo_widget/todo_material_button.dart';

class EditTodo extends StatefulWidget {
  const EditTodo({super.key});

  @override
  State<EditTodo> createState() => _EditTodoState();
}

class _EditTodoState extends State<EditTodo> {
  final formKey = GlobalKey<FormState>();
  late TaskModel model;
  late TextEditingController controller;

  @override
  void initState() {
    model = getIt<TodoBloc>().state.editTask;
    controller = TextEditingController(text: model.title);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: true, // Prevent resizing
      appBar: AppBar(
        title: Text(
          'Edit Task',
          style: theme.appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Assets.svg.delete.svg(),
          ),
        ],
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
                          getIt<TodoBloc>().editTask();
                          router.pop();
                        }
                      },
                      text: 'Update',
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
            TodoField(
                controller: controller,
                onChange: (value) {
                  model = model.copyWith(title: value);
                  getIt<TodoBloc>().onChangeEditTask(model);
                }),
            const Divider(),
            BlocConsumer<TodoBloc, TodoBlocState>(
              buildWhen: (previous, current) => previous.editTask != current.editTask,
              builder: (context, state) {
                return TaskTimeSelection(
                  selectedDate: state.editTask.createdAt,
                  onSelectDate: (DateTime date) {
                    model = model.copyWith(createdAt: date);
                    getIt<TodoBloc>().onChangeEditTask(model);
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
