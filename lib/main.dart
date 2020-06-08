import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/src/bloc/provider.dart';
import 'package:proyecto/src/pages/booking_page.dart';
import 'package:proyecto/src/pages/forgot_password_page.dart';
import 'package:proyecto/src/pages/home_page.dart';
import 'package:proyecto/src/pages/home2_page.dart';
import 'package:proyecto/src/pages/laboratorios_page.dart';
import 'package:proyecto/src/pages/push_notification_page.dart';
import 'package:proyecto/src/pages/recuperar_password_page.dart';
import 'package:proyecto/src/pages/redirect_page.dart';
import 'package:proyecto/src/pages/registro_salida_page.dart';
import 'package:proyecto/src/pages/reserva_page.dart';
import 'package:proyecto/src/pages/ingreso_page.dart';
import 'package:proyecto/src/pages/registro_page.dart';
import 'package:proyecto/src/pages/fast_ingreso_page.dart';
import 'package:proyecto/src/pages/mensaje_page.dart';
import 'package:proyecto/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:proyecto/src/providers/agregarUsuarioInfo.dart';
import 'package:proyecto/src/providers/horarioInfo.dart';
import 'package:proyecto/src/providers/laboratoriosInfo.dart';
import 'package:proyecto/src/providers/push_notification_provider.dart';
import 'package:proyecto/src/providers/recoveryInfo.dart';
import 'package:proyecto/src/providers/uniLinksInfo.dart';
import 'package:proyecto/src/providers/webSocketInformation.dart';
import 'package:uni_links/uni_links.dart';

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
  bool start = true;
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  final prefs = new PreferenciasUsuario();
  @override
  void initState() {
    super.initState();
    final pushPriovider = new PushNotificationProvider();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<int> _asyncMethod() async {
    print('init tiemr');
    await new Future.delayed(const Duration(milliseconds: 3000));
    print('fin tmier');
    return 1;
  }

  void redirectTo() {
    print('redirecTO');
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => new RecuperarPasswordPage()));
  }

  Future<String> initUniLinks() async {
    try {
      Uri initialUri = await getInitialUri();
      if (initialUri != null &&
          initialUri.toString() != '' &&
          initialUri.toString() != null) {
        if (initialUri.queryParameters['token'] != null &&
            initialUri.queryParameters['token'] != '')
          return initialUri.queryParameters['token'];
      }
      return '';
    } on FormatException {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    print('init build');
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WebSocketInfo()),
        ChangeNotifierProvider(create: (_) => LaboratoriosInfo()),
        ChangeNotifierProvider(create: (_) => HorarioInfo()),
        ChangeNotifierProvider(create: (_) => AgregarUsuarioInfo()),
        ChangeNotifierProvider(create: (_) => RecoveryInfo()),
        ChangeNotifierProvider(create: (_) => UniLiksInfo())
      ],
      child: ProviderBloc(
          child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        title: 'control ESCOM',
        initialRoute: 'ingreso',
        routes: {
          'ingreso': (BuildContext context) => IngresoPage(),
          'recuperar': (BuildContext context) => RecuperarPasswordPage(),
          'fast': (BuildContext context) => FastLoginPage(),
          'registro': (BuildContext context) => RegistroPage(),
          'home': (BuildContext context) => HomePage(),
          'reservar': (BuildContext context) => ReservaPage(),
          'push': (BuildContext context) => PushNotificationPage(),
          'mensaje': (BuildContext context) => MensajePage(),
          'laboratorios': (BuildContext context) => LaboratoriosPage(),
          'booking': (BuildContext context) => BookingPage(),
          'reservacion': (BuildContext context) => RegistrarSalidaPage(),
          'home2': (BuildContext context) => HomePageAdministrador(),
          'forgot': (BuildContext context) => ForgotPasswordPage(),
          'redirect': (BuildContext context) => RedirectPage(),
        },
        theme: ThemeData(primaryColor: Colors.deepPurple),
      )),
    );
  }
}
