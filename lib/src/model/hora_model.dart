import 'package:intl/intl.dart';
import 'package:proyecto/src/preferencias_usuario/preferencias_usuario.dart';

final _prefs = new PreferenciasUsuario();
class Horas{
  List<Hora> items=new List();
  Horas();
   Horas.fromList(List<int> list,DateTime date) {
    if(list==null) return;
    for(var item in list)
    {
      final hora=new Hora(item,date:date);
      items.add(hora);
    }
  
  }
}

class Hora{
  int id;
  DateTime inicio;
  DateTime fin;
  String horaInicio;
  String horaFin;
  Hora(int id,{DateTime date})
  {
    this.id=id;
    var now =(date!=null)?date: new DateTime.now();
    var sm="${now.month}";
    var  sd="${now.day}";
    if(now.month<10)
    {
      sm="0${now.month}";
    }
    if(now.day<10)
    {
      sd="0${now.day}";
    }
    switch (id) {
      case 1:
       this.inicio=DateTime.parse('${now.year}-$sm-$sd 07:00:00');	this.fin=DateTime.parse('${now.year}-$sm-$sd 08:29:59');
      break;
       case 2:
       this.inicio=DateTime.parse('${now.year}-$sm-$sd 08:30:00');	this.fin=DateTime.parse('${now.year}-$sm-$sd 09:59:59');
      break;
       case 3:
       this.inicio=DateTime.parse('${now.year}-$sm-$sd 10:00:00');	this.fin=DateTime.parse('${now.year}-$sm-$sd 10:29:59');
      break;
       case 4:
       this.inicio=DateTime.parse('${now.year}-$sm-$sd 10:30:00');	this.fin=DateTime.parse('${now.year}-$sm-$sd 11:59:59');

      break;
       case 5:
       this.inicio=DateTime.parse('${now.year}-$sm-$sd 12:00:00');	this.fin=DateTime.parse('${now.year}-$sm-$sd 13:29:59');
      break;
       case 6:
        this.inicio=DateTime.parse('${now.year}-$sm-$sd 13:30:00');	this.fin=DateTime.parse('${now.year}-$sm-$sd 14:59:59');
      break;
       case 7:
        this.inicio=DateTime.parse('${now.year}-$sm-$sd 15:00:00');	this.fin=DateTime.parse('${now.year}-$sm-$sd 16:29:59');
      break;
       case 8:
        this.inicio=DateTime.parse('${now.year}-$sm-$sd 16:30:00');	this.fin=DateTime.parse('${now.year}-$sm-$sd 17:59:59');
      break;
       case 9:
        this.inicio=DateTime.parse('${now.year}-$sm-$sd 18:00:00');	this.fin=DateTime.parse('${now.year}-$sm-$sd 18:29:59');
      break;
       case 10:
      this.inicio=DateTime.parse('${now.year}-$sm-$sd 18:30:00');	this.fin=DateTime.parse('${now.year}-$sm-$sd 19:59:59');

      break;
       case 11:
       this.inicio=DateTime.parse('${now.year}-$sm-$sd 20:00:00');	this.fin=DateTime.parse('${now.year}-$sm-$sd 21:29:59');
      break;
    }
    if(_prefs.formatHora)
    {
      this.horaInicio=DateFormat('h:mm a').format(inicio);
      this.horaFin=DateFormat('h:mm a').format(fin);
    }else
    {
       this.horaInicio=DateFormat('H:mm').format(inicio);
      this.horaFin=DateFormat('H:mm').format(fin);
    }
    
  }
}