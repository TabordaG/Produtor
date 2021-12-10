import 'package:produtor/pages/compras_terceiros/compras_bloc.dart';
import 'package:produtor/pages/estoque/estoque_abas.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../dados_basicos.dart';

class TelaComprasEstoque extends StatefulWidget {
  final id_sessao;

  @override
  _TelaComprasEstoqueState createState() => _TelaComprasEstoqueState();

  TelaComprasEstoque({
    this.id_sessao,
  });
}

class _TelaComprasEstoqueState extends State<TelaComprasEstoque> {
  final _bloc = ComprasBloc();
  List<Produto> produtos = List<Produto>();

  @override
  void initState() {
    listaFornecedor(widget.id_sessao).then((resultado) {
      setState(() {});
    });
    listaProdutos(widget.id_sessao).then((resultado) {
      setState(() {});
    });
    super.initState();
//    _bloc.iniciaProduto(Produto(nome: '', quantidade: '', preco: ''));
  }

  @override
  Widget build(BuildContext context) {
    var _key = GlobalKey<ScaffoldState>();
    final focus1 = FocusNode();
    final focus2 = FocusNode();
    final focus3 = FocusNode();
    final focus4 = FocusNode();
    final focus5 = FocusNode();
    return Scaffold(
        key: _key,
//        appBar: AppBar(
//          title: Text("Inserir Compra"),
//          centerTitle: true,
//          backgroundColor: Colors.teal,
//        ),
        body: ListView(children: <Widget>[
          Container(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, bottom: 10.0, top: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: Text(
                                  'Nº da Nota Fiscal:',
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 0, 0, 0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.fromLTRB(0, 0, 0, -20),
                                    ),
                                    textInputAction: TextInputAction.next,
                                    focusNode: focus1,
                                    onSubmitted: (text) {
                                      focus1.unfocus();
                                    },
                                    controller: _bloc.outNumeroNota,
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: Text(
                                  'Data de Emissão:',
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 0, 0, 0),
                                  child: RaisedButton(
                                    onPressed: () {
                                      DatePicker.showDatePicker(context,
                                          showTitleActions: true,
                                          minTime: DateTime(2018, 1, 1),
                                          maxTime: DateTime(2099, 12, 31),
                                          onConfirm: (date) {
                                        setState(() {
                                          _bloc.dataEmissao =
                                              "${date.day}/${date.month}/${date.year}";
                                        });
                                      },
                                          currentTime: DateTime.now(),
                                          locale: LocaleType.pt);
                                    },
                                    child: _bloc.dataEmissao != null
                                        ? Text(_bloc.dataEmissao)
                                        : Text(
                                            '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, bottom: 0.0, top: 0.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                        child: Padding(
                            padding: const EdgeInsets.only(left: 0.0),
                            child: Container(
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Fornecedor:",
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              //color: Colors.teal,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  width:
                                                      1, //                   <--- border width here
                                                ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        20.0) //         <--- border radius here
                                                    ),
                                              ),
                                              margin: const EdgeInsets.only(
                                                  left: 0.0, top: 5),
                                              alignment: Alignment.centerRight,
                                              child: Center(
                                                child: DropdownButton<String>(
                                                    hint: Text("Fornecedor"),
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                    ),
                                                    //isExpanded: true,
                                                    value: _bloc
                                                        .selectedFornecedor,
                                                    items: Fornecedores != null
                                                        ? Fornecedores.map<
                                                                DropdownMenuItem<
                                                                    String>>(
                                                            (fornecedor) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: fornecedor,
                                                              child: Text(
                                                                fornecedor,
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      15.0,
                                                                ),
                                                              ),
                                                            );
                                                          }).toList()
                                                        : <String>[''].map<
                                                                DropdownMenuItem<
                                                                    String>>(
                                                            (fornecedor) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: fornecedor,
                                                              child: Text(
                                                                fornecedor,
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize:
                                                                      15.0,
                                                                ),
                                                              ),
                                                            );
                                                          }).toList(),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _bloc.selectedFornecedor =
                                                            value;
                                                      });
                                                    }),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0),
                                            child: Text(
                                              'Natureza da Operação:',
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      15, 0, 0, 0),
                                              child: TextField(
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.fromLTRB(
                                                          0, 0, 0, -20),
                                                ),
                                                textInputAction:
                                                    TextInputAction.next,
                                                focusNode: focus2,
                                                onSubmitted: (text) {
                                                  focus2.unfocus();
                                                },
                                                keyboardType:
                                                    TextInputType.text,
                                                controller:
                                                    _bloc.outNaturezaOperacao,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ])))),
                  ])),
          Container(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, bottom: 10.0, top: 0.0),
              child: Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  child: Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Produtos:",
                              style: TextStyle(
                                  fontSize: 12.0, fontWeight: FontWeight.w500),
                            ),
                            Flexible(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width:
                                              1, //                   <--- border width here
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                20.0) //         <--- border radius here
                                            ),
                                      ),
                                      margin: EdgeInsets.only(top: 5),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      //alignment: Alignment.centerLeft,
                                      // width: 200,
                                      // alignment: Alignment.centerRight,
                                      child: DropdownButton<String>(
                                          isExpanded: true,
                                          hint: Text("Produto"),
                                          style: TextStyle(
                                            fontSize: 12.0,
                                          ),
                                          value: _bloc.selectedProduto,
                                          items: Produtos != null
                                              ? Produtos.map<
                                                      DropdownMenuItem<String>>(
                                                  (Produto) {
                                                  return DropdownMenuItem<
                                                          String>(
                                                      value: Produto,
                                                      child: Text(
                                                        Produto,
                                                        softWrap: true,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Colors.black,
                                                          fontSize: 15.0,
                                                        ),
                                                      ));
                                                }).toList()
                                              : <String>[
                                                  ''
                                                ].map<DropdownMenuItem<String>>(
                                                  (produto) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: produto,
                                                    child: Text(
                                                      produto,
                                                      softWrap: true,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.black54,
                                                        fontSize: 15.0,
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              _bloc.selectedProduto = value;
                                            });
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, left: 5),
                                  child: Text(
                                    'Quantidade:',
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, left: 15),
                                  child: Text(
                                    'Preço Total:',
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, left: 35),
                                  child: Text(
                                    'Incluir',
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                            // Divider(),
                            Row(
                              children: <Widget>[
                                Container(
                                  //color: Colors.teal,
                                  padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                                  width: 69,
                                  height: 40,
                                  child: TextField(
                                    textAlign: TextAlign.end,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.fromLTRB(0, 0, 0, -20),
                                    ),
                                    textInputAction: TextInputAction.next,
                                    focusNode: focus3,
                                    onSubmitted: (text) {
                                      focus3.unfocus();
                                      FocusScope.of(context)
                                          .requestFocus(focus4);
                                    },
                                    keyboardType: TextInputType.text,
                                    controller: _bloc.outProdutosQuantidade,
//                                                       onEditingComplete: _bloc.addProduto(),
                                  ),
                                ),
                                Container(
                                  //color: Colors.teal,
                                  padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                  width: 80,
                                  height: 40,
                                  child: TextField(
                                    textAlign: TextAlign.end,
                                    decoration: InputDecoration(
                                      prefixText: "R\$",
                                      contentPadding:
                                          EdgeInsets.fromLTRB(0, 0, 0, -20),
                                    ),
                                    textInputAction: TextInputAction.next,
                                    focusNode: focus4,
                                    onSubmitted: (text) {
                                      focus4.unfocus();
                                    },
                                    keyboardType: TextInputType.text,
                                    controller: _bloc.outProdutosPreco,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 0, 0, 0),
                                  child: IconButton(
                                      icon: Icon(
                                        Icons.add_circle,
                                        color: Colors.teal,
                                        size: 30,
                                      ),
                                      onPressed: () {
                                        var result;
                                        setState(() {
                                          result = _bloc.addProduto();
                                        });
                                      }),
                                )
                              ],
                            ),
                            Divider(),
                            _bloc.listaProdutos.length > 0
                                ? Container(
                                    child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: _bloc.listaProdutos.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  padding:
                                                      EdgeInsets.only(left: 5),
                                                  width: 100,
                                                  child: Text(
                                                    _bloc.listaProdutos[index]
                                                        .nome,
                                                    maxLines: 99,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      EdgeInsets.only(left: 10),
                                                  width: 75,
                                                  child: Text(
                                                    _bloc.listaProdutos[index]
                                                        .quantidade,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      EdgeInsets.only(left: 0),
                                                  width: 80,
                                                  child: Text(
                                                    "R\$ ${_bloc.listaProdutos[index].preco}",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                IconButton(
                                                    icon: Icon(
                                                      Icons.delete,
                                                      color: Colors.teal,
                                                      size: 18,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        _bloc.removeProduto(
                                                            index);
                                                      });
                                                    })
                                              ],
                                            ),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color:
                                                            Colors.black12))),
                                          );
                                        }),
                                  )
                                : Container(
                                    height: 1,
                                  ),
                          ])))),
          Container(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, bottom: 10.0, top: 0.0),
              child: Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
                  child: Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Faturamento:"),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Forma de Pagamento:"),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: DropdownButton<String>(
                                    value: _bloc.selectedPgto,
                                    onChanged: (value) {
                                      setState(() {
                                        _bloc.selectedPgto = value;
                                      });
                                    },
                                    items: formasdePagamento != null
                                        ? formasdePagamento
                                            .map<DropdownMenuItem<String>>(
                                                (value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black,
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                            );
                                          }).toList()
                                        : <String>['']
                                            .map<DropdownMenuItem<String>>(
                                                (value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black54,
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Valor Total:"),
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  width: 100,
                                  child: TextField(
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.end,
                                    decoration: InputDecoration(
                                      prefixText: "R\$",
                                      contentPadding:
                                          EdgeInsets.fromLTRB(0, 0, 0, -20),
                                    ),
                                    focusNode: focus5,
                                    onSubmitted: (text) {
                                      focus5.unfocus();
                                    },
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.text,
                                    controller: _bloc.outValorFaturamento,
                                  ),
                                ),
                              ],
                            ),
                          ])))),
          Container(
              child: RaisedButton(
            color: Colors.teal,
            child: Container(
              height: 40,
              child: Center(
                child: Text(
                  "Confirmar Compra",
                  style: TextStyle(
                    fontSize: 22,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            onPressed: () async {
              await _bloc.finalizaCompra(widget.id_sessao);
              _key.currentState.showSnackBar(SnackBar(
                content: Text(_bloc.status),
              ));
              if (_bloc.status == 'Sucesso!')
                Navigator.of(context).push(
                  new MaterialPageRoute(
                      // aqui temos passagem de valores id cliente(sessao) de login para home
                      builder: (context) =>
                          estoque_Abas(id_sessao: widget.id_sessao)),
                );
            },
          ))
        ]));
  }
}

