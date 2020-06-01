import 'package:intl/intl.dart';
import 'package:proyecto/src/model/hora_model.dart';
import 'package:proyecto/src/preferencias_usuario/preferencias_usuario.dart';

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

  String horaS;
  String fecha;

Reserva({
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
      ok             =  true;
      idUsuario      =  json['id_usuario'];
      idComputadora  =  json['id_computadora'];
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


