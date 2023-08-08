import 'package:auto/Utilidades/carritoUtil.dart';
import 'package:auto/Utilidades/facturaUtil.dart';
import 'package:auto/Utilidades/sessionUtil.dart';
import 'package:flutter/material.dart';
import 'package:auto/Vistas/sessionView.dart';

class navigationBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    void _onHomePressed(){
      Navigator.pushNamed(context, '/home');
    }
    void _onAutosPressed(){
      Navigator.pushNamed(context, '/autos');
    }
    void _onCarritoPressed(){
      Navigator.pushNamed(context, '/carrito');
    }
    void _onOpcionesPressed(){
      Navigator.pushNamed(context, '/opciones');
    }

    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: _onHomePressed,
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              textStyle: MaterialStateProperty.all<TextStyle>(
                const TextStyle(fontSize: 16.0),
              ),
            ),
            child: const Text('Home'),
          ),
          TextButton(
            onPressed: _onAutosPressed,
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              textStyle: MaterialStateProperty.all<TextStyle>(
                const TextStyle(fontSize: 16.0),
              ),
            ),
            child: const Text('Autos'),
          ),
          TextButton(
            onPressed: _onCarritoPressed,
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              textStyle: MaterialStateProperty.all<TextStyle>(
                const TextStyle(fontSize: 16.0),
              ),
            ),
            child: const Text('Carrito'),
          ),
          TextButton(
            onPressed: _onOpcionesPressed,
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              textStyle: MaterialStateProperty.all<TextStyle>(
                const TextStyle(fontSize: 16.0),
              ),
            ),
            child: const Text('Opciones'),
          ),
        ],
      ),
    );
  }
}
