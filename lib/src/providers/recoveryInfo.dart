import 'package:flutter/material.dart';

class RecoveryInfo with ChangeNotifier {
  String _pass1='';
  String _pass2='';
  String _email='';
  String _errorEmail;
  String _errorPass1;
  String _errorPass2;

  set password(String val) {
    this._pass1 = val;
    notifyListeners();
  }

  set passwordConfirm(String val) {
    this._pass2 = val;
    notifyListeners();
  }

  set errorPassword(String val) {
    this._errorPass1 = val;
    notifyListeners();
  }

  set errorPasswordConfirm(String val) {
    this._errorPass2 = val;
    notifyListeners();
  }

  set email(String val) {
    this._email = val;
    notifyListeners();
  }

  set errorEmail(String val) {
    this._errorEmail = val;
    notifyListeners();
  }

  get email {
    return this._email;
  }

  get errorEmail {
    return this._errorEmail;
  }

  get password {
    return this._pass1;
  }

  get passwordConfirm {
    return this._pass2;
  }

  get errorPassword {
    return this._errorPass1;
  }

  get errorPasswordConfirm {
    return this._errorPass2;
  }

  void reset() {
    this._pass1 = "";
    this._pass2 = "";
    this._errorPass1 = "";
    this._errorPass2 = "";
  }

  validPassword1(String val) {
    if (val.length >= 8) {
      _errorPass1 = null;
      return true;
    }
    _errorPass1 = 'Deben ser al menos 8 caracteres';
    return false;
  }
  validPassword2(String val) {
    if (val.length >= 8) {
      _errorPass2 = null;
      return true;
    }
    _errorPass2 = 'Deben ser al menos 8 caracteres';
    return false;
  }

  validCorreo() {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (regExp.hasMatch(email)) {
      errorEmail = null;
    } else {
      errorEmail = 'Correo no valido';
    }
    return (errorEmail == null) ? true : false;
  }

  bool validForm() {
    bool a = validPassword1(password);
    bool b = validPassword2(passwordConfirm);
    if (a && b) return true;
    return false;
  }
}
