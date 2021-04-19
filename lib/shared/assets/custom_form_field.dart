import 'package:flutter/material.dart';

class CustomInputDecoration extends InputDecoration {
  final String? label;
  final String? hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final BuildContext context;
  final FocusNode focusNode;

  CustomInputDecoration(this.context,
      {required this.focusNode,
      this.label,
      this.hint,
      this.prefixIcon,
      this.suffixIcon})
      : super(
          contentPadding: EdgeInsets.fromLTRB(10, 15, 8, 20),
          labelText: label,
          labelStyle: TextStyle(
              color: focusNode.hasFocus
                  ? Theme.of(context).primaryColor
                  : Colors.grey),
          hintText: hint,
          enabledBorder: CustomWidgetBorder(Colors.grey),
          focusedBorder: CustomWidgetBorder(Theme.of(context).primaryColor),
          errorBorder: CustomWidgetBorder(Colors.red[300]),
          focusedErrorBorder: CustomWidgetBorder(Colors.red[300]),
          prefixIcon: prefixIcon,
          suffix: suffixIcon,
        );
}

class CustomWidgetBorder extends OutlineInputBorder {
  final Color? color;
  CustomWidgetBorder([this.color])
      : super(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: Color.fromRGBO(
              color!.red,
              color.green,
              color.blue,
              color.opacity,
            ),
            width: 1.2,
          ),
        );
}
