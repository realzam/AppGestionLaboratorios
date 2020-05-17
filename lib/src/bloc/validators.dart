
import 'dart:async';
import 'package:proyecto/src/utils/utils.dart';


class Validators{

 final validarNumeroUsuario = StreamTransformer<String,String>.fromHandlers(
    handleData: (usuario,sink){
    if(usuario.length>=10 && isNumeric(usuario))
      {
        sink.add(usuario);
      }else
      {
        if( isNumeric(usuario))
        sink.addError('Deben ser 10 o más Numeros');
        else
        sink.addError('Solo se permite Numeros');
      }
    }
  );

   final validarEmail = StreamTransformer<String,String>.fromHandlers(
     
    handleData: (email,sink){
      Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp=new RegExp(pattern);
    if(regExp.hasMatch(email))
      {
        sink.add(email);
      }else
      {
        sink.addError('Correo incorecto');
      }
    }
  );

  final validarPassword = StreamTransformer<String,String>.fromHandlers(
    handleData: (password,sink){
      if(password.length>=8)
      {
        sink.add(password);
      }else
      {
        sink.addError('Mas de 8 caracters');
      }
    }
  );
}