import 'package:baraarujiyeapp/Colors/colors.dart';
import 'package:baraarujiyeapp/Model/Product_Model.dart';
import 'package:baraarujiyeapp/utils/noproducts.dart';
import 'package:baraarujiyeapp/utils/product_Tile.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ExpiredProducts extends StatefulWidget {
  ExpiredProducts({Key? key, this.products}) : super(key: key);
  Products? products;

  @override
  State<ExpiredProducts> createState() => _ExpiredProductsState();
}

class _ExpiredProductsState extends State<ExpiredProducts> {
  Box<Products> databox = Hive.box<Products>('Products');
  int? number;
  var language = Hive.box('language');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (var element in databox.values) {
      if (element.expiringDate!.isBefore(DateTime.now())) {
        number = element.productName!.length;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors().mainAppColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: number != null ? databox.values.length : 1,
                    itemBuilder: (context, index) {
                      if (databox.values.isEmpty) {
                        return  NoProducts();
                      } else {
                        Products currentProduct = databox.getAt(index)!;
                        var expired = currentProduct.expiringDate!
                            .isBefore(DateTime.now());
                        var unexpired = currentProduct.expiringDate!
                            .isAfter(DateTime.now());
                        if (expired) {
                          return ProductTile(currentProduct, index);
                        } else if (expired == false && number == null) {
                          return Center(
                              child: Text(
                                language.get('language') == 'Eng'?
                            'No expired products yet 😀': 'Ma jirto alaab dhacday 😀',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors().fourthAppColor,
                            ),
                          ));
                        }
                      }
                      return Container();
                    }))
          ],
        ));
  }
}
