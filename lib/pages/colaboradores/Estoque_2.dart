import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:produtor/pages/dados_basicos.dart';
import 'package:toast/toast.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'estoque_2_aba.dart';

var listaEstoque = new List<Produto>();

class EstoqueP2 extends StatefulWidget {
  final id_sessao;
  final id_colaborador;

  EstoqueP2({Key key, this.id_sessao, this.id_colaborador}) : super(key: key);

  @override
  _EstoqueP2State createState() => _EstoqueP2State();
}

class _EstoqueP2State extends State<EstoqueP2> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey(); // snackbar
  Status _currentState;
  List<Status> status = <Status>[
    const Status("ANUNCIADO"),
    const Status('SEM ANUNCIO'),
  ];
  StreamController listaStream;

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
        if (Basicos.offset < Basicos.meus_produtos.length) {
          //atualiza pagina com offset
          Basicos.pagina = _controller.offset;
          // aumenta o offset da consulta no banco
          Basicos.offset = Basicos.offset +
              10; //preenche o grid com a quantidade lida do banco menos dois uma fileira

          // print(_controller.offset);
          // print(Basicos.pagina);
          // _controller.jumpTo(50.0);
          listProdutos();
          // Navigator.of(context).push(new MaterialPageRoute(
          //   // aqui temos passagem de valores id cliente(sessao) de login para home
          //   builder: (context) => new estoque_Abas(id_sessao: widget.id_sessao),
          // ));
        } else
          Basicos.offset = Basicos.meus_produtos.length;
      });
    }
  }

  void initState() {
    listaEstoque = [];
    Basicos.offset = 0;
    Basicos.product_list = [];
    Basicos.meus_pagamentos = [];
    listaStream = StreamController();
    listaStream.sink.add(listaEstoque);
    _controller = ScrollController(
        //initialScrollOffset: Basicos.pagina,
        );
    _controller.addListener(_scrollListener);
    listProdutos().then((resultado) {
      setState(() {});
    });

    super.initState();
    // refresh_List();
    // refresh_db();
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    listaStream.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: new Column(children: [
        Container(
            color: Colors.black12,
            child: Row(children: [
              new Expanded(
                  flex: 4,
                  child: Padding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 0, bottom: 6, top: 6),
                      child: Text("Descrição",
                          style: new TextStyle(
                            height: 2.0,
                            fontSize: 15.2,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center))),
              new Expanded(
                  flex: 1,
                  child: Padding(
                      padding: const EdgeInsets.only(
                          left: 6, right: 0, bottom: 6, top: 6),
                      child: Text('Qtd',
                          style: new TextStyle(
                            height: 2.0,
                            fontSize: 15.2,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center))),
              new Expanded(
                  flex: 4,
                  child: Padding(
                      padding: const EdgeInsets.only(
                          left: 0, right: 0, bottom: 6, top: 6),
                      child: Text('Anunciar',
                          style: new TextStyle(
                            height: 2.0,
                            fontSize: 15.2,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center))),
              new Expanded(
                  flex: 1,
                  child: Padding(
                      padding: const EdgeInsets.only(
                          left: 0, right: 0, bottom: 6, top: 6),
                      child: Text('',
                          style: new TextStyle(
                            height: 2.0,
                            fontSize: 15.2,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center))),
            ])),
        Expanded(
            child: StreamBuilder(
                stream: listaStream.stream,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    default:
                      List<Produto> listaProdutos = snapshot.data;
                      return Scrollbar(
                        child: ListView.builder(
                          controller: _controller,
                          itemCount: listaProdutos.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: new Row(children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Container(
                                      width: 50.0,
                                      height: 43.0,
                                      padding: EdgeInsets.all(0.0),
                                      //diminui a figura
                                      child: Image.network(
                                          get_picture(
                                              listaProdutos[index].picture),
                                          fit: BoxFit.fill),
                                    ),
                                    Text('# ${listaProdutos[index].id}',
                                        textScaleFactor: 0.7,
                                        style: TextStyle(
                                          color: Colors.grey,
                                        )),
                                  ],
                                ),
                                new Expanded(
                                    flex: 2,
                                    child: new Column(children: <Widget>[
                                      new Row(children: <Widget>[
                                        new Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5,
                                                right: 0,
                                                bottom: 2,
                                                top: 10),
                                            child: new SizedBox(
                                              child: Text(
                                                listaProdutos[index].descricao,
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                      //NOME DA MARCA / PRODUTOR
                                      Text(
                                        listaProdutos[index].marca,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54),
                                        textAlign: TextAlign.center,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 10.0),
                                        child: Text(
                                          "R${transform(listaProdutos[index].preco_venda)}",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.teal),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ])),
                                new Expanded(
                                  flex: 1,
                                  //crossAxisAlignment: CrossAxisAlignment.center,
                                  child: InkWell(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 0,
                                          right: 0,
                                          bottom: 12,
                                          top: 12),
                                      child: new Text(
                                        "${listaProdutos[index].estoque_atual.toString()} ${listaProdutos[index].unidade}",
                                        textAlign: TextAlign.center,
                                        textScaleFactor: 1.1,
                                      ),
                                    ),
                                  ),
                                ),
                                new Expanded(
                                  flex: 3,
                                  child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 0,
                                          bottom: 12,
                                          top: 12),
                                      child: Row(children: <Widget>[
                                        Expanded(
                                          child: new DropdownButton<Status>(
                                            hint: Text(listaProdutos[index]
                                                .anunciar
                                                .toString()),
                                            value: _currentState,
                                            onChanged: (Status newValue) {
                                              setState(() async {
                                                await grava_status(
                                                    listaProdutos[index]
                                                        .id
                                                        .toString(),
                                                    newValue.name);
                                                Navigator.of(context).push(
                                                  new MaterialPageRoute(
                                                      // aqui temos passagem de valores id cliente(sessao) de login para home
                                                      builder: (context) =>
                                                          estoque_aba2(
                                                            id_sessao: widget
                                                                .id_sessao,
                                                            id_colaborador: widget
                                                                .id_colaborador,
                                                          )),
                                                );
                                                _currentState = newValue;
                                              });
                                            },
                                            isExpanded: true,
                                            items: status.map((Status status) {
                                              return new DropdownMenuItem<
                                                  Status>(
                                                value: status,
                                                child: new Text(
                                                  status.name,
                                                  style: new TextStyle(
                                                      color: Colors.black),
                                                ),
                                              );
                                            }).toList(),
                                            style: new TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ])),
                                ),
                                new Expanded(
                                  flex: 1,
                                  child: IconButton(
                                    onPressed: () async {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return MeuDialog(
                                                indice: index,
                                                id_sessao: widget.id_sessao,
                                                id_colaborador:
                                                    widget.id_colaborador);
                                          });
                                    },
                                    icon: new Icon(
                                      Icons.keyboard_arrow_right,
                                      color: Colors.teal,
                                    ),
                                  ),
                                )
                              ]),
                            );
                          },
                        ),
                      );
                  }
                }))
      ]),
