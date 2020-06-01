class MyTile {
  String title;
  List<MyTile> children;
  String inicio;
  String fin;
  String clase;
  String key;
  MyTile(this.title, [this.key,this.children = const <MyTile>[],this.inicio,this.fin,this.clase]);
}