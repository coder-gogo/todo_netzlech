import 'package:equatable/equatable.dart';

class TodoBlocState extends Equatable {
  const TodoBlocState._() : super();

  const TodoBlocState.initial() : this._();

  TodoBlocState copyWith() => const TodoBlocState._();

  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}
