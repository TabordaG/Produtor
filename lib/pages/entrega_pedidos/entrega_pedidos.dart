import 'package:produtor/pages/chat/chats.dart';
import 'package:produtor/pages/entrega_pedidos/Entrega_Pedidos_detalhes.dart';
import 'package:produtor/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:produtor/pages/dados_basicos.dart';
import 'package:produtor/pages/relatorio/relatorio_page.dart';
import 'package:toast/toast.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../soft_buttom.dart';
import '../caixa.dart';

double initialScrollOffsetPedidos = 0;

class EntregaPedidoPage extends StatefulWidget {
  final id_sessao;
  var contemLista;
  String selectedStatus;

  @override
  _EntregaPedidoPageState createState() => _EntregaPedidoPageState();

  EntregaPedidoPage({this.id_sessao, this.contemLista, this.selectedStatus});
}

class _EntregaPedidoPageState extends State<EntregaPedidoPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey(); // snackbar
  TextEditingController _buscarPedidosController = TextEditingController();
  StreamController pedidosStream;

  double _top = -60;
  bool isSearch = false, showSearch = false;

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
        !_controller.position.outOfRange &&
        showSearch == false) {
      setState(() {
        if (Basicos.offset <= Basicos.meus_pedidos.length) {
          //atualiza pagina com offset
          Basicos.pagina = _controller.offset;
          // aumenta o offset da consulta no banco
          Basicos.offset = Basicos.offset +
              10; //preenche o grid com a quantidade lida do banco menos dois uma fileira
          print(
              'Length pedidos: ${Basicos.meus_pedidos.length}    Length offset: ${Basicos.offset}');
          if (widget.selectedStatus == 'Todos')
            listPedidos();
          else
            listPedidosStatus();
        } else
          Basicos.offset = Basicos.meus_pedidos.length;
      });
    }
    initialScrollOffsetPedidos = _controller.offset;
  }

  @override
  void initState() {
    if (!indexBottom[3]) {
      setState(() {
        indexBottom[0] = false;
        indexBottom[1] = false;
        indexBottom[2] = false;
        indexBottom[3] = true;
      });
    }
    if (widget.selectedStatus == null) {
      widget.selectedStatus = 'Todos';
    }
    pedidosStream = StreamController();
    Future.delayed(Duration(milliseconds: 250), () {
      setState(() {
        _top = 0;
      });
    });
    _controller = ScrollController(
        // initialScrollOffset: initialScrollOffsetPedidos,
        );
    _controller.addListener(_scrollListener);
    if (widget.contemLista != null) {
      if (widget.selectedStatus == 'Todos') {
        print('Entrou aqui Todos');
        listPedidosInicial();
      } else {
        print('Entrou aqui Outro');
        listPedidosStatus();
      }
    } else
      listPedidos();
    super.initState();
    // refresh_List();
    // refresh_db();
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    pedidosStream.close();
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
    //print("Inicial: ${widget.items[2].pedido_status} Tamanho: ${andamento.length}");
    //refresh_List();
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
                              padding: EdgeInsets.only(
                                  left: 20, top: 10, right: 0, bottom: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 20,
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Pedidos',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Align(
                                      alignment: Alignment.centerRight,
                                      child: PopupMenuButton(
                                        elevation: 3.2,
                                        initialValue: widget.selectedStatus,
                                        offset: Offset(0, 100),
                                        onSelected: (status) {
                                          setState(() {
                                            widget.selectedStatus = status;
                                            Basicos.offset = 0;
                                            Basicos.meus_pedidos = [];
                                            pedidosStream.sink
                                                .add(Basicos.meus_pedidos);
                                          });
                                          if (widget.selectedStatus ==
                                              'Todos') {
                                            listPedidos();
                                          } else {
                                            listPedidosStatus();
                                          }
                                        },
                                        itemBuilder: (BuildContext context) {
                                          return [
                                            'Todos',
                                            'EM ANDAMENTO',
                                            'CONCLUIDO NAO ENTREGUE',
                                            'CONCLUIDO ENTREGUE',
                                            'CANCELADO'
                                          ].map((status) {
                                            return PopupMenuItem(
                                              value: status,
                                              child: Text(status),
                                            );
                                          }).toList();
                                        },
                                      )
                                      // child: IconButton(
                                      //   icon: Icon(Icons.more_vert),
                                      //   onPressed: () {

                                      //   },
                                      // ),
                                      ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Scrollbar(
                                // controller: _controller,
                                child: StreamBuilder<Object>(
                                    stream: pedidosStream.stream,
                                    builder: (context, snapshot) {
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.waiting:
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        default:
                                          List listaPedidos = snapshot.data;
                                          if ((listaPedidos == null ||
                                                  listaPedidos.isEmpty) &&
                                              showSearch) {
                                            return Center(
                                              child: Text(
                                                'Cliente não encontrado.\n'
                                                'Carregue mais pedidos para\n'
                                                'aumentar a área de busca.',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontFamily: "Poppins",
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            );
                                          }
                                          return ListView.builder(
                                              controller: _controller,
                                              itemCount: listaPedidos.length,
                                              itemBuilder: (context, index) {
                                                // print(listaPedidos[index]);
                                                return showList(
                                                  scrollList:
                                                      _controller.offset,
                                                  pedido_total:
                                                      listaPedidos[index]
                                                          ["valor_total"],
                                                  pedido_status:
                                                      listaPedidos[index]
                                                          ["status_pedido"],
                                                  pedido_qtd:
                                                      listaPedidos[index]
                                                          ["quantidade"],
                                                  pedido_numero:
                                                      listaPedidos[index]["id"]
                                                          .toString(),
                                                  pedido_data:
                                                      listaPedidos[index]
                                                          ["data_registro"],
                                                  pedido_nome_cliente:
                                                      listaPedidos[index]
                                                          ['nome'],
                                                  sessao: widget.id_sessao,
                                                  id_cliente:
                                                      listaPedidos[index]
                                                          ['cliente_id'],
                                                  // dados entrega
                                                  endereco: listaPedidos[index]
                                                      ['endereco'],
                                                  bairro: listaPedidos[index]
                                                      ['bairro'],
                                                  cidade: listaPedidos[index]
                                                      ['cidade'],
                                                  cep: listaPedidos[index]
                                                      ['cep'],
                                                  estado: listaPedidos[index]
                                                      ['estado'],
                                                  observacoes:
                                                      listaPedidos[index]
                                                          ['observacoes'],
                                                  sobre_nome:
                                                      listaPedidos[index]
                                                          ['sobre_nome'],
                                                  numero: listaPedidos[index]
                                                      ['numero'],
                                                  complemento:
                                                      listaPedidos[index]
                                                          ['complemento'],
                                                  celular: listaPedidos[index]
                                                      ['celular'],
                                                  tipo_entrega:
                                                      listaPedidos[index]
                                                          ['tipo_entrega'],
                                                  frete: listaPedidos[index]
                                                      ['frete'],
                                                  selectedStatus:
                                                      widget.selectedStatus,
                                                );
                                              });
                                      }
                                    }),
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
                              initialScrollOffsetPedidos = 0;
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
                              initialScrollOffsetPedidos = 0;
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
                              initialScrollOffsetPedidos = 0;
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
                              initialScrollOffsetPedidos = 0;
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
                        initialScrollOffsetPedidos = 0;
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
              AnimatedPositioned(
                duration: Duration(milliseconds: 250),
                top: _top,
                right: 80,
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 60),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOutCubic,
                    height: 45,
                    width: isSearch
                        ? MediaQuery.of(context).size.width - (85 + 60)
                        : 5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black54,
                            offset: Offset(8, 6),
                            blurRadius: 12),
                        BoxShadow(
                            color: Colors.white,
                            offset: Offset(-8, -6),
                            blurRadius: 12),
                      ],
                    ),
                    child: isSearch
                        ? Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 40.0),
                            child: TextFormField(
                              controller: _buscarPedidosController,
                              decoration: InputDecoration(
                                hintText: "Buscar pedidos carregados",
                                border: InputBorder.none,
                                counterText:
                                    "", // remove os numero do contador do maxleng
                              ),
                              maxLength: 50,
                              // validator: (value) {
                              //   if (value.isEmpty) {
                              //     return "O Nome não pode ficar em branco";
                              //   } else {
                              //     if (value.length > 50) {
                              //       return "O nome deve ter comprimento máximo de 50 caracteres";
                              //     }
                              //   }
                              //   return null;
                              // },
                            ),
                          )
                        : Container(),
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: Duration(milliseconds: 250),
                top: _top + 10,
                right: isSearch ? 100 : 50,
                child: IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    _buscarPedidosController.clear();
                    Basicos.offset = 0;
                    Basicos.meus_pedidos = [];
                    pedidosStream.sink.add(Basicos.meus_pedidos);
                    setState(() {
                      isSearch = !isSearch;
                    });
                    if (widget.selectedStatus != 'Todos')
                      setState(() {
                        listPedidosStatus();
                      });
                    else
                      setState(() {
                        listPedidos();
                      });
                  },
                ),
              ),
              AnimatedPositioned(
                duration: Duration(milliseconds: 250),
                top: _top,
                right: 50,
                child: CircularSoftButton(
                  icon: IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Colors.black,
                        size: 28,
                      ),
                      onPressed: () {
                        if (_buscarPedidosController.text.isEmpty) {
                          setState(() {
                            isSearch = !isSearch;
                          });
                        } else {
                          buscarPedidosCarregados();
                        }
                      }),
                  radius: 22,
                ),
              ),
              AnimatedPositioned(
                duration: Duration(milliseconds: 250),
                top: _top,
                right: 0,
                child: CircularSoftButton(
                  icon: IconButton(
                      icon: Icon(
                        Icons.receipt,
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
                              builder: (context) => RelatorioPage(
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
        //onRefresh: refresh_db,
      ),
    );
  }

  buscarPedidosCarregados() async {
    List list = [];
    showSearch = true;
    Basicos.meus_pedidos.forEach((element) {
      String nome = element['nome'];
      print('$nome \n');
      if (nome
          .toLowerCase()
          .contains(_buscarPedidosController.text.toLowerCase()))
        list.add(element);
    });
    // Basicos.meus_pedidos = [];
    circular('inicio');
    await Future.delayed(Duration(seconds: 1));
    circular('fim');
    // Basicos.meus_pedidos = list;
    // pedidosStream.sink.add([]);
    pedidosStream.sink.add(list);
  }

  // Lista itens da cesta
  Future<List> listPedidos() async {
    showSearch = false;
    String link = Basicos.codifica("${Basicos.ip}"
        "/crud/?crud=consult49.${widget.id_sessao},10,${Basicos.offset}");
    var res = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    //print(res.body);
    //print('/crud/?crud=consult49.${widget.id_sessao},10,${Basicos.offset}');
    //var res =Basicos.decodifica(res1.body);

    if (res.body.length == 2)
      new Future.delayed(const Duration(seconds: 1)) //snackbar
          .then((_) => _showSnackBar('Sem Novos Pedidos...'));
    else
      new Future.delayed(const Duration(seconds: 1)) //snackbar
          .then((_) => _showSnackBar('Carregando...')); //snackbar

    if (res.body.length > 2) {
      if (res.statusCode == 200) {
        // converte a lista de consulta em uma lista dinamica
        List list = json.decode(res.body).cast<Map<String, dynamic>>();
        // print(list[0]);
        //Meus_pedidos = list;
        if (widget.contemLista != null) {
          print('Entrou aqui ###### ${widget.contemLista}');
          Basicos.meus_pedidos = [];
          setState(() {
            widget.contemLista = null;
          });
        }

        for (var i = 0; i < list.length; i++) Basicos.meus_pedidos.add(list[i]);
        pedidosStream.sink.add(Basicos.meus_pedidos);
        return list;
      }
    }
  }

  Future<List> listPedidosStatus() async {
    showSearch = false;
    String link;
    if (widget.contemLista != null) {
      link = Basicos.codifica("${Basicos.ip}"
          "/crud/?crud=consul109.${widget.selectedStatus}, ${widget.id_sessao},${Basicos.meus_pedidos.length},0");
    } else {
      link = Basicos.codifica("${Basicos.ip}"
          "/crud/?crud=consul109.${widget.selectedStatus}, ${widget.id_sessao},10,${Basicos.offset}");
    }
    var res = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    //print(res.body);
    //print('/crud/?crud=consult49.${widget.id_sessao},10,${Basicos.offset}');
    //var res =Basicos.decodifica(res1.body);

    if (res.body.length == 2)
      new Future.delayed(const Duration(seconds: 1)) //snackbar
          .then((_) => _showSnackBar('Sem Novos Pedidos...'));
    else
      new Future.delayed(const Duration(seconds: 1)) //snackbar
          .then((_) => _showSnackBar('Carregando...')); //snackbar
    print(res.statusCode);
    if (res.body.length > 2) {
      if (res.statusCode == 200) {
        // converte a lista de consulta em uma lista dinamica
        List list = json.decode(res.body).cast<Map<String, dynamic>>();
        print(list);
        //Meus_pedidos = list;
        if (widget.contemLista != null) {
          print('Entrou aqui ###### ${widget.contemLista}');
          Basicos.meus_pedidos = [];
        }

        for (var i = 0; i < list.length; i++) Basicos.meus_pedidos.add(list[i]);
        pedidosStream.sink.add(Basicos.meus_pedidos);

        if (widget.contemLista != null) {
          circular('inicio');
          Future.delayed(Duration(milliseconds: 250), () {
            _controller.animateTo(initialScrollOffsetPedidos,
                duration: Duration(milliseconds: 250),
                curve: Curves
                    .ease); //_controller.jumpTo(initialScrollOffsetPedidos);
            setState(() {
              widget.contemLista = null;
            });
            // _controller.animateTo(initialScrollOffsetPedidos, duration: Duration(milliseconds: 250), curve: Curves.ease);
          });
          circular('fim');
        }
        return list;
      }
    }
  }

  // Lista itens da cesta
  Future<List> listPedidosInicial() async {
    showSearch = false;
    String link = Basicos.codifica("${Basicos.ip}"
        "/crud/?crud=consult49.${widget.id_sessao},${Basicos.meus_pedidos.length},0");
    var res = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    //print(res.body);
    //print('/crud/?crud=consult49.${widget.id_sessao},10,${Basicos.offset}');
    //var res =Basicos.decodifica(res1.body);

    // if (res.body.length == 2)
    //   new Future.delayed(const Duration(seconds: 1)) //snackbar
    //       .then((_) => _showSnackBar('Sem Novos Pedidos...'));
    // else
    //   new Future.delayed(const Duration(seconds: 1)) //snackbar
    //       .then((_) => _showSnackBar('Carregando...')); //snackbar

    if (res.body.length > 2) {
      if (res.statusCode == 200) {
        // converte a lista de consulta em uma lista dinamica
        List list = json.decode(res.body).cast<Map<String, dynamic>>();
        // print(list[0]);
        Basicos.meus_pedidos = [];
        for (var i = 0; i < list.length; i++) Basicos.meus_pedidos.add(list[i]);
        pedidosStream.sink.add(Basicos.meus_pedidos);
        setState(() {
          widget.contemLista = null;
          Basicos.offset = Basicos.meus_pedidos.length - 10;
        });

        circular('inicio');
        await Future.delayed(Duration(milliseconds: 250), () {
          // _controller.jumpTo(initialScrollOffsetPedidos);
          _controller.animateTo(initialScrollOffsetPedidos,
              duration: Duration(milliseconds: 250), curve: Curves.ease);
        });
        circular('fim');
        return list;
      }
    }
  }

  void circular(String tipo) {
    if (tipo == 'inicio') {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Dialog(
          child: new Container(
            color: Colors.black,
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Text(
                  'carregando',
                  style: new TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                new CircularProgressIndicator(),
                // new Text("Carrengando ..."),
              ],
            ),
          ),
        ),
      );
    } else
      Navigator.pop(context);
  }
}

