import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_netzlech/gen/assets.gen.dart';
import 'package:todo_netzlech/screen/todo/bloc/todo_bloc.dart';
import 'package:todo_netzlech/screen/todo/bloc/todo_state.dart';
import 'package:todo_netzlech/utils/extension.dart';

class HomeTitleBar extends StatelessWidget {
  const HomeTitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Assets.svg.calender.svg(),
        const SizedBox(width: 10.0),
        BlocConsumer<TodoBloc, TodoBlocState>(
          buildWhen: (previous, current) => previous.selectedDate != current.selectedDate,
          builder: (context, state) => Text(
            state.selectedDate.toFormatHumanReadable(),
            style: theme.appBarTheme.titleTextStyle,
          ),
          listener: (context, state) {},
        ),
      ],
    );
  }
}
