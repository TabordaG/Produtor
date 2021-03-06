import 'package:produtor/pages/entrega_pedidos/entrega_pedidos.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:produtor/pages/home.dart';
import '../../soft_buttom.dart';
import '../caixa.dart';
import '../dados_basicos.dart';
import 'message_box.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

List<Message> messages = List<Message>();
List<Message> c = List<Message>();
List<Message> text = List<Message>();

class ChatsPage extends StatefulWidget {
  final id_sessao;

  @override
  _ChatsPageState createState() => _ChatsPageState();

  ChatsPage({
    this.id_sessao,
  });
}

class _ChatsPageState extends State<ChatsPage> {
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

  @override
  void initState() {
    if (!indexBottom[1]) {
      setState(() {
        indexBottom[0] = false;
        indexBottom[1] = true;
        indexBottom[2] = false;
        indexBottom[3] = false;
      });
    }
    Future.delayed(Duration(milliseconds: 250), () {
      setState(() {
        _top = 0;
      });
    });
    iniciaDB_chat().then((resultado) {
      setState(() {});
    });
    super.initState();
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
                        key: _scaffoldKey, //snackbar
                        body: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, top: 20, right: 20, bottom: 5),
                              child: Text(
                                'Conversas',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Expanded(
                              child: FutureBuilder(
                                future: getFutureChats(),
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    default:
                                      List<Message> message_no_reversed =
                                          snapshot.data;
                                      text = message_no_reversed?.toList() ??
                                          []; // evita que o m??todo tolist de erro se nulo
                                      //print(message_no_reversed);

                                      return Scrollbar(
                                        child: ListView.builder(
                                            itemCount: text.length,
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) => ChatScreen(
                                                              id_sessao: widget
                                                                  .id_sessao,
                                                              ID_Cliente: text[
                                                                      index]
                                                                  .ID_Cliente,
                                                              ID_Produtor: text[
                                                                      index]
                                                                  .ID_Empresa)));
                                                },
                                                child: Column(
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 8.0,
                                                                  horizontal:
                                                                      15),
                                                          child: CircleAvatar(
                                                            backgroundColor:
                                                                Color(
                                                                    0xFF004d4d),
                                                            radius: 25,
                                                            child: Text(
                                                              text[index]
                                                                  .ID_Cliente[0]
                                                                  .toUpperCase(),
                                                              style: TextStyle(
                                                                fontSize: 28,
                                                                color: Colors
                                                                    .white,
                                                                shadows: [
                                                                  Shadow(
                                                                      // bottomLeft
                                                                      offset: Offset(
                                                                          -0.1,
                                                                          -0.1),
                                                                      color: Colors
                                                                          .black),
                                                                  Shadow(
                                                                      // bottomRight
                                                                      offset: Offset(
                                                                          0.1,
                                                                          -0.1),
                                                                      color: Colors
                                                                          .black),
                                                                  Shadow(
                                                                      // topRight
                                                                      offset: Offset(
                                                                          0.1,
                                                                          0.1),
                                                                      color: Colors
                                                                          .black),
                                                                  Shadow(
                                                                      // topLeft
                                                                      offset: Offset(
                                                                          -0.1,
                                                                          0.1),
                                                                      color: Colors
                                                                          .black),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Row(
                                                            children: <Widget>[
                                                              Flexible(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: <
                                                                      Widget>[
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          bottom:
                                                                              5.0),
                                                                      child:
                                                                          Text(
                                                                        text[index]
                                                                            .ID_Cliente,
                                                                        softWrap:
                                                                            true,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              20,
                                                                          fontFamily:
                                                                              "Poppins",
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      children: <
                                                                          Widget>[
                                                                        _buildCheck(
                                                                            index),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(left: 5.0),
                                                                          child:
                                                                              Text(
                                                                            text[index].Status != 'Apagado'
                                                                                ? text[index].Mensagem
                                                                                : "Mensagem apagada",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 14,
                                                                              fontFamily: "Poppins",
                                                                              fontWeight: FontWeight.w600,
                                                                              color: Colors.grey,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              if (text[index].Status == 'Enviado' &&
                                                                  text[index]
                                                                          .Situacao ==
                                                                      'Cliente-Produtor' &&
                                                                  (text[index]
                                                                          .ID_Empresa
                                                                          .substring(
                                                                              text[index].ID_Empresa.lastIndexOf('(', text[index].ID_Empresa.length) +
                                                                                  1,
                                                                              text[index].ID_Empresa.length -
                                                                                  1)
                                                                          .toString() ==
                                                                      widget
                                                                          .id_sessao
                                                                          .toString()))
                                                                Badge(
                                                                  //badgeContent: Text('${qtd_chat}'),
                                                                  showBadge:
                                                                      true, //_chatbadge,
                                                                  badgeColor:
                                                                      Colors
                                                                          .teal,
                                                                  animationType:
                                                                      BadgeAnimationType
                                                                          .fade,
                                                                  position: BadgePosition
                                                                      .topStart(
                                                                          top:
                                                                              0.0,
                                                                          start:
                                                                              0.0),
                                                                ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 8.0,
                                                                  bottom: 20.0),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: <Widget>[
                                                              Text(
                                                                '${text[index].Data_Envio.hour.toString()}:${text[index].Data_Envio.minute.toString()} ${_rightName(text[index].Data_Envio)}\n'
                                                                '${text[index].Data_Envio.day}/${text[index].Data_Envio.month}/${text[index].Data_Envio.year}',
                                                                style: TextStyle(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            163,
                                                                            163,
                                                                            163,
                                                                            1),
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Divider(
                                                      color: Colors.black12,
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }),
                                      );
                                  }
                                },
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

  Future<List> iniciaDB_chat() async {
    // Lista mensagens

    // limpar conversas
    chat = []; // zera chat
    //print(widget.id_sessao);
    String link = Basicos.codifica("${Basicos.ip}"
        "/crud/?crud=consult80.${widget.id_sessao},20,${Basicos.offset}");
    var res = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    //var res =Basicos.decodifica(res1.body);
    if (res.body.length == 2)
      new Future.delayed(const Duration(seconds: 1)) //snackbar
          .then((_) => _showSnackBar('Sem Recebimentos...'));
    else
      new Future.delayed(const Duration(seconds: 1)) //snackbar
          .then((_) => _showSnackBar('Carregando...')); //snackbar

    if (res.body.length > 2) {
      if (res.statusCode == 200) {
        // converte a lista de consulta em uma lista dinamica
        List list = json.decode(res.body).cast<Map<String, dynamic>>();
        //Meus_recebimentos = list;

        for (var i = 0; i < list.length; i++) {
          // ---------------------------pega ultima msg

          String link2 = Basicos.codifica("${Basicos.ip}"
              "/crud/?crud=consult79.${list[i]['id_cliente_id'].toString()},${widget.id_sessao}");

          var res2 = await http.get(Uri.encodeFull(link2),
              headers: {"Accept": "application/json"});
          //var res =Basicos.decodifica(res1.body);
          if (res2.body.length > 2) {
            if (res2.statusCode == 200) {
              // converte a lista de consulta em uma lista dinamica
              List list2 = json.decode(res2.body).cast<Map<String, dynamic>>();
//limitar a msg em 20 caracteres
              String msg;
              if (list2[0]['mensagem'].toString().length > 20)
                msg = list2[0]['mensagem'].toString().substring(0, 20) + '...';
              else
                msg = list2[0]['mensagem'].toString() + '...';
              //-----------------------------
              chat.add(Message(
                ID_mensagem: list2[0]['id'].toString(),
                Mensagem: msg,
                Situacao: list2[0]['situacao'].toString(),
                Status: list2[0]['status'].toString(),
                Data_Envio: DateTime.parse(list2[0]['data_envio'].toString()),
                Data_Leitura:
                    DateTime.parse(list2[0]['data_leitura'].toString()),
                ID_Cliente: list[i]['nome_razao_social'].toString() +
                    '(' +
                    list[i]['id_cliente_id'].toString() +
                    ')',
                ID_Empresa: list[i]['razao_social'].toString() +
                    '(' +
                    list[i]['id_empresa_id'].toString() +
                    ')',
              ));
              // print(chat.length);
              // print(messages[i].Data_Envio);
            }
            //print('======================>'+'${list.length}');
          }
        }
        return list;
      }
    }
//
//
  }
}

//        for (var i = 0; i < list.length; i++) {
//          chat.add(Message(
//            ID_mensagem: list[i]['id'].toString(),
//            Mensagem: list[i]['mensagem'],
//            Situacao: list[i]['situacao'],
//            Status: list[i]['status'],
//            Data_Envio: DateTime.parse(list[i]['data_envio'].toString()),
//            Data_Leitura: DateTime.parse(list[i]['data_leitura'].toString()),
//            ID_Cliente: list[i]['nome_razao_social'].toString() +
//                '(' +
//                list[i]['id_cliente_id'].toString() +
//                ')',
//            ID_Empresa: list[i]['razao_social'].toString() +
//                '(' +
//                list[i]['id_empresa_id'].toString() +
//                ')',
//          ));
//         // print(messages[i].Data_Envio);
//        }
//        //print(list);
//        return list;
//      }
//    }
////
////
//  }
//}

//  Classe que realiza a busca das conversas
class CustomSearchDelegate extends SearchDelegate {
  final id_sessao;

  CustomSearchDelegate(this.id_sessao);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "A pesquisa deve conter pelo menos tr??s letras.",
            ),
          )
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: FutureBuilder(
            future: getSearchChats(query),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                default:
                  List<Message> message_no_reversed = snapshot.data;
                  text = message_no_reversed.toList();

                  return ListView.builder(
                      itemCount: text.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                    id_sessao: id_sessao,
                                    ID_Cliente: text[index].ID_Cliente,
                                    ID_Produtor: text[index].ID_Empresa)));
                          },
                          child: Container(
                            padding: index == 0
                                ? EdgeInsets.only(top: 8)
                                : EdgeInsets.only(),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.blue,
                                        child: Text(
                                          text[index]
                                              .ID_Cliente[0]
                                              .toUpperCase(),
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                text[index].ID_Cliente,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17),
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  _buildCheck(index),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0,
                                                            top: 2.0),
                                                    child: Text(
                                                      text[index].Status !=
                                                              'Apagado'
                                                          ? text[index].Mensagem
                                                          : "Mensagem apagada",
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontSize: 13),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 8.0, bottom: 20.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            '${text[index].Data_Envio.hour.toString()}:${text[index].Data_Envio.minute.toString()} ${_rightName(text[index].Data_Envio)}',
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    163, 163, 163, 1),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: Colors.black12,
                                ),
                              ],
                            ),
                          ),
                        );
                      });
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.
    return Column();
  }
}