// ignore: must_be_immutable
class showList extends StatefulWidget {
  final sessao;
  final pedido_numero;
  final pedido_total;
  final pedido_data;
  final pedido_status;
  final pedido_qtd;
  final pedido_nome_cliente;
  final id_cliente;
  final endereco;
  final bairro;
  final cidade;
  final cep;
  final estado;
  final observacoes;
  final sobre_nome;
  final numero;
  final complemento;
  final celular;
  final tipo_entrega;
  final frete;
  final scrollList;
  String selectedStatus;

  showList(
      {this.pedido_numero,
      this.pedido_status,
      this.pedido_total,
      this.pedido_qtd,
      this.pedido_data,
      this.pedido_nome_cliente,
      this.sessao,
      this.id_cliente,
      this.endereco,
      this.bairro,
      this.cidade,
      this.cep,
      this.estado,
      this.observacoes,
      this.sobre_nome,
      this.numero,
      this.complemento,
      this.celular,
      this.tipo_entrega,
      this.frete,
      this.scrollList,
      this.selectedStatus});

  @override
  _showListState createState() => _showListState();
}

// ignore: camel_case_types
class _showListState extends State<showList> {
  @override
  void initState() {
    super.initState();
  }

  final TextEditingController _controller = TextEditingController();
  Status _currentState;

