import 'package:devfest2020/services/token.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mpesa_sdk_dart/mpesa_sdk_dart.dart';

import 'services/OutputResponse.dart' as outrsp;

void main() {
  runApp(DevFestApp());
}

class DevFestApp extends StatefulWidget {
  @override
  _DevFestAppState createState() => _DevFestAppState();
}

class _DevFestAppState extends State<DevFestApp> {
  double montante;

  String thirdPartyReference = "DevFest2020";
  TextEditingController _textEditingController = TextEditingController();
  String inputServiceProviderCode = "171717";
  var _transactionID;
  String resposta;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: Scaffold(
        appBar: AppBar(
          title: Text("DevFestApp"),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(resposta ?? "Aguardando resposta"),
                Container(
                  width: 200,
                  child: TextField(
                    decoration: InputDecoration(hintText: "Montante a debitar"),
                    controller: _textEditingController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      montante = double.parse(value);
                    },
                  ),
                ),
                RaisedButton(
                  child: Text("Pagar"),
                  onPressed: () {
                    efectuarPagamento();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  efectuarPagamento() async {
    PaymentRequest payload = PaymentRequest(
      inputTransactionReference: 'Tiquete',
      inputCustomerMsisdn: '258846738751',
      inputAmount: montante,
      inputThirdPartyReference: thirdPartyReference,
      inputServiceProviderCode: inputServiceProviderCode,
    );

    Response response = await MpesaTransaction.c2b(token, payload);

    setState(() {
      _transactionID =
          outrsp.responseFromJson(response.body).outputTransactionID;
    });

    verificarEstado();
  }

  verificarEstado() async {
    Response response = await MpesaTransaction.getTransactionStatus(
      token,
      thirdPartyReference,
      _transactionID,
      inputServiceProviderCode,
    );
    setState(() {
      resposta = outrsp
          .responseFromJson(response.body)
          .outputResponseTransactionStatus;
    });
  }
}
