import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io';

class UsuarioProvider {
  final _prefs = new PreferenciasUsuario();
  final storage = new FlutterSecureStorage();
  final _url = "https://proyectoescom.herokuapp.com";

  Future<Map<String, dynamic>> login(String numUsuario, String password) async {
    final numUiont = int.parse(numUsuario);
    final authdata = {'id': numUiont, 'password': password};
    final uu = json.encode(authdata);
    final url = '$_url/login';
    final res = await http
        .post(url, body: uu, headers: {'content-type': 'application/json'});
    Map<String, dynamic> decodeResp = json.decode(res.body);
    print(decodeResp);
    if (decodeResp.containsKey('status')) {
      await storage.write(key: 'numUsuario', value: numUsuario.toString());
      await storage.write(key: 'password', value: password);
      await storage.write(key: 'tipo', value: decodeResp['type'].toString());
      await storage.write(key: 'correo', value: decodeResp['correo']);
      if (decodeResp['type'] == 3)
        await storage.write(
            key: 'laboratorio', value: decodeResp['lab'].toString());
      setTokenNotification();
      if (_prefs.recordarme) {
        var aux = "";
        for (var i = 0; i < numUsuario.length - 4; i++) {
          aux = aux + "*";
        }
        _prefs.numUser = aux + numUsuario.substring(numUsuario.length - 4);
      } else {
        _prefs.numUser = "";
      }
      return {'ok': true};
    } else {
      return {'ok': false, 'mensaje': decodeResp['error']};
    }
  }

  Future<Map<String, dynamic>> nuevoUsuario(
      String numUsuario, String email, String password, String nombre, int type,
      {int lab}) async {
    final numUiont = int.parse(numUsuario);
    print('num usu' + numUsuario);
    final url = '$_url/add/usuario/$type';
    final authdata = {
      'id': numUiont,
      "correo": email,
      "password": password,
      "nombre": nombre,
      "lab": lab
    };
    final uu = json.encode(authdata);

    final res = await http
        .post(url, body: uu, headers: {'content-type': 'application/json'});

    Map<String, dynamic> decodeResp = json.decode(res.body);
    //print(decodeResp);
    if (decodeResp.containsKey('status')) {
      /* if (type == 1) {
        await storage.write(key: 'numUsuario', value: numUsuario.toString());
        await storage.write(key: 'password', value: password);
        await storage.write(key: 'tipo', value: type.toString());
        setTokenNotification();
        if (_prefs.recordarme) {
          var aux = "";
          for (var i = 0; i < numUsuario.length - 4; i++) {
            aux = aux + "*";
          }
          _prefs.numUser = aux + numUsuario.substring(numUsuario.length - 4);
        } else {
          _prefs.numUser = "";
        }
      }*/
      return {'ok': true};
    } else {
      return {'ok': false, 'mensaje': decodeResp['error']};
    }
  }

  Future<dynamic> reservarComputadora(int compu, int lab, int hora) async {
    String usu = await storage.read(key: 'numUsuario');
    final url = '$_url/reservaComputadora';
    final authdata = {
      "usuario": int.parse(usu),
      "compu": compu,
      "lab": lab,
      "hora": hora
    };
    final uu = json.encode(authdata);

    final res = await http
        .post(url, body: uu, headers: {'content-type': 'application/json'});
    Map<String, dynamic> decodeResp = json.decode(res.body);
    print(decodeResp);

    return {'status': decodeResp['status'], 'mensaje': decodeResp['message']};
  }

  Future<dynamic> reservarLaboratorio(int lab, int hora) async {
    String usu = await storage.read(key: 'numUsuario');
    final url = '$_url/reservaLaboratorio';
    final authdata = {"usuario": int.parse(usu), "lab": lab, "hora": hora};
    final uu = json.encode(authdata);

    final res = await http
        .post(url, body: uu, headers: {'content-type': 'application/json'});
    Map<String, dynamic> decodeResp = json.decode(res.body);
    print(decodeResp);

    return {'status': decodeResp['status'], 'mensaje': decodeResp['message']};
  }

  Future<dynamic> miReserva() async {
    String usu = await storage.read(key: 'numUsuario');
    final url = '$_url/miReserva/$usu';
    final res = await http.get(url);
    Map<String, dynamic> decodeResp = json.decode(res.body);
    print(decodeResp);
    if (decodeResp['status'] == 0)
      return {'status': decodeResp['status'], 'info': decodeResp['info']};
    else
      return {'status': decodeResp['status']};
  }

