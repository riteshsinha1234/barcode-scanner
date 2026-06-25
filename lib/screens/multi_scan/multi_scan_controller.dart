import 'package:barcode_scanner/models/cart_item_model.dart';
import 'package:barcode_scanner/models/product_model.dart';
import 'package:get/get.dart';

class MultiScanController extends GetxController {
  RxList<CartItemModel> cartItems = <CartItemModel>[].obs;

  void addProduct(ProductModel product) {
    final index = cartItems.indexWhere(
      (item) => item.product.barcode == product.barcode,
    );

    if (index != -1) {
      cartItems[index].quantity++;
      cartItems.refresh();
    } else {
      cartItems.add(CartItemModel(product: product));
    }
  }

  void increaseQuantity(int index) {
    cartItems[index].quantity++;
    cartItems.refresh();
  }

  void decreaseQuantity(int index) {
    if (cartItems[index].quantity > 1) {
      cartItems[index].quantity--;
      cartItems.refresh();
    } else {
      cartItems.removeAt(index);
    }
  }

  void clearCart() {
    cartItems.clear();
  }

  double get totalAmount {
    double total = 0;

    for (var item in cartItems) {
      total += item.product.price * item.quantity;
    }

    return total;
  }

  int get totalItems {
    int total = 0;

    for (var item in cartItems) {
      total += item.quantity;
    }

    return total;
  }
}
