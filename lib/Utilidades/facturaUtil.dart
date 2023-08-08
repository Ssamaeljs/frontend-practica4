import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class facturaUtil {
  static final Box _boxFactura = Hive.box("factura");

  static Future<void> saveExternal_Factura(String externalFactura) async {
    await _boxFactura.put("external_Factura", externalFactura);
  }
  static Future<void> saveCheckoutId(String checkoutId) async{
    await _boxFactura.put("checkoutId", checkoutId);
  }

  static String? getExternal_Factura() {
    return _boxFactura.get("external_Factura");
  }
  static String? getCheckoutId() {
    return _boxFactura.get("checkoutId");
  }


  static Future<void> borrarFactura() async{
    await _boxFactura.clear();
  }

}
