// ignore_for_file: must_be_immutable

import 'package:baraarujiyeapp/Colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class InputFields extends StatelessWidget {
  var language = Hive.box('language');
  TextEditingController productNameController = TextEditingController();
  String labeling;
  var keybtype;
  var maxline;
  var minline;
  String? hintext;
  InputFields(
      {Key? key,
      required this.productNameController,
      required this.labeling,
      this.keybtype,
      this.maxline,
      this.minline,
      this.hintext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return language.get('language') == 'Eng'
              ? "this field can't be empty!"
              : "Khaanadani ma madhnaan karto!";
        }
        return null;
      },
      keyboardType: keybtype,
      minLines: minline,
      maxLines: maxline,
      controller: productNameController,
      style: TextStyle(color: AppColors().fourthAppColor),
      decoration: InputDecoration(
          hintText: hintext,
          hintStyle: TextStyle(color: AppColors().thirdAppColor),
          label: Text(
            labeling,
            style: TextStyle(color: AppColors().thirdAppColor),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide(
                  width: 1,
                  color: AppColors().secondaryAppColor,
                  style: BorderStyle.solid)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide:
                  BorderSide(width: 1, color: AppColors().secondaryAppColor)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide:
                  BorderSide(width: 1, color: AppColors().secondaryAppColor))),
    );
  }
}
