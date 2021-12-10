//listar os pagamentos e recebimentos

import 'package:produtor/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:produtor/pages/dados_basicos.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../soft_buttom.dart';
import 'chat/chats.dart';
import 'entrega_pedidos/entrega_pedidos.dart';

class Caixaf extends StatefulWidget {
  final id_sessao;
  String soma_pagamentos = '0.0';
  String soma_recebimentos = '0.0';

  @override
  _CaixafState createState() => _CaixafState();

  Caixaf({this.id_sessao}); //, this.soma_pagamentos, this.soma_recebimentos});
}

class _CaixafState extends State<Caixaf> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey(); // snackbar
  StreamController caixastream;
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
        if (Basicos.offset < Basicos.caixa.length) {
          //atualiza pagina com offset
          Basicos.pagina = _controller.offset;
          // aumenta o offset da consulta no banco
          Basicos.offset = Basicos.offset +
              10; //preenche o grid com a quantidade lida do banco menos dois uma fileira

          // print(_controller.offset);
          // print(Basicos.pagina);
          // _controller.jumpTo(50.0);
          listRecebimentos();
          total_pagar().then((soma) {
            setState(() {
              widget.soma_pagamentos = soma;
            });
          });
          total_receber().then((rec) {
            setState(() {
              widget.soma_recebimentos = rec;
            });
          });
          // Navigator.of(context).push(new MaterialPageRoute(
          //   // aqui temos passagem de valores id cliente(sessao) de login para home
          //   builder: (context) => new Caixaf(id_sessao: widget.id_sessao),
          // ));
        } else
          Basicos.offset = Basicos.caixa.length;
      });
    }
  }

  @override
  void initState() {
    Basicos.caixa = [];
    Basicos.offset = 0;
    if (!indexBottom[2]) {
      setState(() {
        indexBottom[0] = false;
        indexBottom[1] = false;
        indexBottom[2] = true;
        indexBottom[3] = false;
      });
    }
    Future.delayed(Duration(milliseconds: 250), () {
      setState(() {
        _top = 0;
      });
    });
    caixastream = StreamController();
    _controller = ScrollController(
      initialScrollOffset: Basicos.pagina,
    );
    _controller.addListener(_scrollListener);

    listRecebimentos().then((resultado) {
      setState(() {});
    });

    total_pagar().then((soma) {
      widget.soma_pagamentos = soma;
      setState(() {});
    });
    total_receber().then((rec) {
      widget.soma_recebimentos = rec;
      setState(() {});
    });

    super.initState();
    // refresh_List();
    // refresh_db();
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    caixastream.close();
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
                    left: 10, right: 10.0, top: 65, bottom: 60),
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
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, top: 20, right: 20, bottom: 5),
                              child: Text(
                                'Fluxo de Caixa',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                      color: Colors.white,
                                      child: Row(children: [
                                        new Expanded(
                                            flex: 4,
                                            child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 24,
                                                    right: 0,
                                                    bottom: 6,
                                                    top: 6),
                                                child: Text("Tipo Entrada : ",
                                                    style: new TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    textAlign:
                                                        TextAlign.center))),
                                        new Expanded(
                                            flex: 1,
                                            child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 6,
                                                    right: 0,
                                                    bottom: 6,
                                                    top: 6),
                                                child: IconButton(
                                                  icon: Icon(
                                                    Icons.fiber_manual_record,
                                                    color: Colors.teal,
                                                  ),
                                                  iconSize: 15,
                                                  onPressed: () {},
                                                  //onPressed: () {},
                                                ))),
                                        Text('  Pagamentos',
                                            style: new TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            )),
                                        new Expanded(
                                            flex: 1,
                                            child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 6,
                                                    right: 0,
                                                    bottom: 6,
                                                    top: 6),
                                                child: IconButton(
                                                  icon: Icon(
                                                    Icons.fiber_manual_record,
                                                    color: Colors.blue,
                                                  ),
                                                  iconSize: 15,
                                                  onPressed: () {},
                                                  // onPressed: () {},
                                                ))),
                                        Text('  Recebimentos',
                                            style: new TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            )),
                                        new Expanded(
                                            flex: 1,
                                            child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 0,
                                                    right: 0,
                                                    bottom: 6,
                                                    top: 6),
                                                child: Text('',
                                                    style: new TextStyle(
                                                      height: 2.0,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    textAlign:
                                                        TextAlign.center))),
                                      ])),
                                  Expanded(
                                    child: StreamBuilder<Object>(
                                        stream: caixastream.stream,
                                        builder: (context, snapshot) {
                                          switch (snapshot.connectionState) {
                                            case ConnectionState.waiting:
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            default:
                                              List listaCaixa = snapshot.data;
                                              return Scrollbar(
                                                child: ListView.builder(
                                                    controller: _controller,
                                                    itemCount: listaCaixa
                                                        .length, //andamento?.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return showList(
                                                        fornecedor:
                                                            listaCaixa[index]
                                                                ["fornecedor"],
                                                        meio_pagamento_pagar:
                                                            listaCaixa[index][
                                                                "meio_de_pagamento_pagar"],
                                                        valor_conta_pagar:
                                                            listaCaixa[index][
                                                                "valor_conta_pagar"],
                                                        status_conta_pagar:
                                                            listaCaixa[index][
                                                                "status_conta_pagar"],
                                                        forma_pagamento_pagar:
                                                            listaCaixa[index][
                                                                "forma_pagamento_pagar"],
                                                        tipo: listaCaixa[index]
                                                                ["tipo"]
                                                            .toString(),
                                                        data_registro:
                                                            listaCaixa[index][
                                                                "data_registro"],
                                                        id_pagar:
                                                            listaCaixa[index]
                                                                    ["id_pagar"]
                                                                .toString(),
                                                        sessao:
                                                            widget.id_sessao,
                                                      );
                                                    }),
                                              );
                                          }
                                        }),
                                  ),
                                  Container(
                                    color: Colors.black.withOpacity(0.1),
                                    margin: EdgeInsets.only(top: 2),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          child: Expanded(
                                            child: ListTile(
                                              title: new Text(
                                                "Pag: ", //  # ${widget.id_pedido}",

                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  // fontWeight: FontWeight.bold,
                                                  color: Colors.teal,
                                                ),
                                              ),
                                              subtitle: new Text(
                                                "R\$ ${widget.soma_pagamentos}",
                                                //"Situação: ${ widget.status_pedido}",
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.teal,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Expanded(
                                            child: ListTile(
                                              title: new Text(
                                                "Receb:",
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  // fontWeight: FontWeight.bold,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              subtitle: new Text(
                                                "R\$ ${widget.soma_recebimentos}",
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue,
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
                                                  fontSize: 16.0,
                                                  // fontWeight: FontWeight.bold,
                                                  //color: Colors.red,
                                                ),
                                              ),
                                              subtitle: new Text(
                                                "R\$ ${(double.parse(widget.soma_recebimentos) - double.parse(widget.soma_pagamentos)).toStringAsFixed(2)}",
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: Duration(milliseconds: 450),
                bottom: 0,
                child: Hero(
                  tag: 'bottombar',
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    color: Color(
                        0xFFe3e7ed), //Color(0xFFeceff3),//Color(0xFFd3d9e3),//Color(0xFFf8faf8).withOpacity(1),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width - 8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            icon: Icon(Icons.home,
                                color: indexBottom[0]
                                    ? Color(0xFF006767)
                                    : Colors.black26,
                                size: 30),
                            onPressed: () {
                              if (!indexBottom[0]) {
                                setState(() {
                                  indexBottom[0] = true;
                                  indexBottom[1] = false;
                                  indexBottom[2] = false;
                                  indexBottom[3] = false;
                                });
                              }
                              Basicos.offset = 0; // zera o ofset do banco
                              Basicos.product_list =
                                  []; // zera o lista de produtos da pagina principal
                              Basicos.pagina = 1;
                              //Basicos.buscar_produto_home = ''; // limpa pesquisa
                              Navigator.of(context).push(new MaterialPageRoute(
                                // aqui temos passagem de valores id cliente(sessao) de login para home
                                builder: (context) =>
                                    new home2(id_sessao: widget.id_sessao),
                              ));
                            },
                          ),
                          IconButton(
                            icon: Stack(
                              children: [
                                Center(
                                    child: Icon(
                                  Icons.chat,
                                  color: indexBottom[1]
                                      ? Color(0xFF006767)
                                      : Colors.black26,
                                  size: 30,
                                )),
                                qtd_chat != null && qtd_chat != '0'
                                    ? Positioned(
                                        bottom: 2,
                                        right: 0,
                                        child: Container(
                                          width: 7,
                                          height: 7,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.teal,
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                            onPressed: () {
                              if (!indexBottom[1]) {
                                setState(() {
                                  indexBottom[0] = false;
                                  indexBottom[1] = true;
                                  indexBottom[2] = false;
                                  indexBottom[3] = false;
                                });
                              }
                              Basicos.offset = 0; // zera o ofset do banco
                              Basicos.product_list =
                                  []; // zera o lista de produtos da pagina principal
                              Basicos.pagina = 1;
                              //Basicos.buscar_produto_home = ''; // limpa pesquisa
                              Navigator.of(context).push(new MaterialPageRoute(
                                // aqui temos passagem de valores id cliente(sessao) de login para home
                                builder: (context) =>
                                    new ChatsPage(id_sessao: widget.id_sessao),
                              ));
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.monetization_on,
                                color: indexBottom[2]
                                    ? Color(0xFF006767)
                                    : Colors.black26,
                                size: 30),
                            onPressed: () {
                              if (!indexBottom[2]) {
                                setState(() {
                                  indexBottom[0] = false;
                                  indexBottom[1] = false;
                                  indexBottom[2] = true;
                                  indexBottom[3] = false;
                                });
                              }
                              Basicos.offset = 0;
                              Basicos.product_list = [];
                              Basicos.meus_pedidos = [];
                              Navigator.of(context).push(new MaterialPageRoute(
                                // aqui temos passagem de valores id cliente(sessao) de login para home
                                builder: (context) =>
                                    new Caixaf(id_sessao: widget.id_sessao),
                              ));
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.assessment,
                                color: indexBottom[3]
                                    ? Color(0xFF006767)
                                    : Colors.black26,
                                size: 30),
                            onPressed: () {
                              if (!indexBottom[3]) {
                                setState(() {
                                  indexBottom[0] = false;
                                  indexBottom[1] = false;
                                  indexBottom[2] = false;
                                  indexBottom[3] = true;
                                });
                              }
                              Basicos.offset = 0;
                              Basicos.product_list = [];
                              Basicos.meus_pedidos = [];
                              Navigator.of(context).push(new MaterialPageRoute(
                                // aqui temos passagem de valores id cliente(sessao) de login para home
                                builder: (context) => new EntregaPedidoPage(
                                    id_sessao: widget.id_sessao),
                              ));
                            },
                          ),
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
  Future<List> listRecebimentos() async {
    //print(widget.id_sessao);
    String link = Basicos.codifica("${Basicos.ip}"
        "/crud/?crud=consult65.${widget.id_sessao},${widget.id_sessao},10,${Basicos.offset}");
    var res = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    //print(res.body);
    //var res =Basicos.decodifica(res1.body);

    if (res.body.length == 2)
      new Future.delayed(const Duration(seconds: 1)) //snackbar
          .then((_) => _showSnackBar('Sem Novos Lançamentos...'));
    else
      new Future.delayed(const Duration(seconds: 1)) //snackbar
          .then((_) => _showSnackBar('Carregando...')); //snackbar

    if (res.body.length > 2) {
      if (res.statusCode == 200) {
        // converte a lista de consulta em uma lista dinamica
        List list = json.decode(res.body).cast<Map<String, dynamic>>();
//        //caixa = list;
        // print(list);
        for (var i = 0; i < list.length; i++) Basicos.caixa.add(list[i]);
        caixastream.sink.add(Basicos.caixa);
        return list;
      }
    }
  }

  // soma os valores da cesta retorna o total
  Future<String> total_pagar() async {
    //print(widget.id_sessao);
    String link = Basicos.codifica("${Basicos.ip}"
        "/crud/?crud=consult66.${widget.id_sessao}");
    var res1 = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    //print(res.body);
    var res = Basicos.decodifica(res1.body);
    if (res1.body.length > 2) {
      if (res1.statusCode == 200) {
        // converte a lista de consulta em uma lista dinamica
        List list = json.decode(res).cast<Map<String, dynamic>>();
//        //caixa = list;
        //  print(list[0]['total_pag']);
        return list[0]['total_pag'].toString();
      }
    }
  }

  // soma os valores da cesta retorna o total
  Future<String> total_receber() async {
    //print(widget.id_sessao);
    String link = Basicos.codifica("${Basicos.ip}"
        "/crud/?crud=consult67.${widget.id_sessao}");
    var res1 = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    //print(res.body);
    var res = Basicos.decodifica(res1.body);
    if (res1.body.length > 2) {
      if (res1.statusCode == 200) {
        // converte a lista de consulta em uma lista dinamica
        List list = json.decode(res).cast<Map<String, dynamic>>();
//        //caixa = list;
        // print(list[0]['total_rec']);
        return list[0]['total_rec'].toString();
      }
    }
  }
}

// ignore: must_be_immutable
class showList extends StatefulWidget {
  final sessao;
  final fornecedor;
  final meio_pagamento_pagar;
  final valor_conta_pagar;
  final status_conta_pagar;
  final forma_pagamento_pagar;
  final tipo;
  final data_registro;
  final id_pagar;

  showList({
    this.fornecedor,
    this.meio_pagamento_pagar,
    this.valor_conta_pagar,
    this.status_conta_pagar,
    this.forma_pagamento_pagar,
    this.tipo,
    this.data_registro,
    this.id_pagar,
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

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        //=============== subttitulo da sessao
        title: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                //tanho das letra no lista de produtos
                new Text(
                  "#Num: " + widget.id_pagar.toString(),
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                ),

                Expanded(
                  child: new Text(
                    "  Data:",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        color: Colors.grey),
                  ),
                ),
                //tanho das letra no lista de produtos
                new Text(
                  inverte_data(
                      widget.data_registro.toString().substring(0, 10)),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                ),
                //===========sessao cor do produto

                Expanded(
                  child: new Text(
                    "   Valor: ",
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                  ),
                ),

                //posiciona o texto
                Expanded(
                  child: new Text(
                    widget.valor_conta_pagar.toString(), //"R\$" +
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: ((int.parse(widget.tipo) - 1) % 2 == 0)
                          ? Colors.teal.withOpacity(1)
                          : Colors.black.withOpacity(1),
                    ),
                  ),
                ),
              ],
            ),

// dados recebimentos
            Row(
              children: <Widget>[
                Expanded(
                  child: new Text(
                    "Meio Pag: \n" + widget.meio_pagamento_pagar.toString(),
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                  ),
                ),
                Expanded(
                  child: new Text(
                    "Conta:" + widget.status_conta_pagar.toString(),
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                  ),
                ),
              ],
            ),
            //============================ sessao preco produto
            Row(
              children: <Widget>[
                Expanded(
                  child: new Text(
                    "Origem:" + widget.fornecedor.toString(),
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Container(
          width: 30,
          height: double.infinity,
          color: ((int.parse(widget.tipo) - 1) % 2 == 0)
              ? Colors.teal.withOpacity(0.5)
              : Colors.blue.withOpacity(0.5),
        ),
        contentPadding: EdgeInsets.fromLTRB(5, 0.0, 0.0, 0.0),
//        onTap: () {
//          Navigator.of(context).push(new MaterialPageRoute(
//            // aqui temos passagem de valores id cliente(sessao) de login para home
//            builder: (context) => new Detalhe_Recebimento(
//              id_sessao: widget.sessao,
//              id_recebimento: widget.recebimento_numero,
//            ),
//          ));
//        },
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
