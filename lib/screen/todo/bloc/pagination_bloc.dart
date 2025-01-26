import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_netzlech/model/task_model/task_model.dart';
import 'package:todo_netzlech/screen/todo/bloc/pagination_state.dart';
import 'package:todo_netzlech/utils/todo_db/todo_db.dart';

class TodoBloc extends Cubit<TodoBlocState> {
  final TodoHelper service;

  TodoBloc({required this.service})
      : super(TodoBlocState.initial(
          date: DateTime.now(),
          model: TaskModel(title: ''),
        )) {
    fetchTask();
    fetchPendingTask();
  }

  void queryForDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
    fetchTask();
  }

  void fetchTask() async {
    final fetch = await service.fetchTasks(state.selectedDate);
    emit(state.copyWith(task: fetch));
  }

  void fetchPendingTask() async {
    final fetch = await service.fetchAllPendingTasks();
    emit(state.copyWith(pendingTask: fetch));
  }

  void onChangeAddTask(TaskModel model) {
    emit(state.copyWith(addTask: model));
  }

  void insert() async {
    await service.insertTask(state.addTask);
    fetchTask();
    // await service.insertTask(
    //   TaskModel(
    //     title: Faker().lorem.sentence(),
    //     status: Random().nextInt(100) % 2 == 0 ? 'completed' : 'pending',
    //     createdAt: DateTime(
    //       Faker().randomGenerator.integer(12, min: 1),
    //       Faker().randomGenerator.integer(24, min: 1),
    //     ),
    //     updatedAt: DateTime(
    //       Faker().randomGenerator.integer(12, min: 1),
    //       Faker().randomGenerator.integer(24, min: 1),
    //     ),
    //   ),
    // );
  }

  @override
  Future<void> close() {
    // TODO: implement close
    return super.close();
  }
}
