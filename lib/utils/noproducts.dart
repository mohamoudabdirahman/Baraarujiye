import 'package:baraarujiyeapp/Colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NoProducts extends StatelessWidget {
  var language = Hive.box('language');
   NoProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            '😐',
            style: TextStyle(
              fontSize: 60,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
             language.get('language') == 'Eng' ?
            'There is no recorded products yet': 'Ma jirto alaab diwaangeshan ilaa hadda',
            style: TextStyle(fontSize: 18, color: AppColors().thirdAppColor),
          )
        ],
      ),
    );
  }
}
