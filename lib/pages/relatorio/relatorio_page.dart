import 'package:produtor/pages/entrega_pedidos/entrega_pedidos.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:produtor/pages/relatorio/relatorio_diario.dart';
import 'package:produtor/pages/relatorio/relatorio_personalizado.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../soft_buttom.dart';
import '../dados_basicos.dart';

List<Venda> pedidosNovosEntrega = [];
List<RelatorioPedidosVendas> itensPedidosNovosEntrega = [];
List<Venda> pedidosNovosRetirada = [];
List<RelatorioPedidosVendas> itensPedidosNovosRetirada = [];

List<Venda> pedidos = [];

List<MarcaProduto> marcaProdutoEntrega = [];
List<MarcaProduto> marcaProdutoRetirada = [];
List<MarcaProduto> marcaProdutoTotal = [];
List<double> quantidademarcaTotal = [];

List<ProdutosRelatorio> relatorioProdutosEntrega = [];
List<ProdutosRelatorio> relatorioProdutosRetirada = [];
List<ProdutosRelatorio> relatorioProdutosTotal = [];
bool produtosNovos = false;

String itemSelecionadoRelatorio = 'EM ANDAMENTO';

class RelatorioPedidosVendas {
  Venda venda;
  dynamic pedido;

  RelatorioPedidosVendas({this.venda, this.pedido});
}

class RelatorioPage extends StatefulWidget {
  @override
  final id_sessao;

  _RelatorioPageState createState() => _RelatorioPageState();
  RelatorioPage({
    this.id_sessao,
  });
}

