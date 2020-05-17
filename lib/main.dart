import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/src/bloc/provider.dart';
import 'package:proyecto/src/pages/home2_page.dart';
import 'package:proyecto/src/pages/laboratorios_page.dart';
import 'package:proyecto/src/pages/push_notification_page.dart';
import 'package:proyecto/src/pages/reserva_page.dart';
import 'package:proyecto/src/pages/ingreso_page.dart';
import 'package:proyecto/src/pages/producto_page.dart';
import 'package:proyecto/src/pages/registro_page.dart';
import 'package:proyecto/src/pages/fast_ingreso_page.dart';
import 'package:proyecto/src/pages/mensaje_page.dart';
import 'package:proyecto/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:proyecto/src/providers/laboratoriosInfo.dart';
import 'package:proyecto/src/providers/webInformacion.dart';
import 'package:proyecto/src/providers/push_notification_provider.dart';
import 'package:proyecto/src/providers/webSocketInformation.dart';

void main() async {
 WidgetsFlutterBinding.ensureInitialized();

 final storage = new FlutterSecureStorage();
 
    final prefs = new PreferenciasUsuario();
    await prefs.initPrefs();

    if(prefs.recordarme  && prefs.numUser!="")
    {
      prefs.pagina='fast';
    }else{
      prefs.pagina='ingreso';
    }
    

   
 runApp(MyApp());
  }
 
class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  final prefs = new PreferenciasUsuario();
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    final pushPriovider=new PushNotificationProvider();
    
    pushPriovider.initNotifications();

  }
  @override
  Widget build(BuildContext context) {

      return  MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WebSocketInfo()),
        ChangeNotifierProvider(create: (_) => LaboratoriosInfo()),
      ],
      child: ProviderBloc(
         child:MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        title: 'ESCOM',
        initialRoute:'laboratorios',//prefs.pagina,
        routes: {
          'ingreso': (BuildContext context) =>IngresoPage(),
          'fast': (BuildContext context) =>FastLoginPage(),
          'registro': (BuildContext context) =>RegistroPage(),
          'home': (BuildContext context) =>MyHomePage(),
          'producto': (BuildContext context) =>ProductoPage(),
          'reservar': (BuildContext context) =>ReservaPage(),
          'push': (BuildContext context) => PushNotificationPage(),
          'mensaje': (BuildContext context) => MensajePage(),
          'laboratorios':(BuildContext context)=>LaboratoriosPage()
        },
        theme: ThemeData(
          primaryColor: Colors.deepPurple
        ),
      )),
    );
  }
}