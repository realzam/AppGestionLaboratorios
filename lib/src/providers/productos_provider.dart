import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mime_type/mime_type.dart';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:proyecto/src/model/producto_model.dart';
import 'package:proyecto/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:proyecto/src/providers/usuario_provider.dart';

class ProductosProvider{

final String _url="https://proyecto-313ac.firebaseio.com";
final _prefs = new PreferenciasUsuario();
final usuarioProvider= new UsuarioProvider();
final storage = new FlutterSecureStorage();

 Future<bool> crearProducto(ProductoModel producto) async
  {
    await usuarioProvider.verificarToken();
    final url='$_url/productos.json?auth=${_prefs.token}';
    final res= await http.post(url,body: productoModelToJson(producto));
    final decodeData=json.decode(res.body);
    print(decodeData);
    return true;
  }

Future<bool> editarProducto(ProductoModel producto) async
  {
   
   await usuarioProvider.verificarToken();
    final url='$_url/productos/${producto.id}.json?auth=${_prefs.token}';
    final res= await http.put(url,body: productoModelToJson(producto));
    final decodeData=json.decode(res.body);
    print(decodeData);
    return true;
  }
  Future<List<ProductoModel>> cargarProductos()async
  {
     return [];
   // await usuarioProvider.verificarToken();
    
      final url='$_url/productos.json?auth=${_prefs.token}';
      final res= await http.get(url);
      final Map <String, dynamic> decodeData =json.decode(res.body);
      final List<ProductoModel> productos=new List();

      if(decodeData==null)
      return [];
      print(decodeData);
      decodeData.forEach((id,prod){
        final prodTemp=ProductoModel.fromJson(prod);
        prodTemp.id=id;
        productos.add(prodTemp);
      });
      return productos;
    
  }

Future<int> borrarProducto(String id)async
{
await usuarioProvider.verificarToken();
  final url = '$_url/productos/$id.json?auth=${_prefs.token}';
  final resp = await http.delete(url);
  print(resp.body);
  return 1;
}


  Future<String> subirImagen(File imagen) async{
    final url=Uri.parse('https://api.cloudinary.com/v1_1/dc0wenflo/image/upload?upload_preset=koogi7st');
    final mimeType=mime(imagen.path).split('/');
    final imageUploadRequest=http.MultipartRequest(
      'POST',
      url
    );
    final file=await http.MultipartFile.fromPath(
      'file',imagen.path,
      contentType: MediaType(mimeType[0],mimeType[1])
      );

      imageUploadRequest.files.add(file);

      final streamResponse=await imageUploadRequest.send();
      final resp= await http.Response.fromStream(streamResponse);

      if(resp.statusCode!=200 && resp.statusCode!=201)
      {
        print('algo salio mal');
        print(resp.body);
        return null;
      }
      final resData=json.decode(resp.body);
      print(resData);
      return resData['secure_url'];
  }


}