class _RelatorioPageState extends State<RelatorioPage> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  BehaviorSubject<int> _selectRadio = BehaviorSubject<int>();
  BehaviorSubject<DateTime> dataDiaria = BehaviorSubject<DateTime>();
  BehaviorSubject<DateTime> dataPersonalizado1 = BehaviorSubject<DateTime>();
  BehaviorSubject<DateTime> dataPersonalizado2 = BehaviorSubject<DateTime>();
  double _top = -60;

  String nomeCidade = "";
  List<String> _status = [
    'EM ANDAMENTO',
    'CONCLUIDO NAO ENTREGUE',
    'CONCLUIDO ENTREGUE',
    'CANCELADO'
  ];

  Widget _widget = Container(
    child: Text("Selecione uma opção de Relatório!"),
    padding: EdgeInsets.only(top: 200),
  );

  @override
  void dispose() {
    _selectRadio.close();
    dataDiaria.close();
    dataPersonalizado1.close();
    dataPersonalizado2.close();
  }

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 250), () {
      setState(() {
        _top = 0;
      });
    });
    super.initState();
    pedidosNovosEntrega.clear();
    pedidosNovosRetirada.clear();
  }

  @override
  Widget build(BuildContext context) {
    Widget relatorioPedidosWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text("Selecione o tipo de Relatório de Pedidos:"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                children: <Widget>[
                  StreamBuilder<int>(
                      stream: _selectRadio.stream,
                      builder: (context, snapshot) {
                        return Radio(
                          value: 0,
                          groupValue: _selectRadio.value,
                          onChanged: (val) {
                            _selectRadio.sink.add(val);
                          },
                        );
                      }),
                  Text(
                    "Diário",
                    style: TextStyle(fontSize: 12.0),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  StreamBuilder<int>(
                      stream: _selectRadio.stream,
                      builder: (context, snapshot) {
                        return Radio(
                          value: 1,
                          groupValue: _selectRadio.value,
                          onChanged: (val) {
                            _selectRadio.sink.add(val);
                          },
                        );
                      }),
                  Text(
                    "Personalizado",
                    style: TextStyle(fontSize: 12.0),
                  ),
                ],
              ),
            ],
          ),
          StreamBuilder<int>(
            stream: _selectRadio.stream,
            builder: (context, snapshot) {
              snapshot.data == 0
                  ? _widget = DiarioPedidos(_scaffoldKey)
                  : snapshot.data == 1
                      ? _widget = PersonalizadoPedidos(_scaffoldKey)
                      : _widget;
              return _widget;
            },
          )
        ]);
    Widget relatorioProdutosWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text("Selecione o tipo de Relatório de Produtos:"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                children: <Widget>[
                  StreamBuilder<int>(
                      stream: _selectRadio.stream,
                      builder: (context, snapshot) {
                        return Radio(
                          value: 0,
                          groupValue: _selectRadio.value,
                          onChanged: (val) {
                            _selectRadio.sink.add(val);
                          },
                        );
                      }),
                  Text(
                    "Diário",
                    style: TextStyle(fontSize: 12.0),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  StreamBuilder<int>(
                      stream: _selectRadio.stream,
                      builder: (context, snapshot) {
                        return Radio(
                          value: 1,
                          groupValue: _selectRadio.value,
                          onChanged: (val) {
                            _selectRadio.sink.add(val);
                          },
                        );
                      }),
                  Text(
                    "Personalizado",
                    style: TextStyle(fontSize: 12.0),
                  ),
                ],
              ),
            ],
          ),
          StreamBuilder<int>(
            stream: _selectRadio.stream,
            builder: (context, snapshot) {
              snapshot.data == 0
                  ? _widget = DiarioProdutos(_scaffoldKey)
                  : snapshot.data == 1
                      ? _widget = PersonalizadoProdutos(_scaffoldKey)
                      : _widget;
              return _widget;
            },
          )
        ]);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Color(0xFF004d4d)),
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
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
                                    'Relatório de Entregas',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                      color: Colors.teal),
                                  child: TabBar(tabs: <Widget>[
                                    Tab(
                                      text: 'Relatório de Pedidos',
                                    ),
                                    Tab(
                                      text: 'Relatório de Produtos',
                                    )
                                  ], indicatorColor: Colors.black),
                                ),
                                Expanded(
                                  child: Scrollbar(
                                    child: TabBarView(
                                      children: <Widget>[
                                        relatorioPedidosWidget,
                                        relatorioProdutosWidget
                                      ],
                                    ),
                                  ),
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
                              Basicos.offset = 0;
                              Basicos.product_list = [];
                              Basicos.meus_pedidos = [];
                              Future.delayed(Duration(milliseconds: 250), () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => EntregaPedidoPage(
                                          id_sessao: widget.id_sessao,
                                        )));
                              });
                            }),
                        radius: 22,
                      ),
                    ),
                  ],
                ),
              )),
        ));
  }

  Widget DiarioPedidos(GlobalKey<ScaffoldState> scaffoldkey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        DropdownButton<String>(
            items: _status.map((String dropDownStringItem) {
              return DropdownMenuItem<String>(
                value: dropDownStringItem,
                child: Text(dropDownStringItem,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              );
            }).toList(),
            onChanged: (String novoItemSelecionado) {
              _dropDownItemSelected(novoItemSelecionado);
              setState(() {
                itemSelecionadoRelatorio = novoItemSelecionado;
              });
            },
            value: itemSelecionadoRelatorio),
        SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 0.0),
          child: Text(
            'Data do Relatório:',
            style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: StreamBuilder<DateTime>(
              stream: dataDiaria.stream,
              builder: (context, snapshot) {
                return RaisedButton(
                  onPressed: () async {
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(2018, 1, 1),
                        maxTime: DateTime(2099, 12, 31), onConfirm: (date) {
                      DateFormat.yMd().format(date);
                      dataDiaria.sink.add(date);
                    }, currentTime: DateTime.now(), locale: LocaleType.pt);
                  },
                  child: dataDiaria.value != null
                      ? Text(
                          '${dataDiaria.value.day}/${dataDiaria.value.month}/${dataDiaria.value.year}')
                      : Text('DD/MM/AAAA'),
                );
              }),
        ),
        Divider(),
        OutlineButton(
          onPressed: () async {
            if (dataDiaria.value != null) {
              pedidos.clear();
              circular('inicio');
              await consultaVendas(widget.id_sessao, dataDiaria.value);
              circular('fim');
              recebePedidosDiario(
                data: dataDiaria.value,
              );

              if (pedidosNovosEntrega.length > 0 ||
                  pedidosNovosRetirada.length > 0) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RelatorioDiario(
                              data1: dataDiaria.value,
                            )));
              } else {
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text("Não há pedidos pendentes com essa data!"),
                  backgroundColor: Colors.teal,
                ));
              }
            } else {
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text("Selecione uma data para fazer a pesquisa!"),
                backgroundColor: Colors.teal,
              ));
            }
          },
          child: Text("Exibir Relatório"),
        )
      ],
    );
  }

  Widget PersonalizadoPedidos(GlobalKey<ScaffoldState> scaffoldkey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        DropdownButton<String>(
            items: _status.map((String dropDownStringItem) {
              return DropdownMenuItem<String>(
                value: dropDownStringItem,
                child: Text(dropDownStringItem,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              );
            }).toList(),
            onChanged: (String novoItemSelecionado) {
              _dropDownItemSelected(novoItemSelecionado);
              setState(() {
                itemSelecionadoRelatorio = novoItemSelecionado;
              });
            },
            value: itemSelecionadoRelatorio),
        SizedBox(
          height: 8,
        ),
        Text(
          'Data do Relatório:',
          style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500),
        ),
        Wrap(
          runAlignment: WrapAlignment.spaceEvenly,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('De:  '),
                  StreamBuilder<DateTime>(
                      stream: dataPersonalizado1.stream,
                      builder: (context, snapshot) {
                        return RaisedButton(
                          onPressed: () async {
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime(2018, 1, 1),
                                maxTime: DateTime(2099, 12, 31),
                                onConfirm: (date) {
                              DateFormat.yMd().format(date);
                              dataPersonalizado1.sink.add(date);
                            },
                                currentTime: DateTime.now(),
                                locale: LocaleType.pt);
                          },
                          child: dataPersonalizado1.value != null
                              ? Text(
                                  '${dataPersonalizado1.value.day}/${dataPersonalizado1.value.month}/${dataPersonalizado1.value.year}')
                              : Text('DD/MM/AAAA'),
                        );
                      }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Até:  '),
                  StreamBuilder<DateTime>(
                      stream: dataPersonalizado2.stream,
                      builder: (context, snapshot) {
                        return RaisedButton(
                          onPressed: () async {
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime(2018, 1, 1),
                                maxTime: DateTime(2099, 12, 31),
                                onConfirm: (date) {
                              DateFormat.yMd().format(date);
                              dataPersonalizado2.sink.add(date);
                            },
                                currentTime: DateTime.now(),
                                locale: LocaleType.pt);
                          },
                          child: dataPersonalizado2.value != null
                              ? Text(
                                  '${dataPersonalizado2.value.day}/${dataPersonalizado2.value.month}/${dataPersonalizado2.value.year}')
                              : Text('DD/MM/AAAA'),
                        );
                      }),
                ],
              ),
            )
          ],
        ),
        Divider(),
        OutlineButton(
          onPressed: () async {
            if (dataPersonalizado1.value != null &&
                dataPersonalizado2.value != null) {
              pedidos.clear();
              circular('inicio');
              await consultaVendas2(widget.id_sessao, dataPersonalizado1.value,
                  dataPersonalizado2.value);
              circular('fim');
              recebePedidosPersonalizado(
                data1: dataPersonalizado1.value,
                data2: dataPersonalizado2.value,
              );
              if (pedidosNovosEntrega.length > 0 ||
                  pedidosNovosRetirada.length > 0) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RelatorioPersonalizado(
                              id_sessao: widget.id_sessao,
                              data1: dataPersonalizado1.value,
                              data2: dataPersonalizado2.value,
                            )));
              } else {
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text("Não há pedidos pendentes com essas datas!"),
                  backgroundColor: Colors.teal,
                ));
              }
            } else {
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text("Selecione uma data para fazer a pesquisa!"),
                backgroundColor: Colors.teal,
              ));
            }
          },
          child: Text("Exibir Relatório"),
        )
      ],
    );
  }

  Widget DiarioProdutos(GlobalKey<ScaffoldState> scaffoldkey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        DropdownButton<String>(
            items: _status.map((String dropDownStringItem) {
              return DropdownMenuItem<String>(
                value: dropDownStringItem,
                child: Text(dropDownStringItem,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              );
            }).toList(),
            onChanged: (String novoItemSelecionado) {
              _dropDownItemSelected(novoItemSelecionado);
              setState(() {
                itemSelecionadoRelatorio = novoItemSelecionado;
              });
            },
            value: itemSelecionadoRelatorio),
        SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 0.0),
          child: Text(
            'Data do Relatório:',
            style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: StreamBuilder<DateTime>(
              stream: dataDiaria.stream,
              builder: (context, snapshot) {
                return RaisedButton(
                  onPressed: () async {
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(2018, 1, 1),
                        maxTime: DateTime(2099, 12, 31), onConfirm: (date) {
                      DateFormat.yMd().format(date);
                      dataDiaria.sink.add(date);
                    }, currentTime: DateTime.now(), locale: LocaleType.pt);
                  },
                  child: dataDiaria.value != null
                      ? Text(
                          '${dataDiaria.value.day}/${dataDiaria.value.month}/${dataDiaria.value.year}')
                      : Text('DD/MM/AAAA'),
                );
              }),
        ),
        Divider(),
        OutlineButton(
          onPressed: () async {
            if (dataDiaria.value != null) {
              bool verificado = false;
              pedidos.clear();
              circular('inicio');
              await consultaVendasProdutos(widget.id_sessao, dataDiaria.value);
              marcaProdutoEntrega = [];
              marcaProdutoRetirada = [];
              marcaProdutoTotal = [];
              relatorioProdutosEntrega.forEach((element) {
                verificado = false;
                for (var marca in marcaProdutoEntrega) {
                  if (marca.marca == element.marca) {
                    marca.produtos.add(element);
                    verificado = true;
                    break;
                  }
                }
                if (!verificado) {
                  marcaProdutoEntrega.add(MarcaProduto(
                    marca: element.marca,
                    produtos: [element],
                  ));
                }
              });
              relatorioProdutosRetirada.forEach((element) {
                verificado = false;
                for (var marca in marcaProdutoRetirada) {
                  if (marca.marca == element.marca) {
                    marca.produtos.add(element);
                    verificado = true;
                    break;
                  }
                }
                if (!verificado) {
                  marcaProdutoRetirada.add(MarcaProduto(
                    marca: element.marca,
                    produtos: [element],
                  ));
                }
              });
              relatorioProdutosTotal.forEach((element) {
                verificado = false;
                for (var marca in marcaProdutoTotal) {
                  if (marca.marca == element.marca) {
                    marca.produtos.add(element);
                    verificado = true;
                    break;
                  }
                }
                if (!verificado) {
                  marcaProdutoTotal.add(MarcaProduto(
                    marca: element.marca,
                    produtos: [element],
                  ));
                }
              });
              circular('fim');
              if (relatorioProdutosEntrega.length > 0 ||
                  relatorioProdutosRetirada.length > 0) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RelatorioDiario(
                              data1: dataDiaria.value,
                            )));
              } else {
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text("Não há pedidos pendentes com essa data!"),
                  backgroundColor: Colors.teal,
                ));
              }
            } else {
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text("Selecione uma data para fazer a pesquisa!"),
                backgroundColor: Colors.teal,
              ));
            }
          },
          child: Text("Exibir Relatório"),
        )
      ],
    );
  }

  Widget PersonalizadoProdutos(GlobalKey<ScaffoldState> scaffoldkey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        DropdownButton<String>(
            items: _status.map((String dropDownStringItem) {
              return DropdownMenuItem<String>(
                value: dropDownStringItem,
                child: Text(dropDownStringItem,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              );
            }).toList(),
            onChanged: (String novoItemSelecionado) {
              _dropDownItemSelected(novoItemSelecionado);
              setState(() {
                itemSelecionadoRelatorio = novoItemSelecionado;
              });
            },
            value: itemSelecionadoRelatorio),
        SizedBox(
          height: 8,
        ),
        Text(
          'Data do Relatório:',
          style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500),
        ),
        Wrap(
          runAlignment: WrapAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('De:  '),
                  StreamBuilder<DateTime>(
                      stream: dataPersonalizado1.stream,
                      builder: (context, snapshot) {
                        return RaisedButton(
                          onPressed: () async {
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime(2018, 1, 1),
                                maxTime: DateTime(2099, 12, 31),
                                onConfirm: (date) {
                              DateFormat.yMd().format(date);
                              dataPersonalizado1.sink.add(date);
                            },
                                currentTime: DateTime.now(),
                                locale: LocaleType.pt);
                          },
                          child: dataPersonalizado1.value != null
                              ? Text(
                                  '${dataPersonalizado1.value.day}/${dataPersonalizado1.value.month}/${dataPersonalizado1.value.year}')
                              : Text('DD/MM/AAAA'),
                        );
                      }),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Até:  '),
                StreamBuilder<DateTime>(
                    stream: dataPersonalizado2.stream,
                    builder: (context, snapshot) {
                      return RaisedButton(
                        onPressed: () async {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(2018, 1, 1),
                              maxTime: DateTime(2099, 12, 31),
                              onConfirm: (date) {
                            DateFormat.yMd().format(date);
                            dataPersonalizado2.sink.add(date);
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.pt);
                        },
                        child: dataPersonalizado2.value != null
                            ? Text(
                                '${dataPersonalizado2.value.day}/${dataPersonalizado2.value.month}/${dataPersonalizado2.value.year}')
                            : Text('DD/MM/AAAA'),
                      );
                    }),
              ],
            )
          ],
        ),
        Divider(),
        OutlineButton(
          onPressed: () async {
            bool verificado = false;
            if (dataPersonalizado1.value != null &&
                dataPersonalizado2.value != null) {
              pedidos.clear();
              circular('inicio');
              await consultaVendasProdutos2(widget.id_sessao,
                  dataPersonalizado1.value, dataPersonalizado2.value);
              // recebeProdutosPersonalizado(
              //   data1: dataPersonalizado1.value,
              //   data2: dataPersonalizado2.value,
              // );
              marcaProdutoEntrega = [];
              marcaProdutoRetirada = [];
              marcaProdutoTotal = [];
              quantidademarcaTotal = [];
              print('Entrega: ${relatorioProdutosEntrega.length}\n');
              print('Retirada: ${relatorioProdutosRetirada.length}\n');
              print('Total: ${relatorioProdutosTotal.length}\n');
              relatorioProdutosEntrega.forEach((element) {
                verificado = false;
                // for (var marca in marcaProdutoEntrega) {
                //   if(marca.marca == element.marca) {
                //     marca.produtos.add(element);
                //     verificado = true;
                //     break;
                //   }
                // }
                for (int index = 0;
                    index < marcaProdutoEntrega.length;
                    index++) {
                  if (marcaProdutoEntrega[index].marca == element.marca) {
                    marcaProdutoEntrega[index].produtos.add(element);
                    verificado = true;
                    break;
                  }
                }
                if (!verificado) {
                  marcaProdutoEntrega.add(MarcaProduto(
                    marca: element.marca,
                    produtos: [element],
                  ));
                }
              });
              relatorioProdutosRetirada.forEach((element) {
                verificado = false;
                for (var marca in marcaProdutoRetirada) {
                  if (marca.marca == element.marca) {
                    marca.produtos.add(element);
                    verificado = true;
                    break;
                  }
                }
                if (!verificado) {
                  marcaProdutoRetirada.add(MarcaProduto(
                    marca: element.marca,
                    produtos: [element],
                  ));
                }
              });
              relatorioProdutosTotal.forEach((element) {
                verificado = false;
                for (int index = 0; index < marcaProdutoTotal.length; index++) {
                  if (marcaProdutoTotal[index].marca == element.marca) {
                    marcaProdutoTotal[index].produtos.add(element);
                    quantidademarcaTotal[index] += element.quantidade;
                    verificado = true;
                    break;
                  }
                }
                if (!verificado) {
                  marcaProdutoTotal.add(MarcaProduto(
                    marca: element.marca,
                    produtos: [element],
                  ));
                  quantidademarcaTotal.add(element.quantidade);
                }
              });
              // print('PAGE MarcaProdutoTotal [0]: ${marcaProdutoTotal[0].produtos[0].quantidade}');
              circular('fim');
              if (relatorioProdutosEntrega.length > 0 ||
                  relatorioProdutosRetirada.length > 0) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RelatorioPersonalizado(
                              id_sessao: widget.id_sessao,
                              data1: dataPersonalizado1.value,
                              data2: dataPersonalizado2.value,
                            )));
              } else {
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text("Não há pedidos pendentes com essas datas!"),
                  backgroundColor: Colors.teal,
                ));
              }
            } else {
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text("Selecione uma data para fazer a pesquisa!"),
                backgroundColor: Colors.teal,
              ));
            }
          },
          child: Text("Exibir Relatório"),
        )
      ],
    );
  }

  void _dropDownItemSelected(String novoItem) {
    setState(() {
      itemSelecionadoRelatorio = novoItem;
    });
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
              )));
    } else
      Navigator.pop(context);
  }
}

