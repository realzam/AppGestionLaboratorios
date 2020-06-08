class ReservasReportes{
    List<ReservaReporte> items = new List();

  ReservasReportes();
  ReservasReportes.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;
    for (var item in jsonList) {
      final laboratorio = new ReservaReporte.fromJson(item);
      items.add(laboratorio);
    }
  }
}

class ReservaReporte {
    
    ReservaReporte({
        this.idUsuario,
        this.computadora,
        this.dia,
        this.hora,
        this.estado,
        this.observacion,
        this.nombre,
    });

    int idUsuario;
    int computadora;
    String dia;
    String hora;
    String estado;
    String observacion;
    String nombre;

  ReservaReporte.fromJson(Map<String, dynamic> json) {
        idUsuario    = json["idUsuario"];
        computadora  = (json.containsKey('Computadora'))?json["Computadora"]:-2;
        dia          = json["dia"];
        hora         = json["hora"];
        estado       = json["Estado"];
        observacion  = json["observacion"];
        nombre       = json["Nombre"];
}

    Map<String, dynamic> toJson() => {
        "idUsuario": idUsuario,
        "Computadora": computadora,
        "dia": dia,
        "hora": hora,
        "Estado": estado,
        "observacion": observacion,
        "Nombre": nombre,
    };
}