//      floatingActionButton: FloatingActionButton(
//        onPressed: () {
//          // Add your onPressed code here!
//        },
//        child: Icon(Icons.edit),
//        backgroundColor: Colors.teal,
//      ),
    );
  }

  // Lista produtos
  Future<List> listProdutos() async {
    // busca marca colaborador

// seleciona marca
    String link = Basicos.codifica(
        "${Basicos.ip}/crud/?crud=consul103.${widget.id_colaborador}");
    var resx1 = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    var resx = Basicos.decodifica(resx1.body);
    //print("${Basicos.ip}/crud/?crud=consul103.${widget.id_colaborador}");
    if (resx1.body.length > 2) {
      if (resx1.statusCode == 200) {
        var listx = json.decode(resx).cast<Map<String, dynamic>>();

        //print(widget.id_sessao);
        double qtd, venda;
        String anuncio;
        String link = Basicos.codifica("${Basicos.ip}"
            "/crud/?crud=consul108.${widget.id_sessao},${listx[0]['observacoes'].toString()},10,${Basicos.offset}");
        var res = await http
            .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
        //print(res.body);
        //var res =Basicos.decodifica(res1.body);
        if (res.body.length == 2)
          new Future.delayed(const Duration(seconds: 1)) //snackbar
              .then((_) => _showSnackBar('Sem Novos Produtos Cadastrados...'));
        else
          new Future.delayed(const Duration(seconds: 1)) //snackbar
              .then((_) => _showSnackBar('Carregando...')); //snackbar

        if (res.body.length > 2) {
          if (res.statusCode == 200) {
            // converte a lista de consulta em uma lista dinamica
            List list = json.decode(res.body).cast<Map<String, dynamic>>();
            print(list[0]);
            //Lista = list;
            for (var i = 0; i < list.length; i++) {
              Basicos.meus_produtos.add(list[i]);
              // print(list[i]["quantidade"].toString());
              // evita nulo na quantidade
              if (list[i]["quantidade"].toString() == 'null')
                qtd = 0.0;
              else
                qtd = double.parse(list[i]["quantidade"].toString());
              // evita nulo no preco de venda
              if (list[i]['preco_venda'].toString() == 'null')
                venda = 0.0;
              else
                venda = double.parse(list[i]['preco_venda'].toString());

              // anuncio 0 ou 1 para anunciar ou sem anuncio
              if (list[i]["anunciar_produto"] == 1)
                anuncio = 'ANUNCIADO';
              else
                anuncio = 'SEM ANUNCIO';
              listaEstoque.add(Produto(
                id: list[i]["id_produto"],
                descricao: list[i]["descricao_simplificada"],
                marca: list[i]['descricao'],
                estoque_atual: qtd,
                //double.parse(list[i]["quantidade"].toString()),
                unidade: list[i]['unidade_medida'],
                preco_venda: venda,
                // double.parse(list[i]['preco_venda'].toString()),
                anunciar: anuncio,
                //list[i]['data_validade'].toString().replaceAll('-','')),//list[i]['data_validade'],
                picture: list[i]['imagem'],
                validade: DateTime.now().add(new Duration(days: 7)),
                // adiciona 7 dias na data de hj
                cadastro: DateTime.now(),
              ));
              listaStream.sink.add(listaEstoque);
            }
            return list;
          }
        }
      }
    }
  }

  transform(double value) {
    FlutterMoneyFormatter fmf = FlutterMoneyFormatter(amount: value);
    return fmf.output.symbolOnLeft;
  }
}

