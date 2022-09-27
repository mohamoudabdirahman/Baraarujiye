import 'dart:io';

import 'package:hive/hive.dart';

part 'Product_Model.g.dart';

@HiveType(typeId: 0)
class Products extends HiveObject {
  @HiveField(0)
  String? productName;
  @HiveField(1)
  String? description;
  @HiveField(2)
  DateTime? expiringDate;
  @HiveField(3)
  bool? expired;

  Products(this.productName, this.description, this.expiringDate,
      this.expired);
}
