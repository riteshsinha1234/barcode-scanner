class SheetModel {
  final String sheetId;
  final String fileName;
  final int totalProducts;
  final DateTime? createdAt;

  SheetModel({
    required this.sheetId,
    required this.fileName,
    required this.totalProducts,
    this.createdAt,
  });
}
