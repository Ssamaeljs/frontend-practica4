import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class sessionUtil {
  static final Box _boxLogin = Hive.box("login");

  static Future<void> saveToken(String token) async {
    await _boxLogin.put("token", token);
  }

  static Future<void> saveIdentificacion(String identificacion) async {
    await _boxLogin.put("identificacion", identificacion);
  }

  static String? getToken() {
    return _boxLogin.get("token");
  }

  static String? getIdentificacion() {
    return _boxLogin.get("identificacion");
  }

  static Future<void> borrarSesion() async{
    await _boxLogin.clear();
  }

  static bool estaSesion() {
    String? token = _boxLogin.get("token");
    return token != null && token.isNotEmpty;
  }
}