class Venda {
  int id;
  String observacoesEntrega,
      cidade,
      bairro,
      complemento,
      numero,
      endereco,
      statusPedido,
      cliente,
      produtor,
      estado,
      tipoEntrega,
      total,
      frete;
  DateTime dataVenda;

  Venda(
      this.id,
      this.bairro,
      this.cidade,
      this.complemento,
      this.dataVenda,
      this.endereco,
      this.numero,
      this.observacoesEntrega,
      this.cliente,
      this.produtor,
      this.statusPedido,
      this.estado,
      this.tipoEntrega,
      this.total,
      this.frete);
}

class ProdutosRelatorio {
  String imagem;
  String id;
  double quantidade;
  String nomeProduto;
  String marca;
  String statusPedido;
  DateTime dataVenda;

  ProdutosRelatorio(
      {this.id,
      this.imagem,
      this.nomeProduto,
      this.quantidade,
      this.marca,
      this.dataVenda,
      this.statusPedido});
}

Future<List<Venda>> consultaVendas(
    String id_sessao, DateTime data_diaria) async {
  String link = Basicos.codifica("${Basicos.ip}"
      "/crud/?crud=consult91.${id_sessao},${data_diaria}");
  var res = await http
      .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});

  if (res.body.length > 2) {
    if (res.statusCode == 200) {
      // converte a lista de consulta em uma lista dinamica
      List list = json.decode(res.body).cast<Map<String, dynamic>>();
      // print(list[0]);
      for (var i = 0; i < list.length; i++) {
        pedidos.add(
          Venda(
              int.parse(list[i]['id'].toString()),
              list[i]['bairro'],
              list[i]['cidade'],
              list[i]['complemento'],
              DateTime.parse(list[i]['data_venda']),
              list[i]['endereco'],
              list[i]['numero'],
              list[i]['observacoes'],
              list[i]['nome'],
              list[i]['celular'],
              list[i]['status_pedido'],
              list[i]['estado'],
              list[i]['tipo_entrega'],
              list[i]['valor_total'],
              list[i]['frete']),
        );
      }
      produtosNovos = false;
      return pedidos;
    }
  }
}

