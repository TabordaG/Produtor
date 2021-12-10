import 'package:produtor/pages/atualiza_cadastro/dados_cadastrais.dart';
import 'package:produtor/pages/colaboradores/ragistrar_colaborador.dart';
import 'package:flutter/material.dart';
import 'package:produtor/pages/produtos/cadastro_produto.dart';
import 'package:produtor/pages/entrega_pedidos/entrega_pedidos.dart';
import 'package:badges/badges.dart';
import 'package:produtor/pages/dados_basicos.dart';
import 'package:produtor/pages/estoque/estoque_abas.dart';
import 'package:produtor/pages/pagamentos/pagamentos.dart';
import 'package:produtor/pages/recebimentos/recebimentos.dart';
import 'package:produtor/pages/caixa.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:produtor/pages/sobre.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:produtor/pages/login.dart';
import '../menu_item.dart';
import 'chat/chats.dart';
import 'entrega_pedidos/Entrega_Pedidos_detalhes.dart';
import 'fornecedores.dart';
import 'package:url_launcher/url_launcher.dart';

List<bool> indexBottom = [false, false, false, false];
String qtd_chat = ""; //quantidade de msg no chat

class home2 extends StatefulWidget {
  final id_sessao;

  home2({
    this.id_sessao,
  }); // id_cliente da sessao
  @override
  void initState() {}

  _homeState2 createState() => _homeState2();
}

class _homeState2 extends State<home2> with TickerProviderStateMixin {
  bool _isExpanded = false;
  double _rightPadding = 20;
  AnimationController _controller;
  StreamController streamCestas;

  List prod_list = [
    {'email': 'email'},
    {'nome_razao_social': 'nome'}
  ];
  List lista_cestas = [
    {'id': 'id_pedido'},
    {'data_registro': 'data_registro'},
    {'valor_total': 'valor_total'},
    {'quantidade': '0.0'},
    {'status_pedido': 'status_pedido'},
    {'cliente_id': 'cliente_id'},
    {'nome_razao_social': 'nome_cliente'},
  ];

  TabController _tabController;
  int index_tab = 0;
  int num_cestas = 0;
  String msg_cestas = '';

  bool _chatbadge = false;