  List<Status> status = <Status>[
    const Status("EM ANDAMENTO"),
    const Status('CONCLUIDO NAO ENTREGUE'),
    const Status('CONCLUIDO ENTREGUE'),
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
                      fontWeight: FontWeight.normal,
                      fontSize: 14.0,
                      color: Colors.grey),
                ),
                Text(
                  widget.pedido_numero,
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
                        fontWeight: FontWeight.normal,
                        fontSize: 14.0,
                        color: Colors.grey),
                  ),
                ),
                //tanho das letra no lista de produtos
                Expanded(
                  child: Text(
                    inverte_data(
                        widget.pedido_data.toString().substring(0, 10)),
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                  ),
                ),
                //===========sessao cor do produto
                Expanded(
                  child: new Text(
                    "   Total: ",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14.0,
                        color: Colors.grey),
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
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            //============================ sessao preco produto
            Row(
              children: <Widget>[
                //Expanded(
                new Text(
                  "Situação:        Cliente: ",
                  //textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14.0,
                      color: Colors.grey),
                ),
                Expanded(
                  child: Text(
                    widget.pedido_nome_cliente,
                    //textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                        color: Colors.black),
                  ),
                ), //ajusta quebra de linha
              ],
            ),
//            Row(
//              children: <Widget>[
            new DropdownButton<Status>(
              hint: Text(widget.pedido_status),
              value: _currentState,
              onChanged: (Status newValue) {
                setState(() {
                  grava_status(widget.pedido_numero, newValue.name);
                  Toast.show(
                      "Atualizando Situação \n do Pedido: " +
                          widget.pedido_numero,
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
                fontSize: 16,
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: new MaterialButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        // user must tap button for close dialog!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Enviar Uma Menssagem ao Cliente: ' +
                                '${widget.pedido_nome_cliente}'),
                            content: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Card(
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                color: Color(
                                    0xFFeceff3), //Color(0xFFf8faf8).withOpacity(1),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: TextField(
                                          controller: _controller,
                                          decoration: InputDecoration.collapsed(
                                              hintText: 'Enviar Mensagem'),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.send,
                                        color: Color(0xFF004d4d),
                                      ),
                                      onPressed: () {
                                        _sendMessage(_controller.text,
                                            widget.sessao, widget.id_cliente);
                                        initialScrollOffsetPedidos = 0;
                                        Basicos.offset = 0;
                                        Basicos.product_list = [];
                                        Basicos.meus_pedidos = [];
                                        //Basicos.buscar_produto_home = ''; // limpa pesquisa
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ChatsPage(
                                                id_sessao: widget.sessao),
                                          ),
                                        );
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: const Text('Cancela',
                                    style: TextStyle(color: Colors.teal)),
                                onPressed: () {
                                  _controller.text = '';
                                  Navigator.of(context).pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: new Text(
                      "Falar Com Cliente",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    color: Color(0xFF012f7a),
                  ),
                ),
                Text(
                  "   ",
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                Expanded(
                  child: new MaterialButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        // user must tap button for close dialog!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Dados do Cliente: '),
                            content: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: 150.0,
                                maxHeight: 280.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    '${widget.pedido_nome_cliente}' +
                                        ' ${widget.sobre_nome}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(bottom: 5.0)),
                                  Text(
                                    '${widget.endereco}, ${widget.numero} - ${widget.bairro}, '
                                    '\n${widget.cidade} - ${widget.estado}, \n${widget.cep}',
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(),
                                    flex: 1,
                                  ),
                                  Text(
                                    'Complemento:',
                                    style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: Text(
                                      widget.complemento.isNotEmpty
                                          ? '${widget.complemento}'
                                          : 'Não há complemento',
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(),
                                    flex: 2,
                                  ),
                                  Text(
                                    'Celular: ${widget.celular}',
                                    style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(bottom: 5.0)),
//                                  Row(
//                                    mainAxisAlignment:
//                                        MainAxisAlignment.spaceBetween,
//                                    children: <Widget>[
//                                      Text(
//                                        'Sexo: ${cliente.sexo}',
//                                        style: const TextStyle(
//                                            fontSize: 15.0,
//                                            color: Colors.black87),
//                                      ),
//                                      Text(
//                                        'Idade: ${calcularIdade(cliente.dataNascimento)}',
//                                        style: const TextStyle(
//                                          fontSize: 15.0,
//                                          color: Colors.black,
//                                        ),
//                                      ),
//                                    ],
//                                  ),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text(
                                  'Fechar',
                                  style: TextStyle(color: Colors.teal),
                                ),
                                onPressed: () {
                                  _controller.text = '';
                                  Navigator.of(context).pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: new Text(
                      " Endereço",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    color: Color(0xFF004d4d),
                  ),
                ),
              ],
            )
          ],
          //           )
        ),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () {
          // print(initialScrollOffsetPedidos);
          // initialScrollOffsetPedidos = widget.scrollList;
          Navigator.of(context).push(new MaterialPageRoute(
            // aqui temos passagem de valores id cliente(sessao) de login para home
            builder: (context) => new Detalhe_Entrega(
              id_sessao: widget.sessao,
              id_pedido: widget.pedido_numero,
              frete: widget.frete,
              tipo_entrega: widget.tipo_entrega,
              endereco: widget.endereco,
              numero: widget.numero,
              bairro: widget.bairro,
              cidade: widget.cidade,
              estado: widget.estado,
              complemento: widget.complemento,
              cep: widget.cep,
              nome: widget.pedido_nome_cliente,
              sobre_nome: widget.sobre_nome,
              selectedStatus: widget.selectedStatus,
              data_pedido:
                  inverte_data(widget.pedido_data.toString().substring(0, 10)),
            ),
          ));
        },
      ),
    );
  }

  String totalPedido() {
    double total;
    try {
      total = double.parse(widget.pedido_total) + double.parse(widget.frete);
      return total.toStringAsFixed(2);
    } catch (e) {
      return widget.pedido_total;
    }
  }

  //  Adiciona a nova mensagem no banco
  Future<List> _sendMessage(String text, _id_produtor, _id_cliente) async {
    // insere no banco de dados
    //Inserir mensagem ###############################################
    String link2 = Basicos.codifica("${Basicos.ip}/crud/?crud=consult74."
        "${text}," //    msg text NOT NULL,
        "Produtor-Cliente,"
        "Enviado,"
        //    data_envio timestamp with time zone NOT NULL,
        //    data_leitura timestamp with time zone NOT NULL,
        "${_id_cliente}," //    cliente_id integer NOT NULL,
        "${_id_produtor}," //    produtor_id integer NOT NULL,
        );
    var res2 = await http
        .get(Uri.encodeFull(link2), headers: {"Accept": "application/json"});
    var res3 = Basicos.decodifica(res2.body);
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

//Future<String> busca_cliente(String id) async {
//  String link2 = Basicos.codifica("${Basicos.ip}""/crud/?crud=consult22.${id}");
//  var res2 = await http.get(Uri.encodeFull(link2), headers: {"Accept": "application/json"});
//  if (res2.body.length > 2) {
//    if (res2.statusCode == 200) {
//      // converte a lista de consulta em uma lista dinamica
//      List list = json.decode(res2.body).cast<Map<String, dynamic>>();
//      //Meus_pedidos = list;
//      print(list);
//      return list[0]['razao_social'].toString();
//    }
//  }
//}

Future<String> grava_status(final numero_pedido, final situacao) async {
  String link = Basicos.codifica("${Basicos.ip}"
      "/crud/?crud=consult30.${numero_pedido},${situacao}");
  //print(situacao);
  var res = await http
      .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
  //print(res.body);
  //var res =Basicos.decodifica(res1.body);
  if (res.body.length > 2) {
    if (res.statusCode == 200) {
      // converte a lista de consulta em uma lista dinamica
      //  List list = json.decode(res.body).cast<Map<String, dynamic>>();
      //Meus_pedidos = list;

      // for (var i = 0; i < list.length; i++) Basicos.meus_pedidos.add(list[i]);

      return 'sucesso';
    }
  }
}

class Status {
  const Status(this.name);

  final String name;
}
