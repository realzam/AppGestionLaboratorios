import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationProvider{

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _mensajeStreamController=StreamController<String>.broadcast();
  Stream<String> get mensaje =>_mensajeStreamController.stream;

  initNotifications()
  {
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.getToken().then((token)  {
      print('========== FCM Token===========');
      print(token);
      print(token.length);
    });



     _firebaseMessaging.configure(
       onMessage: (info) async{
         print('============= on Message =======');
         print(info);
       
         String argumento='no-data';
         if(Platform.isAndroid)
         {
           argumento=info['data']['info']??'no-data';
          _mensajeStreamController.sink.add(argumento);
         }
       },
       onLaunch: (info) async{
         print('============= on Launch =======');
         print(info);
           final noti=info['data']['info'];
         print(noti);
          String argumento='no-data';
         if(Platform.isAndroid)
         {
           argumento=info['data']['info']??'no-data';
          _mensajeStreamController.sink.add(argumento);
         }
        
       },
       onResume: (info) async{
         print('============= on Resume =======');
         print(info);
          final noti=info['data']['info'];
         print(noti);
          String argumento='no-data';
         if(Platform.isAndroid)
         {
           argumento=info['data']['info']??'no-data';
          _mensajeStreamController.sink.add(argumento);
         }
       }
     );

  }

  dispose() { 
    _mensajeStreamController?.close();
  }
}


//czQBegL_VbA:APA91bHibgrYb2R0MF9473Sv8p80kS8I3qRusoygPyKrGwhAtn86FVydFraZs0g-Jo8J2WeSQHXa-Z2fDAYmMEnBesfLW0YnKgelIez4MbkcZBJ54aN0tW4ovI0tGQEA1KjFHrbJiS5g