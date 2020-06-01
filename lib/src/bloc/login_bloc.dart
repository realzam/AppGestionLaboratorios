import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:proyecto/src/bloc/validators.dart';


class LoginBloc with Validators{
  
//register
  final _numeroUsuarioController=BehaviorSubject<String>();
  final _passwordController=BehaviorSubject<String>();
  final _passwordConfirmController=BehaviorSubject<String>();
  final _emailController=BehaviorSubject<String>();
  final _nombreController=BehaviorSubject<String>();



  //recuperar los datos del stream
Stream<String> get numeroUsuarioStream => _numeroUsuarioController.stream.transform(validarNumeroUsuario);
Stream<String>  get passwordStream => _passwordController.stream.transform(validarPassword);
Stream<String> get passwordConfirmStream => _passwordConfirmController.stream.transform(validarPassword);
Stream<String>  get emailStream => _emailController.stream.transform(validarEmail);
Stream<String> get nombreStream => _nombreController.stream.transform(validarNombre);



Stream<bool> get formValidStream => 
    CombineLatestStream.combine5(numeroUsuarioStream, passwordStream,passwordConfirmStream,emailStream,nombreStream, (u, p,cp,e,n,) => true);

  //insetar valortes al stream
  Function(String) get changeNumeroUsuario => _numeroUsuarioController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changePasswordConfirm => _passwordConfirmController.sink.add;
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changeNombre => _nombreController.sink.add;

  dispose(){
    _nombreController?.close();
    _numeroUsuarioController?.close();
    _passwordController?.close();
    _passwordConfirmController?.close();
    _emailController?.close();
  }
  //obtener ultimo valor 
  String get numeroUsuario =>_numeroUsuarioController.value;
  String get password =>_passwordController.value;
  String get confirmPassword =>_passwordConfirmController.value;
  String get email =>_emailController.value;
  String get nombre =>_nombreController.value;

}