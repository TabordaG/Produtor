import 'package:flutter/material.dart';
import 'package:produtor/pages/dados_basicos.dart';
import 'package:http/http.dart' as http;
import 'package:produtor/pages/recebimentos/recebimentos.dart';
import 'package:toast/toast.dart';
import 'dart:async';
import 'dart:convert';

import 'package:toast/toast.dart';

import '../../soft_buttom.dart';

class Detalhe_Recebimento2 extends StatefulWidget {
  // id_cliente da sessao
  final id_sessao;
  final id_recebimento;
  final data_pedido;
  final frete;

  Detalhe_Recebimento2(
      {this.id_sessao, this.id_recebimento, this.data_pedido, this.frete});

  _Detalhe_Recebimento2 createState() => _Detalhe_Recebimento2();
}

class _Detalhe_Recebimento2 extends State<Detalhe_Recebimento2> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey(); // snackbar
  double _top = -60;
  // barra de aviso
  void _showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.black,
      duration: Duration(seconds: 2),
    ));
  }

  ScrollController _controller; // controle o listview
  List Parcela_on_the_recebimento = [];

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 250), () {
      setState(() {
        _top = 0;
      });
    });
    listRecebimentos().then((resultado) {
      setState(() {});
    });

    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 10.0, top: 65, bottom: 5),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[200],
                        blurRadius:
                            20.0, // has the effect of softening the shadow
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 20, right: 20, bottom: 5),
                          child: Text(
                            'Parcelas Recebimento (' +
                                Parcela_on_the_recebimento.length.toString() +
                                ')',
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                              controller: _controller,
                              // retorna o laco com lista de produtos
                              itemCount: Parcela_on_the_recebimento.length,
                              itemBuilder: (context, index) {
                                return Single_pedido_product(
                                  sessao: widget.id_sessao,
                                  data_pedido: widget.data_pedido,
                                  id_recebimento: widget.id_recebimento,
                                  frete: widget.frete,
                                  id_parcela: Parcela_on_the_recebimento[index]
                                      ["id"],
                                  data_pagamento:
                                      Parcela_on_the_recebimento[index]
                                          ["data_pagamento"],
                                  valor_pagamento:
                                      Parcela_on_the_recebimento[index]
                                          ["valor_pagamento"],
                                  status_pagamento:
                                      Parcela_on_the_recebimento[index]
                                          ["status_pagamento"],
                                  meio_pagamento:
                                      Parcela_on_the_recebimento[index]
                                          ["meio_pagamento"],
                                  //pedido_prod_size: Parcela_on_the_recebimento[index]["Tamanho"],
                                  data_vencimento:
                                      Parcela_on_the_recebimento[index]
                                              ["data_vencimento"]
                                          .toString(),
                                  conta_a_receber:
                                      Parcela_on_the_recebimento[index]
                                          ["conta_a_receber"],
                                );
                              }),
                        ),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Frete:',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'R\$ ' + widget.frete.toString(),
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 250),
              top: _top,
              child: CircularSoftButton(
                icon: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 28,
                    ),
                    // onPressed: widget.closedBuilder,
                    onPressed: () {
                      setState(() {
                        _top = -60;
                      });
                      Future.delayed(Duration(milliseconds: 250), () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RecebimentosPage2(
                                  id_sessao: widget.id_sessao,
                                )));
                      });
                    }),
                radius: 22,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: new Container(
        color: Colors.grey.withOpacity(0.3),
        child: Row(
          children: <Widget>[
            Container(
              child: Expanded(
                child: ListTile(
                  title: new Text(
                    "Pedido: ", //  # ${widget.id_pedido}",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(0.4),
                    ),
                  ),
                  subtitle: new Text(
                    "# ${widget.id_recebimento}",
                    //"Situação: ${ widget.status_pedido}",
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: Expanded(
                child: ListTile(
                  title: new Text(
                    "Data Pedido:",
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.4)),
                  ),
                  subtitle: new Text(
                    "${inverte_data(widget.data_pedido.toString().substring(0, 10))}",
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: Expanded(
                child: ListTile(
                  title: new Text(
                    "Total + Frete:",
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(0.4),
                    ),
                  ),
                  subtitle: new Text(
                    "R\$ ${total()}",
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // String totalPedido() {
  //   double total;
  //   try {
  //     total = double.parse(widget.valor_pagamento) + double.parse(frete);
  //     return total.toStringAsFixed(2);
  //   }
  //   catch (e) {
  //     return valor_pagamento.toStringAsFixed(2);
  //   }
  // }

  // Lista itens do cesta
  Future<List> listRecebimentos() async {
    String link = Basicos.codifica(
        "${Basicos.ip}/crud/?crud=consult60.${widget.id_recebimento}");
    var res = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    //menssagem de carregando
    new Future.delayed(const Duration(seconds: 1)) //snackbar
        .then((_) => _showSnackBar('Carregando...')); //snackbar
    if (res.body.length > 2) {
      if (res.statusCode == 200) {
        // converte a lista de consulta em uma lista dinamica
        List list = json.decode(res.body).cast<Map<String, dynamic>>();
        //Meus_recebimentos = list;
        for (var i = 0; i < list.length; i++)
          Parcela_on_the_recebimento.add(list[i]);
        //somaq parcelas
        await total();
        return list;
      }
    }
  }

// soma os valores da cesta retorna o total
  String total() {
    var soma = 0.0;
    for (int i = 0; i < Parcela_on_the_recebimento.length; i++) {
      soma = soma +
          (double.parse(Parcela_on_the_recebimento[i]["valor_pagamento"]));
    }
    try {
      soma += double.parse(widget.frete);
      return soma.toStringAsFixed(2);
    } catch (e) {
      return soma.toStringAsFixed(2);
    }
  }
}

// monta radio group tipo pagamento
class MyDialog extends StatefulWidget {
  const MyDialog();

  @override
  State createState() => new MyDialogState();
}

class MyDialogState extends State<MyDialog> {
  String _selectedId;

//  void initState() {
//    Parametro.tipo_pagamento = "";
//  }

  Widget build(BuildContext context) {
    String _picked = "";
    return new Column(
      // title: new Text("New Dialog"),
      // contentPadding: const EdgeInsets.all(10.0),
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(2, 10.0, 10.0, 0.0),
          width: 250,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.4),
            borderRadius: BorderRadius.all(Radius.circular(22.0)),
          ),
        ),
      ],
    );
  }
}
// monta radio group tipo pagamento

class Single_pedido_product extends StatelessWidget {
  final sessao;
  final data_pedido;
  final id_recebimento;
  final id_parcela;
  final valor_pagamento;
  final status_pagamento;
  final meio_pagamento;
  final data_pagamento;
  final data_vencimento;
  final conta_a_receber;
  final frete;

  Single_pedido_product(
      {this.sessao,
      this.data_pedido,
      this.id_recebimento,
      this.id_parcela,
      this.valor_pagamento,
      this.status_pagamento,
      this.meio_pagamento,
      this.data_pagamento,
      this.data_vencimento,
      this.conta_a_receber,
      this.frete});

  @override
  Status _currentState;

  List<Status> status = <Status>[
    const Status("PENDENTE"),
    const Status('PAGO'),
    const Status('PARCIALMENTE PAGO'),
    const Status('CANCELADO')
  ];

  // status meio de pagamento
//  'DINHEIRO', 'DINHEIRO'),
//  ('CARTAO DEBITO', 'CARTAO DEBITO'),
//  ('CARTAO CREDITO', 'CARTAO CREDITO'),
//  ('CHEQUE', 'CHEQUE'),
//  ('OUTROS', 'OUTROS')

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <
            Widget>[
          Column(
            children: <Widget>[
              Text(
                'Parcela\n#${id_parcela}',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.normal),
                textAlign: TextAlign.center,
              ),
              new Text(
                "Valor: ",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 0, right: 10, bottom: 0, top: 0),
                child: Text(
                  "R\$ ${valor_pagamento.toString()}   ",
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                  textAlign: TextAlign.center,
                  // textScaleFactor: 1.1,
                ),
              ),
              //continua
            ],
          ),
          Container(
            //color: Colors.red,
            alignment: Alignment.topLeft,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
              Row(
                children: <Widget>[
                  new Text(
                    " Data Pagamento:",
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                    textAlign: TextAlign.left,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 0, right: 0, bottom: 0, top: 0),
                    child: new Text(
                      " ${inverte_data(data_pagamento.toString().substring(0, 10))}",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ],
              ),
              Row(children: <Widget>[
                new Text(
                  " Data Cadastro :",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  textAlign: TextAlign.left,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 0, right: 10, bottom: 0, top: 0),
                  child: new Text(
                    " ${inverte_data(data_vencimento.toString().substring(0, 10))}",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ),
              ]),
              Row(
                children: <Widget>[
                  new Text(
                    " Data Vencimento: ",
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                    textAlign: TextAlign.left,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 0, right: 0.0, bottom: 0, top: 0),
                    child: new Text(
                      " ${inverte_data(data_vencimento.toString().substring(0, 10))}",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ],
              )
            ]),
          ),
        ]),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new Text(
              "  Situação:   ",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              textAlign: TextAlign.left,
            ),
            new DropdownButton<Status>(
              hint: Text(status_pagamento),
              value: _currentState,
              onChanged: (Status newValue) async {
//               setState(() {
                await grava_status(id_parcela.toString(), newValue.name);
                Toast.show(
                    "Atualizando Situação \n da parcela: " +
                        id_parcela.toString(),
                    context,
                    duration: Toast.LENGTH_LONG,
                    gravity: Toast.CENTER,
                    backgroundRadius: 0.0);
                _currentState = newValue;
                Navigator.of(context).push(new MaterialPageRoute(
                  // aqui temos passagem de valores id cliente(sessao) de login para home
                  builder: (context) => new Detalhe_Recebimento2(
                    id_sessao: sessao,
                    id_recebimento: id_recebimento,
                    data_pedido: data_pedido,
                  ),
                ));
//                });
              },
              items: status.map((Status status) {
                return new DropdownMenuItem<Status>(
                  value: status,
                  child: new Text(
                    status.name,
                    textAlign: TextAlign.left,
                    style: new TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
              style: new TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ],
    ));
  }

  //converte data em ingles para padrao brasileiro
  String inverte_data(substring) {
    String temp = '';
    //print(substring);
    temp = substring[8] + substring[9];
    temp = temp + '-' + substring[5] + substring[6];
    temp = temp + '-' + substring.toString().substring(0, 4);
    return temp;
  }
}

Future<String> grava_status(final numero_parcela, final situacao) async {
  // print(numero_parcela + '-' + situacao);
  String link = Basicos.codifica("${Basicos.ip}"
      "/crud/?crud=consult59.${numero_parcela},${situacao}");
  //print(situacao);
  var res = await http
      .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
  //var res =Basicos.decodifica(res1.body);
  if (res.body.length > 2) {
    if (res.statusCode == 200) {
      // converte a lista de consulta em uma lista dinamica
      //  List list = json.decode(res.body).cast<Map<String, dynamic>>();
      //Meus_pedidos = list;

      // for (var i = 0; i < list.length; i++) Basicos.meus_pedidos.add(list[i]);
      // print('2');
      return 'sucesso';
    }
  }
}

//converte data em ingles para padrao brasileiro
String inverte_data(substring) {
  String temp = '';
  //print(substring);
  temp = substring[8] + substring[9];
  temp = temp + '-' + substring[5] + substring[6];
  temp = temp + '-' + substring.toString().substring(0, 4);
  return temp;
}

class Status {
  const Status(this.name);

  final String name;
}