class MeuDialog extends StatefulWidget {
  final indice, id_sessao;
  final id_colaborador;

  MeuDialog({this.indice, this.id_sessao, this.id_colaborador}); // index
  @override
  _MeuDialogState createState() => new _MeuDialogState();
}

class _MeuDialogState extends State<MeuDialog> {
  //int index =1;
  double newestoque, newpreco_atual;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text(
          "Adicionar Estoque: \n${listaEstoque[widget.indice].descricao}"),
      content: Container(
        color: Colors.black.withOpacity(.10),
        width: double.maxFinite,
        height: double.maxFinite, //700.0,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: ListView(
            children: <Widget>[
              Text(
                  'Estoque atual: ${listaEstoque[widget.indice].estoque_atual} ${listaEstoque[widget.indice].unidade} \nPreço: R\$ ${(listaEstoque[widget.indice].preco_venda).toStringAsFixed(2).replaceAll('.', ',')}'),
              TextFormField(
                //controller: newestoque,
                decoration: InputDecoration(
                  labelText: 'Adicionar ao Estoque (qtd):',
                  //hintText: '0'
                  counterText: "", // remove os numero do contador do maxleng
                ),
                autovalidate: true,
                keyboardType: TextInputType.numberWithOptions(
                    decimal: false, signed: false),
                initialValue: '',
                onChanged: (value) {
                  newestoque = double.parse(value);
                },
                maxLength: 10,
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
//                validator: (input) {
//                  final isDigitsOnly = int.tryParse(input);
//                  return isDigitsOnly == null
//                      ? 'digitos apenas'
//                      : null;
//                },
              ),
              TextFormField(
                //controller: newestoque,
                decoration: InputDecoration(
                  labelText: 'Preço atual: (ex.: 5,35)',
                  counterText: "", // remove os numero do contador do maxleng
                ),
                maxLength: 10,
                keyboardType: TextInputType.numberWithOptions(
                    decimal: true, signed: false),
                initialValue: listaEstoque[widget.indice]
                    .preco_venda
                    .toStringAsFixed(2)
                    .replaceAll('.', ','),
                onChanged: (value) {
                  newpreco_atual = double.parse(value.replaceAll(',', '.'));
                },
              ),
              Text(
                '\nData Cadastro: ',
                style: TextStyle(
                  fontSize: 12.0,
                  // fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(.6),
                ),
              ),
              RaisedButton(
                color: Colors.teal.withOpacity(0.4),
                onPressed: () async =>
                    await _dataCadastro(context, widget.indice),
                child: new Text(
                  // '${DateTime.now()}',
                  "${listaEstoque[widget.indice].cadastro.day}" +
                      '/' +
                      '${listaEstoque[widget.indice].cadastro.month}' +
                      '/' +
                      '${listaEstoque[widget.indice].cadastro.year}',

                  // .substring(0, Products_on_List[index].pedido_prod_qtd.toString().indexOf('.', 0))
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.1,
                  style: TextStyle(fontSize: 12),
                ),
              ),
              Text(
                '\nData Validade: ',
                style: TextStyle(
                  fontSize: 12.0,
                  // fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(.6),
                ),
              ),
              RaisedButton(
                color: Colors.teal.withOpacity(0.4),
                onPressed: () async =>
                    await _dataValidade(context, widget.indice),
                child: new Text(
                  // '${DateTime.now()}',
                  "${listaEstoque[widget.indice].validade.day}" +
                      '/' +
                      '${listaEstoque[widget.indice].validade.month}' +
                      '/' +
                      '${listaEstoque[widget.indice].validade.year}',
                  // .substring(0, Products_on_List[index].pedido_prod_qtd.toString().indexOf('.', 0))
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.1,
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        new FlatButton(
          child: new Text(
            "Atualizar",
            style: TextStyle(color: Colors.teal),
          ),
          onPressed: () async {
            // insere dados no banco
            if (newestoque == null) newestoque = 0.0;
            if (newpreco_atual == null)
              newpreco_atual = listaEstoque[widget.indice].preco_venda;
            var retorno = await gravaEstoque(
                newestoque.toString(),
                newpreco_atual.toString().replaceAll(',', '.'),
                "${listaEstoque[widget.indice].cadastro.day}" +
                    '/' +
                    '${listaEstoque[widget.indice].cadastro.month}' +
                    '/' +
                    '${listaEstoque[widget.indice].cadastro.year}',
                "${listaEstoque[widget.indice].validade.day}" +
                    '/' +
                    '${listaEstoque[widget.indice].validade.month}' +
                    '/' +
                    '${listaEstoque[widget.indice].validade.year}',
                '${listaEstoque[widget.indice].id.toString()}',
                '${listaEstoque[widget.indice].estoque_atual.toString()}');
            if (retorno == 'sucesso')
              Toast.show("Estoque atualizado", context,
                  duration: Toast.LENGTH_LONG,
                  gravity: Toast.CENTER,
                  backgroundRadius: 0.0);
            Navigator.of(context).push(
              new MaterialPageRoute(
                  // aqui temos passagem de valores id cliente(sessao) de login para home
                  builder: (context) => estoque_aba2(
                        id_sessao: widget.id_sessao,
                        id_colaborador: widget.id_colaborador,
                      )),
            );
          },
        ),
        new FlatButton(
          child: new Text(
            "Cancelar",
            style: TextStyle(color: Colors.teal),
          ),
          onPressed: () {
            newestoque = null;
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Future<Null> _dataCadastro(BuildContext context, int index) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: listaEstoque[index].cadastro,
        firstDate: DateTime(1900, 7),
        lastDate: DateTime(2101));
    if (picked != null && picked != listaEstoque[index].cadastro)
      setState(() {
        listaEstoque[index].cadastro = picked;
        //print(Lista[index].cadastro);
      });
  }

  Future<Null> _dataValidade(BuildContext context, int index) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: listaEstoque[index].validade,
        firstDate: DateTime(1900, 7),
        lastDate: DateTime(2101));
    if (picked != null && picked != listaEstoque[index].validade)
      setState(() {
        listaEstoque[index].validade = picked;
      });
  }

//  transform(double value) {
//    FlutterMoneyFormatter fmf = FlutterMoneyFormatter(amount: value);
//    return fmf.output.symbolOnLeft;
//  }

// grava os dados de entrada estoque
  Future<String> gravaEstoque(
      String estoque,
      String preco,
      String data_cadastro,
      String data_validade,
      String produto,
      String estoque_atual) async {
// sequencia para registro de entrada no estoque

//  //1) inserir na tabela compras compras
    String link = Basicos.codifica("${Basicos.ip}/crud/?crud=consult52."
        //    id integer NOT NULL DEFAULT nextval('compras_id_seq'::regclass),
        //    solicitante character varying(20) NOT NULL,
        //    data_compra date NOT NULL,
        //    nota_fiscal character varying(15) NOT NULL,
        //    valor_total numeric(15,2) NOT NULL,
        //    status_compra character varying(30) NOT NULL,
        //    observacoes text NOT NULL,
        //    data_registro timestamp with time zone NOT NULL,
        //    data_alteracao timestamp with time zone NOT NULL,
        //    empresa_id integer,
        //    fornecedor_id integer NOT NULL,
        //    pagamento_id integer,
        );

    var res1 = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    var res2 = Basicos.decodifica(res1.body);
    if (res1.body.length > 2) {
      if (res1.statusCode == 200) {
        var list = json.decode(res2).cast<Map<String, dynamic>>();
        //print(list[0]['id']); // retorna o id inserido na tabelas
        // caso inserido com sucesso e id retornado insere os produtos na tabela saida_produtos
        if (list[0]['id'] != Null) {
//2) inseir em conta a pagar
          String link2 = Basicos.codifica("${Basicos.ip}/crud/?crud=consult53."
              //    id integer NOT NULL DEFAULT nextval('produtos_id_seq'::regclass),
              //        data_conta,
              //        valor_conta,
              //        forma_de_pagamento,
              //        meio_de_pagamento,
              //        quantidade_parcelas,
              //        primeiro_vencimento,
              //        valor_entrada,
              //        documento_vinculado,
              //        status_conta,
              //        descricao,
              //        data_registro,
              //        data_alteracao,
              //        observacoes_conta,
              //        empresa_id,
              "${list[0]['id']}" //        favorecido_id,
              );

          var res3 = await http.get(Uri.encodeFull(link2),
              headers: {"Accept": "application/json"});
          var res4 = Basicos.decodifica(res3.body);

          if (res3.body.length > 2) {
            if (res3.statusCode == 200) {
              var list2 = json.decode(res4).cast<Map<String, dynamic>>();
              //print(list[0]['id']); // retorna o id inserido na tabelas
              // caso inserido com sucesso e id retornado insere os produtos na tabela saida_produtos
              if (list2[0]['id'] != Null) {
// fazer update em compras com o pagamento id
                String link3 =
                    Basicos.codifica("${Basicos.ip}/crud/?crud=consult54."
                        "${list[0]['id']}," //        id de compras,
                        "${list2[0]['id']}" //        pagamento_id,
                        );
                var res3 = await http.get(Uri.encodeFull(link3),
                    headers: {"Accept": "application/json"});

// inserir em entrada produtos a quantidade no estoque de produtos

                String link4 = Basicos.codifica(
                    "${Basicos.ip}/crud/?crud=consult55."
                    //    id integer NOT NULL DEFAULT nextval('entrada_produtos_id_seq'::regclass),
                    "${estoque}," //    quantidade numeric(15,3) NOT NULL
                    "${preco}," //    preco_compra numeric(15,3) NOT NULL,
                    "${data_cadastro}," //    data_entrada date NOT NULL,
                    //    data_fabricacao date,
                    "${data_validade}," //    data_validade date,
                    //    numero_lote character varying(20) NOT NULL
                    "${(double.parse(estoque) * double.parse(preco)).toString()}," //    total numeric(15,2) NOT NULL,
                    //    balanco character varying(20) NOT NULL,
                    //    status_entrada character varying(15) NOT NULL,
                    //    observacoes_entrada text NOT NULL,
                    "${data_cadastro}," //    data_registro timestamp with time zone NOT NULL,
                    //    data_alteracao timestamp with time zone NOT NULL,
                    "${list[0]['id']}," //    compra_id integer,
                    //    empresa_id integer,
                    "${produto}" //    produto_id integer,

                    );
                var res5 = await http.get(Uri.encodeFull(link4),
                    headers: {"Accept": "application/json"});
                var res6 = Basicos.decodifica(res5.body);
                if (res5.body.length > 2) {
                  if (res5.statusCode == 200) {
                    var list2 = json.decode(res6).cast<Map<String, dynamic>>();
// update quantidade e valor do produto

                    String link5 = Basicos.codifica(
                        "${Basicos.ip}/crud/?crud=consult56."
                        "${produto}," //        id de produto,
                        "${(double.parse(estoque) + double.parse(estoque_atual)).toString()}," //        estoque atual,
                        "${preco}" //        preco venda,
                        );
                    var res7 = await http.get(Uri.encodeFull(link5),
                        headers: {"Accept": "application/json"});
                    return "sucesso";
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

String get_picture(String picture) {
  if (picture == '') {
    return '${Basicos.ip2}/media/estoque/produtos/img/product-01.jpg';
  } else {
    //print("${basicos().ip}/media/${prod_picture}");
    return "${Basicos.ip2}/media/$picture";
  }
}

class Produto {
  int id;
  String descricao;
  double estoque_atual;
  String unidade;
  double preco_venda;
  String anunciar;
  final picture;
  DateTime validade;
  DateTime cadastro;
  String marca;

  Produto(
      {this.id,
      this.descricao,
      this.estoque_atual,
      this.unidade,
      this.preco_venda,
      this.anunciar,
      this.picture,
      this.validade,
      this.cadastro,
      this.marca});
}

Future<String> grava_status(final numero_produto, final situacao) async {
  int sit;
  if (situacao == 'ANUNCIADO')
    sit = 1;
  else
    sit = 0;

  String link = Basicos.codifica("${Basicos.ip}"
      "/crud/?crud=consult51.${numero_produto},${sit}");
  var res = await http
      .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
  //print(res.body);
  //var res =Basicos.decodifica(res1.body);
  if (res.body.length > 2) {
    if (res.statusCode == 200) {
      return 'sucesso';
    }
  }
}

class Status {
  const Status(this.name);

  final String name;
}