Future<List> listaFornecedor(String id_sessao) async {
  //print(id_sessao);
  Fornecedores.clear();
  String link = Basicos.codifica("${Basicos.ip}"
      "/crud/?crud=consult93.${id_sessao}");
  var res = await http
      .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
  //print('/crud/?crud=consult49.${widget.id_sessao},10,${Basicos.offset}');
  //var res =Basicos.decodifica(res1.body);

  if (res.body.length > 2) {
    if (res.statusCode == 200) {
      // converte a lista de consulta em uma lista dinamica
      List list = json.decode(res.body).cast<Map<String, dynamic>>();
      //Meus_pedidos = list;
      for (var i = 0; i < list.length; i++) {
        Fornecedores.add(
            '${list[i]['id']}- ' + '${list[i]['nome_razao_social']}');
        //print(list[i]['data_venda']);
      }
      return list;
    }
  }
}

// produtos
Future<List> listaProdutos(String id_sessao) async {
  //print(id_sessao);
  Produtos.clear();
  String link = Basicos.codifica("${Basicos.ip}"
      "/crud/?crud=consult94.${id_sessao}");
  var res = await http
      .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
  //print('/crud/?crud=consult49.${widget.id_sessao},10,${Basicos.offset}');
  //var res =Basicos.decodifica(res1.body);

  if (res.body.length > 2) {
    if (res.statusCode == 200) {
      // converte a lista de consulta em uma lista dinamica
      List list = json.decode(res.body).cast<Map<String, dynamic>>();
      //Meus_pedidos = list;
      for (var i = 0; i < list.length; i++) {
        Produtos.add(
            '${list[i]['id']}-(${list[i]['estoque_atual'].toString().substring(0, list[i]['estoque_atual'].toString().indexOf('.', 0))}) ' +
                '${list[i]['descricao_simplificada']}');
        //print(list[i]['descricao_simplificada']);
      }
      return list;
    }
  }
}

List formasdePagamento = ['Débito', 'Crédito', 'Boleto', "Dinheiro", "Outros"];

List Fornecedores = [];
//List Fornecedores = [
//  'Mercado Ki-Tem',
//  'Big Lar',
//  "Ecofeira",
//];

List Produtos = [];