// -----------------fim sa busca====================================================

//  Future que busca no banco as mensagens do produtor ("no caso do teste, idsessao = empresa0"), e adiciona para lista
//  a ??ltima mensagem de conversa com cada cliente que ele teve.
Future getFutureChats() async {
  //Obter mensagens do banco de dados
  messages = [];
  c = [];
  bool v = false;
  messages = chat;
  //c.add(messages[messages.length - 1]);
  // print(c.length);
  for (int j = messages.length - 1; j >= 0; j--) {
    // print('M='+'${messages[j].ID_Empresa}');
    c.add(messages[j]);
//    if (messages[j].ID_Empresa == "empresa0") {
//      for (int i = 0; i < c.length; i++) {
//        if (c[i].ID_Cliente == messages[j].ID_Cliente) {
//          v = true;
//        }
//      }
//      if (v == false) {
//        c.add(messages[j]);
//      }
//      v = false;
//    }
  }
  return c;
}

//  Future que busca nas mensagens filtradas da empresa0, retornando uma lista de conversas com
//  os cliente que contem a palavra de pesquisa digitada.
Future getSearchChats(String query) async {
  // print(query);
  messages = [];
  c = [];
  bool v = false;
  messages = chat;
  for (int j = messages.length - 1; j >= 0; j--) {
    // print(messages[j].ID_Cliente);
    if (messages[j].ID_Cliente.toLowerCase().contains(query.toLowerCase())) {
      // print("contains index: $j");
      c.forEach((f) {
        if (f.ID_Cliente == messages[j].ID_Cliente) {
          v = true;
        }
      });
      if (v == false) {
        c.add(messages[j]);
      }
      v = false;
    }
  }
  return c;
}

