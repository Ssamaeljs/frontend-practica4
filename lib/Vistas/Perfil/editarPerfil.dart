import 'package:auto/Servicios/conexion.dart';
import 'package:auto/Utilidades/sessionUtil.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

class editarPerfil extends StatefulWidget {
  const editarPerfil({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _editarPerfilState();
  }
}

class _editarPerfilState extends State<editarPerfil> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _focusNodePassword = FocusNode();

  bool _obscurePassword = true;
  bool _perfilLoaded = false;

  TextEditingController _nombreController = TextEditingController();
  TextEditingController _apellidoController = TextEditingController();
  TextEditingController _direccionController = TextEditingController();
  TextEditingController _correoController = TextEditingController();
  TextEditingController _claveController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  void _cargarDatos(){
    String id = sessionUtil.getIdentificacion().toString();
    if(!_perfilLoaded){
      conexion.obtener(id, sessionUtil.getToken().toString(), "personas").then((info){
        var personaAux = info.info;
        if (info.code != 200) {
          sessionUtil.borrarSesion();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(info.msg),),);
          Navigator.pushNamed(context, '/home');
        } else {
          setState(() {
            _nombreController.text = personaAux['nombres'];
            _apellidoController.text = personaAux['apellidos'];
            _direccionController.text = personaAux['direccion'];
            _correoController.text = personaAux['cuenta']['correo'];
            _perfilLoaded = true;
          });
        }
      });
    }
  }

  void _ActualizarDatos(){
    setState(() {
      if (_formKey.currentState!.validate()) {
        Map <dynamic, dynamic> data = {
          "identificacion": sessionUtil.getIdentificacion().toString(),
          "nombres": _nombreController.text,
          "apellidos": _apellidoController.text,
          "direccion": _direccionController.text,
          "correo": _correoController.text,
        };

        String claveText = _claveController.text;
        if (claveText.trim().length >= 5) {
          data["clave"] = claveText;
        }

        conexion.actualizar(data, sessionUtil.getToken().toString(),"personas").then((info) {
          print(info.info);
          if(info.code != 200){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(info.msg),),);
          }else{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(info.msg),),);
            Navigator.pushNamed(context, '/home');
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: 'Ingresar nombres',
                  prefixIcon: const Icon(Icons.person_outline),
                ),
                //validator: _validateCardNumber,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _apellidoController,
                decoration: InputDecoration(
                  labelText: 'Ingresar apellidos',
                  prefixIcon: const Icon(Icons.person_outline),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _direccionController,
                decoration: InputDecoration(
                  labelText: "Ingresar Dirección",
                  prefixIcon: const Icon(Icons.streetview),
                ),
              ),
              TextFormField(
                controller: _correoController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: "Ingresar Correo",
                  prefixIcon: const Icon(Icons.email),
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
                  labelText: "Ingresar nueva Clave",
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
                ),
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
                    onPressed: _ActualizarDatos,
                    child: const Text("Actualizar Datos"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
