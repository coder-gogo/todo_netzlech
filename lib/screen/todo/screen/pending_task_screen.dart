import 'package:flutter/material.dart';

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
    );
  }
}
