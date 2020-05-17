import 'package:flutter/material.dart';
import 'package:proyecto/src/bloc/provider.dart';
import 'package:proyecto/src/providers/usuario_provider.dart';
import 'package:proyecto/src/utils/utils.dart';

class RegistroPage extends StatefulWidget {

  @override
  _RegistroPageState createState(
    
  ) => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
Color mainColor= Color.fromRGBO(1, 127, 255, 1.0);
Color secondColor= Color.fromRGBO(0, 102, 151, 1.0);

final usuarioProvider= new UsuarioProvider();
bool passwordVisible=false;
bool passwordVisible2=false;

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(

      body: Stack(
        children: <Widget>[
          _crearFondo(context),
          _loginForm(context),
        ],
      )
    );
  }

Widget _loginForm(BuildContext context)
{
  final bloc=ProviderBloc.of(context);

  final size =MediaQuery.of(context).size;
  return SingleChildScrollView(
    child: Column(
      children: <Widget>[
        SafeArea(
          child: Container(
            height: 180.0,
          )
        ),
        Container(
          width:size.width*0.85 ,
          padding: EdgeInsets.symmetric(vertical: 50.0),
          margin: EdgeInsets.symmetric(vertical: 30.0),
          decoration: BoxDecoration(
            color:Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black26,
                blurRadius: 3.0,
                offset: Offset(0.0,5.0),
                spreadRadius: 3.0
              )
            ]
                     
          ),
          child: Column(
            children: <Widget>[
              Text("Crear cuenta",style: TextStyle(fontSize: 20.0),),
              SizedBox(height: 60.0,),
              _crearNumeroUsuario(bloc),
              SizedBox(height: 30.0,),
              _crearEmail(bloc),
              SizedBox(height: 30.0,),
              _crearPassword(bloc),
              SizedBox(height: 30.0,),
              _crearConfirmarPassword(bloc),
              SizedBox(height: 30.0,),
              _crearBoton(bloc),
            ],
          ),
        ),
        FlatButton(
          child: Text('¿Ya tienes un cuenta? Ingresar'),
          onPressed: ()=>Navigator.pushReplacementNamed(context, 'ingreso'),
          ),
      ],
    ),
  );
}

Widget _crearNumeroUsuario(LoginBloc bloc)
{
  return StreamBuilder(
    stream: bloc.numeroUsuarioStream,
    builder: (BuildContext context,AsyncSnapshot snapshot){
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                icon:Icon(Icons.accessibility, color: mainColor,),
               // hintText: '2016961245',
                labelText: 'No.Boleta/No.Empleado',
                errorText: snapshot.error
              ),
              onChanged: bloc.changeNumeroUsuario,
            ),
          );
      }
    );
}

Widget _crearPassword(LoginBloc bloc)
{
  return StreamBuilder(
    stream: bloc.passwordStream ,
    builder: (BuildContext context, AsyncSnapshot snapshot){
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: TextField(
          
          obscureText: !passwordVisible,
          
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon( passwordVisible ?Icons.visibility :Icons.visibility_off),
              onPressed: (){
                
                setState(() {
                 passwordVisible=!passwordVisible;
                });
              }
              ),
            icon:Icon(Icons.lock_open, color: mainColor,),
            labelText: 'Contraseña',
            errorText: snapshot.error,
          ),
          onChanged: bloc.changePassword,
        ),
      );
    },
  );  
}

Widget _crearConfirmarPassword(LoginBloc bloc)
{
  return StreamBuilder(
    stream: bloc.passwordConfirmStream ,
    builder: (BuildContext context, AsyncSnapshot snapshot){
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: TextField(
          
          obscureText: !passwordVisible2,
          decoration: InputDecoration(
             suffixIcon: IconButton(
              icon: Icon( passwordVisible2 ?Icons.visibility :Icons.visibility_off),
              onPressed: (){
                
                setState(() {
                 passwordVisible2=!passwordVisible2;
                });
              }
              ),
            icon:Icon(Icons.lock_open, color:mainColor,),
            labelText: 'Confirmar contraseña',
            errorText: snapshot.error,
          ),
          onChanged: bloc.changePasswordConfirm,
        ),
      );
    },
  );  
}

Widget _crearEmail(LoginBloc bloc)
{
  return StreamBuilder(
    stream: bloc.emailStream,
    builder: (BuildContext context,AsyncSnapshot snapshot){
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                icon:Icon(Icons.alternate_email, color: mainColor,),
                hintText: 'ejemplo@gmail.com',
                labelText: 'Correo electrónico',
                errorText: snapshot.error
              ),
              onChanged: bloc.changeEmail,
            ),
          );
      }
    );
}

Widget _crearBoton(LoginBloc bloc)
{
  return StreamBuilder(
    stream: bloc.formValidStream ,

    builder: (BuildContext context, AsyncSnapshot snapshot){
      return RaisedButton(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 80.0,vertical: 15.0),
          child:Text("ingresar")
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)
        ),
        elevation: 0.0,
        color:mainColor,
        textColor: Colors.white,
        onPressed: snapshot.hasData?()=>_register(context,bloc):null

        ,
      );
    },
  );
}

_register(BuildContext context,LoginBloc bloc)async{
  final ConfirmAction action = await asyncConfirmDialog(context,'Confirmar registro');  
  print('accion $action');
 
  if(action==ConfirmAction.Accept)
  {
    if(bloc.password!=bloc.confirmPassword)
    {
      mostrarAlerta(context,'las contraseñas son diferentes');
    }else{
       final info= await usuarioProvider.nuevoUsuario(bloc.numeroUsuario,bloc.email, bloc.password);
        if(info['ok'] )
      {
      Navigator.pushReplacementNamed(context, 'home');

      }else
      {
        mostrarAlerta(context,info['mensaje']);
      }
  }

  }
  
}

Widget _crearFondo(BuildContext context)
{
  final size =MediaQuery.of(context).size;
  final fondoMoroado=  Container(
    height: size.height *0.5,
    width: double.infinity,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: <Color>[
          mainColor,
          Color.fromRGBO(1, 92, 190, 1.0)
        ]
        ),

    ),
  );
  final circulo=Container(
    width: 100.0,
    height: 100.0,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(100.0),
      color:Color.fromRGBO(255, 255, 255, 0.25)
    ),
  );
  return Stack(
    children: <Widget>[
      fondoMoroado,
      Positioned(top: 90.0,left: 30.0,child: circulo,),
      Positioned(top: -40.0,left: -30.0,child: circulo,),
      Positioned(top: -40.0,right: -80.0,child: circulo,),
      Positioned(top: 250.0,right: 20.0,child: circulo,),
      Positioned(bottom: -50.0,left: -20.0,child: circulo,),
      Container(
        padding: EdgeInsets.only(top:size.height *0.1,),
        child: Column(

          children: <Widget>[
            Icon(Icons.person_pin_circle, color:Colors.white,size:100.0),
            SizedBox(height: 10.0,width: double.infinity,),
            Text('control com', style: TextStyle(color:Colors.white, fontSize: 25.0),)
          ],
        ),
      )
    ],
  );
}
}