import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_netzlech/model/task_model/task_model.dart';
import 'package:todo_netzlech/screen/todo/bloc/todo_state.dart';
import 'package:todo_netzlech/utils/todo_db/todo_db.dart';

class TodoBloc extends Cubit<TodoBlocState> {
  final TodoHelper service;

  TodoBloc({required this.service})
      : super(TodoBlocState.initial(
          date: DateTime.now(),
          model: TaskModel(title: ''),
          editTask: TaskModel(title: ''),
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

  void updateTaskStatus(bool value, TaskModel model) async {
    TaskModel taskModel = model;
    if (value) {
      taskModel = taskModel.copyWith(
        status: 'completed',
        updatedAt: DateTime.now(),
      );
    } else {
      taskModel = taskModel.copyWith(
        status: 'pending',
        updatedAt: DateTime.now(),
      );
    }
    await service.updateTask(taskModel);
    fetchTask();
    fetchPendingTask();
  }

  void fetchPendingTask() async {
    final fetch = await service.fetchAllPendingTasks();
    emit(state.copyWith(pendingTask: fetch));
  }

  void onChangeAddTask(TaskModel model) {
    emit(state.copyWith(addTask: model));
  }

  void onChangeEditTask(TaskModel model) {
    emit(state.copyWith(editTask: model));
  }

  void insert() async {
    await service.insertTask(state.addTask);
    emit(state.copyWith(addTask: TaskModel(title: '')));
    fetchTask();
  }

  void editTask() async {
    await service.updateTask(state.editTask);
    fetchTask();
    fetchPendingTask();
  }

  @override
  Future<void> close() {
    // TODO: implement close
    return super.close();
  }
}
