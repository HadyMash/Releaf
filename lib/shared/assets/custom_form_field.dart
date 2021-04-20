import 'package:flutter/material.dart';

class CustomInputDecoration extends InputDecoration {
  final String? label;
  final String? hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final BuildContext context;
  // final FocusNode focusNode;

  CustomInputDecoration(
    this.context, {
    // required this.focusNode,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
  }) : super(
          contentPadding: EdgeInsets.fromLTRB(10, 15, 8, 20),
          labelText: label,
          // labelStyle: TextStyle(color: Colors.grey),
          // color: focusNode.hasFocus
          //     ? Theme.of(context).primaryColor
          //     : Colors.grey),
          hintText: hint,
          enabledBorder: CustomWidgetBorder(color: Colors.grey, width: 1.2),
          focusedBorder: CustomWidgetBorder(
              color: Theme.of(context).primaryColor, width: 2.2),
          errorBorder: CustomWidgetBorder(color: Colors.red[300], width: 1.5),
          focusedErrorBorder:
              CustomWidgetBorder(color: Colors.red[300], width: 2.4),
          prefixIcon: prefixIcon,
          suffix: suffixIcon,
        );
}

class CustomWidgetBorder extends OutlineInputBorder {
  final Color? color;
  final double width;

  CustomWidgetBorder({required this.color, required this.width})
      : super(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: Color.fromRGBO(
              color!.red,
              color.green,
              color.blue,
              color.opacity,
            ),
            width: width,
          ),
        );
}
