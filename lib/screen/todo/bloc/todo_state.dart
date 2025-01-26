import 'package:equatable/equatable.dart';
import 'package:todo_netzlech/model/task_model/task_model.dart';

class TodoBlocState extends Equatable {
  final List<TaskModel> task;
  final Map<DateTime, List<TaskModel>> pendingTask;
  final DateTime selectedDate;
  final TaskModel addTask;

  const TodoBlocState._({
    required this.task,
    required this.pendingTask,
    required this.selectedDate,
    required this.addTask,
  }) : super();

  const TodoBlocState.initial({
    required DateTime date,
    required TaskModel model,
  }) : this._(
          task: const [],
          pendingTask: const {},
          selectedDate: date,
          addTask: model,
        );

  TodoBlocState copyWith({
    List<TaskModel>? task,
    Map<DateTime, List<TaskModel>>? pendingTask,
    DateTime? selectedDate,
    TaskModel? addTask,
  }) =>
      TodoBlocState._(
        task: task ?? this.task,
        pendingTask: pendingTask ?? this.pendingTask,
        selectedDate: selectedDate ?? this.selectedDate,
        addTask: addTask ?? this.addTask,
      );

  @override
  List<Object> get props => [
        task,
        selectedDate,
        pendingTask,
        addTask,
      ];

  @override
  bool get stringify => true;
}
