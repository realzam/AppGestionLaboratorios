import 'package:intl/intl.dart';
import 'package:proyecto/src/model/hora_model.dart';
import 'package:proyecto/src/preferencias_usuario/preferencias_usuario.dart';

final _prefs = new PreferenciasUsuario();

class ReservasAdmin{
  
  List<ReservaAdmin> items=new List();
  
  ReservasAdmin();
 ReservasAdmin.fromJsonList(List<dynamic> jsonList) {
    if(jsonList==null) return;
    for(var item in jsonList)
    {
      final reservas=new ReservaAdmin.fromJson(item);
      items.add(reservas);
    }
  }
}

class ReservaAdmin{
    
     ReservaAdmin({
        this.idUsuario,
        this.nombre,
        this.idComputadora,
        this.idLaboratorio,
        this.inicio,
        this.dia,
        this.hora,
        this.fin,
        this.estado,
        this.horaH,
        this.tipoUsuario
    });

    int idUsuario;
    String nombre;
    int idComputadora;
    int idLaboratorio;
    String inicio;
    int dia;
    int hora;
    Hora horaH;
    String fin;
    String estado;
    int tipoUsuario;

     ReservaAdmin.fromJson(Map<String, dynamic> json) {
        tipoUsuario =json["tipo_usuario"];
        idUsuario= json["id_usuario"];
        nombre= json["nombre"];
        idComputadora= (json.containsKey('id_computadora'))?json["id_computadora"]:-2;
        idLaboratorio= json["id_laboratorio"];
        inicio=json["inicio"];
        fin  =json["fin"];
        dia= json["dia"];
        hora= json["hora"];
        estado= json["estado"];
        horaH=Hora(hora);
    }

    Map<String, dynamic> toJson() => {
        "id_usuario": idUsuario,
        "nombre": nombre,
        "id_computadora": idComputadora,
        "id_laboratorio": idLaboratorio,
        "inicio": inicio,
        "dia": dia,
        "hora": hora,
        "fin": fin,
        "estado": estado,
    };
}