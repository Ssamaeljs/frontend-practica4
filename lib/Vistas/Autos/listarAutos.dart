import 'dart:developer';

import 'package:auto/Servicios/conexion.dart';
import 'package:auto/Utilidades/carritoUtil.dart';
import 'package:auto/Utilidades/sessionUtil.dart';
import 'package:flutter/material.dart';
import '../BarraNavegacion/navigationBar.dart';

class ListarAutos extends StatefulWidget {
  const ListarAutos({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ListarAutosState();
  }
}

class _ListarAutosState extends State<ListarAutos> {

  bool _autosLoaded = false;
  List<dynamic> _autosList = [];
  String url = "192.168.100.98";
  @override
  void initState() {
    super.initState();
    _cargarAutos();
  }

  void _cargarAutos() {
    if (!_autosLoaded) {
      conexion.listar(sessionUtil.getToken().toString(), 'autos').then((info) {
        var autoAux = info.info;
        if (info.code != 200) {
          sessionUtil.borrarSesion();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(info.msg),),);
          Navigator.pushNamed(context, '/home');
        } else {
          log(info.msg);
          setState(() {
            _autosList = autoAux;
            _autosLoaded = true;
          });
        }
      });
    }
  }

  void _agregarItem(Map<dynamic, dynamic> auto) async {
    String msg = await carritoUtil.saveItem(auto) as String;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg),),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Autos"),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _autosList.length,
                itemBuilder: (context, index) {
                  var auto = _autosList[index];
                  bool isDisponible = auto['estado'] ?? true;
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          "http://"+url+":3006/images/" + auto['image'],
                        ),
                        radius: 20,
                      ),
                      title: Text(auto['modelo']),
                      subtitle: Text(auto['precio'].toString()),
                      trailing: isDisponible
                          ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                            Icon(Icons.shopping_cart),
                            SizedBox(width: 4),
                            TextButton(
                              onPressed: () => _agregarItem(auto),
                              child: Text('Añadir'),
                            ),
                           ],
                          )
                          : Text(
                            'NO DISPONIBLE',
                            style: TextStyle(color: Colors.red), // You can customize the text style
                          ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: navigationBar()
    );
  }
}
