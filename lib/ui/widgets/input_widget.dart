import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  const InputWidget({
    Key? key,
    required this.labelText,
    // required this.inputFunction,
    this.obscureText = false,
    required this.validatorFunction,
    required this.controller,
    this.textInputType = TextInputType.text,
    // this.initialValue = '',
  }) : super(key: key);

  final String labelText;
  final bool obscureText;
  // final void Function(String value) inputFunction;
  final String? Function(String value) validatorFunction;
  final TextEditingController controller;
  final TextInputType textInputType;
  // final String initialValue;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: labelText,
      ),
      controller: controller,
      // initialValue: initialValue,
      obscureText: obscureText,
      // onSaved: (newValue) => inputFunction(newValue ?? ''),
      validator: (value) => validatorFunction(value ?? ''),
      // validator: (value) => value!.length < 6 ? 'At least 6 caracters' : null,
    );
  }
}