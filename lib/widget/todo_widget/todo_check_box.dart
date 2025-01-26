import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_netzlech/gen/assets.gen.dart';

class TodoCheckBox extends StatefulWidget {
  const TodoCheckBox({super.key, this.value = false, required this.onChange});

  final bool value;
  final void Function(bool value) onChange;

  @override
  State<TodoCheckBox> createState() => _TodoCheckBoxState();
}

class _TodoCheckBoxState extends State<TodoCheckBox> with SingleTickerProviderStateMixin {
  late bool value;

  @override
  void initState() {
    value = widget.value;
    super.initState();
  }

  void changeState() {
    value = !value;
    HapticFeedback.mediumImpact();
    widget.onChange(value); // Notify parent widget of the change
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: changeState,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400), // Adjusted duration
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: animation,
              child: RotationTransition(
                turns: animation, // Adds a rotation effect
                child: child,
              ),
            ),
          );
        },
        child: value
            ? Assets.svg.check.svg(key: const ValueKey('checked'))
            : Assets.svg.unCheck.svg(
                key: const ValueKey('unchecked'),
              ),
      ),
    );
  }
}
