import 'package:flutter/material.dart';
import 'package:food/pages/admin/models/user_account_model.dart';

class AdminCreateNewAccountPresenter {
  final UserModel _userModel;
  final VoidCallback _onSuccess;
  final VoidCallback _onError;
  final Function(bool) _onLoading;

  AdminCreateNewAccountPresenter(
    this._userModel, this._onSuccess, this._onError, this._onLoading);
  
  void createUser(String email, String password) async {
    _onLoading(true);

    try {
      await _userModel.createUser(email, password);
      _onSuccess;
    }
    catch(e) {
      _onError();
    }
    finally {
      _onLoading(false);
    }
  }

}