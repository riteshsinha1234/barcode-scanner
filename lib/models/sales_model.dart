import 'package:hive/hive.dart';
import 'cart_item_model.dart';

part 'sales_model.g.dart';

@HiveType(typeId: 3)
class SalesModel {
  @HiveField(0)
  String invoiceNo;

  @HiveField(1)
  List<CartItemModel> items;

  @HiveField(2)
  double totalAmount;

  @HiveField(3)
  DateTime saleDate;

  SalesModel({
    required this.invoiceNo,
    required this.items,
    required this.totalAmount,
    required this.saleDate,
  });
}
