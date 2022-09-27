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
   ProductInfo({Key? key,this.notified}) : super(key: key);

  @override
  State<ProductInfo> createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  Box<Products> databox = Hive.box<Products>('Products');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().mainAppColor,
      appBar: widget.notified! ? AppBar(
        backgroundColor: AppColors().mainAppColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
      ):null,
      body: ValueListenableBuilder<Box<Products>>(
        valueListenable: Hive.box<Products>('Products').listenable(),
        builder: (context, box, _) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Expiring products",
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
                                  'Warning!',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: AppColors().fourthAppColor),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                    "These products will be expiring in 30 days",
                                    overflow: TextOverflow.clip,
                                    style: GoogleFonts.roboto(
                                      fontSize: 18,
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
                        for (var element in databox.values) {
                          if (element.expiringDate!.isAfter(DateTime.now())) {
                            // numberofexpired = element.productName!.length;
                          }
                          var date = element.expiringDate!
                              .subtract(const Duration(days: 30));
                          var alert = formatDate(date, [d, " ", '', " ", '']);

                          var day = formatDate(
                              element.expiringDate!, [d, " ", '', " ", '']);
                          //print(day);
                          int calculatedExpireDate =
                              int.parse(alert) - int.parse(day);
                          if (calculatedExpireDate <= 30 &&
                              currentProduct.expiringDate!
                                  .isAfter(DateTime.now())) {
                            return ProductTile(currentProduct, index);
                          }
                          // if (element.expiringDate!.isBefore(DateTime.now())) {
                          //   element.delete();
                          // }
                        }
                        return Container();
                      })),
                ]))
              ]);
        },
      ),
    );
  }
}
