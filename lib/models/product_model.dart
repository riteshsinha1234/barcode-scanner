import 'package:hive/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 0)
class ProductModel {
  @HiveField(0)
  String barcode;

  @HiveField(1)
  String name;

  @HiveField(2)
  double price;

  ProductModel({
    required this.barcode,
    required this.name,
    required this.price,
  });
}
