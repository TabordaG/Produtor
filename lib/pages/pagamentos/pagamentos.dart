import 'package:produtor/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:produtor/pages/dados_basicos.dart';
import 'package:toast/toast.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../soft_buttom.dart';

class PagamentosPage2 extends StatefulWidget {
  final id_sessao;

  @override
  _PagamentosPageState2 createState() => _PagamentosPageState2();

  PagamentosPage2({
    this.id_sessao,
  });
}

class _PagamentosPageState2 extends State<PagamentosPage2> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey(); // snackbar
  StreamController pagamentoStream;
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

  _scrollListener() {
    // recebe o scroll se no inicio ou fim
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        if (Basicos.offset < Basicos.meus_pagamentos.length) {
          //atualiza pagina com offset
          Basicos.pagina = _controller.offset;
          // aumenta o offset da consulta no banco
          Basicos.offset = Basicos.offset +
              10; //preenche o grid com a quantidade lida do banco menos dois uma fileira

          // print(_controller.offset);
          // print(Basicos.pagina);
          // _controller.jumpTo(50.0);
          listPagamentos();
          // Navigator.of(context).push(new MaterialPageRoute(
          //   // aqui temos passagem de valores id cliente(sessao) de login para home
          //   builder: (context) =>
          //       new PagamentosPage2(id_sessao: widget.id_sessao),
          // ));
        } else
          Basicos.offset = Basicos.meus_pagamentos.length;
      });
    }
  }

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 250), () {
      setState(() {
        _top = 0;
      });
    });
    pagamentoStream = StreamController();
    _controller = ScrollController(
        // initialScrollOffset: Basicos.pagina,
        );
    _controller.addListener(_scrollListener);
    listPagamentos().then((resultado) {
      setState(() {});
    });
    super.initState();
    // refresh_List();
    // refresh_db();
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    pagamentoStream.close();
    _controller.dispose();
    super.dispose();
  }

  Future<bool> onWillPop() async {
    setState(() {
      _top = -60;
    });
    Future.delayed(Duration(milliseconds: 250), () {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => home2(
                id_sessao: widget.id_sessao,
              )));
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
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
                      child: Scaffold(
                        key: _scaffoldKey,
                        body: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, top: 20, right: 20, bottom: 5),
                              child: Text(
                                'Pagamentos',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Expanded(
                              child: StreamBuilder(
                                  stream: pagamentoStream.stream,
                                  builder: (context, snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.waiting:
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      default:
                                        List listaPagamentos = snapshot.data;
                                        return Scrollbar(
                                          child: ListView.builder(
                                              controller: _controller,
                                              itemCount: listaPagamentos
                                                  .length, //andamento?.length,
                                              itemBuilder: (context, index) {
                                                return showList(
                                                  pagamento_total:
                                                      listaPagamentos[index]
                                                          ["valor_conta"],
                                                  pagamento_status:
                                                      listaPagamentos[index]
                                                          ["status_conta"],
                                                  pagamento_qtd:
                                                      listaPagamentos[index]
                                                          ["quantidade"],
                                                  pagamento_numero:
                                                      listaPagamentos[index]
                                                              ["id"]
                                                          .toString(),
                                                  pagamento_data:
                                                      listaPagamentos[index]
                                                          ["data_registro"],
                                                  num_compra:
                                                      listaPagamentos[index]
                                                          ["num_compra"],
                                                  cliente:
                                                      listaPagamentos[index]
                                                          ["nome_razao_social"],
                                                  sessao: widget.id_sessao,
                                                );
                                              }),
                                        );
                                    }
                                  }),
                            ),
                          ],
                        ),
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
                              builder: (context) => home2(
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
      ),
    );
  }

  // Lista itens da cesta
  Future<List> listPagamentos() async {
    //print(widget.id_sessao);
    String link = Basicos.codifica("${Basicos.ip}"
        "/crud/?crud=consult61.${widget.id_sessao},10,${Basicos.offset}");
    var res = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    //print(res.body);
    //var res =Basicos.decodifica(res1.body);

    if (res.body.length == 2)
      new Future.delayed(const Duration(seconds: 1)) //snackbar
          .then((_) => _showSnackBar('Sem Novos Pagamentos...'));
    else
      new Future.delayed(const Duration(seconds: 1)) //snackbar
          .then((_) => _showSnackBar('Carregando...')); //snackbar

    if (res.body.length > 2) {
      if (res.statusCode == 200) {
        // converte a lista de consulta em uma lista dinamica
        List list = json.decode(res.body).cast<Map<String, dynamic>>();
        //Meus_pagamentos = list;
        for (var i = 0; i < list.length; i++)
          Basicos.meus_pagamentos.add(list[i]);
        pagamentoStream.sink.add(Basicos.meus_pagamentos);
        return list;
      }
    }
  }
}

