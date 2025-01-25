import 'package:flutter/material.dart';
import 'package:todo_netzlech/gen/assets.gen.dart';

class HomeTitleBar extends StatelessWidget {
  const HomeTitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Assets.svg.calender.svg(),
        const SizedBox(width: 10.0),
        Text(
          'Today',
          style: theme.appBarTheme.titleTextStyle,
        ),
      ],
    );
  }
}