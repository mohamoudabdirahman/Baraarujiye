// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:math';

import 'package:baraarujiyeapp/Colors/colors.dart';
import 'package:baraarujiyeapp/Model/Product_Model.dart';
import 'package:baraarujiyeapp/Screens/Hompage.dart';
import 'package:baraarujiyeapp/utils/Calendar.dart';
import 'package:baraarujiyeapp/utils/texfields.dart';
import 'package:date_format/date_format.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';

class AddProductScren extends StatefulWidget {
  AddProductScren({Key? key, this.product}) : super(key: key);
  
  Products? product;
  @override
  State<AddProductScren> createState() => _AddProductScrenState();
}

class _AddProductScrenState extends State<AddProductScren> {
  final TextEditingController _productName = TextEditingController();
  final TextEditingController _productDescription = TextEditingController();
  final DateTime _currentDate = DateTime.now();
  late Box box;

  //File? _image;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  Box<Products> productBox = Hive.box<Products>('Products');
  final datebox = Hive.box('date');
  var language = Hive.box('language');
  final ispresedcal = Hive.box('ispressed');
  var pickeddate;

  bool nottapped = false;
  //dispose the controllers

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _productName.dispose();
    _productDescription.dispose();
  }

  final CalendarCarousel _calendarCarouselNoHeader = CalendarCarousel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().mainAppColor,
      appBar: AppBar(
        backgroundColor: AppColors().mainAppColor,
        title: Text('BARAARUJIYE',
            style: GoogleFonts.montserrat(
                color: AppColors().thirdAppColor,
                letterSpacing: 3,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Form(
        key: _formkey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  language.get('language') == 'Eng' ?
                  'Add Schedule':'Diwaangeli alaab',
                    style: TextStyle(
                        fontSize: 25,
                        color: AppColors().thirdAppColor,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 30,
                ),
                InputFields(
                  productNameController: _productName,
                  labeling: language.get('language') == 'Eng' ? 'Product Name':'Magaca Alaabta',
                  hintext:
                      widget.product == null ? '' : widget.product!.productName,
                ),
                SizedBox(
                  height: 20,
                ),
                InputFields(
                  productNameController: _productDescription,
                  labeling: language.get('language') == 'Eng' ? 'Product Description': 'Sharaxaada alaabta',
                  keybtype: TextInputType.multiline,
                  minline: 5,
                  hintext:
                      widget.product == null ? '' : widget.product!.description,
                  maxline: 25,
                ),
                SizedBox(
                  height: 30,
                ),
                MyCalendar(
                  product: widget.product,
                ),
                MaterialButton(
                  onPressed: () {
                    pickeddate = datebox.get('date');

                    save();

                    // productBox.clear();
                  },
                  minWidth: 300,
                  height: 50,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  color: AppColors().secondaryAppColor,
                  child: Text(
                    widget.product == null ? language.get('language') == 'Eng'? 'Save' : 'Diwaangeli' : language.get('language') == 'Eng' ? 'Update' : 'Cusbooneysi',
                    style: TextStyle(color: AppColors().fourthAppColor),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  save() async {
    //var calvalue = ispresedcal.get('ispressed');
    if (_formkey.currentState!.validate()) {
      showDialog(
          context: context,
          builder: (context) {
            return AbsorbPointer(
              absorbing: true,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Center(
                    child: SizedBox(
                  height: 50,
                  width: 50,
                  child: LoadingIndicator(
                      colors: [AppColors().secondaryAppColor],
                      indicatorType: Indicator.ballClipRotatePulse),
                )),
              ),
            );
          });
     
        try {
          var newProduct = Products(_productName.text.toString(),
              _productDescription.text.toString(), pickeddate, false);
          if (widget.product != null) {
            if (_formkey.currentState!.validate()) {
              widget.product!.productName = newProduct.productName;
              widget.product!.description = newProduct.description;
              widget.product!.expiringDate = pickeddate;
              widget.product!.expired = false;
              widget.product!.save();
            }
            //datebox.put('date', DateTime.now());
            Navigator.pop(context);
            Navigator.pop(context, HomePage());
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: AppColors().secondaryAppColor,
                elevation: 1,
                content: Text(
                   language.get('language') == 'Eng' ?
                  'You have Successfully Updated Your Product': 'waad ku guuleysatay wax ka badelka alaabtan',
                  style: TextStyle(color: AppColors().fourthAppColor),
                )));
          } else {
            productBox.add(Products(_productName.text.toString(),
                _productDescription.text.toString(), pickeddate, false));
            //there is problem here and we have to trigger and solve it 😎


            // datebox.put(
            //     'date', widget.product == null ? DateTime.now() : );
            Navigator.pop(context);
            Navigator.pop(context, HomePage());
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: AppColors().secondaryAppColor,
                elevation: 1,
                content: Text(
                   language.get('language') == 'Eng' ?
                  'You have Successfully Created a product expire date' : 'waad ku guuleysatay diwaangelinta alaabtan',
                  style: TextStyle(color: AppColors().fourthAppColor),
                )));
          }
        } on Exception catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: AppColors().secondaryAppColor,
              elevation: 1,
              content: Text(
                e.toString(),
                style: TextStyle(color: AppColors().fourthAppColor),
              )));
          Navigator.pop(context);
        }
    }
  }
}
