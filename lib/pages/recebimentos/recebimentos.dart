import 'package:produtor/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:produtor/pages/dados_basicos.dart';
import 'package:produtor/pages/recebimentos/recebimentos_detalhe.dart';
import 'package:toast/toast.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../soft_buttom.dart';

class RecebimentosPage2 extends StatefulWidget {
  final id_sessao;

  @override
  _RecebimentosPageState2 createState() => _RecebimentosPageState2();
  RecebimentosPage2({
    this.id_sessao,
  });
}

class _RecebimentosPageState2 extends State<RecebimentosPage2> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey(); // snackbar
  StreamController listaRecebimentos;
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
        if (Basicos.offset < Basicos.meus_recebimentos.length) {
          //atualiza pagina com offset
          Basicos.pagina = _controller.offset;
          // aumenta o offset da consulta no banco
          Basicos.offset = Basicos.offset +
              10; //preenche o grid com a quantidade lida do banco menos dois uma fileira

          // print(_controller.offset);
          // print(Basicos.pagina);
          // _controller.jumpTo(50.0);
          listRecebimentos();
          // Navigator.of(context).push(new MaterialPageRoute(
          //   // aqui temos passagem de valores id cliente(sessao) de login para home
          //   builder: (context) =>
          //   new RecebimentosPage2(id_sessao: widget.id_sessao),
          // ));
        } else
          Basicos.offset = Basicos.meus_recebimentos.length;
      });
    }
  }

  @override
  void initState() {
    listaRecebimentos = StreamController();
    _controller = ScrollController(
        // initialScrollOffset: Basicos.pagina,
        );
    Future.delayed(Duration(milliseconds: 250), () {
      setState(() {
        _top = 0;
      });
    });
    _controller.addListener(_scrollListener);
    listRecebimentos().then((resultado) {
      setState(() {});
    });

    super.initState();
    // refresh_List();
    // refresh_db();
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    listaRecebimentos.close();
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
    //refresh_List();
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
                                'Recebimentos',
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
                                  stream: listaRecebimentos.stream,
                                  builder: (context, snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.waiting:
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      default:
                                        List listaRecebidos = snapshot.data;
                                        return Scrollbar(
                                          child: ListView.builder(
                                              controller: _controller,
                                              itemCount: listaRecebidos
                                                  .length, //andamento?.length,
                                              itemBuilder: (context, index) {
                                                return showList(
                                                  recebimento_total:
                                                      listaRecebidos[index]
                                                          ["valor_conta"],
                                                  recebimento_status:
                                                      listaRecebidos[index]
                                                          ["status_conta"],
                                                  recebimento_qtd:
                                                      listaRecebidos[index]
                                                          ["quantidade"],
                                                  recebimento_numero:
                                                      listaRecebidos[index]
                                                              ["id"]
                                                          .toString(),
                                                  recebimento_data:
                                                      listaRecebidos[index]
                                                          ["data_registro"],
                                                  num_pedido:
                                                      listaRecebidos[index]
                                                          ["num_pedido"],
                                                  cliente: listaRecebidos[index]
                                                      ["nome_razao_social"],
                                                  frete: listaRecebidos[index]
                                                      ["frete"],
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
  Future<List> listRecebimentos() async {
    //print(widget.id_sessao);
    String link = Basicos.codifica("${Basicos.ip}"
        "/crud/?crud=consult57.${widget.id_sessao},10,${Basicos.offset}");
    var res = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    //print(res.body);
    //var res =Basicos.decodifica(res1.body);

    if (res.body.length == 2)
      new Future.delayed(const Duration(seconds: 1)) //snackbar
          .then((_) => _showSnackBar('Sem Novos Recebimentos...'));
    else
      new Future.delayed(const Duration(seconds: 1)) //snackbar
          .then((_) => _showSnackBar('Carregando...')); //snackbar

    if (res.body.length > 2) {
      if (res.statusCode == 200) {
        // converte a lista de consulta em uma lista dinamica
        List list = json.decode(res.body).cast<Map<String, dynamic>>();
        print(list[0]);
        //Meus_recebimentos = list;
        for (var i = 0; i < list.length; i++)
          Basicos.meus_recebimentos.add(list[i]);
        listaRecebimentos.sink.add(Basicos.meus_recebimentos);
        return list;
      }
    }
  }
}

// ignore: must_be_immutable
class showList extends StatefulWidget {
  final sessao;
  final recebimento_numero;
  final recebimento_total;
  final recebimento_data;
  final recebimento_status;
  final recebimento_qtd;
  final num_pedido;
  final cliente;
  final frete;

  showList({
    this.recebimento_numero,
    this.recebimento_status,
    this.recebimento_total,
    this.recebimento_qtd,
    this.recebimento_data,
    this.num_pedido,
    this.cliente,
    this.frete,
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
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          // aqui temos passagem de valores id cliente(sessao) de login para home
          builder: (context) => new Detalhe_Recebimento2(
              id_sessao: widget.sessao,
              frete: widget.frete,
              id_recebimento: widget.recebimento_numero,
              data_pedido: widget.recebimento_data.toString().substring(0, 10)),
        ));
      },
      child: Card(
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
                    widget.recebimento_numero,
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
                    inverte_data(widget.recebimento_data
                            .toString()
                            .substring(0, 10)) +
                        '    ',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                  ),
                  //===========sessao cor do produto

                  Expanded(
                    child: new Text(
                      "Total + Frete: ",
                      textAlign: TextAlign.left,
                      softWrap: true,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: Colors.black.withOpacity(0.4)),
                    ),
                  ),

                  // new Container(
                  // alignment: Alignment.topLeft,
                  //posiciona o texto
                  Expanded(
                    child: new Text(
                      totalPedido(), //"R\$" +
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Text(
                      "Frete: ",
                      textAlign: TextAlign.left,
                      softWrap: true,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: Colors.black.withOpacity(0.4)),
                    ),
                    Text(
                      widget.frete.toString(), //"R\$" +
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
              ),

// dados recebimentos
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
                    widget.num_pedido.toString(),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        color: Colors.black),
                  ),
                  Text(
                    "       Cliente: ",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        color: Colors.black.withOpacity(0.4)),
                  ),
                  Expanded(
                    child: Text(widget.cliente,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                            color: Colors.black)),
                  ),
                ],
              ),
              //============================ sessao preco produto
              Row(
                children: <Widget>[
                  new Text(
                    "Situação:",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        color: Colors.black.withOpacity(0.4)),
                  ),
                ],
              ),
