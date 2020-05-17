class Laboratorios{
  
  List<Laboratorio> items=new List();
  
  Laboratorios();
 Laboratorios.fromJsonList(List<dynamic> jsonList) {
    if(jsonList==null) return;
    for(var item in jsonList)
    {
      final laboratorio=new Laboratorio.fromJson(item);
      items.add(laboratorio);
    }
  
  }
}


class Laboratorio {
    int idLaboratorio;
    String estado;
    int disponibles;
    List<int> horasLibres;

    Laboratorio({
        this.idLaboratorio,
        this.estado,
        this.disponibles,
        this.horasLibres,
    });

    Laboratorio.fromJson(Map<String, dynamic> json) {
        idLaboratorio = json["id_laboratorio"];
        estado        = json["estado"];
        disponibles   = json["disponibles"];
        horasLibres   = json["horas_libres"].cast<int>();
        var x=1;
    }

}