Future<List<Venda>> consultaVendas2(
    String id_sessao, DateTime data_1, DateTime data_2) async {
  String link = Basicos.codifica("${Basicos.ip}"
      "/crud/?crud=consult92.${id_sessao},${data_1},${data_2}");
  var res = await http
      .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});

  if (res.body.length > 2) {
    if (res.statusCode == 200) {
      // converte a lista de consulta em uma lista dinamica
      List list = json.decode(res.body).cast<Map<String, dynamic>>();
      print(list);
      for (var i = 0; i < list.length; i++) {
        pedidos.add(Venda(
            int.parse(list[i]['id'].toString()),
            list[i]['bairro'],
            list[i]['cidade'],
            list[i]['complemento'],
            DateTime.parse(list[i]['data_venda']),
            list[i]['endereco'],
            list[i]['numero'],
            list[i]['observacoes'],
            list[i]['nome'],
            list[i]['celular'],
            list[i]['status_pedido'],
            list[i]['estado'],
            list[i]['tipo_entrega'],
            list[i]['valor_total'],
            list[i]['frete']));
      }
      produtosNovos = false;
      return pedidos;
    }
  }
}

Future<List<ProdutosRelatorio>> consultaVendasProdutos(
    String id_sessao, DateTime data_diaria) async {
  int idProduto;
  relatorioProdutosEntrega = [];
  relatorioProdutosRetirada = [];
  String link = Basicos.codifica("${Basicos.ip}"
      "/crud/?crud=consult91.${id_sessao},${data_diaria}");
  var res = await http
      .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});

  if (res.body.length > 2) {
    if (res.statusCode == 200) {
      // converte a lista de consulta em uma lista dinamica
      List list = json.decode(res.body).cast<Map<String, dynamic>>();
      for (var i = 0; i < list.length; i++) {
        if (list[i]['status_pedido'] == itemSelecionadoRelatorio) {
          idProduto = int.parse(list[i]['id'].toString());
          String link =
              Basicos.codifica("${Basicos.ip}/crud/?crud=consult15.$idProduto");
          var res1 = await http.get(Uri.encodeFull(link),
              headers: {"Accept": "application/json"});
          var resProduct = Basicos.decodifica(res1.body);
          if (res1.body.length > 2) {
            if (res1.statusCode == 200) {
              // converte a lista de consulta em uma lista dinamica
              List list2 = json.decode(resProduct).cast<Map<String, dynamic>>();
              list2.forEach((element) {
                if (list[i]['tipo_entrega'] == 'Retirar no Local') {
                  int index = relatorioProdutosRetirada.indexWhere(
                      (item) => item.id == element['id'].toString());
                  // print(index);
                  if (index != -1) {
                    // print('add existing <--------------');
                    relatorioProdutosRetirada[index].quantidade +=
                        double.parse(element['quantidade']);
                  } else {
                    // print('add new <--------------');
                    relatorioProdutosRetirada.add(ProdutosRelatorio(
                      id: element['id'].toString(),
                      imagem: element['imagem'],
                      nomeProduto: element['descricao_simplificada'],
                      quantidade: double.parse(element['quantidade']),
                      marca: element['descricao'],
                      dataVenda: DateTime.parse(
                        list[i]['data_venda'],
                      ),
                      statusPedido: list[i]['status_pedido'],
                    ));
                  }
                } else {
                  int index = relatorioProdutosEntrega.indexWhere(
                      (item) => item.id == element['id'].toString());
                  // print(index);
                  if (index != -1) {
                    // print('add existing <--------------');
                    relatorioProdutosEntrega[index].quantidade +=
                        double.parse(element['quantidade']);
                  } else {
                    // print('add new <--------------');
                    relatorioProdutosEntrega.add(ProdutosRelatorio(
                      id: element['id'].toString(),
                      imagem: element['imagem'],
                      nomeProduto: element['descricao_simplificada'],
                      quantidade: double.parse(element['quantidade']),
                      marca: element['descricao'],
                      dataVenda: DateTime.parse(
                        list[i]['data_venda'],
                      ),
                      statusPedido: list[i]['status_pedido'],
                    ));
                  }
                }
              });
              produtosNovos = true;
            }
          }
        }
      }
    }
    produtosNovos = true;
  }
}

