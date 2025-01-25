import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_netzlech/screen/todo/bloc/pagination_state.dart';

class TodoBloc extends Cubit<TodoBlocState> {
  TodoBloc() : super(const TodoBlocState.initial());

  @override
  Future<void> close() {
    // TODO: implement close
    return super.close();
  }
}
