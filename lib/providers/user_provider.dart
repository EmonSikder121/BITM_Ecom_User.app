import 'package:flutter/material.dart';
import '../auth/authservice.dart';
import '../db/db_helper.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? userModel;

  Future<void> addUser(UserModel userModel) {
    return DbHelper.addUser(userModel);
  }

  getUserInfo() {
    DbHelper.getUserInfo(AuthService.currentUser!.uid).listen((snapshot) {
      if (snapshot.exists) {
        userModel = UserModel.fromMap(snapshot.data()!);
        notifyListeners();
      }
    });
  }

  Future<void> updateUserProfileField(String field, dynamic value) =>
      DbHelper.updateUserProfileField(
          AuthService.currentUser!.uid, {field: value});

  Future<bool> doesUserExist(String uid) => DbHelper.doesUserExist(uid);
}