  void initState() {
    if (!indexBottom[0]) {
      setState(() {
        indexBottom[0] = true;
        indexBottom[1] = false;
        indexBottom[2] = false;
        indexBottom[3] = false;
      });
    }
    streamCestas = StreamController();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    busca_empresa().then((resultado) {
      setState(() {});
    });
    busca_cestas().then((resultado) {
      setState(() {});
    });
    busca_msg_chat().then((resultado) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    streamCestas.close();
    super.dispose();
  }

  Future<bool> onWillPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFF004d4d), //or set color with: Color(0xFF0000FF)
    ));
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 60.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20, top: 50, right: 20, bottom: 10),
                        child: Text(
                          "Agricultor Recoopsol",
                          //"Simple way to find \nTasty food",
                          style: TextStyle(
                            fontSize: 28,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      thickness: .2,
                      color: Color(0xFF004d4d),
                      indent: 20,
                      endIndent: 20,
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          AnimatedContainer(
                            duration: Duration(milliseconds: 500),
                            height: num_cestas != 0 ? 125.0 : 40,
                            child: StreamBuilder(
                                stream: streamCestas.stream,
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    default:
                                      List lista = snapshot.data;
                                      if (lista.length == 0) {
                                        return Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Center(
                                            child: Text(
                                              msg_cestas,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontStyle: FontStyle.italic,
                                                //fontWeight: FontWeight.bold,
                                                color: Colors.teal,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      return ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: num_cestas,
                                        itemBuilder: (context, index) {
                                          return PedidosAtivos(
                                            index: index,
                                            image_location:
                                                'images/cestas/hortefrute.png',
                                            image_description: 'R\$ ' +
                                                lista[index]['valor_total']
                                                    .toString() +
                                                '\n' +
                                                inverte_data(lista[index]
                                                        ['data_registro']
                                                    .toString()),
                                            image_caption: '#' +
                                                lista[index]['id'].toString() +
                                                ' ' +
                                                '${lista[index]['nome_razao_social'].toString().length > 7 ? lista[index]['nome_razao_social'].toString().substring(0, 7) : lista[index]['nome_razao_social'].toString()}',
                                            qtd: lista[index]['quantidade']
                                                .toString(),
                                            id_sessao: widget.id_sessao,
                                            id_pedido:
                                                lista[index]['id'].toString(),
                                            data_registro: lista[index]
                                                    ['data_registro']
                                                .toString(),
                                          );
                                        },
                                      );
                                  }
                                }),
                          ),
                          Divider(
                            thickness: .2,
                            color: Color(0xFF004d4d),
                            indent: 20,
                            endIndent: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20, top: 10, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  flex: 9,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24.0),
                                    ),
                                    elevation: 4,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                        color: Colors.white,
                                      ),
                                      height: 160,
                                      child: ListTile(
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.note_add,
                                              color: Colors.teal,
                                              size: 45,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              'Cadastro De Produto',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              'Novo Produto',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(new MaterialPageRoute(
                                            // aqui temos passagem de valores id cliente(sessao) de login para home
                                            builder: (context) =>
                                                new cadastroProduto2(
                                                    id_sessao:
                                                        widget.id_sessao),
                                          ));
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(flex: 1, child: Container()),
                                Expanded(
                                  flex: 9,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24.0),
                                    ),
                                    elevation: 4,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                        color: Colors.white,
                                      ),
                                      height: 160,
                                      child: ListTile(
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.playlist_add_check,
                                              color: Colors.teal,
                                              size: 45,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              'Estoque',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              'Editar Produto',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          Basicos.offset = 0;
                                          Basicos.product_list = [];
                                          Basicos.meus_pagamentos = [];
                                          Navigator.of(context)
                                              .push(new MaterialPageRoute(
                                            // aqui temos passagem de valores id cliente(sessao) de login para home
                                            builder: (context) =>
                                                new estoque_Abas(
                                                    id_sessao:
                                                        widget.id_sessao),
                                          ));
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  flex: 9,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24.0),
                                    ),
                                    elevation: 4,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                        color: Colors.white,
                                      ),
                                      height: 160,
                                      child: ListTile(
                                        //  leading: Icon(Icons.wb_sunny),
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.money_off,
                                              color: Colors.teal,
                                              size: 45,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              'Recebimentos',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              'Situação De Pedidos',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          Basicos.offset = 0;
                                          Basicos.product_list = [];
                                          Basicos.meus_pagamentos = [];
                                          Navigator.of(context)
                                              .push(new MaterialPageRoute(
                                            // aqui temos passagem de valores id cliente(sessao) de login para home
                                            builder: (context) =>
                                                new RecebimentosPage2(
                                                    id_sessao:
                                                        widget.id_sessao),
                                          ));
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(flex: 1, child: Container()),
                                Expanded(
                                  flex: 9,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24.0),
                                    ),
                                    elevation: 4,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                        color: Colors.white,
                                      ),
                                      height: 160,
                                      child: ListTile(
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.payment,
                                              color: Colors.teal,
                                              size: 45,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              'Pagamentos',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              'Contas',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          Basicos.offset = 0;
                                          Basicos.product_list = [];
                                          Basicos.meus_pagamentos = [];
                                          Navigator.of(context)
                                              .push(new MaterialPageRoute(
                                            // aqui temos passagem de valores id cliente(sessao) de login para home
                                            builder: (context) =>
                                                new PagamentosPage2(
                                                    id_sessao:
                                                        widget.id_sessao),
                                          ));
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20, bottom: 5),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              elevation: 4,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  color: Colors.white,
                                ),
                                height: 75,
                                width: double.infinity,
                                child: Center(
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.group,
                                      color: Colors.teal,
                                      size: 45,
                                    ),
                                    title: Text(
                                      'Colaboradores',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Registro e Ativação',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(new MaterialPageRoute(
                                        // aqui temos passagem de valores id cliente(sessao) de login para home
                                        builder: (context) =>
                                            new RegistrarColaborador(
                                                id_sessao: widget.id_sessao),
                                      ));
                                    },
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
                              index_tab = 1;
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
                              index_tab = 1;
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
                top: -23,
                bottom: 0,
                left: _isExpanded ? 0 : -MediaQuery.of(context).size.width - 55,
                duration: Duration(milliseconds: 600), //800
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 600), //800
                  curve: Curves.easeInQuint,
                  opacity: _isExpanded ? 1 : 0,
                  child: GestureDetector(
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width - 55,
                          color: Color(
                              0xFF004d4d), // Colors.black.withOpacity(.9), //Color(0xFF262AAA),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 50,
                              ),
                              ListTile(
                                onTap: () async {
                                  String tipo = await consulta_tipo();
                                  // print(tipo);
                                  if (tipo == 'PESSOA_FISICA') {
                                    Navigator.of(context)
                                        .push(new MaterialPageRoute(
                                      // aqui temos passagem de valores id cliente(sessao) de login para home
                                      builder: (context) =>
                                          new Dados_Cadastrais(
                                              id_sessao: widget.id_sessao),
                                    ));
                                  }
                                },
                                title: Text(
                                  '${prod_list[0]['razao_social'].toString()}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline
                                      .copyWith(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                ),
                                subtitle: RichText(
                                  text: TextSpan(
                                    children: <InlineSpan>[
                                      TextSpan(
                                        text:
                                            '${prod_list[0]['email'].toString()}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .button
                                            .copyWith(
                                                color: Colors.white70,
                                                fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                leading: CircleAvatar(
                                  child: Icon(
                                    Icons.perm_identity,
                                    color: Colors.white,
                                  ),
                                  backgroundColor: Colors.teal,
                                  radius: 40,
                                ),
                              ),
                              Divider(
                                height: 50,
                                thickness: 0.5,
                                color: Colors.white.withOpacity(.3),
                                indent: 32,
                                endIndent: 32,
                              ),
                              Expanded(
                                child: ListView(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  scrollDirection: Axis.vertical,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () async {
                                        String tipo = await consulta_tipo();
                                        // print(tipo);
                                        if (tipo == 'PESSOA_FISICA') {
                                          Navigator.of(context)
                                              .push(new MaterialPageRoute(
                                            // aqui temos passagem de valores id cliente(sessao) de login para home
                                            builder: (context) =>
                                                new Dados_Cadastrais(
                                                    id_sessao:
                                                        widget.id_sessao),
                                          ));
                                        }
                                      },
                                      child: Container(
                                        width: 100,
                                        color: Colors.transparent,
                                        child: MenuItem(
                                          title: 'Dados Cadastrais',
                                          icon: Icons.person,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              Registrar_fornecedor_juridico(
                                                  id_sessao: widget.id_sessao),
                                        ));
                                      },
                                      child: Container(
                                        width: 100,
                                        color: Colors.transparent,
                                        child: MenuItem(
                                          icon: Icons.list,
                                          title: "Cadastro Fornecedor",
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => ChatsPage(
                                              id_sessao: widget.id_sessao),
                                        ));
                                      },
                                      child: Container(
                                        width: 100,
                                        color: Colors.transparent,
                                        child: MenuItem(
                                          icon: Icons.chat,
                                          title: "Chat",
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      height: 50,
                                      thickness: 0.5,
                                      color: Colors.white.withOpacity(.3),
                                      indent: 15,
                                      endIndent: 15,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => Sobre(
                                              id_sessao: widget.id_sessao),
                                        ));
                                      },
                                      child: Container(
                                        width: 100,
                                        color: Colors.transparent,
                                        child: MenuItem(
                                          icon: Icons.label,
                                          title: "Sobre",
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        const url =
                                            "http://recoopsol.ic.ufmt.br/index.php/ajuda-app/";
                                        if (await canLaunch(url)) {
                                          await launch(url);
                                        } else {
                                          throw 'erro $url';
                                        }
                                      },
                                      child: Container(
                                        width: 100,
                                        color: Colors.transparent,
                                        child: MenuItem(
                                          title: ('Ajuda'),
                                          icon: (Icons.help),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        SharedPreferences prefs2 =
                                            await SharedPreferences
                                                .getInstance();
                                        prefs2
                                            .remove('email'); // remove cookies
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Login()));
                                      },
                                      child: Container(
                                        width: 100,
                                        color: Colors.transparent,
                                        child: MenuItem(
                                          icon: Icons.exit_to_app,
                                          title: "Sair",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (!_isExpanded) {
                                  setState(() {
                                    _rightPadding =
                                        MediaQuery.of(context).size.width - 56;
                                  });
                                  Future.delayed(Duration(milliseconds: 200),
                                      () {
                                    _controller.forward();
                                  });
                                  Future.delayed(Duration(milliseconds: 800),
                                      () {
                                    setState(() {
                                      _isExpanded = true;
                                      _rightPadding = 20;
                                    });
                                  });
                                } else {
                                  setState(() {
                                    _isExpanded = false;
                                    _rightPadding =
                                        MediaQuery.of(context).size.width - 56;
                                  });
                                  Future.delayed(Duration(milliseconds: 800),
                                      () {
                                    setState(() {
                                      _rightPadding = 20;
                                    });
                                  });
                                  Future.delayed(Duration(milliseconds: 1000),
                                      () {
                                    _controller.reverse();
                                  });
                                }
                              },
                              onHorizontalDragStart: (details) {
                                if (!_isExpanded) {
                                  setState(() {
                                    _rightPadding =
                                        MediaQuery.of(context).size.width - 56;
                                  });
                                  Future.delayed(Duration(milliseconds: 200),
                                      () {
                                    _controller.forward();
                                  });
                                  Future.delayed(Duration(milliseconds: 800),
                                      () {
                                    setState(() {
                                      _isExpanded = true;
                                      _rightPadding = 20;
                                    });
                                  });
                                } else {
                                  setState(() {
                                    _isExpanded = false;
                                    _rightPadding =
                                        MediaQuery.of(context).size.width - 56;
                                  });
                                  Future.delayed(Duration(milliseconds: 800),
                                      () {
                                    setState(() {
                                      _rightPadding = 20;
                                    });
                                  });
                                  Future.delayed(Duration(milliseconds: 1000),
                                      () {
                                    _controller.reverse();
                                  });
                                }
                              },
                              child: Container(
                                height: MediaQuery.of(context).size.height,
                                width: 56,
                                color: Colors.white12,
                              ),
                            ),
                            Align(
                              alignment: Alignment(0, -.99),
                              child: ClipPath(
                                clipper: CustomMenuClippler(),
                                child: Container(
                                  height: 110,
                                  width: 45,
                                  color: Color(
                                      0xFF004d4d), // Colors.black.withOpacity(.9),//Color(0xFF262AAA),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: Duration(milliseconds: 600), //800
                curve: Curves.easeOut,
                right: _rightPadding,
                top: 5,
                child: GestureDetector(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.only(left: 30, bottom: 30, top: 20),
                      child: RotationTransition(
                        turns: Tween(begin: 0.0, end: 0.5).animate(_controller),
                        child: SvgPicture.asset(
                          "icons/menu.svg",
                          height: 14,
                          color: _isExpanded ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  onTap: () async {
                    if (!_isExpanded) {
                      setState(() {
                        _rightPadding = MediaQuery.of(context).size.width - 56;
                      });
                      Future.delayed(Duration(milliseconds: 200), () {
                        _controller.forward();
                      });
                      Future.delayed(Duration(milliseconds: 800), () {
                        setState(() {
                          _isExpanded = true;
                          _rightPadding = 20;
                        });
                      });
                    } else {
                      setState(() {
                        _isExpanded = false;
                        _rightPadding = MediaQuery.of(context).size.width - 56;
                      });
                      Future.delayed(Duration(milliseconds: 800), () {
                        setState(() {
                          _rightPadding = 20;
                        });
                      });
                      Future.delayed(Duration(milliseconds: 1000), () {
                        _controller.reverse();
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // busca nome e email do empresa
  Future<List> busca_empresa() async {
    String link = Basicos.codifica(
        "${Basicos.ip}/crud/?crud=consult45.${widget.id_sessao}");
    var res1 = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    var res = Basicos.decodifica(res1.body);
    //print(link);
    if (res1.body.length > 2) {
      if (res1.statusCode == 200) {
        var list = json.decode(res).cast<Map<String, dynamic>>();
        prod_list = list;
        //print(prod_list);
        return list;
      }
    }
  }

  // busca msg chat
  Future<String> busca_msg_chat() async {
    String link = Basicos.codifica(
        "${Basicos.ip}/crud/?crud=consult82.${widget.id_sessao}");
    var res1 = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    var res = Basicos.decodifica(res1.body); // print(res.body);
    // print(res);
    if (res1.body.length >= 1) {
      if (res1.statusCode == 200) {
        var list = json.decode(res).cast<Map<String, dynamic>>();
        qtd_chat = list[0]["count"].toString();
        //   print(qtd);
        if (qtd_chat.toString() == '0') {
          _chatbadge = false;
        } else {
          _chatbadge = true;
        }
        return qtd_chat;
      }
    }
  }

  // lista pediso abertos
  Future<List> busca_cestas() async {
    String link = Basicos.codifica("${Basicos.ip}"
        "/crud/?crud=consult68.${widget.id_sessao},10,0");
    var res = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    //print(res.body);
    num_cestas = 0;
    msg_cestas = 'Nenhum pedido realizado';
    //var res =Basicos.decodifica(res1.body);
    if (res.body.length > 2) {
      if (res.statusCode == 200) {
        // converte a lista de consulta em uma lista dinamica
        List list = json.decode(res.body).cast<Map<String, dynamic>>();
        //Meus_recebimentos = list;
        // for (var i = 0; i < list.length; i++) Basicos.meus_recebimentos.add(list[i]);
        lista_cestas = list;
        num_cestas = list.length;
        msg_cestas = '';
        Future.delayed(Duration(milliseconds: 800), () {
          streamCestas.sink.add(list);
        });
        return list;
      }
    }
    streamCestas.sink.add([]);
    return [];
  }

  //converte data em ingles para padrao brasileiro
  String inverte_data(String substring) {
    String temp = '';
    if (substring == 'null')
      return temp;
    else {
      temp = substring[8] + substring[9];
      temp = temp + '-' + substring[5] + substring[6];
      temp = temp + '-' + substring.toString().substring(0, 4);
      return temp;
    }
  }

//   carrega dados da empresa
  Future<String> consulta_tipo() async {
    // verifica se email ja cadastrado
    String link = Basicos.codifica(
        "${Basicos.ip}/crud/?crud=consult69.${widget.id_sessao}");
    //print(link);
    var res1 = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    var res = Basicos.decodifica(res1.body);
    if (res1.body.length > 2) {
      if (res1.statusCode == 200) {
        List list = json.decode(res).cast<Map<String, dynamic>>();
        //print(list);
        //  print(list[0]['contrato']);
        return list[0]['contrato'].toString();
      }
    }
  }
}

class CustomMenuClippler extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;

    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(-8, 8, 10, 16);
    path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width + 1, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(-8, height - 8, 0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class PedidosAtivos extends StatelessWidget {
  final String image_location;
  final String image_caption;
  final String image_description;
  final String qtd;
  final String id_sessao;
  final String id_pedido;
  final String data_registro;
  final int index;

  PedidosAtivos(
      {this.image_location,
      this.id_pedido,
      this.data_registro,
      this.image_caption,
      this.image_description,
      this.qtd,
      this.id_sessao,
      this.index});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.fromLTRB(index == 0 ? 15 : 3, 0, 0, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          margin: const EdgeInsets.only(
              bottom: 4.0, right: 4), //Same as `blurRadius` i guess
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.teal[100]],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(1.0, 1.0), //(x,y)
                blurRadius: 6.0,
              ),
            ],
          ),
          width: 115.0,
          child: Container(
            child: ListTile(
              //leading: Text('10/10/2020'),
              title: Badge(
                badgeContent: Text(
                  arredonda(qtd),
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
                // showBadge: _mostrabadge,
                badgeColor: Colors.white,
                animationType: BadgeAnimationType.fade,
                position: BadgePosition.topEnd(top: 48.0, end: 32),
                //(top: 0.0,bottom: 0.0,right: 0.0,left: 0.0),
                child: Container(
                  height: 85,
                  child: Column(
                    children: [
                      Text(
                        image_caption,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Icon(
                        Icons.shopping_basket,
                        size: 55,
                        color: Colors.teal,
                      ),
                    ],
                  ),
                ),
              ),
              // leading: Text(image_caption,
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     fontSize: 12,
              //     fontFamily: "Poppins",
              //     fontWeight: FontWeight.w600,
              //     color: Colors.black87,
              //   ),
              // ),
              subtitle: Container(
                alignment: Alignment.topCenter,
                child: Text(
                  image_description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
              ),
              //trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
//              Navigator.of(context).push(new MaterialPageRoute(
//                // aqui temos passagem de valores id cliente(sessao) de login para home
//                builder: (context) =>
//                new EntregaPedidoPage(id_sessao: id_sessao,),
//              ));
                // print(id_sessao);
                // print(id_pedido);
                // print(data_registro);
                Navigator.of(context).push(new MaterialPageRoute(
                  // aqui temos passagem de valores id cliente(sessao) de login para home
                  builder: (context) => new Detalhe_Entrega(
                    id_sessao: id_sessao,
                    id_pedido: id_pedido,
                    // status_pedido: widget.pedido_status,
                    data_pedido: data_registro,
                    //inverte_data(data_registro.substring(0, 10)),
                  ),
                ));
              },
            ),
          ),
        ),
      ),
    );
  }
}

String arredonda(String qtd) {
  String temp = '0.0';
  if (qtd != 'null') {
    temp = qtd.substring(0, qtd.toString().indexOf('.', 0));
    return temp;
  } else
    return temp;
}