Future<List<ProdutosRelatorio>> consultaVendasProdutos2(
    String id_sessao, DateTime data_1, DateTime data_2) async {
  int idProduto;
  relatorioProdutosEntrega = [];
  relatorioProdutosRetirada = [];
  relatorioProdutosTotal = [];
  String link = Basicos.codifica("${Basicos.ip}"
      "/crud/?crud=consult92.${id_sessao},${data_1},${data_2}");
  var res = await http
      .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});

  if (res.body.length > 2) {
    if (res.statusCode == 200) {
      // converte a lista de consulta em uma lista dinamica
      List list = json.decode(res.body).cast<Map<String, dynamic>>();
      for (var i = 0; i < list.length; i++) {
        if (list[i]['status_pedido'] == itemSelecionadoRelatorio) {
          idProduto = int.parse(list[i]['id'].toString());
          String link =
              Basicos.codifica("${Basicos.ip}/crud/?crud=consult15.$idProduto");
          var res1 = await http.get(Uri.encodeFull(link),
              headers: {"Accept": "application/json"});
          var resProduct = Basicos.decodifica(res1.body);
          if (res1.body.length > 2) {
            if (res1.statusCode == 200) {
              List list2 = json.decode(resProduct).cast<Map<String, dynamic>>();
              // print(list2[0]);
              list2.forEach((element) {
                if (list[i]['tipo_entrega'] == 'Retirar no Local') {
                  int index = relatorioProdutosRetirada.indexWhere(
                      (item) => item.id == element['id'].toString());
                  if (index != -1) {
                    relatorioProdutosRetirada[index].quantidade +=
                        double.parse(element['quantidade']);
                  } else {
                    relatorioProdutosRetirada.add(ProdutosRelatorio(
                      id: element['id'].toString(),
                      imagem: element['imagem'],
                      nomeProduto: element['descricao_simplificada'],
                      quantidade: double.parse(element['quantidade']),
                      marca: element['descricao'],
                      dataVenda: DateTime.parse(list[i]['data_venda']),
                      statusPedido: list[i]['status_pedido'],
                    ));
                  }
                } else {
                  int index = relatorioProdutosEntrega.indexWhere(
                      (item) => item.id == element['id'].toString());
                  if (index != -1) {
                    relatorioProdutosEntrega[index].quantidade +=
                        double.parse(element['quantidade']);
                  } else {
                    relatorioProdutosEntrega.add(ProdutosRelatorio(
                      id: element['id'].toString(),
                      imagem: element['imagem'],
                      nomeProduto: element['descricao_simplificada'],
                      quantidade: double.parse(element['quantidade']),
                      marca: element['descricao'],
                      dataVenda: DateTime.parse(list[i]['data_venda']),
                      statusPedido: list[i]['status_pedido'],
                    ));
                  }
                }
                int index = relatorioProdutosTotal
                    .indexWhere((item) => item.id == element['id'].toString());
                if (index != -1) {
                  relatorioProdutosTotal[index].quantidade +=
                      double.parse(element['quantidade']);
                  // print('entrou aqui ------ ');
                  // print('${relatorioProdutosTotal[index].id} ${relatorioProdutosTotal[index].quantidade}');
                } else {
                  relatorioProdutosTotal.add(ProdutosRelatorio(
                    id: element['id'].toString(),
                    imagem: element['imagem'],
                    nomeProduto: element['descricao_simplificada'],
                    quantidade: double.parse(element['quantidade']),
                    marca: element['descricao'],
                    dataVenda: DateTime.parse(list[i]['data_venda']),
                    statusPedido: list[i]['status_pedido'],
                  ));
                }
              });
              produtosNovos = true;
            }
          }
        }
      }
      // relatorioProdutos.forEach((element) {
      //   verificado = false;
      //   for (var marca in marcaProduto) {
      //     if(marca.marca == element.marca) {
      //       marca.produtos.add(element);
      //       verificado = true;
      //       break;
      //     }
      //   }
      //   if(!verificado) {
      //     marcaProduto.add(MarcaProduto(
      //     marca: element.marca,
      //     produtos: [element],
      //     ));
      //   }
      // });

      // marcaProduto.forEach((elementMarca) {
      //   print('****** Elemento por Marca');
      //   elementMarca.produtos.forEach((elementProduto) {
      //     print(elementProduto.nomeProduto);
      //   });
      // });
    }
    produtosNovos = true;
  }
}

class MarcaProduto {
  final String marca;
  final List<ProdutosRelatorio> produtos;
  final double quantidade;

  MarcaProduto({this.marca, this.produtos, this.quantidade});
}
