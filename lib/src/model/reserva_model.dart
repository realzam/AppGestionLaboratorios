import 'package:intl/intl.dart';
import 'package:proyecto/src/model/hora_model.dart';

class Reservas {
  List<Reserva> items = new List();

  Reservas();
  Reservas.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;
    for (var item in jsonList) {
      final reserva = new Reserva.fromJson(item);
      items.add(reserva);
    }
  }
}

class Reserva{
  bool ok;
  int idUsuario;
  int idComputadora;
  int idLaboratorio;
  DateTime inicio;
  int dia;
  int hora;
  DateTime fin;
  String estado;
  int tipo;

  String horaS;
  String fecha;

Reserva({
  this.tipo,
    this.ok,
    this.idUsuario,
    this.idComputadora,
    this.idLaboratorio,
    this.inicio,
    this.dia,
    this.hora,
    this.fin,
    this.estado,
    this.horaS,
    this.fecha
  });

    Reserva.fromJson(Map<String, dynamic> json) {
      tipo           =  json['tipo'];
      ok             =  true;
      idUsuario      =  json['id_usuario'];
      idComputadora  =  (json['tipo']==1)?json['id_computadora']:-2;
      idLaboratorio  =  json['id_laboratorio'];
      inicio         =  DateTime.parse(json['inicio']);
      dia            =  json['dia'];
      hora           =  json['hora'];
      fin            =  DateTime.parse(json['fin']);
      estado         =  json['estado'];
      horaS          =  Hora(hora).horaInicio;
      fecha          =  DateFormat('d').format(fin) +' ' + DateFormat('MMM').format(fin);
    }
    Reserva.nothing()
    {
      ok=false;
    }
    
}


