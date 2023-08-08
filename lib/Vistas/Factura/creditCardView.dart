import 'dart:async';
import 'dart:convert';

import 'package:auto/Servicios/conexion.dart';
import 'package:auto/Utilidades/carritoUtil.dart';
import 'package:auto/Utilidades/facturaUtil.dart';
import 'package:auto/Utilidades/sessionUtil.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
class creditCardView extends StatefulWidget {
  const creditCardView({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _creditCardViewState();
  }
}
class _creditCardViewState extends State<creditCardView> {

  final html = """<!DOCTYPE html>
<html lang="en">

<head>
    <style id="customPageStyle">
        body {
            background-color: #f6f6f5;
        }
    </style>
    <style>
        .centrar {
            margin-right: 150px;
            margin-left: 100px;
            border: 1px solid #808080;
            padding: 10px;
        }
    </style>
    <script src="https://eu-test.oppwa.com/v1/paymentWidgets.js?checkoutId=${facturaUtil.getCheckoutId()}"></script>
</head>

<body>
    <div class="centrar">
        <form action="https://flutter.dev" class="paymentWidgets" data-brands="VISA MASTER"></form>
    </div>
</body>

</html>
<html>""";

  // Creamos el controlador del WebView
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    cargarHtml();

  }

  void cargarHtml() async {
    final url = Uri.dataFromString(
      html,
      mimeType: 'text/html',
      encoding: Encoding.getByName('utf-8'),
    ).toString();

    // Obtenemos el controlador del WebView y luego cargamos la URL con el contenido HTML
    final webViewController = await _controller.future;
    webViewController.loadUrl(url);
  }
  void _onPagarPressed() {

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
          Navigator.pop(context);
          Navigator.pushNamed(context, '/factura');
        }
      });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Credit Card'),
      ),
      body: WebView(
        // Asignamos el controlador del WebView
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        navigationDelegate: (NavigationRequest request) {
          final domain = Uri.parse(request.url).host;
          if (domain == 'flutter.dev') {
            // Redirigir al usuario a la ruta '/factura'
            _onPagarPressed();
            return NavigationDecision.prevent; // Prevenir la navegación a la URL externa
          }
          return NavigationDecision.navigate; // Permitir la navegación a otras URL
        },
      ),
    );
  }
}

