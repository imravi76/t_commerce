
import 'package:flutter/material.dart';

import '../constants.dart';

class CustomInput extends StatelessWidget {

  final String? hints;
  final Function(String)? onChanged, onSubmitted;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final bool? isPasswordField;

  const CustomInput({Key? key, this.hints, this.onChanged, this.onSubmitted, this.focusNode, this.textInputAction, this.isPasswordField}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    bool _isPasswordField = isPasswordField ?? false;

    return Container(

      child: TextField(
        obscureText: _isPasswordField,
        focusNode: focusNode,
        onSubmitted: onSubmitted,
        onChanged: onChanged,
        textInputAction: textInputAction,
        style: Constants.regularDarkText,

        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hints ?? "Hints....",
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 20.0,
          )
        ),
      ),

      margin: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 24.0,
      ),

      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }
}
