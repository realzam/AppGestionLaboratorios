import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/src/bloc/provider.dart';
import 'package:proyecto/src/pages/booking_page.dart';
import 'package:proyecto/src/pages/home_page.dart';
import 'package:proyecto/src/pages/laboratorios_page.dart';
import 'package:proyecto/src/pages/push_notification_page.dart';
import 'package:proyecto/src/pages/registro_salida_page.dart';
import 'package:proyecto/src/pages/reserva_page.dart';
import 'package:proyecto/src/pages/ingreso_page.dart';
import 'package:proyecto/src/pages/registro_page.dart';
import 'package:proyecto/src/pages/fast_ingreso_page.dart';
import 'package:proyecto/src/pages/mensaje_page.dart';
import 'package:proyecto/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:proyecto/src/providers/horarioInfo.dart';
import 'package:proyecto/src/providers/laboratoriosInfo.dart';
import 'package:proyecto/src/providers/push_notification_provider.dart';
import 'package:proyecto/src/providers/webSocketInformation.dart';

void main() async {
  print('hola desde main');
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  if (prefs.recordarme && prefs.numUser != "") {
    prefs.pagina = 'fast';
  } else {
    prefs.pagina = 'ingreso';
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
    super.initState();
    final pushPriovider = new PushNotificationProvider();
   pushPriovider.initNotifications();
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WebSocketInfo()),
        ChangeNotifierProvider(create: (_) => LaboratoriosInfo()),
        ChangeNotifierProvider(create: (_) => HorarioInfo()),
      ],
      child: ProviderBloc(
          child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        title: 'control ESCOM',
        initialRoute: prefs.pagina,
        routes: {
          'ingreso': (BuildContext context) => IngresoPage(),
          'fast': (BuildContext context) => FastLoginPage(),
          'registro': (BuildContext context) => RegistroPage(),
          'home': (BuildContext context) => HomePage(),//'home': (BuildContext context) => MyHomePage(),
          'reservar': (BuildContext context) => ReservaPage(),
          'push': (BuildContext context) => PushNotificationPage(),
          'mensaje': (BuildContext context) => MensajePage(),
          'laboratorios': (BuildContext context) => LaboratoriosPage(),
          'booking': (BuildContext context) => BookingPage(),
          'reservacion': (BuildContext context) => RegistrarSalidaPage(),
        },
        theme: ThemeData(primaryColor: Colors.deepPurple),
      )),
    );
  }
}
