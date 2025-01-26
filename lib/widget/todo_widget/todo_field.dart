import 'package:flutter/material.dart';

class TodoField extends StatelessWidget {
  const TodoField({super.key, this.focusNode, required this.onChange, this.controller});

  final FocusNode? focusNode;
  final void Function(String value) onChange;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12.0,
        horizontal: 20.0,
      ).copyWith(top: 16.0),
      child: TextFormField(
        controller: controller,
        onChanged: onChange,
        focusNode: focusNode,
        autofocus: true,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please add a task before proceeding.';
          }
          return null; // Validation passed
        },
        decoration: const InputDecoration(
          labelText: 'Task',
          isDense: true,
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0XFF318FFF),
            ),
          ),
        ),
      ),
    );
  }
}