  Future<dynamic> cancelarReservaComputadora() async {
    String usu = await storage.read(key: 'numUsuario');
    final url = '$_url/cancelarReserva/computadora/$usu';
    final res = await http.put(url);
    Map<String, dynamic> decodeResp = json.decode(res.body);
    print(decodeResp);
    if (decodeResp['status'] == 0)
      return {'status': decodeResp['status'], 'info': decodeResp['info']};
    else
      return {'status': decodeResp['status']};
  }

  Future<dynamic> cancelarReservaLaboratorio() async {
    String usu = await storage.read(key: 'numUsuario');
    final url = '$_url/cancelarReserva/laboratorio/$usu';
    final res = await http.put(url);
    Map<String, dynamic> decodeResp = json.decode(res.body);
    print(decodeResp);
    if (decodeResp['status'] == 0)
      return {'status': decodeResp['status'], 'info': decodeResp['info']};
    else
      return {'status': decodeResp['status']};
  }

  Future<dynamic> setTokenNotification() async {
    String usu = await storage.read(key: 'numUsuario');
    final url = '$_url/tokenNotification';
    final authdata = {
      "token": _prefs.token,
      "usuario": int.parse(usu),
    };
    final uu = json.encode(authdata);

    final res = await http
        .post(url, body: uu, headers: {'content-type': 'application/json'});
    Map<String, dynamic> decodeResp = json.decode(res.body);
    print(decodeResp);
  }

  Future<dynamic> setNextEdoReserva(int usuario, int tipoOperacion,
      String estado, int hora, int lab, int computadora, int usarioTipo,
      {String observaciones: 'Sin observaciones'}) async {
    final url = '$_url/nextReserva';
    final authdata = {
      "usuario": usuario,
      "tipoO": tipoOperacion,
      "estado": estado,
      "hora": hora,
      "lab": lab,
      "computadora": computadora,
      "tipoUsuario": usarioTipo,
      "observaciones": observaciones
    };

    final uu = json.encode(authdata);

    final res = await http
        .put(url, body: uu, headers: {'content-type': 'application/json'});
    Map<String, dynamic> decodeResp = json.decode(res.body);
    return {'status': decodeResp['status'], 'info': decodeResp['message']};
  }

  Future<Map<String, dynamic>> getFileFromUrl(int opc, int tipo) async {
    String lab = await storage.read(key: 'laboratorio');
    int ilab = int.parse(lab);
    final authdata = {"lab": ilab, "opc": opc, "tipo": tipo};
    final uu = json.encode(authdata);
    final url = '$_url/views/generarReporte';

    var data = await http
        .post(url, body: uu, headers: {'content-type': 'application/json'});
    print('');
    try {
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/mypdfonline.pdf");

      File urlFile = await file.writeAsBytes(bytes);

      return {'status': true, 'file': urlFile};
      //return urlFile;
    } catch (e) {
      print('error al ontener pdf');
      print(e);
      return {
        'status': false,
      };
    }
  }

  Future<Map<String, dynamic>> getEnviarPdf(int opc, int tipo) async {
    String lab = await storage.read(key: 'laboratorio');
    String correo = await storage.read(key: 'correo');
    int ilab = int.parse(lab);
    final authdata = {"lab": ilab, "opc": opc, "tipo": tipo, "to": correo};
    final uu = json.encode(authdata);
    final url = '$_url/views/enviarPDF';
    final res = await http
        .post(url, body: uu, headers: {'content-type': 'application/json'});
    Map<String, dynamic> decodeResp = json.decode(res.body);
    return decodeResp;
  }

  Future<Map<String, dynamic>> resetPassword(String pass1,String pass2,String token) async{
    final authdata = {"password":pass1, "pwd":pass2};
    final uu = json.encode(authdata);
    final url = '$_url/passwordReset/$token';
    final res = await http.post(url, body: uu, headers: {'content-type': 'application/json','User-Agent':'Android'});
    Map<String, dynamic> decodeResp = json.decode(res.body);
    return decodeResp;
  }

    Future<Map<String, dynamic>> requetEmailPassword(String correo) async{
    final authdata = {"usuario":correo};
    final uu = json.encode(authdata);
    final url = '$_url/passwordOlvidado';
    final res = await http.post(url, body: uu, headers: {'content-type': 'application/json'});
    Map<String, dynamic> decodeResp = json.decode(res.body);
    return decodeResp;
  }
}
