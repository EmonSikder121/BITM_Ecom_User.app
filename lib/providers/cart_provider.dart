import 'package:ecom_user_pb_bitm/auth/authservice.dart';
import 'package:ecom_user_pb_bitm/db/db_helper.dart';
import 'package:ecom_user_pb_bitm/utils/helper_functions.dart';
import 'package:flutter/material.dart';

import '../models/cart_model.dart';
import '../models/product_model.dart';

class CartProvider extends ChangeNotifier {
  List<CartModel> cartList = [];

  num priceWithQuantity(CartModel cartModel) =>
      cartModel.salePrice * cartModel.quantity;

  int get totalItemsInCart => cartList.length;

  bool isProductInCart(String pid) {
    bool tag = false;
    for (final cartModel in cartList) {
      if (cartModel.productId == pid) {
        tag = true;
        break;
      }
    }
    return tag;
  }

  addToCart(ProductModel productModel) {
    final cartModel = CartModel(
      productId: productModel.productId!,
      categoryId: productModel.category.categoryId!,
      productName: productModel.productName,
      productImageUrl: productModel.thumbnailImageUrl,
      salePrice: num.parse(calculatePriceAfterDiscount(productModel.salePrice, productModel.productDiscount)),
    );
    DbHelper.addToCart(AuthService.currentUser!.uid, cartModel);
  }

  removeFromCart(String pid) {
    DbHelper.removeFromCart(AuthService.currentUser!.uid, pid);
  }

  void getAllCartItems() {
    DbHelper.getAllCartItems(AuthService.currentUser!.uid).listen((snapshot) {
      cartList = List.generate(snapshot.docs.length,
          (index) => CartModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  void increaseQuantity(CartModel cartModel) {
    cartModel.quantity += 1;
    DbHelper.updateCartQuantity(AuthService.currentUser!.uid, cartModel);
  }

  void decreaseQuantity(CartModel cartModel) {
    if(cartModel.quantity > 1) {
      cartModel.quantity -= 1;
      DbHelper.updateCartQuantity(AuthService.currentUser!.uid, cartModel);
    }
  }

  num getCartSubTotal() {
    num total = 0;
    for (final cartModel in cartList) {
      total += priceWithQuantity(cartModel);
    }
    return total;
  }

  Future<void> clearCart() {
    return DbHelper.clearCartItems(AuthService.currentUser!.uid, cartList);
  }
}