//            Row(
//              children: <Widget>[
              new DropdownButton<Status>(
                hint: Text(widget.recebimento_status),
                value: _currentState,
                onChanged: (Status newValue) {
                  setState(() {
                    // verificar se o recebimento for colocado como pago se o pedido foi entregue
                    grava_status(widget.recebimento_numero, newValue.name);
                    Toast.show(
                        "Atualizando Situação \n do Recebimento: " +
                            widget.recebimento_numero,
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
                      textAlign: TextAlign.center,
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
        ),
      ),
    );
  }

  String totalPedido() {
    double total;
    try {
      total =
          double.parse(widget.recebimento_total) + double.parse(widget.frete);
      return total.toStringAsFixed(2);
    } catch (e) {
      return widget.recebimento_total.toStringAsFixed(2);
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
}

Future<String> grava_status(final numero_recebimento, final situacao) async {
  String link = Basicos.codifica("${Basicos.ip}"
      "/crud/?crud=consult58.${numero_recebimento},${situacao}");
  //print(situacao);
  var res = await http
      .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
  //print(res.body);
  //var res =Basicos.decodifica(res1.body);
  if (res.body.length > 2) {
    if (res.statusCode == 200) {
      // converte a lista de consulta em uma lista dinamica
      //  List list = json.decode(res.body).cast<Map<String, dynamic>>();
      //Meus_recebimentos = list;

      // for (var i = 0; i < list.length; i++) Basicos.meus_recebimentos.add(list[i]);

      return 'sucesso';
    }
  }
}

class Status {
  const Status(this.name);

  final String name;
}
