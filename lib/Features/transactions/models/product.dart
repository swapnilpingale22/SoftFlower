// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProductModel {
  final String itemName;
  final double itemQuantity;
  final double itemRate;
  final double totalSale;
  final double commission;

  ProductModel({
    required this.itemName,
    required this.itemQuantity,
    required this.itemRate,
    required this.totalSale,
    required this.commission,
  });
}
