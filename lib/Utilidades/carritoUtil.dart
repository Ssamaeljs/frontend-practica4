import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class carritoUtil {
  static Box<List<Map<dynamic, dynamic>>> _boxCarrito = Hive.box("carrito");
  static Future<String> saveItem(Map<dynamic, dynamic> auto) async {
    List<Map<dynamic, dynamic>> carritoList = _boxCarrito.get("carrito") ?? [];

    // Verificar si el auto ya existe en la lista
    bool autoExists = carritoList.any((item) {
      return item['externalId'] == auto['externalId'];
    });

    if (!autoExists) {
      carritoList.add(auto);
      await _boxCarrito.put("carrito", carritoList);
      return "Auto Añadido al carrito";
    }else{
      return "No puede añadirse el mismo auto al carrito";
    }
  }

  static Future<String> removeItem(Map<dynamic, dynamic> auto) async {
    List<Map<dynamic, dynamic>> carritoList = _boxCarrito.get("carrito") ?? [];
    // Buscar el índice del item a eliminar
    int index = carritoList.indexWhere((item) =>
      item['externalId'] == auto['externalId']
    );

    // Si se encontró el índice, remover el item de la lista
    if (index >= 0) {
      carritoList.removeAt(index);
      await _boxCarrito.put("carrito", carritoList);
      return "Se quitó el auto";
    }else{
      return "";
    }
  }
  static Future<List<Map<dynamic, dynamic>>> getCarrito() async {
    List<Map<dynamic, dynamic>> carritoList = _boxCarrito.get("carrito") ?? [];
    return carritoList;
  }

  static Future<void> borrarCarrito() async {
    await _boxCarrito.clear();
  }

}

