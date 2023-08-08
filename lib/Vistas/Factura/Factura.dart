import 'package:auto/Servicios/conexion.dart';
import 'package:auto/Utilidades/carritoUtil.dart';
import 'package:auto/Utilidades/facturaUtil.dart';
import 'package:auto/Utilidades/sessionUtil.dart';
import 'package:auto/Vistas/BarraNavegacion/navigationBar.dart';
import 'package:flutter/material.dart';

class Factura extends StatefulWidget {
  const Factura({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FacturaState();
  }
}

class _FacturaState extends State<Factura> {
  List<Map<dynamic, dynamic>> _autosList = [];
  String Cliente = "";
  String identificacion = "";
  String direccion = "";
  String numeroFactura = "";
  String numeroTarjeta = "";
  String total = "";

  //Datos para la factura

  double subTotal = 0;
  double iva = 0.12;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
    _cargarAutos();
  }

  void _cargarDatos() async {

      conexion.obtener(facturaUtil.getCheckoutId().toString(), sessionUtil.getToken().toString(),"checkout").then((info){
        var infoAux = info.info;
        print("INFO AUX 1");
        print(infoAux);
        if(info.code != 200){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(info.msg),),);
        }else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(infoAux['resultDetails']['ExtendedDescription']),),);
          setState(() {
            numeroTarjeta = infoAux['card']['last4Digits'].toString();
            total = infoAux['amount'].toString();
          });
        }
      });
      conexion.obtener(sessionUtil.getIdentificacion().toString(), sessionUtil.getToken().toString(), "personas").then((info){
        print("INFO AUX 2");
        var infoAux = info.info;
        print(infoAux);
        if(info.code != 200){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(info.msg),),);
        }else{
          setState(() {
            Cliente = infoAux['nombres'] +" "+ infoAux['apellidos'];
            identificacion = infoAux['identificacion'];
            direccion = infoAux['direccion'];
          });
        }
      });
      conexion.obtener(facturaUtil.getExternal_Factura().toString(), sessionUtil.getToken().toString(), "facturas").then((info){
        print("INFO AUX 3");
        var infoAux = info.info;
        print(infoAux);
        if(info.code != 200){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(info.msg),),);
        }else{
          setState(() {
            numeroFactura = infoAux['numeroFactura'];
          });
        }
      });
  }

  void _cargarAutos() async{
    List<Map<dynamic, dynamic>> autos = await carritoUtil.getCarrito();
    setState(() {
      _autosList = autos;
    });
    _guardarDetalleFactura();
  }

  void _guardarDetalleFactura() {
    for (var auto in _autosList) {
      Map<dynamic, dynamic> data = {
        'external_Factura': facturaUtil.getExternal_Factura(),
        'external_Auto': auto['externalId'],
      };
      conexion.guardar(data, 'detalleFactura').then((info){
        if(info.code != 200){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(info.msg),),);
        }else{

        }
      });
    }
    carritoUtil.borrarCarrito();
    facturaUtil.borrarFactura();
  }

  void _onRegresarPressed(){
    carritoUtil.borrarCarrito();
    facturaUtil.borrarFactura();
    Navigator.pushNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalle Factura"),
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
          "No se ha cargado el detalle correctamente",
          style: TextStyle(fontSize: 10, color: Colors.white),
        )
            : Column(
          children: [
            // Mostrar información de la factura
            SizedBox(height: 20),
            Text(
              "Número de Factura: $numeroFactura",
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              "Cliente: $Cliente",
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              "Identificación: $identificacion",
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              "Tarjeta Termina: $numeroTarjeta",
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              "Dirección: $direccion",
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingTextStyle: TextStyle(fontSize: 10, color: Colors.white),
                dataTextStyle: TextStyle(fontSize: 10, color: Colors.white),
                columns: [
                  DataColumn(label: Text('Item')),
                  DataColumn(label: Text('Auto')),
                  DataColumn(label: Text('Precio')),
                ],
                rows: _autosList.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<dynamic, dynamic> auto = entry.value;
                  return DataRow(cells: [
                    DataCell(Text((index + 1).toString())),
                    DataCell(Text(auto['modelo'])),
                    DataCell(Text(auto['precio'].toString())),
                  ]);
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'IVA: ${iva.toStringAsFixed(2)}%',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Total: $total USD',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _onRegresarPressed,
              child: Text(
                'Regresar',
                style: TextStyle(fontSize: 16),
              ),
            ),
            ],
        ),
      ),
    );
  }
}
