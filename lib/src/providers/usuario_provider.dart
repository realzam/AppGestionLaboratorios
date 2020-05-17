import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:proyecto/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UsuarioProvider{

 
final _prefs = new PreferenciasUsuario();
final storage = new FlutterSecureStorage();
final _url="https://proyectoescom.herokuapp.com";


Future< Map<String,dynamic> > login(String numUsuario,String password) async {
  final numUiont=int.parse(numUsuario);
    final authdata={
      'id':numUiont,
      'password':password
    };
    final uu=json.encode(authdata);
    final url='$_url/login';
final res=await http.post(
  url,
  body: uu,
  headers: {'content-type': 'application/json'}
);
  Map<String,dynamic> decodeResp=json.decode(res.body);
  print(decodeResp);
if(decodeResp.containsKey('status'))
  {
    await storage.write(key: 'numUsuario', value: numUsuario.toString());
    await storage.write(key: 'password', value: password);

    if(_prefs.recordarme)
    {

      var aux="";
      for(var i=0;i<numUsuario.length-4;i++)
      {
        aux=aux+"*";
      }
       _prefs.numUser=aux+numUsuario.substring(numUsuario.length - 4);
    }
    else
    {
      _prefs.numUser="";
    }
    return{'ok':true};
  }else{

  return{'ok':false, 'mensaje':decodeResp['error']};
  }
}


Future< Map<String,dynamic> > nuevoUsuario(String numUsuario,String email,String password) async
{
  final numUiont=int.parse(numUsuario);
  print('num usu'+numUsuario);
  final url='$_url/add/alumno';
  final authdata={
    'id':numUiont,
    "correo":email,
    "password":password
  };
  final uu=json.encode(authdata);

final res=await http.post(
  url,
  body: uu,
  headers: {'content-type': 'application/json'}
);

Map<String,dynamic> decodeResp=json.decode(res.body);
print(decodeResp);
if(decodeResp.containsKey('status'))
{
    await storage.write(key: 'numUsuario', value: numUsuario.toString());
    await storage.write(key: 'password', value: password);
  if(_prefs.recordarme)
  {
    var aux="";
    for(var i=0;i<numUsuario.length-4;i++)
    {
      aux=aux+"*";
    }
    _prefs.numUser=aux+numUsuario.substring(numUsuario.length - 4);
  }else
  {
    _prefs.numUser="";
  }
  

  return{'ok':true};
}else{

return{'ok':false, 'mensaje':decodeResp['error']};
}

}

Future<dynamic> verificarToken()async
  {
    print('verificando token');
    String  email= await storage.read(key: 'email');
    String  password= await storage.read(key: 'password');
    if(_prefs.token==null || _prefs.token=="")
    {
      final resp=await login(email,password);
      print(resp);
      return true;
    }
    final url='https://proyecto-313ac.firebaseio.com/verificarToken.json?auth=${_prefs.token}';
    final res= await http.get(url);
    final Map <String, dynamic> decodeData =json.decode(res.body);
    if(decodeData['error']!=null)
    {
      print('expiro el token');
      print('generando uno nuevo');
      await login(email,password);
      
    }else
    {
      print('token valido');
    }
    return  true;
  }

}