import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_netzlech/gen/assets.gen.dart';
import 'package:todo_netzlech/injectable/injectable.dart';
import 'package:todo_netzlech/route_config/route_config.dart';
import 'package:todo_netzlech/screen/todo/bloc/todo_bloc.dart';
import 'package:todo_netzlech/screen/todo/bloc/todo_state.dart';
import 'package:todo_netzlech/utils/extension.dart';
import 'package:todo_netzlech/widget/todo_widget/task_card.dart';

class PendingTaskScreen extends StatelessWidget {
  const PendingTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pending Task',
          style: theme.appBarTheme.titleTextStyle,
        ),
      ),
      body: BlocConsumer<TodoBloc, TodoBlocState>(
        bloc: getIt<TodoBloc>()..fetchPendingTask(),
        buildWhen: (previous, current) => current.pendingTask != previous.pendingTask,
        builder: (context, state) {
          return state.pendingTask.isEmpty
              ? Center(
                  child: Assets.svg.noTask.svg(),
                )
              : ListView(
                  padding: const EdgeInsets.only(top: 16.0),
                  children: state.pendingTask.entries
                      .map(
                        (e) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16.0),
                              padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 20.0,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0XFFF8FBFF),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Text(
                                e.key.toFormatHumanReadable(),
                                style: const TextStyle(
                                  color: Color(0XFF318FFF),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: e.value
                                  .map<Widget>((element) => TaskCard(
                                        allowDivider: e.value.last.id != element.id,
                                        model: element,
                                        onClick: () {
                                          getIt<TodoBloc>().onChangeEditTask(element);
                                          router.push(TodoRoute.editTodo);
                                        },
                                        onChange: getIt<TodoBloc>().updateTaskStatus,
                                      ))
                                  .toList(),
                            )
                          ],
                        ),
                      )
                      .toList(),
                );
        },
        listener: (context, state) {},
      ),
    );
  }
}
