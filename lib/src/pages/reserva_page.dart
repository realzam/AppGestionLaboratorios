import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:proyecto/src/model/hora_model.dart';
import 'package:proyecto/src/model/laboratorio_model.dart';
import 'package:proyecto/src/widgets/boton_cool.dart';
import 'package:intl/intl.dart';

class ReservaPage extends StatefulWidget {
  @override
  _ReservaPageState createState() => _ReservaPageState();
}

class _ReservaPageState extends State<ReservaPage> {
Laboratorio lab;
List<Hora> listaDates=new List();



  Size tam;

  Color mainColor= Color.fromRGBO(1, 127, 255, 1.0);

  Color secondColor= Color.fromRGBO(0, 102, 151, 1.0);

  Color ed1=Color.fromRGBO(255, 221, 130, 1.0);

  Color ed2=Color.fromRGBO(63, 148,255, 1.0);

  Color ed3=Colors.white;

   String  _chosenValue;
  @override
  Widget build(BuildContext context) {
   
  lab = ModalRoute.of(context).settings.arguments;
   tam =MediaQuery.of(context).size;
   listaDates=new List();
    lab.horasLibres.forEach((element) { 
      listaDates.add(Hora(element));
    });
    if(_chosenValue==null)
     _chosenValue =DateFormat('kk:mm').format(listaDates[0].inicio);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          elevation: 0.0,
          leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ), 
        title: Text("Elegir computadora"),
      ),
        body:Stack(
          children: <Widget>[
          _fondo(),
          _contenido(),
          BotonCool()
          ],
        )
    );
  }

  Widget _fondo()
  {
    return Container(
      width: tam.width,
      height: tam.height,
      color: mainColor,
    );
  }

  Widget _contenido()
  {
    return SingleChildScrollView(
       
      child: Column(
        children: <Widget>[
          estados(),
          SizedBox(height: 20.0,),
          pizaron(),
          SizedBox(height: 20.0,),
          computadoras(),
          SizedBox(height: 10.0,),
          resumen()
        ],
      ),
    );
  }

  Widget resumen()
  {
    return Stack(
      children: <Widget>[
        
          Container(
            padding: EdgeInsets.all(20.0),
              height: tam.height*0.9,
              width: tam.width,
              decoration: BoxDecoration(
                  color:Colors.white,//Color.fromRGBO(7, 5, 76, 1.0),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0),topRight: Radius.circular(40.0) ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Icon(FontAwesomeIcons.mapMarkerAlt,color: Color.fromRGBO(7, 5, 76, 1.0)),
                      SizedBox(width: 5.0,),
                       Text('Laboratorio ${lab.idLaboratorio}',style: TextStyle(color: Color.fromRGBO(7, 5, 76, 1.0),fontWeight: FontWeight.bold,fontSize: 16.0),),
                       
                    ],
                  ),
                  SizedBox(height: 10.0,),
                  horaPick(),
                ],
              ),
            ),
       
      ],
    );
  }

List<DropdownMenuItem<String>> getOpcionesDropdown()
{
  List<DropdownMenuItem<String>> lista=new List();
  listaDates.forEach((element) { 
    var s=DateFormat('kk:mm').format(element.inicio);
    lista.add(DropdownMenuItem(
      child:Text(s),
      value: s,
    ));
  });
return lista;
}


Widget horaPick()
{
 

    return  Container(
      decoration: BoxDecoration(
                  color:Color.fromRGBO(232, 234, 250, 1.0),//Color.fromRGBO(7, 5, 76, 1.0),
                  borderRadius: BorderRadius.circular(15.0)
      ),
      height: 100.0,
      width: 95.0,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(width: 100.0,),
                 DropdownButton(
              value: _chosenValue,
              underline: Container(), 
              icon: Icon(Icons.arrow_downward,color: Colors.black,),
              iconSize: 20.0, // can be changed, default: 24.0
              iconEnabledColor: Colors.blue,
              items: getOpcionesDropdown(),
              onChanged: (value) {
                setState(() {
                  _chosenValue = value;

                });
              },
            ),
            Text('Hora',style: TextStyle(color: Color.fromRGBO(162, 162, 185, 1.0), fontWeight: FontWeight.bold,fontSize: 16.0),)
            ],
          ),
        ),
      );
}

