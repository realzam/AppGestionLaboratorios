
class Server {
    DateTime fecha;
    int horaID;
    int dia;

    Server({
        this.fecha,
        this.horaID,
        this.dia
    });

    Server.fromJson(Map<String, dynamic> json) {
        this.fecha   = DateTime.parse(json["fecha_servidor"]);
        this.horaID   = json["hora_id"];
        this.dia  = json["dia"];
    }
}