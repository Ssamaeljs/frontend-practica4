import 'dart:developer';

import 'package:auto/Servicios/conexion.dart';
import 'package:auto/Utilidades/carritoUtil.dart';
import 'package:auto/Utilidades/facturaUtil.dart';
import 'package:auto/Utilidades/sessionUtil.dart';
import 'package:auto/Vistas/home.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:validators/validators.dart';

class SessionView extends StatefulWidget {
  const SessionView({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SessionViewState();
  }
}

class _SessionViewState extends State<SessionView> {

  final FocusNode _focusNodePassword = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _cuentaController = TextEditingController();
  final TextEditingController _claveController = TextEditingController();
  final Box _boxLogin = Hive.box("login");
  bool _obscurePassword = true;
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sessionUtil.borrarSesion();
    carritoUtil.borrarCarrito();
    facturaUtil.borrarFactura();
  }
  void _iniciarSesion(){
    setState(() {
      if (_formKey.currentState!.validate()) {
        Map <dynamic, dynamic> data = {
          "correo": _cuentaController.text,
          "clave": _claveController.text,
        };
        conexion.inicioSesion(data).then((info) {
          var infoAux = info.info;
          if(info.code != 200){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(info.msg),),);
          }else{
            _boxLogin.put("userName", ""+infoAux['user']['nombres']+" "+infoAux['user']['apellidos']);
            sessionUtil.saveToken(infoAux['token']);
            sessionUtil.saveIdentificacion(infoAux['user']['identificacion']);
            Navigator.pushNamed(context, '/home');
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(info.msg),),);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .primaryContainer,
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                const SizedBox(height: 150),
                Text(
                  "Adrián's Car",
                  style: Theme
                      .of(context)
                      .textTheme
                      .headlineLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  "Entra con tu cuenta",
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium,
                ),
                const SizedBox(height: 60),
                TextFormField(
                  controller: _cuentaController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: "Correo",
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onEditingComplete: () => _focusNodePassword.requestFocus(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Porfavor ingrese un correo";
                    }
                    if (!isEmail(value)) {
                      return "Debe ser un correo válido";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _claveController,
                  focusNode: _focusNodePassword,
                  obscureText: _obscurePassword,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    labelText: "Clave",
                    prefixIcon: const Icon(Icons.password_outlined),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        icon: _obscurePassword
                            ? const Icon(Icons.visibility_outlined)
                            : const Icon(Icons.visibility_off_outlined)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Porfavor ingrese una clave";
                    }
                  },
                ),
                const SizedBox(height: 60),
                Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: _iniciarSesion,
                      child: const Text("Sesion"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

  @override
  void dispose() {
    _focusNodePassword.dispose();
    _cuentaController.dispose();
    _claveController.dispose();
    super.dispose();
  }
}
