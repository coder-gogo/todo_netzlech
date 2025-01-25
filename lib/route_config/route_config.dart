import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_netzlech/main.dart';
import 'package:todo_netzlech/screen/pagination/pagination_bloc.dart';
import 'package:todo_netzlech/screen/pagination/pagination_screen.dart';
import 'package:todo_netzlech/screen/todo/screen/create_todo.dart';
import 'package:todo_netzlech/screen/todo/screen/pending_task_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  redirectLimit: 1,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'setting',
          builder: (context, state) => const SettingScreen(),
        ),
        GoRoute(
          path: 'pagination',
          builder: (context, state) {
            const screen = PaginationExample();
            return BlocProvider(
              lazy: true,
              create: (context) => PaginationBloc(),
              child: screen,
            );
          },
        ),
        GoRoute(
          path: TodoRoute.pendingTask,
          builder: (context, state) {
            const screen = PendingTaskScreen();
            return screen;
          },
        ),
        GoRoute(
          path: TodoRoute.createTodo,
          builder: (context, state) {
            const screen = CreateTodo();
            return screen;
          },
        ),
      ],
    ),
  ],
);

class TodoRoute {
  static const String createTodo = '/create_todo';
  static const String pendingTask = '/pending_task';
}
