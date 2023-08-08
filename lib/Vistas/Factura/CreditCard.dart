import 'package:auto/Servicios/conexion.dart';
import 'package:auto/Utilidades/facturaUtil.dart';
import 'package:auto/Utilidades/sessionUtil.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

class CreditCard extends StatefulWidget {
  const CreditCard({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CreditCardState();
  }
}

class _CreditCardState extends State<CreditCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _cardNumberController = TextEditingController();
  TextEditingController _cardHolderNameController = TextEditingController();
  TextEditingController _expirationDateController = TextEditingController();
  TextEditingController _cvvController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cardNumberController.addListener(_formatCardNumber);
    _cvvController.addListener(_formatCVVNumber);
    _expirationDateController.addListener(_formatExpirationNumber);
  }

  @override
  void dispose() {
    _cardNumberController.removeListener(_formatCardNumber);
    _cardNumberController.dispose();
    _cardHolderNameController.dispose();
    _expirationDateController.removeListener(_formatExpirationNumber);
    _expirationDateController.dispose();
    _cvvController.removeListener(_formatCVVNumber);
    _cvvController.dispose();
    super.dispose();
  }

  void _formatCardNumber() {
    String value = _cardNumberController.text.replaceAll(RegExp(r'\s'), '');
    if (value.length > 17) {
      value = value.substring(0, 16);
    }
    if (value.length > 4) {
      value = value.replaceRange(4, 4, ' ');
    }
    if (value.length > 9) {
      value = value.replaceRange(9, 9, ' ');
    }
    if (value.length > 14) {
      value = value.replaceRange(14, 14, ' ');
    }
    _cardNumberController.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }
  void _formatCVVNumber(){
    if (_cvvController.text.length > 3) {
      String cvvValue = _cvvController.text.substring(0, 3);
      _cvvController.value = TextEditingValue(
        text: cvvValue,
        selection: TextSelection.collapsed(offset: cvvValue.length),
      );
    }
  }
  void _formatExpirationNumber(){
    String expirationValue = _expirationDateController.text.replaceAll(RegExp(r'\D'), '');

    if (expirationValue.length > 4) {
      expirationValue = expirationValue.substring(0, 4);
    }
    if (expirationValue.length > 2) {
      expirationValue = expirationValue.replaceRange(2, 2, '/');
    }
    print(expirationValue);
    _expirationDateController.value = TextEditingValue(
      text: expirationValue,
      selection: TextSelection.collapsed(offset: expirationValue.length),
    );
  }

  String? _validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingresa el número de tarjeta';
    }
    if (value.length < 19) {
      return 'Número de tarjeta incompleto';
    }
    if (!isCreditCard(value)) {
      return 'Número de tarjeta inválido';
    }
    return null;
  }

  String? _validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingresa el CVV';
    }

    if (value.length != 3 || !isNumeric(value)) {
      return 'CVV inválido';
    }

    return null;
  }

  String? _validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingresa la fecha de expiración (MM/YY)';
    }

    List<String> parts = value.split('/');
    if (parts.length != 2 || parts[0].length != 2 || parts[1].length != 2) {
      return 'Formato de fecha inválido. Debe ser MM/YY';
    }

    int month = int.tryParse(parts[0]) ?? 0;
    int year = int.tryParse(parts[1]) ?? 0;

    if (month < 1 || month > 12 || year < 0) {
      return 'Fecha de expiración inválida';
    }
    return null;
  }

  void _onPagarPressed() {
    if (_formKey.currentState!.validate()) {
      Map <dynamic, dynamic> data = {
        "identificacion" : sessionUtil.getIdentificacion(),
      };

      conexion.guardar(data, 'facturas').then((info){
        var infoAux = info.info;
        if(info.code != 200){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(info.msg),),);
        }else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(info.msg),),);
          facturaUtil.saveExternal_Factura(infoAux['externalId']);
          Navigator.pushNamed(context, '/factura');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pagar'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _cardNumberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Número de Tarjeta',
                ),
                maxLength: 19, // Incluyendo espacios, el máximo son 19 caracteres
                validator: _validateCardNumber,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _cardHolderNameController,
                decoration: InputDecoration(
                  labelText: 'Titular de la Tarjeta',
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _expirationDateController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'MM/YY'
                      ),
                      maxLength: 5,
                      validator: _validateExpiryDate,
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: TextFormField(
                      controller: _cvvController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'CVV',
                      ),
                      maxLength: 3,
                      validator: _validateCVV,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _onPagarPressed,
                child: Text('Pagar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
