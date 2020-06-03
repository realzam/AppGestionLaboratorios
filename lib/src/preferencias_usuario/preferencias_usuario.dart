import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {
  static final PreferenciasUsuario _instancia =
      new PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  void clear() {
    _prefs.clear();
  }

  // GET y SET del nombre
  get token {
    return _prefs.getString('token') ?? '';
  }

  set token(String value) {
    _prefs.setString('token', value);
  }

  get recordarme {
    return _prefs.getBool('recordarme') ?? false;
  }

  set recordarme(bool value) {
    _prefs.setBool('recordarme', value);
  }

  // GET y SET de la última página
  get pagina {
    return _prefs.getString('pagina') ?? 'ingreso';
  }

  set pagina(String value) {
    _prefs.setString('pagina', value);
  }

  get paginaActual {
    return _prefs.getString('paginaActual') ?? '';
  }

  set paginaActual(String value) {
    print('================== pgina actual ============');
    print(value);
    _prefs.setString('paginaActual', value);
  }

  get numUser {
    return _prefs.getString('numUser') ?? '';
  }

  set numUser(String value) {
    _prefs.setString('numUser', value);
  }

  get ultimaPagina {
    return _prefs.getString('ultimaPagina') ?? '';
  }

  set ultimaPagina(String value) {
    _prefs.setString('ultimaPagina', value);
  }

  get formatHora {
    return _prefs.getBool('formatHora') ?? false;
  }

  set formatHora(bool value) {
    _prefs.setBool('formatHora', value);
  }
}
