import 'package:baraarujiyeapp/Colors/colors.dart';
import 'package:baraarujiyeapp/Model/Product_Model.dart';
import 'package:baraarujiyeapp/Screens/Hompage.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../utils/product_Tile.dart';

class ProductInfo extends StatefulWidget {
  bool? notified;
  ProductInfo({Key? key, this.notified}) : super(key: key);

  @override
  State<ProductInfo> createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  Box<Products> databox = Hive.box<Products>('Products');
  var language = Hive.box('language');
  int? abouttobeexpired;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().mainAppColor,
      appBar: widget.notified!
          ? AppBar(
              backgroundColor: AppColors().mainAppColor,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back)),
            )
          : null,
      body: ValueListenableBuilder<Box<Products>>(
        valueListenable: Hive.box<Products>('Products').listenable(),
        builder: (context, box, _) {
          return Padding(
            padding:
                widget.notified! ? EdgeInsets.all(8.0) : EdgeInsets.all(3.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              language.get('language') == 'Eng'
                                  ? "Expiring products"
                                  : "Alaabta Dhacaysa",
                              style: GoogleFonts.roboto(
                                  fontSize: 24,
                                  color: AppColors().fourthAppColor,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 10,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              //color: AppColors().secondaryAppColor
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    language.get('language') == 'Eng'
                                        ? 'Warning!'
                                        : 'Digniin!',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: AppColors().fourthAppColor),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                      databox.isEmpty 
                                          ? language.get('language') == 'Eng'
                                              ? 'There is no recorded products yet'
                                              : 'Ma jirto alaab diwaangeshan ilaa hadda'
                                          : language.get('language') == 'Eng'
                                              ? "These products will expire in 30 days"
                                              : 'Alaabtani waxay ku dhacaysaa 30 cisho',
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.roboto(
                                        fontSize: 16,
                                        color: AppColors().thirdAppColor,
                                      )),
                                ]),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                      child: PageView(children: [
                    ListView.builder(
                        itemCount: box.values.length,
                        itemBuilder: ((context, index) {
                          Products currentProduct = box.getAt(index)!;
                          var date = currentProduct.expiringDate;

                          // print(date);
                          DateTime dates = DateTime(date!.year, date.month,
                              date.day, date.hour, date.minute);
                          DateTime dates2 = DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                              DateTime.now().hour,
                              DateTime.now().minute);
                          int duration = dates.difference(dates2).inDays;
                          // Duration duration2 = dates.difference(dates2);
                          //print(duration);
                          // for (var element in databox.values) {
                          //   if (element.expiringDate!
                          //           .subtract(Duration(days: 30)) ==
                          //       duration) {
                          //     print(element.productName);
                          //   }
                          // }
                          
                          if (duration <= 30 &&
                              currentProduct.expiringDate!
                                  .isAfter(DateTime.now())) {
                            print(currentProduct.productName);
                            abouttobeexpired =
                                currentProduct.productName!.length;
                            print(abouttobeexpired);
                            return ProductTile(currentProduct, index);
                          } else if (duration > 30 &&
                              currentProduct.expiringDate!
                                  .isAfter(DateTime.now()) &&
                              abouttobeexpired == null) {
                            print(abouttobeexpired);
                            return Center(
                              child: Column(
                                children: [
                                  Text(
                                    '😎',
                                    style: TextStyle(
                                        fontSize: 30,
                                        color: AppColors().fourthAppColor),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    language.get('language') == 'Eng'
                                        ? 'No Products are about to expire the next 30 days'
                                        : 'Ma jirto alaab dhacaysa 30 ka cisho ee soo socda',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors().fourthAppColor),
                                        overflow: TextOverflow.clip,
                                  ),
                                ],
                              ),
                            );
                          }
                          return Container();
                        })),
                  ]))
                ]),
          );
        },
      ),
    );
  }
}
