import 'package:flutter/material.dart';
import 'package:proyecto/src/utils/utils.dart';

class AgregarUsuarioInfo with ChangeNotifier {
  String _nombre='';
  String _id='';
  String _correo='';
  String _errorNombre;
  String _errorId;
  String _errorCorreo;
  bool _isValidForm = false;

  set nombre(String val) {
    this._nombre = val;
    notifyListeners();
  }

  get nombre => this._nombre;

  set id(String val) {
    this._id = val;
    notifyListeners();
  }

  get id => this._id;

  set correo(String val) {
    this._correo = val;
    notifyListeners();
  }

  get correo => this._correo;

  set errorNombre(String val) {
    this._errorNombre = val;
    notifyListeners();
  }

  get errorNombre => this._errorNombre;

  set errorId(String val) {
    this._errorId = val;
    notifyListeners();
  }

  get errorId => this._errorId;

  set errorCorreo(String val) {
    this._errorCorreo = val;
    notifyListeners();
  }

  get errorCorreo => this._errorCorreo;

  set isValidForm(bool val) {
    this._isValidForm = val;
    notifyListeners();
  }

  get isValidForm => this._isValidForm;

  validID() {
    if (isNumeric(_id)) {
      if (_id.length >= 7) {
        errorId = null;
      } else
        errorId = 'Deben ser 7 o más Numeros';
    } else
      errorId = 'Solo se permite Numeros';
    return (errorId == null) ? true : false;
  }

  validNombre() {
    Pattern pattern =
        r"^([A-Za-zÁÉÍÓÚñáéíóúÑ]{0}?[A-Za-zÁÉÍÓÚñáéíóúÑ\']+[\s])+([A-Za-zÁÉÍÓÚñáéíóúÑ]{0}?[A-Za-zÁÉÍÓÚñáéíóúÑ\'])+[\s]?([A-Za-zÁÉÍÓÚñáéíóúÑ]{0}?[A-Za-zÁÉÍÓÚñáéíóúÑ\'])?$";
    RegExp regExp = new RegExp(pattern);
    if (regExp.hasMatch(nombre)) {
      errorNombre = null;
    } else {
      errorNombre = 'Nombre incorecto';
    }
    return (errorNombre == null) ? true : false;
  }

  validCorreo() {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (regExp.hasMatch(correo)) {
      errorCorreo = null;
    } else {
      errorCorreo = 'Correo no valido';
    }
    return (errorCorreo == null) ? true : false;
  }

  validForm() {
    bool a = validID();
    bool b = validNombre();
    bool c = validCorreo();
    if (a && b && c) return true;
    return false;
  }
  reset()
  {
  _correo='';
  _id='';
  _nombre='';
  _errorCorreo=null;
  _errorId=null;
  _errorNombre=null;
  }
}
