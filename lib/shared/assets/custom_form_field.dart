import 'package:flutter/material.dart';

class CustomInputDecoration extends InputDecoration {
  String? label;
  String? hint;

  CustomInputDecoration({this.label, this.hint})
      : super(
          contentPadding: EdgeInsets.fromLTRB(10, 15, 8, 20),
          labelText: label,
          hintText: hint,
          enabledBorder: CustomWidgetBorder(Colors.grey),
          focusedBorder: CustomWidgetBorder(Colors.grey),
          errorBorder: CustomWidgetBorder(Colors.red[300]),
          focusedErrorBorder: CustomWidgetBorder(Colors.red[300]),
        );
}

class CustomWidgetBorder extends OutlineInputBorder {
  // borderRadius: BorderRadius.all(Radius.circular(10)),
  //                     borderSide: BorderSide(
  //                       color: Colors.grey,
  //                       width: 1.2,
  Color? color;
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
