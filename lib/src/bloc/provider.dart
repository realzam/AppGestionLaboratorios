import 'package:flutter/material.dart';
import 'package:proyecto/src/bloc/login_bloc.dart';
export  'package:proyecto/src/bloc/login_bloc.dart';
class ProviderBloc extends InheritedWidget{
  
  static ProviderBloc _instancia;
  factory ProviderBloc({Key key, Widget child})
  {
    if(_instancia == null)
    {
      _instancia = new ProviderBloc._internal(key: key,child: child,);
    }
    return _instancia;
  }
 final loginBloc=LoginBloc();

ProviderBloc._internal({Key key, Widget child})
  :super(key:key,child:child);

 /* Provider({Key key, Widget child})
  :super(key:key,child:child);*/

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of ( BuildContext context ){
   return context.dependOnInheritedWidgetOfExactType<ProviderBloc>().loginBloc;
}

}