Widget pizaron()
{
  return Center(
    child:Container(
      color: Colors.white,
      height: 12.0,
      width: 0.5*tam.width,
      child: Center(child: Text('pizarrón',style: TextStyle(color: Colors.black,fontSize: 12.0),))
    )
  );
}

Widget computadoras()
{
  List nums=[1,3,5,7];
  List nums2=[2,4,6,8];
  List nums3=[9,10,11,12,13,14,15,16,17];
  List nums4=[18,19,20,21,22,23,24,25,26];
  List nums5=[27,29,31,33];
  List nums6=[28,30,32,34];
 return Container(
      child:Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          columna1(nums),
          spaceRow1(),
          columna1(nums2),
          spaceRow1(),
          spaceRow1(),
          columna2(nums3),
          spaceRow1(),
          columna2(nums4),
          spaceRow1(),
          spaceRow1(),
          columna1(nums5),
          spaceRow1(),
          columna1(nums6),
        ]
      )
    );
}

 Widget spaceCol()
  {
    return  SizedBox(height: 0.01*tam.height);
  }

   Widget spaceRow1()
  {
    return  SizedBox(width: 0.025*tam.width);
  }

  Widget fakeCompu()
  {
      return Container
      (
        width: 0.08*tam.width,
        height: 0.08*tam.width,
        color: Colors.transparent,
      );
  }

  Widget columna1(List n)
  {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          parFakeCompu(),
          parFakeCompu(),
          parCompu(a:n[0]),
          parFakeCompu(),
          parCompu(a:n[1]),
          parFakeCompu(),
          parCompu(a:n[2]),
          parFakeCompu(),
          parCompu(a:n[3]),
          parFakeCompu(),
        ],
    );
  }

  Widget columna2(List n)
  {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          parCompu(a:n[0]),
          parCompu(a:n[1]),
          parCompu(a:n[2]),
          parCompu(a:n[3]),
          parFakeCompu(),
          parCompu(a:n[4]),
          parCompu(a:n[5]),
          parCompu(a:n[6]),
          parCompu(a:n[7]),
          parCompu(a:n[8]),
        ],
    );
  }

  Widget parCompu({a:1})
  {
    return Column(
      children: <Widget>[
        compu(id: a),
          spaceCol(),
      ],
    );
  } 

   Widget parFakeCompu()
  {
    return Column(
      children: <Widget>[
        fakeCompu(),
          spaceCol(),
      ],
    );
  }

  Widget compu({ed:3,id:0})
    {
      
      Color myestado;
      Color myborde=Colors.white;
      switch (ed){
        case 1:myestado=ed1;myborde=ed1;break;
        case 2:myestado=ed2;myborde=ed2;break;
        default:
        myestado=ed3;break;
      }
      return Container
      (
        width: 0.1*tam.width,
        height: 0.1*tam.width,
        decoration: BoxDecoration(
          color: myestado,
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(color:myborde),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
          ),
          child:GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: (){
              
            },
            child:  Center(
            child: Text(id.toString(),style: TextStyle(color: Colors.white),)
          ),
          ),
      );
    }

Widget estados()
{
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      estado1(),
      spaceCol(),
      estado2(),
      spaceCol(),
      estado3()
    ],
  );
}

  Widget estado1()
  {
    return Column(
      children: <Widget>[

       Container(
          width: 0.06*tam.width,
          height: 0.06*tam.width,
          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color:ed1
          ),
          
        ),
        SizedBox(height: 5.0,),
        Text('Seleccionado',style: TextStyle(color: Colors.white,fontSize: 14.0),)
      ],
    );
  }

Widget estado2()
  {
    return Column(
      children: <Widget>[

       Container(
          width: 0.06*tam.width,
          height: 0.06*tam.width,
          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color:ed2,
          border: Border.all(color:Colors.white),
          ),
          
        ),
        SizedBox(height: 5.0,),
       Text('No disponible',style: TextStyle(color: Colors.white,fontSize: 14.0),)
      ],
    );
  }

  Widget estado3()
  {
    return Column(
      children: <Widget>[

       Container(
          width: 0.06*tam.width,
          height: 0.06*tam.width,
          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color:ed3,
          border: Border.all(color:Colors.white),
          ),
          
        ),
        SizedBox(height: 5.0,),
       Text('Disponible',style: TextStyle(color: Colors.white,fontSize: 14.0),)
      ],
    );
  }
}



