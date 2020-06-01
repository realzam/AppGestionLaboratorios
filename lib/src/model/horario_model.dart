
import 'package:intl/intl.dart';
import 'package:proyecto/src/preferencias_usuario/preferencias_usuario.dart';

class HorarioModel {
    bool status;
    List<Lab> lab;

    HorarioModel({
        this.lab,
        this.status,
    });

    factory HorarioModel.fromJson(Map<String, dynamic> json) => HorarioModel(
        lab: List<Lab>.from(json["lab"].map((x) => Lab.fromJson(x))),
        status: true
    );

    Map<String, dynamic> toJson() => {
        "lab": List<dynamic>.from(lab.map((x) => x.toJson())),
    };
}

class Lab {
    int idLaboratorio;
    List<Dia> dias;

    Lab({
        this.idLaboratorio,
        this.dias,
    });

    factory Lab.fromJson(Map<String, dynamic> json) => Lab(
        idLaboratorio: json["id_laboratorio"],
        dias: List<Dia>.from(json["dias"].map((x) => Dia.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id_laboratorio": idLaboratorio,
        "dias": List<dynamic>.from(dias.map((x) => x.toJson())),
    };
}

class Dia {
    int dia;
    List<ClaseElement> clases;

    Dia({
        this.dia,
        this.clases,
    });

    factory Dia.fromJson(Map<String, dynamic> json) => Dia(
        dia: json["dia"],
        clases: List<ClaseElement>.from(json["clases"].map((x) => ClaseElement.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "dia": dia,
        "clases": List<dynamic>.from(clases.map((x) => x.toJson())),
    };
}

class ClaseElement {
  final _prefs = new PreferenciasUsuario();
    String clase;
    int hora;
    String inicio;
    String fin;

    ClaseElement({
        this.clase,
        this.hora,
        this.inicio,
        this.fin,
    });

    ClaseElement.fromJson(Map<String, dynamic> json) 
    {
      clase= json["clase"];
        hora= json["hora"];
        
        inicio=(_prefs.formatHora)?DateFormat('hh:mm a').format(DateTime.parse('2020-05-29 '+json["inicio"]+'Z')): json["inicio"];
        fin  =(_prefs.formatHora)?DateFormat('hh:mm a').format(DateTime.parse('2020-05-29 '+json["fin"]+'Z')): json["fin"];

        print('len ${inicio.length+fin.length}');
    }
        
   

    Map<String, dynamic> toJson() => {
        "clase": clase,
        "hora": hora,
        "inicio": inicio,
        "fin": fin,
    };
}

//enum ClaseEnum { TEORIA_COMPUTACIONAL, LIBRE, SISTEMAS_OPERATIVOS, POO, ALGORITMIA, BASE_DE_DATOS, REDES_1, TECNOLOGIAS_PARA_LA_WEB, ADOO, INGENIERIA_DE_SOFTWARE }


