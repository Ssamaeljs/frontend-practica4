import 'package:auto/Utilidades/carritoUtil.dart';
import 'package:auto/Utilidades/facturaUtil.dart';
import 'package:auto/Utilidades/sessionUtil.dart';
import 'package:flutter/material.dart';

class opcionesView extends StatefulWidget {
  const opcionesView({
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _opcionesViewState();
  }
}

class _opcionesViewState extends State<opcionesView> {

  void _onEditarPerfilPressed(){
    Navigator.pushNamed(context, '/editarPerfil');
  }

  void _onCerrarSesionPressed(){
    sessionUtil.borrarSesion();
    carritoUtil.borrarCarrito();
    facturaUtil.borrarFactura();
    Navigator.pushNamed(context, '/session');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hasta la Proxima"),),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("opcionesView"),
      ),
      body: Center(
        child: Column( // Use Column to stack widgets vertically
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _onEditarPerfilPressed,
              child: Text(
                'Editar Perfil',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 16), // Add some spacing between the buttons
            ElevatedButton(
              onPressed: _onCerrarSesionPressed, // Assign the function to the onPressed event
              child: Text(
                'Cerrar Sesión',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
