import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_netzlech/gen/assets.gen.dart';
import 'package:todo_netzlech/injectable/injectable.dart';
import 'package:todo_netzlech/route_config/route_config.dart';
import 'package:todo_netzlech/screen/todo/bloc/todo_bloc.dart';
import 'package:todo_netzlech/screen/todo/bloc/todo_state.dart';
import 'package:todo_netzlech/utils/calender/horizontal_calender.dart';
import 'package:todo_netzlech/widget/api_builder_widget.dart';
import 'package:todo_netzlech/widget/todo_widget/home_title_bar.dart';
import 'package:todo_netzlech/widget/todo_widget/task_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // @override
  // void initState() {
  //   super.initState();
  //   final notification = FirebasePushHelper.instance;
  //   notification.initPushConfiguration((value) {});
  // }

  final peopleKey = GlobalKey<ApiBuilderWidgetState>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => router.push(TodoRoute.createTodo),
        child: Assets.svg.add.svg(),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              snap: true,
              pinned: true,
              actions: [
                IconButton(
                  onPressed: () => router.push(TodoRoute.pendingTask),
                  icon: Assets.svg.task.svg(),
                ),
              ],
              forceElevated: innerBoxIsScrolled,
              title: const HomeTitleBar(),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(90),
                child: HorizontalWeekCalendar(
                  onDateChange: (date) => getIt<TodoBloc>().queryForDate(date),
                  inactiveBackgroundColor: const Color(0XFFEEF5FF),
                  inactiveTextColor: const Color(0XFF76B5FF),
                  weekStartFrom: WeekStartFrom.sunday,
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  minDate: DateTime(1970),
                  maxDate: DateTime(2050),
                  initialDate: DateTime.now(),
                ),
              ),
            ),
          ];
        },
        body: BlocConsumer<TodoBloc, TodoBlocState>(
          bloc: getIt<TodoBloc>()..fetchTask(),
          buildWhen: (previous, current) => current.task != previous.task,
          builder: (context, state) {
            return state.task.isEmpty
                ? Center(
                    child: Assets.svg.noTask.svg(),
                  )
                : ListView(
                    padding: EdgeInsets.zero,
                    children: state.task
                        .map<Widget>((e) => TaskCard(
                              allowDivider: state.task.last.id != e.id,
                              model: e,
                              onChange: getIt<TodoBloc>().updateTaskStatus,
                              onClick: () {
                                getIt<TodoBloc>().onChangeEditTask(e);
                                router.push(TodoRoute.editTodo);
                              },
                            ))
                        .toList(),
                  );
          },
          listener: (context, state) {},
        ),
      ),
    );
  }
}
