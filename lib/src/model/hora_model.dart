

class Hora{
  int id;
  DateTime inicio;
  DateTime fin;

  Hora(int id)
  {
    this.id=id;
    var now = new DateTime.now();
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
       this.inicio=DateTime.parse('${now.year}-$sm-$sd 08:30:00');	this.fin=DateTime.parse('${now.year}-$sm-$sd 9:59:59');
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
  }
}