// ignore: must_be_immutable
class showList extends StatefulWidget {
  final sessao;
  final pagamento_numero;
  final pagamento_total;
  final pagamento_data;
  final pagamento_status;
  final pagamento_qtd;
  final num_compra;
  final cliente;

  showList({
    this.pagamento_numero,
    this.pagamento_status,
    this.pagamento_total,
    this.pagamento_qtd,
    this.pagamento_data,
    this.num_compra,
    this.cliente,
    this.sessao,
  });

  @override
  _showListState createState() => _showListState();
}

// ignore: camel_case_types
class _showListState extends State<showList> {
  @override
  void initState() {
    super.initState();
  }

  Status _currentState;

  List<Status> status = <Status>[
    const Status("PENDENTE"),
    const Status('PARCIALMENTE PAGO'),
    const Status('PAGO'),
    const Status('CANCELADO')
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        //=============== subttitulo da sessao
        title: new Column(
          children: <Widget>[
            // dentro da coluna

            new Row(
              children: <Widget>[
                //tanho das letra no lista de produtos

                new Text(
                  "Num: ",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      color: Colors.black.withOpacity(0.4)),
                ),
                new Text(
                  widget.pagamento_numero,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      color: Colors.black),
                ),
                Expanded(
                  child: new Text(
                    "  Data: ",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        color: Colors.black.withOpacity(0.4)),
                  ),
                ),
                //tanho das letra no lista de produtos
                new Text(
                  inverte_data(
                      widget.pagamento_data.toString().substring(0, 10)),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                ),
                //===========sessao cor do produto

                new Text(
                  "   Total: ",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      color: Colors.black.withOpacity(0.4)),
                ),

                // new Container(
                // alignment: Alignment.topLeft,
                //posiciona o texto
                Expanded(
                  child: new Text(
                    widget.pagamento_total.toString(), //"R\$" +
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ),
              ],
            ),

// dados pagamentos
            Row(
              children: <Widget>[
                new Text(
                  "Pedido: ",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      color: Colors.black.withOpacity(0.4)),
                ),
                new Text(
                  widget.num_compra.toString(),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      color: Colors.black),
                ),
                new Text(
                  "    Cliente: ",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      color: Colors.black.withOpacity(0.4)),
                ),
                Expanded(
                  child: new Text(
                    widget.cliente,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
            //============================ sessao preco produto
            Row(
              children: <Widget>[
                Expanded(
                  child: new Text(
                    "Situação:",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        color: Colors.black.withOpacity(0.4)),
                  ),
                ),
              ],
            ),
//            Row(
//              children: <Widget>[
            new DropdownButton<Status>(
              hint: Text(widget.pagamento_status),
              value: _currentState,
              onChanged: (Status newValue) {
                setState(() {
                  grava_status(widget.pagamento_numero, newValue.name);
                  Toast.show(
                      "Atualizando Situação \n do Pagamento: " +
                          widget.pagamento_numero,
                      context,
                      duration: Toast.LENGTH_LONG,
                      gravity: Toast.CENTER,
                      backgroundRadius: 0.0);
                  _currentState = newValue;
                });
              },
              isExpanded: true,
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
                fontSize: 14,
              ),
            ),
          ],
          //           )
        ),
        // trailing: Icon(Icons.keyboard_arrow_right),
        // onTap: () {
        //   Navigator.of(context).push(new MaterialPageRoute(
        //     // aqui temos passagem de valores id cliente(sessao) de login para home
        //     builder: (context) => new Detalhe_Pagamentos(
        //       id_sessao: widget.sessao,
        //       id_pagamentos: widget.pagamento_numero,
        //     ),
        //   ));
        // },
      ),
    );
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

Future<String> grava_status(final numero_pagamento, final situacao) async {
  String link = Basicos.codifica("${Basicos.ip}"
      "/crud/?crud=consult64.${numero_pagamento},${situacao}");
  //print(situacao);
  var res = await http
      .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
  //print(res.body);
  //var res =Basicos.decodifica(res1.body);
  if (res.body.length > 2) {
    if (res.statusCode == 200) {
      // converte a lista de consulta em uma lista dinamica
      //  List list = json.decode(res.body).cast<Map<String, dynamic>>();
      //Meus_pagamentos = list;

      // for (var i = 0; i < list.length; i++) Basicos.meus_pagamentos.add(list[i]);

      return 'sucesso';
    }
  }
}

class Status {
  const Status(this.name);

  final String name;
}