Widget _buildCheck(int index) {
  Color color;
  IconData icon;
  if (text[index].Status == 'Lido') {
    icon = Icons.done_all;
    color = Colors.green;
  } else if (text[index].Status == 'Enviado') {
    icon = Icons.done;
    color = Colors.grey;
  } else if (text[index].Status == 'Recebido') {
    icon = Icons.done_all;
    color = Colors.grey;
  } else if (text[index].Status == 'Apagado') {
    icon = Icons.do_not_disturb;
    color = Colors.grey;
  }
  return Icon(icon, color: color, size: 16);
}

_rightName(DateTime dateTime) {
  if (dateTime.hour >= 12)
    return 'PM';
  else
    return 'AM';
}

class Message {
  final ID_mensagem;
  final ID_Cliente;
  final ID_Empresa;
  final Mensagem;
  final Situacao;
  final Status;
  final Data_Envio;
  final Data_Leitura;

  Message(
      {this.ID_mensagem,
      this.ID_Cliente,
      this.ID_Empresa,
      this.Mensagem,
      this.Situacao,
      this.Status,
      this.Data_Envio,
      this.Data_Leitura});
}

List<Message> chat = [];
List<Message> filteredmessage = List<Message>();
List<Message> msg = List<Message>();

//  Filtra todas as mensagens da tabela, buscando as que possuem o cliente e empresa passados como paramentro
Future getFilteredMessages(String ID_Cliente, String ID_Produtor,
    {Message message}) async {
  filteredmessage = [];
  msg = chat;
  msg.forEach((f) {
    if (f.ID_Cliente == ID_Cliente && f.ID_Empresa == ID_Produtor)
      filteredmessage.add(f);
  });
  msg = [];

  return (filteredmessage);
}

//
Future getFutureMessages(String ID_Cliente, String ID_Produtor) async {
  //Obter mensagens do banco de dados
  getFilteredMessages(ID_Cliente, ID_Produtor);
  return filteredmessage;
}
