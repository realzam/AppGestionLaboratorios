import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BotonCool extends StatelessWidget {
 

  @override
  Widget build(BuildContext context) {
    Size tam =MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Positioned(
          bottom: 0.0,
          right: 0.0,
          child: Container(
            child:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Reservar',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16.0),),
                SizedBox(width: 5.0,),
                Icon(FontAwesomeIcons.arrowRight,color: Colors.white,)
              ],
            ),
            width:tam.width*0.45,
            height: 60.0,
            decoration: BoxDecoration(
              color: Color.fromRGBO(13, 8, 70, 1.0),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0)),
            ),
          ),
        )
      ],
    );
  }
}