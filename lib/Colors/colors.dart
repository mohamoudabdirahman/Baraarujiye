import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';

var box = Hive.box('modeStatus');

class AppColors {
  Color mainAppColor =
      box.get('darkmode') ? const Color(0xff1E1034) : const Color(0xffECE1FE);
  Color secondaryAppColor =
      box.get('darkmode') ? const Color(0xff661CD6) : const Color(0xffB8B7BB);
  Color thirdAppColor =
      box.get('darkmode') ? const Color(0xffB8B7BB) : const Color(0xff661CD6);
  Color fourthAppColor =
      box.get('darkmode') ? const Color(0xffECE1FE) : const Color(0xff1E1034);
}
