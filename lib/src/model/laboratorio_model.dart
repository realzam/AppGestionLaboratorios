import 'package:proyecto/src/model/hora_model.dart';

class Laboratorios {
  List<Laboratorio> items = new List();

  Laboratorios();
  Laboratorios.fromJsonList(List<dynamic> jsonList, DateTime date) {
    if (jsonList == null) return;
    for (var item in jsonList) {
      final laboratorio = new Laboratorio.fromJson(item, date);
      items.add(laboratorio);
    }
  }
}

class Laboratorio {
  int idLaboratorio;
  String estado;
  int disponibles;
  List<int> horasIDLibres;
  List<Hora> horasLibres;
  Laboratorio({
    this.idLaboratorio,
    this.estado,
    this.disponibles,
    this.horasIDLibres,
    this.horasLibres,
  });

  Laboratorio.fromJson(Map<String, dynamic> json, DateTime date) {
    idLaboratorio       = json["id_laboratorio"];
    estado              = json["estado"];
    disponibles         = json["disponibles"];
    String horaS        = json["horas_libres"].substring(1);
    horaS               = horaS.substring(0, horaS.length - 1);
    List<String> lista  = horaS.split(',');
    horasIDLibres       = lista.map(int.parse).toList();
    final horas         = new Horas.fromList(horasIDLibres, date);
    horasLibres         = horas.items;
  }
}
