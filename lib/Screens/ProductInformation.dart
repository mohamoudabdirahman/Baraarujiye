import 'dart:ui';

import 'package:baraarujiyeapp/Colors/colors.dart';
import 'package:baraarujiyeapp/Model/Product_Model.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProductInfomation extends StatefulWidget {
  String? productname;
  String? productdesc;
  String? dateofexpire;
  ProductInfomation(
      {Key? key,
      this.products,
      this.productdesc,
      this.productname,
      this.index,
      this.dateofexpire})
      : super(key: key);
  Products? products;
  int? index;

  @override
  State<ProductInfomation> createState() => _ProductInfomationState();
}

class _ProductInfomationState extends State<ProductInfomation> {
  var language = Hive.box('language');
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: 500,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors().secondaryAppColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              language.get('language') == 'Eng' ?
                              'About this product': 'Warbixinta alaabtan',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: AppColors().fourthAppColor),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  language.get('language') == 'Eng' ?
                                  'Product Name': 'Magaca Alaabta',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors().thirdAppColor),
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  widget.products == null
                                      ? ''
                                      : widget.products!.productName!,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: AppColors().fourthAppColor),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                   language.get('language') == 'Eng' ?
                                  'Product Description': 'Sharaxaada Alaabta',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors().thirdAppColor),
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  widget.products == null
                                      ? ''
                                      : widget.products!.description!,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: AppColors().fourthAppColor),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                   language.get('language') == 'Eng' ?
                                  'Date of expire': 'Taariikhda dhicitaanka',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors().thirdAppColor),
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  widget.products == null
                                      ? ''
                                      : formatDate(
                                          widget.products!.expiringDate!,
                                          [d, ", ", M, " ", yyyy]),
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: AppColors().fourthAppColor),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Center(
                            child: MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              color: AppColors().mainAppColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              minWidth: 200,
                              child: Text(
                                 language.get('language') == 'Eng' ?
                                'Close': 'xidh',
                                style: TextStyle(
                                    color: AppColors().fourthAppColor),
                              ),
                            ),
                          )
                        ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
