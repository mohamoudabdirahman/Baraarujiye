import 'package:baraarujiyeapp/Colors/colors.dart';
import 'package:baraarujiyeapp/Model/Product_Model.dart';
import 'package:baraarujiyeapp/Screens/AddProduct.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ionicons/ionicons.dart';

class ProductTile extends StatefulWidget {
  ProductTile(this.product, this.index, {Key? key,}) : super(key: key);

  int index;
  Products product;
  @override
  State<ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  Box<Products> productBox = Hive.box<Products>('Products');
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Slidable(
        endActionPane: ActionPane(motion: const ScrollMotion(), children: [
          SizedBox(width: 5),
          SlidableAction(
            onPressed: (context) {
              widget.product.delete();
            },
            icon: Icons.delete_sweep_outlined,
            backgroundColor: AppColors().secondaryAppColor,
            borderRadius: BorderRadius.circular(12),
          ),
          SizedBox(
            width: 5,
          ),
          SlidableAction(
            onPressed: (context) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => AddProductScren(
                            product: widget.product,
                          ))));
            },
            icon: Icons.edit_rounded,
            backgroundColor: AppColors().thirdAppColor,
            borderRadius: BorderRadius.circular(12),
          )
        ]),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: AppColors().secondaryAppColor,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Container(
                width: 95,
                height: 74,
                decoration: BoxDecoration(
                  color: AppColors().mainAppColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                    child: Text(
                  widget.index.toString(),
                  style:
                      TextStyle(color: AppColors().thirdAppColor, fontSize: 25),
                )),
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.productName!,
                    style: GoogleFonts.roboto(
                        fontSize: 20, color: AppColors().fourthAppColor),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    formatDate(
                        widget.product.expiringDate!, [d, ", ", M, " ", yyyy]),
                    style: GoogleFonts.roboto(
                        fontSize: 15, color: AppColors().thirdAppColor),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
