class Computadoras{
  
  List<Computadora> items=new List();
  
  Computadoras();
 Computadoras.fromJsonList(List<dynamic> jsonList) {
    if(jsonList==null) return;
    for(var item in jsonList)
    {
      final laboratorio=new Computadora.fromJson(item);
      items.add(laboratorio);
    }
  
  }
}


class Computadora {
    int idComputadora;
    int idLaboratorio;
    String estado;

    Computadora({
        this.idComputadora,
        this.idLaboratorio,
        this.estado,
    });

    Computadora.fromJson(Map<String, dynamic> json) {
        idComputadora   = json["id_computadora"];
        idLaboratorio   = json["id_laboratorio"];
        estado          = json["estado"];
    }
}
