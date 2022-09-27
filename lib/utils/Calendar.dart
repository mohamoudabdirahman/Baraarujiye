// ignore_for_file: prefer_const_constructors

import 'package:baraarujiyeapp/Colors/colors.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:baraarujiyeapp/Model/Product_Model.dart';

class MyCalendar extends StatefulWidget {
  MyCalendar({Key? key, this.product}) : super(key: key);
  Products? product;
  @override
  State<MyCalendar> createState() => _MyCalendarState();
}

class _MyCalendarState extends State<MyCalendar> {
  DateTime _currentDate = DateTime.now();
  DateTime currentDate2 = DateTime.now();
  bool ispressed = false;

  String _currentMonth = formatDate(DateTime.now(), ['', ", ", M, " ", '']);

  DateTime _targetDateTime = DateTime.now();

  CalendarCarousel _calendarCarouselNoHeader = CalendarCarousel();

  final datebox = Hive.box('date');
  final ispressedbox = Hive.box('ispressed');

  @override
  Widget build(BuildContext context) {
    return _calendarCarouselNoHeader = CalendarCarousel<Event>(
      todayBorderColor: AppColors().secondaryAppColor,
      onDayPressed: (DateTime date, List<Event> events) {
        setState(() {
          if (widget.product == null) {
            currentDate2 = date;
          }
          if (widget.product != null) {
            widget.product!.expiringDate = date;
          }
        });
        // for (var event in events) {
        //   print(event.date.day);
        // }
        if (currentDate2.isAfter(date)) {
          print('no date');
        } else {
          DateTime formatteddate = date;
          datebox.put('date', formatteddate);
        }
      },
      daysHaveCircularBorder: true,
      showOnlyCurrentMonthDate: false,
      weekendTextStyle: TextStyle(
        color: Colors.lightBlue,
      ),
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
//      firstDayOfWeek: 4,
      //markedDatesMap: _markedDateMap,
      height: 420.0,
      selectedDateTime:
          widget.product == null ? currentDate2 : widget.product!.expiringDate,
      targetDateTime: _targetDateTime,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateCustomShapeBorder: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: AppColors().secondaryAppColor)),
      markedDateCustomTextStyle: TextStyle(
        fontSize: 18,
        color: Colors.blue,
      ),
      showHeader: true,
      showHeaderButton: true,
      headerTextStyle:
          TextStyle(color: AppColors().secondaryAppColor, fontSize: 24),
      todayTextStyle: TextStyle(
        color: AppColors().fourthAppColor,
      ),
      todayButtonColor: Colors.transparent,
      selectedDayTextStyle: TextStyle(
        color: AppColors().fourthAppColor,
      ),
      selectedDayButtonColor: widget.product == null
          ? AppColors().secondaryAppColor
          : AppColors().secondaryAppColor,
      selectedDayBorderColor: AppColors().secondaryAppColor,
      minSelectedDate: _currentDate.subtract(Duration(days: 360)),
      maxSelectedDate: _currentDate.add(Duration(days: 360)),
      prevDaysTextStyle: TextStyle(
        fontSize: 16,
        color: AppColors().thirdAppColor,
      ),
      weekdayTextStyle: TextStyle(color: AppColors().secondaryAppColor),
      daysTextStyle: TextStyle(color: AppColors().thirdAppColor),
      inactiveDaysTextStyle: TextStyle(
        color: Colors.grey,
        fontSize: 16,
      ),
      onCalendarChanged: (DateTime date) {
        setState(() {
          _targetDateTime = date;
          _currentMonth = _targetDateTime.toString();
        });
      },
      onDayLongPressed: (DateTime date) {},
    );
  }
}
