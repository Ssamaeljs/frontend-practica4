

import 'package:auto/Utilidades/sessionUtil.dart';
import 'package:auto/Vistas/Autos/listarAutos.dart';
import 'package:auto/Vistas/BarraNavegacion/opcionesView.dart';
import 'package:auto/Vistas/Exception/page404.dart';
import 'package:auto/Vistas/Factura/Carrito.dart';
import 'package:auto/Vistas/Factura/CreditCard.dart';
import 'package:auto/Vistas/Factura/Factura.dart';
import 'package:auto/Vistas/Factura/creditCardView.dart';
import 'package:auto/Vistas/Perfil/editarPerfil.dart';
import 'package:auto/Vistas/home.dart';
import 'package:flutter/material.dart';

import 'Vistas/sessionView.dart';

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(32, 63, 129, 1.0),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const SessionView(),
      initialRoute: '/session',
      onGenerateRoute: (settings) {
        if (settings.name == '/session') {
          // Si la ruta es '/session', siempre permitir el acceso
          return MaterialPageRoute(builder: (context) => const SessionView());
        } else {
          var autenticado = sessionUtil.estaSesion();
          print(autenticado);
          if (autenticado) {
            // Si está autenticado, permitir el acceso a las demás rutas
            return _buildRoute(settings);
          } else {
            // Si no está autenticado, redirigir a la página de inicio de sesión
            return MaterialPageRoute(builder: (context) => const SessionView());
          }
        }
      },
    );
  }

  // Método para construir la ruta según el nombre de la ruta
  Route _buildRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(builder: (context) => const Home());
      case '/autos':
        return MaterialPageRoute(builder: (context) => const ListarAutos());
      case '/carrito':
        return MaterialPageRoute(builder: (context) => const Carrito());
      case '/creditCard':
        return MaterialPageRoute(builder: (context) => const creditCardView());

      case '/factura':
        return MaterialPageRoute(builder: (context) => const Factura());
      case '/opciones':
        return MaterialPageRoute(builder: (context) => const opcionesView());
      case '/editarPerfil':
        return MaterialPageRoute(builder: (context) => const editarPerfil());
        default:
      // Si la ruta no se encuentra, muestra la página 404
        return MaterialPageRoute(builder: (context) => Page404());
    }
  }
}



