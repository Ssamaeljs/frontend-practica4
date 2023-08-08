import 'dart:convert';
import 'dart:developer';
import 'package:auto/Modelo/RespuestaGenerica.dart';
import 'package:http/http.dart' as http;

class conexion {
  static const String urlB = "192.168.100.98";

  static const String url = "http://"+urlB+":3006/api";

  static Future<RespuestaGenerica> inicioSesion(Map<dynamic, dynamic> data) async {
    final headers = {
      "Accept": 'application/json',
      "Content-Type": 'application/json'
    };

    final response = await http.post(Uri.parse(url + "/login"),
        headers: headers,
        body: jsonEncode(data)
    );
    final responseData = jsonDecode(response.body);
      return RespuestaGenerica(
        code: responseData['code'],
        msg: responseData['msg'],
        info: responseData['info'],
      );
  }

  static Future<RespuestaGenerica> listar(String key, String obj) async {
    final headers = {
      "Content-Type": "application/json",
      "X-API-TOKEN": key
    };

    final response = await http.get(Uri.parse(url + "/$obj/listar"), headers: headers);
    final responseData = jsonDecode(response.body);
      return RespuestaGenerica(
        code: responseData['code'],
        msg: responseData['msg'],
        info: responseData['info'],
      );
  }

  static Future<RespuestaGenerica> obtener(String id, String key,String obj) async {
    final headers = {
      "Content-Type": "application/json",
      "X-API-TOKEN": key
    };

    final response = await http.get(Uri.parse('${url}/$obj/obtener/$id'),
        headers: headers
    );

    final responseData = jsonDecode(response.body);
    return RespuestaGenerica(
      code: responseData['code'],
      msg: responseData['msg'],
      info: responseData['info'],
    );
  }

  static Future<RespuestaGenerica> guardar(dynamic data, String obj) async {
    final headers = {
      "Content-Type": "application/json",
      //"X-API-TOKEN": key
    };

    final response = await http.post(Uri.parse(url + "/$obj/guardar"),
        headers: headers,
        body: jsonEncode(data)
    );
    final responseData = jsonDecode(response.body);
    return RespuestaGenerica(
      code: responseData['code'],
      msg: responseData['msg'],
      info: responseData['info'],
    );

  }

  static Future<RespuestaGenerica> actualizar(dynamic data, String key, String obj) async {
    final headers = {
      "Content-Type": "application/json",
      "X-API-TOKEN": key
    };

    final response = await http.put(Uri.parse(url + "/$obj/actualizar"),
        headers: headers,
        body: jsonEncode(data)
    );
    final responseData = jsonDecode(response.body);
    return RespuestaGenerica(
      code: responseData['code'],
      msg: responseData['msg'],
      info: responseData['info'],
    );
  }

}
