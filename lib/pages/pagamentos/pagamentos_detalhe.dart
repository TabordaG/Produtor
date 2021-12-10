import 'package:flutter/material.dart';
import 'package:produtor/pages/dados_basicos.dart';
import 'package:http/http.dart' as http;
import 'package:produtor/pages/pagamentos/pagamentos.dart';
import 'package:toast/toast.dart';
import 'dart:async';
import 'dart:convert';

import 'package:toast/toast.dart';

class Detalhe_Pagamentos extends StatefulWidget {
  // id_cliente da sessao
  final id_sessao;
  final id_pagamentos;

  Detalhe_Pagamentos({
    this.id_sessao,
    this.id_pagamentos,
  });

  _Detalhe_Pagamentos createState() => _Detalhe_Pagamentos();
}

class _Detalhe_Pagamentos extends State<Detalhe_Pagamentos> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey(); // snackbar
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
  List Parcela_on_the_pagamento = [];

  @override
  void initState() {
    listPagamentos().then((resultado) {
      setState(() {});
    });

    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // snackbar
      // monta barra inicial com nome do app e os icones de busca e cesta
      appBar: new AppBar(
        leading: new IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Basicos.offset = 0;
            Basicos.product_list = [];
            Basicos.meus_pagamentos = [];
            //index_tab = 1;
            Navigator.of(context).push(new MaterialPageRoute(
              // aqui temos passagem de valores id cliente(sessao) de login para home
              builder: (context) =>
                  new PagamentosPage2(id_sessao: widget.id_sessao),
            ));
            //Navigator.push(
//                context,
//                MaterialPageRoute(
//                    builder: (context) => new EntregaPedidoPage(
//                          id_sessao: widget.id_sessao,
//                        )));
          },
        ),
        elevation: 0.1,
        backgroundColor: Colors.teal,
        title: InkWell(
          onTap: () {
            Basicos.offset = 0;
            Basicos.product_list = [];
            Basicos.meus_pagamentos = [];
            //index_tab = 1;
            Navigator.of(context).push(new MaterialPageRoute(
              // aqui temos passagem de valores id cliente(sessao) de login para home
              builder: (context) =>
                  new PagamentosPage2(id_sessao: widget.id_sessao),
            ));
//            Navigator.push(
//                context,
//                MaterialPageRoute(
//                    builder: (context) => new EntregaPedidoPage(
//                          id_sessao: widget.id_sessao,
//                        )));
          },
          child: Text(
            'Parcelas Pagamento (' +
                Parcela_on_the_pagamento.length.toString() +
                ')',
          ),
        ),
        actions: <Widget>[
          new IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {}),
        ],
      ),
      body:
          // new pedido products(id_sessao: widget.id_sessao)
          ListView.builder(
              controller: _controller,
              // retorna o laco com lista de produtos
              itemCount: Parcela_on_the_pagamento.length,
              itemBuilder: (context, index) {
                return Single_pedido_product(
                  sessao: widget.id_sessao,
                  id_pagamento: widget.id_pagamentos,
                  id_parcela: Parcela_on_the_pagamento[index]["id"],
                  data_pagamento: Parcela_on_the_pagamento[index]
                      ["data_pagamento"],
                  valor_pagamento: Parcela_on_the_pagamento[index]
                      ["valor_pagamento"],
                  status_pagamento: Parcela_on_the_pagamento[index]
                      ["status_pagamento"],
                  meio_pagamento: Parcela_on_the_pagamento[index]
                      ["meio_pagamento"],
                  //pedido_prod_size: Parcela_on_the_pagamento[index]["Tamanho"],
                  data_vencimento: Parcela_on_the_pagamento[index]
                          ["data_vencimento"]
                      .toString(),
                  conta_a_receber: Parcela_on_the_pagamento[index]
                      ["conta_a_receber"],
                );
              }),

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
                      // fontWeight: FontWeight.bold,
                      //color: Colors.red,
                    ),
                  ),
                  subtitle: new Text(
                    "# ${widget.id_pagamentos}",
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
                      // fontWeight: FontWeight.bold,
                      //color: Colors.red,
                    ),
                  ),
                  subtitle: new Text(
                    "${'data'}",
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
                    "Total:",
                    style: TextStyle(
                      fontSize: 14.0,
                      // fontWeight: FontWeight.bold,
                      //color: Colors.red,
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

  // Lista itens do cesta
  Future<List> listPagamentos() async {
    String link = Basicos.codifica(
        "${Basicos.ip}/crud/?crud=consult63.${widget.id_pagamentos}");
    var res = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    //menssagem de carregando
    new Future.delayed(const Duration(seconds: 1)) //snackbar
        .then((_) => _showSnackBar('Carregando...')); //snackbar
    if (res.body.length > 2) {
      if (res.statusCode == 200) {
        // converte a lista de consulta em uma lista dinamica
        List list = json.decode(res.body).cast<Map<String, dynamic>>();
        //Meus_pagamentos = list;
        for (var i = 0; i < list.length; i++)
          Parcela_on_the_pagamento.add(list[i]);
        //somaq parcelas
        await total();
        return list;
      }
    }
  }

// soma os valores da cesta retorna o total
  String total() {
    var soma = 0.0;
    for (int i = 0; i < Parcela_on_the_pagamento.length; i++) {
      soma =
          soma + (double.parse(Parcela_on_the_pagamento[i]["valor_pagamento"]));
    }
    return soma.toString();
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
  final id_pagamento;
  final id_parcela;
  final valor_pagamento;
  final status_pagamento;
  final meio_pagamento;
  final data_pagamento;
  final data_vencimento;
  final conta_a_receber;

  Single_pedido_product({
    this.sessao,
    this.id_pagamento,
    this.id_parcela,
    this.valor_pagamento,
    this.status_pagamento,
    this.meio_pagamento,
    this.data_pagamento,
    this.data_vencimento,
    this.conta_a_receber,
  });

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
        child: new Row(children: <Widget>[
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
            padding:
                const EdgeInsets.only(left: 0, right: 10, bottom: 0, top: 0),
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
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Row(
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
                //print(data_pedido);

                Navigator.of(context).push(new MaterialPageRoute(
                  // aqui temos passagem de valores id cliente(sessao) de login para home
                  builder: (context) => new Detalhe_Pagamentos(
                    id_sessao: sessao,
                    id_pagamentos: id_pagamento,
                  ),
                ));
//                });
              },
              items: status.map((Status status) {
                return new DropdownMenuItem<Status>(
                  value: status,
                  child: new Text(
                    status.name,
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
        // continua
        Row(
          children: <Widget>[
            new Text(
              " Data do Pagamento:",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
              textAlign: TextAlign.left,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 0, right: 0, bottom: 0, top: 0),
              child: new Text(
                " ${data_pagamento.toString()}",
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
            " Data do Cadastro :",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            textAlign: TextAlign.left,
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 0, right: 10, bottom: 0, top: 0),
            child: new Text(
              " ${data_vencimento.toString()}",
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
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
              textAlign: TextAlign.left,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 0, right: 10, bottom: 0, top: 0),
              child: new Text(
                " ${data_vencimento.toString()}",
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
    ]));
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
  //print(numero_parcela+'-'+situacao);
  String link = Basicos.codifica("${Basicos.ip}"
      "/crud/?crud=consult64.${numero_parcela},${situacao}");
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

class Status {
  const Status(this.name);

  final String name;
}
