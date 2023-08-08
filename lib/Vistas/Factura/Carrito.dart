import 'package:auto/Servicios/conexion.dart';
import 'package:auto/Utilidades/carritoUtil.dart';
import 'package:auto/Utilidades/facturaUtil.dart';
import 'package:auto/Utilidades/sessionUtil.dart';
import 'package:auto/Vistas/Factura/pagoView.dart';
import 'package:flutter/material.dart';
import '../BarraNavegacion/navigationBar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Carrito extends StatefulWidget {
  const Carrito({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CarritoState();
  }
}

class _CarritoState extends State<Carrito> {
  List<Map<dynamic, dynamic>> _autosList = [];

  double subTotal = 0;
  double iva = 0.12;
  double total = 0;

  @override
  void initState() {
    super.initState();
    _cargarAutos();
  }

  void _cargarAutos() async{
    List<Map<dynamic, dynamic>> autos = await carritoUtil.getCarrito();
    setState(() {
      _autosList = autos;
      _calcularTotales();
    });
  }

  void _calcularTotales() {
    double subtotal = 0;
    for (var auto in _autosList) {
      subtotal += auto['precio'];
    }

    double totalAmount = subtotal * iva;

    setState(() {
      subTotal = subtotal;
      total = totalAmount;
    });
  }

  void _quitarAuto(Map<dynamic, dynamic> auto) async {
    String msg = await carritoUtil.removeItem(auto);
    _cargarAutos();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );
  }

  void _onPagarPressed(){

    Map<dynamic, dynamic> data = {
      'amount': total,
      'currency':'USD',
      'paymentType':'DB'
    };
    conexion.guardar(data, "checkout").then((info) {
      var infoAux = info.info;
      if(info.code != 200){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(info.msg),),);
      }else{
        print(infoAux);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(info.msg),),);
        facturaUtil.saveCheckoutId(infoAux['result']['id']);
        Navigator.pushNamed(context, '/creditCard');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Carrito"),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white),
              ),
            ),
          )
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: _autosList.isEmpty
            ? Text(
          "Aún no se ha añadido nada al carrito",
          style: TextStyle(fontSize: 10, color: Colors.white),
        )
            : Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingTextStyle: TextStyle(fontSize: 10, color: Colors.white),
                dataTextStyle: TextStyle(fontSize: 10, color: Colors.white),
                columns: [
                  DataColumn(label: Text('Item')),
                  DataColumn(label: Text('Auto')),
                  DataColumn(label: Text('Precio')),
                  DataColumn(label: Text('Acciones')),
                ],
                rows: _autosList.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<dynamic, dynamic> auto = entry.value;
                  return DataRow(cells: [
                    DataCell(Text((index + 1).toString())),
                    DataCell(Text(auto['modelo'])),
                    DataCell(Text(auto['precio'].toString())),
                    DataCell(
                      Row(
                        children: [
                          Icon(Icons.shopping_cart),
                          SizedBox(width: 4),
                          TextButton(
                            onPressed: () => _quitarAuto(auto),
                            child: Text(
                              'Quitar',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Subtotal: ${subTotal.toStringAsFixed(2)} USD',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
            SizedBox(width: 20),
            Text(
              'IVA: ${iva.toStringAsFixed(2)}%',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Total: ${total.toStringAsFixed(2)} USD',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _onPagarPressed,
              child: Text(
                'Pagar',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: navigationBar(),
    );
  }

}



