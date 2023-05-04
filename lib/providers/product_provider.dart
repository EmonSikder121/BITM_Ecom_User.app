import 'dart:io';
import 'package:ecom_user_pb_bitm/auth/authservice.dart';
import 'package:ecom_user_pb_bitm/models/comment_model.dart';
import 'package:ecom_user_pb_bitm/models/rating_model.dart';
import 'package:ecom_user_pb_bitm/models/user_model.dart';
import 'package:ecom_user_pb_bitm/utils/helper_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../models/purchase_model.dart';

class ProductProvider extends ChangeNotifier {
  List<CategoryModel> categoryList = [];
  List<ProductModel> productList = [];

  getAllCategories() {
    DbHelper.getAllCategories().listen((snapshot) {
      categoryList = List.generate(snapshot.docs.length,
          (index) => CategoryModel.fromMap(snapshot.docs[index].data()));
      categoryList
          .sort((cat1, cat2) => cat1.categoryName.compareTo(cat2.categoryName));
      notifyListeners();
    });
  }

  getAllProducts() {
    DbHelper.getAllProducts().listen((snapshot) {
      productList = List.generate(snapshot.docs.length,
          (index) => ProductModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  Future<String> uploadImage(String thumbnailImageLocalPath) async {
    final photoRef = FirebaseStorage.instance
        .ref()
        .child('ProductImages/${DateTime.now().millisecondsSinceEpoch}');
    final uploadTask = photoRef.putFile(File(thumbnailImageLocalPath));
    final snapshot = await uploadTask.whenComplete(() => null);
    return snapshot.ref.getDownloadURL();
  }

  ProductModel getProductById(String productId) {
    return productList.firstWhere((element) => element.productId == productId);
  }

  Future<void> updateProductField(
      String productId, String field, dynamic value) {
    return DbHelper.updateProductField(productId, {field: value});
  }

  List<CategoryModel> getCategoryListForFiltering() {
    return [CategoryModel(categoryName: 'All'), ...categoryList];
  }

  getAllProductsByCategory(CategoryModel categoryModel) {
    DbHelper.getAllProductsByCategory(categoryModel).listen((snapshot) {
      productList = List.generate(snapshot.docs.length,
          (index) => ProductModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  Future<void> addRating(double rating, String pid) async {
    final ratingModel = RatingModel(
      ratingId: AuthService.currentUser!.uid,
      userId: AuthService.currentUser!.uid,
      productId: pid,
      rating: rating,
    );
    await DbHelper.addRating(ratingModel);
    final snapshot = await DbHelper.getRatingsByProduct(pid);
    double total = 0.0;
    final ratingList = List.generate(snapshot.docs.length,
        (index) => RatingModel.fromMap(snapshot.docs[index].data()));
    for (var rating in ratingList) {
      total += rating.rating;
    }
    final avgRating = total / ratingList.length;
    return updateProductField(pid, productFieldAvgRating, avgRating);
  }

  Future<CommentModel> addComment(UserModel userModel, String pid, String comment) async {
    final commentModel = CommentModel(
      commentId: DateTime.now().millisecondsSinceEpoch,
      userModel: userModel,
      productId: pid,
      comment: comment,
      date: getFormattedDate(DateTime.now(), pattern: 'dd/MM/yyyy hh:mm:ss a'),
    );
    await DbHelper.addComment(commentModel);
    return commentModel;
  }

  Future<List<CommentModel>>getAllCommentsByProduct(String pid) async {
    final snapshot = await DbHelper.getAllCommentsByProduct(pid);
    return List.generate(snapshot.docs.length, (index) => CommentModel.fromMap(snapshot.docs[index].data()));
  }

/*
  Future<String> uploadImage(String thumbnailImageLocalPath) async {
    final photoRef = FirebaseStorage.instance
        .ref()
        .child('ProductImages/${DateTime.now().millisecondsSinceEpoch}');
    final uploadTask = photoRef.putFile(File(thumbnailImageLocalPath));
    final snapshot = await uploadTask.whenComplete(() => null);
    return snapshot.ref.getDownloadURL();
  }

  Future<String> uploadImageForWeb(PickedFile pickedFile) async {
    final photoRef = FirebaseStorage.instance
        .ref()
        .child('ProductImages/${DateTime.now().millisecondsSinceEpoch}');
    final uploadTask = photoRef.putData(await pickedFile.readAsBytes());
    final snapshot = await uploadTask.whenComplete(() => null);
    return snapshot.ref.getDownloadURL();
  }



  Future<void> deleteImage(String downloadUrl) {
    return FirebaseStorage.instance.refFromURL(downloadUrl).delete();
  }

  Future<void> repurchase(PurchaseModel purchaseModel, ProductModel productModel) {
    return DbHelper.repurchase(purchaseModel, productModel);
  }



  */
}
