import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:produtor/pages/produtos/atualiza_produtos.dart';
import 'package:toast/toast.dart';
import 'package:produtor/pages/home.dart';
import 'package:produtor/pages/dados_basicos.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:strings/strings.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';

import '../../soft_buttom.dart';

class cadastroProduto2 extends StatefulWidget {
  final id_sessao;

  cadastroProduto2({
    this.id_sessao,
  });

  @override
  _cadastroProdutoState2 createState() => _cadastroProdutoState2();
}

class _cadastroProdutoState2 extends State<cadastroProduto2> {
  final _formKey = GlobalKey<FormState>();

  // List<String> lista_categorias = ['Verdura', 'Legume', 'Fruta'];

  List<String> _category_list = []; // dados estaticos de categorias
  List<String> _marcas_list = []; // dados estaticos de marcas
  //String dropdownValue;

  TextEditingController _produtoTextController = TextEditingController();
  TextEditingController _descricao_completaTextController =
      TextEditingController();
  TextEditingController _codigoTextController = TextEditingController();
  TextEditingController _qtdeEmbalagemTextController = TextEditingController();
  TextEditingController _unidadeTextController = TextEditingController();
  TextEditingController _cdgBarrasTextController = TextEditingController();
  TextEditingController _descMarketingTextController = TextEditingController();
  TextEditingController _observacoesTextController = TextEditingController();
  TextEditingController _precoTextController = TextEditingController();
  TextEditingController _buscaTextController = TextEditingController();

  String gender;
  bool hidePass = true;
  bool Loading = false;
  String _selectedIdcat;
  String _selectedIdmarca;
  double _top = -60;
  List<String> _busca_produtos = []; // consulta produto para edição

  ////////  VARIAVEIS PARA INSERÇÃO DA IMAGEM ///////
  File _image1;
  File _image2;
  File _image3;
  var image1;
  var image2;
  var image3;

  int index_tab = 0;

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 250), () {
      setState(() {
        _top = 0;
      });
    });
    //inicializa categoria
    buscaCategorias().then((resultado) {
      setState(() {});
    });
    //inicializa marca
    buscaMarca().then((resultado) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, top: 20, right: 20, bottom: 5),
                      child: Text(
                        'Dados Cadastrais',
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Scrollbar(
                        child: ListView(
                          children: <Widget>[
                            Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding:
                                        EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                    height: 60,
                                    alignment: Alignment(0, 0),
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          20.0, 10.0, 20.0, 0.0),
                                      child: Material(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 0.0),
                                          child: ListTile(
                                              title: TextFormField(
                                            controller: _produtoTextController,
                                            decoration: InputDecoration(
                                                suffix: Text('Nome do Produto',
                                                    style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontSize: 14.0,
                                                    )),
                                                hintText: "Nome do Produto",
                                                icon: Icon(
                                                  Icons.subdirectory_arrow_left,
                                                  size: 30,
                                                  color: Colors.teal,
                                                )),
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return "O Nome não pode ficar em branco";
                                              }
                                              return null;
                                            },
                                          )),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Container(
                                  //   padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                  //   height: 60,
                                  //   alignment: Alignment(0, 0),
                                  //   child: Padding(
                                  //     padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
                                  //     child: Material(
                                  //       child: Padding(
                                  //         padding: EdgeInsets.only(left: 0.0),
                                  //         child: ListTile(
                                  //             title: TextFormField(
                                  //           maxLines: null,
                                  //           expands: true,
                                  //           controller: _descricao_completaTextController,
                                  //           decoration: InputDecoration(
                                  //               suffix: Text('Descrição',
                                  //                   style: TextStyle(
                                  //                     fontStyle: FontStyle.italic,
                                  //                     fontSize: 14.0,
                                  //                   )),
                                  //               hintText: "Descrição Completa",
                                  //               icon: Icon(
                                  //                 Icons.description,
                                  //                 size: 30,
                                  //                 color: Colors.teal,
                                  //               )),
                                  //           validator: (value) {
                                  //             if (value.isEmpty) {
                                  //               return "Descrição não pode ficar vazia.";
                                  //             }
                                  //             return null;
                                  //           },
                                  //         )),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  Container(
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.fromLTRB(
                                              40.0, 20.0, 0.0, 0.0),
                                          alignment: Alignment.bottomLeft,
                                          //                          child: (Text(
                                          //                            'Categoria',
                                          //                            textAlign: TextAlign.left,
                                          //                            style: TextStyle(
                                          //                              fontStyle: FontStyle.italic,
                                          //                              fontSize: 14.0,
                                          //                            ),
                                          //                          )),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10.0, 0.0, 20.0, 0.0),
                                          child: ListTile(
                                            leading: Icon(
                                              Icons.category,
                                              size: 30,
                                              color: Colors.teal,
                                            ),
                                            subtitle: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0.0, 0.0, 10.0, 0.0),
                                              child: DropdownButton<String>(
                                                isExpanded: true,
                                                hint: const Text(
                                                  "Categoria",
                                                  style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                                value: _selectedIdcat,
                                                onChanged: (String value) {
                                                  setState(() {
                                                    _selectedIdcat = value;
                                                  });
                                                },
                                                items: _category_list
                                                    .map((String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(
                                                      value.substring(
                                                          value.indexOf(
                                                                  '-', 0) +
                                                              1,
                                                          value.length),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.black54,
                                                        fontSize: 15.0,
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.fromLTRB(
                                              40.0, 20.0, 0.0, 0.0),
                                          alignment: Alignment.bottomLeft,
                                          //                          child: (Text(
                                          //                            'Marca',
                                          //                            textAlign: TextAlign.left,
                                          //                            style: TextStyle(
                                          //                              fontStyle: FontStyle.italic,
                                          //                              fontSize: 14.0,
                                          //                            ),
                                          //                          )),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10.0, 0.0, 20.0, 0.0),
                                          child: ListTile(
                                            leading: Icon(
                                              Icons.bookmark,
                                              size: 30,
                                              color: Colors.teal,
                                            ),
                                            subtitle: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0.0, 0.0, 10.0, 0.0),
                                              child: DropdownButton<String>(
                                                isExpanded: true,
                                                hint: const Text(
                                                  "Marca",
                                                  style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                                value: _selectedIdmarca,
                                                onChanged: (String value) {
                                                  setState(() {
                                                    _selectedIdmarca = value;
                                                  });
                                                },
                                                items: _marcas_list
                                                    .map((String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(
                                                      value.substring(
                                                          value.indexOf(
                                                                  '-', 0) +
                                                              1,
                                                          value.length),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.black54,
                                                        fontSize: 15.0,
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                    height: 60,
                                    alignment: Alignment(0, 0),
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          20.0, 10.0, 20.0, 0.0),
                                      child: Material(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 0.0),
                                          child: ListTile(
                                              title: TextFormField(
                                            controller: _codigoTextController,
                                            decoration: InputDecoration(
                                                suffix: Text('Código Embalagem',
                                                    style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontSize: 14.0,
                                                    )),
                                                hintText: "Código Embalagem",
                                                icon: Icon(
                                                  Icons.code,
                                                  size: 30,
                                                  color: Colors.teal,
                                                )),
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return "O Código não pode ficar em branco";
                                              }
                                              return null;
                                            },
                                            keyboardType: TextInputType.number,
                                          )),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                    height: 60,
                                    alignment: Alignment(0, 0),
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          20.0, 10.0, 20.0, 0.0),
                                      child: Material(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 0.0),
                                          child: ListTile(
                                              title: TextFormField(
                                            controller:
                                                _qtdeEmbalagemTextController,
                                            decoration: InputDecoration(
                                                suffix: Text('Quantidade',
                                                    style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontSize: 14.0,
                                                    )),
                                                hintText:
                                                    "Quantidade por embalagem",
                                                icon: Icon(
                                                  Icons.check,
                                                  size: 30,
                                                  color: Colors.teal,
                                                )),
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return "O campo não pode ficar em branco";
                                              }
                                              return null;
                                            },
                                            keyboardType: TextInputType.number,
                                          )),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                    height: 60,
                                    alignment: Alignment(0, 0),
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          20.0, 10.0, 20.0, 0.0),
                                      child: Material(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 0.0),
                                          child: ListTile(
                                              title: TextFormField(
                                            controller: _unidadeTextController,
                                            decoration: InputDecoration(
                                                suffix: Text('Unidade',
                                                    style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontSize: 14.0,
                                                    )),
                                                hintText: "Unidade",
                                                icon: Icon(
                                                  Icons.unarchive,
                                                  size: 30,
                                                  color: Colors.teal,
                                                )),
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return "O campo não pode ficar em branco";
                                              }
                                              return null;
                                            },
                                            keyboardType:
                                                TextInputType.multiline,
                                          )),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                    height: 60,
                                    alignment: Alignment(0, 0),
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          20.0, 10.0, 20.0, 0.0),
                                      child: Material(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 0.0),
                                          child: ListTile(
                                              title: TextFormField(
                                            controller:
                                                _cdgBarrasTextController,
                                            decoration: InputDecoration(
                                                suffix: Text('Código de Barras',
                                                    style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontSize: 14.0,
                                                    )),
                                                hintText: "Código de Barras",
                                                icon: Icon(
                                                  Icons.reorder,
                                                  size: 30,
                                                  color: Colors.teal,
                                                )),
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return "O campo não pode ficar em branco";
                                              }
                                              return null;
                                            },
                                            keyboardType: TextInputType.number,
                                          )),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                    height: 60,
                                    alignment: Alignment(0, 0),
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          20.0, 10.0, 20.0, 0.0),
                                      child: Material(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 0.0),
                                          child: ListTile(
                                              title: TextFormField(
                                            controller: _precoTextController,
                                            decoration: InputDecoration(
                                                suffix: Text('Ex. 15,30',
                                                    style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontSize: 14.0,
                                                    )),
                                                hintText: "Preço Venda",
                                                icon: Icon(
                                                  Icons.attach_money,
                                                  size: 30,
                                                  color: Colors.teal,
                                                )),
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return "O campo não pode ficar em branco";
                                              } else {
                                                Pattern pattern =
                                                    '^[0-9]+?(.|,[0-9]{2})\$';
                                                RegExp regex =
                                                    new RegExp(pattern);
                                                if (!regex.hasMatch(value)) {
                                                  return 'Insira um valor válido';
                                                }
                                                // ^R\$(\d{1,3}(\.\d{3})*|\d+)(\,\d{2})?$
                                              }
                                              return null;
                                            },
                                            keyboardType: TextInputType.number,
                                          )),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                    height: 60,
                                    alignment: Alignment(0, 0),
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          20.0, 10.0, 20.0, 0.0),
                                      child: Material(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 0.0),
                                          child: ListTile(
                                              title: TextFormField(
                                            controller:
                                                _descMarketingTextController,
                                            decoration: InputDecoration(
                                                suffix: Text('Classificação',
                                                    style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontSize: 14.0,
                                                    )),
                                                hintText: "Classificação",
                                                icon: Icon(
                                                  Icons.equalizer,
                                                  size: 30,
                                                  color: Colors.teal,
                                                )),
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return "O campo não pode ficar em branco";
                                              }
                                              return null;
                                            },
                                            keyboardType:
                                                TextInputType.multiline,
                                          )),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                    height: 80,
                                    alignment: Alignment(0, 0),
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          20.0, 10.0, 20.0, 0.0),
                                      child: Material(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 0.0),
                                          child: ListTile(
                                              title: TextFormField(
                                            controller:
                                                _observacoesTextController,
                                            decoration: InputDecoration(
                                                suffix:
                                                    Text('Descrição Completa',
                                                        style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontSize: 14.0,
                                                        )),
                                                hintText: "Descrição Completa",
                                                icon: Icon(
                                                  Icons.edit,
                                                  size: 30,
                                                  color: Colors.teal,
                                                )),
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return "O campo não pode ficar em branco";
                                              }
                                              return null;
                                            },
                                            keyboardType:
                                                TextInputType.multiline,
                                          )),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        40.0, 10.0, 40.0, 10),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(12.0),
                                      color: Colors.teal,
                                      child: MaterialButton(
                                        onPressed: () async {
                                          String result = await validateForm();
                                          print(result);
                                          if (result == "sucesso") {
                                            Toast.show(
                                              "Cadastro Realizado com Sucesso",
                                              context,
                                              duration: Toast.LENGTH_LONG,
                                              gravity: Toast.CENTER,
                                              backgroundRadius: 0.0,
                                            );
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        new home2(
                                                            id_sessao: widget
                                                                .id_sessao)));
                                          } else {
                                            if (result == "falha_local") {
                                              Toast.show(
                                                  "Escolha uma Categoria ou Marca para o produto",
                                                  context,
                                                  duration: Toast.LENGTH_LONG,
                                                  gravity: Toast.CENTER,
                                                  backgroundRadius: 0.0);
                                            } else {
                                              Toast.show(
                                                  "Erro ao cadastrar", context,
                                                  duration: Toast.LENGTH_LONG,
                                                  gravity: Toast.CENTER,
                                                  backgroundRadius: 0.0);
                                            }
                                          }
                                        },
                                        minWidth:
                                            MediaQuery.of(context).size.width,
                                        child: Text(
                                          "Cadastrar",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  //                  Padding(
                                  //                    padding: const EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 0),
                                  //                    child: Material(
                                  //                      borderRadius: BorderRadius.circular(20.0),
                                  //                      color: Colors.teal,
                                  //                      child: MaterialButton(
                                  //                        onPressed: () async {
                                  //                          Upload(image1);
                                  //
                                  ////                          String result = await validateForm();
                                  ////                          print(result);
                                  ////                          if (result == "sucesso") {
                                  ////                            Toast.show(
                                  ////                              "Cadastro Realizado com Sucesso",
                                  ////                              context,
                                  ////                              duration: Toast.LENGTH_LONG,
                                  ////                              gravity: Toast.CENTER,
                                  ////                              backgroundRadius: 0.0,
                                  ////                            );
                                  ////                            Navigator.push(
                                  ////                                context,
                                  ////                                MaterialPageRoute(
                                  ////                                    builder: (context) =>
                                  ////                                    new home(id_sessao: widget.id_sessao)));
                                  ////                          } else {
                                  ////                            if (result == "falha_local") {
                                  ////                              Toast.show(
                                  ////                                  "Escolha uma Categoria ou Marca para o produto",
                                  ////                                  context,
                                  ////                                  duration: Toast.LENGTH_LONG,
                                  ////                                  gravity: Toast.CENTER,
                                  ////                                  backgroundRadius: 0.0);
                                  ////                            } else {
                                  ////                              Toast.show("Erro ao cadastrar", context,
                                  ////                                  duration: Toast.LENGTH_LONG,
                                  ////                                  gravity: Toast.CENTER,
                                  ////                                  backgroundRadius: 0.0);
                                  ////                            }
                                  ////                          }
                                  //                          print('teste1');
                                  //                        },
                                  //                        minWidth: MediaQuery.of(context).size.width,
                                  //                        child: Text(
                                  //                          "teste envio imagem",
                                  //                          textAlign: TextAlign.center,
                                  //                          style: TextStyle(
                                  //                              color: Colors.white,
                                  //                              fontWeight: FontWeight.bold,
                                  //                              fontSize: 20.0),
                                  //                        ),
                                  //                      ),
                                  //                    ),
                                  //                  )
                                  Card(),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
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
          AnimatedPositioned(
            duration: Duration(milliseconds: 250),
            top: _top,
            right: 0,
            child: CircularSoftButton(
              icon: IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.black,
                    size: 28,
                  ),
                  // onPressed: widget.closedBuilder,
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return new AlertDialog(
                          title: new Text("Busca produto:"),
                          content: Container(
                            color:
                                Colors.white, //Colors.black.withOpacity(.10),
                            width: double.maxFinite,
                            height: double.maxFinite, //700.0,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ListView(
                                children: <Widget>[
                                  //Text('Nome: '),
                                  ListTile(
                                      title: TextFormField(
                                    controller: _buscaTextController,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    decoration: InputDecoration(
                                      labelText: 'Nome do Produto',
                                      labelStyle: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 20.0,
                                      ),
                                      counterText: "",
                                      // remove os numero do contador do maxleng,
                                      hintText: "Nome do Produto",
                                    ),
                                    maxLength: 30,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "O Nome não pode ficar em branco";
                                      }
                                      return null;
                                    },
                                  )),
                                ],
                              ),
                            ),
                          ),
                          actions: <Widget>[
                            // usually buttons at the bottom of the dialog
                            new FlatButton(
                              child: new Text(
                                "Buscar",
                                style: TextStyle(color: Colors.teal),
                              ),
                              onPressed: () async {
                                if (_buscaTextController.text.length <= 3) {
                                  Toast.show(
                                      "Texto deve ter pelo menos 3 caracteres",
                                      context,
                                      duration: Toast.LENGTH_LONG,
                                      gravity: Toast.CENTER,
                                      backgroundRadius: 0.0);
                                } else {
                                  String result = await busca_produto();
                                  //if (result)
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      return new AlertDialog(
                                        title: new Text("Editar produto:"),
                                        content: Scrollbar(
                                          child: GridView.builder(
                                            padding: EdgeInsets.only(
                                                left: 5.0,
                                                right: 5.0,
                                                top: 10,
                                                bottom: 10),
                                            shrinkWrap: false,
                                            itemCount: _busca_produtos.length,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 1,
                                                    childAspectRatio: 3.5),
                                            itemBuilder: (context, index) {
                                              final item =
                                                  _busca_produtos[index];
                                              return Card(
                                                color: Colors.teal
                                                    .withOpacity(0.7),
                                                child: ListTile(
                                                  //  leading: Icon(Icons.wb_sunny),
                                                  title: Text(
                                                    _busca_produtos[index]
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  trailing: Icon(
                                                    Icons.keyboard_arrow_right,
                                                    color: Colors.white,
                                                  ),
                                                  onTap: () {
                                                    Basicos.offset = 0;
                                                    Basicos.meus_pedidos = [];
                                                    Navigator.of(context).push(
                                                        new MaterialPageRoute(
                                                      // aqui temos passagem de valores id cliente(sessao) de login para home
                                                      builder: (context) =>
                                                          new Atualiza_Produto(
                                                        id_sessao:
                                                            widget.id_sessao,
                                                        id_produto: _busca_produtos[
                                                                index]
                                                            .substring(
                                                                0,
                                                                _busca_produtos[
                                                                        index]
                                                                    .indexOf(
                                                                        '-',
                                                                        0)),
                                                      ),
                                                    ));
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        actions: <Widget>[
                                          new FlatButton(
                                            child: new Text(
                                              "Voltar",
                                              style:
                                                  TextStyle(color: Colors.teal),
                                            ),
                                            onPressed: () {
                                              //newestoque = null;
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                                ;
                              },
                            ),
                            new FlatButton(
                              child: new Text(
                                "Cancelar",
                                style: TextStyle(color: Colors.teal),
                              ),
                              onPressed: () {
                                //newestoque = null;
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }),
              radius: 22,
            ),
          ),
        ],
      ),
    ));
  }

  Future<String> busca_produto() async {
    _busca_produtos = []; // limpa busca
    String link = Basicos.codifica(
        "${Basicos.ip}/crud/?crud=consult88.${widget.id_sessao},%${_buscaTextController.text.substring(0, _buscaTextController.text.length - 1)}%,"); // retirar caracter em branco no final
    // print("${Basicos.ip}/crud/?crud=consult88.${widget.id_sessao},%${_buscaTextController.text.substring(0, _buscaTextController.text.length - 1)}%,");
    var res1 = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    var res = Basicos.decodifica(res1.body);

    if (res1.body.length > 2) {
      if (res1.statusCode == 200) {
        List list = json.decode(res).cast<Map<String, dynamic>>();
        for (var i = 0, len = list.length; i < len; i++) {
          _busca_produtos.add(list[i]['id'].toString() +
              '-' +
              list[i]['descricao_simplificada'].toString() +
              '(' +
              list[i]['preco_venda'].toString().replaceAll('.', ',') +
              ')');
          //_busca_produtos.add(list[i]['descricao_simplificada'].toString());
          //_busca_produtos.add(list[i]['estoque_atual'].toString());
          // _busca_produtos.add(list[i]['preco_venda'].toString());
          // print(list[i]);
        }
        // print(list);
        return 'sucesso';
      }
    }
  }

  Upload(File imageFile) async {
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
//
    var uri = Uri.parse('teste');
//
    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));
//    //contentType: new MediaType('image', 'png'));
//
    request.files.add(multipartFile);
//    var response = await request.send();
//    print(response.statusCode);
//    response.stream.transform(utf8.decoder).listen((value) {
//      print(value);
//    });
    String link = Basicos.codifica("${Basicos.ip}/crud/?crud=consult48."
        "teste1,"
        "${length},"
        "${request.files}" //   imagem
        );
    print(link);
    var res1 = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    //var res = (res1.body);
    print(res1.body);

    //return "sucesso";
  }

  Future<String> validateForm() async {
    FormState formState = _formKey.currentState;
    if (formState.validate()) {
      if (_selectedIdcat == null || _selectedIdmarca == null) {
        return "falha_local";
      } else {
        String link = Basicos.codifica("${Basicos.ip}/crud/?crud=consult46."
            //    id integer NOT NULL DEFAULT nextval('produtos_id_seq'::regclass),
            "${capitalize(Basicos.strip(_produtoTextController.text))}," //    descricao_simplificada character varying(32),
            "${_unidadeTextController.text}," //    unidade_medida character varying(10) NOT NULL,
            //    estoque_minimo numeric(15,3) NOT NULL,
            //    estoque_maximo numeric(15,3) NOT NULL,
            //    estoque_atual numeric(15,3) NOT NULL,
            //    fracionar_produto character varying(5) NOT NULL,
            "${_codigoTextController.text}," //    id_embalagem_fechada integer NOT NULL,
            "${_qtdeEmbalagemTextController.text}," //    quantidade_embalagem_fechada numeric(15,3) NOT NULL,
            //    valor_compra numeric(15,3) NOT NULL,
            //    percentual_lucro numeric(15,3) NOT NULL,
            //    desconto_maximo numeric(5,3) NOT NULL,
            //    atacado_apartir numeric(15,3) NOT NULL,
            //    atacado_desconto numeric(5,3) NOT NULL,
            //    status character varying(20) NOT NULL,
            "${Basicos.strip(_observacoesTextController.text)}," //    observacoes text NOT NULL,
            "${Basicos.strip(_descMarketingTextController.text)}," //    marketing character varying(500) NOT NULL,
            "${_precoTextController.text.replaceAll(',', '.')}," //    preco_venda numeric(15,2) NOT NULL,
            //    data_registro timestamp with time zone NOT NULL,
            //    data_alteracao timestamp with time zone NOT NULL,
            "0," //    imagem character varying(100),
            "${_cdgBarrasTextController.text}," //    codigo_barras character varying(50) NOT NULL,
            //    anunciar_produto integer NOT NULL,
            "${Basicos.strip(_observacoesTextController.text)}," //    descricao_completa character varying(500),
            "${_selectedIdcat.substring(0, _selectedIdcat.indexOf('-'))}," //    categoria_produto_id integer NOT NULL,
            "${widget.id_sessao.toString()}," //    empresa_id integer,
            "${_selectedIdmarca.substring(0, _selectedIdmarca.indexOf('-'))}" //    marca_produto_id integer NOT NULL,
            );
        //print(link);
        var res1 = await http
            .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
        var res = Basicos.decodifica(res1.body);
        //print(res.body);

        return "sucesso";
      }
    }
  }

// lista as categorias para preencher o combo
  Future<List> buscaCategorias() async {
    String link = Basicos.codifica("${Basicos.ip}/crud/?crud=consulta4.");
    var res1 = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    var res = Basicos.decodifica(res1.body);
    // print(res.body);
    if (res1.body.length > 2) {
      if (res1.statusCode == 200) {
        List list = json.decode(res).cast<Map<String, dynamic>>();
        for (var i = 0, len = list.length; i < len; i++) {
          _category_list.add(
              list[i]['id'].toString() + '-' + list[i]['descricao'].toString());
        }
        // await busca_cliente();
        //print(list);
        return list;
      }
    }
  }

  // lista marca para preencher o combo
  Future<List> buscaMarca() async {
    String link = Basicos.codifica("${Basicos.ip}/crud/?crud=consult47.");
    var res1 = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    var res = Basicos.decodifica(res1.body);
    // print(res.body);
    if (res1.body.length > 2) {
      if (res1.statusCode == 200) {
        List list = json.decode(res).cast<Map<String, dynamic>>();
        for (var i = 0, len = list.length; i < len; i++) {
          _marcas_list.add(
              list[i]['id'].toString() + '-' + list[i]['descricao'].toString());
        }
        // await busca_cliente();
        //print(list);
        return list;
      }
    }
  }

  ////////  FUNÇÃO QUE SELECIONA A IMAGEM E MUDA ESTADO DA MESMA ///////

  void _selectImage(Future<File> pickImage, int imageNumber) async {
    File tempImg = await pickImage;
    switch (imageNumber) {
      case 1:
        setState(() => image1 = tempImg);
        break;

      case 2:
        setState(() => image2 = tempImg);
        break;

      case 3:
        setState(() => image3 = tempImg);
        break;
    }
  }

  ////////  WIDGET DE VISUALIZAÇÃO DA IMAGEM ////////

  _displayChild1() {
    if (image1 == null) {
      return Padding(
        padding: const EdgeInsets.all(25),
        child: Text("Insira a foto do produto", textAlign: TextAlign.center),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Image.file(
          image1,
          fit: BoxFit.fill,
          alignment: Alignment.center,
          width: double.infinity,
        ),
      );
    }
  }

  _displayChild2() {
    if (image2 == null) {
      return Padding(
        padding: const EdgeInsets.all(25),
        child: Text("Insira a foto do produto", textAlign: TextAlign.center),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Image.file(
          image2,
          fit: BoxFit.fill,
          alignment: Alignment.center,
          width: double.infinity,
        ),
      );
    }
  }

  _displayChild3() {
    if (image3 == null) {
      return Padding(
        padding: const EdgeInsets.all(25),
        child: Text("Insira a foto do produto", textAlign: TextAlign.center),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Image.file(
          image3,
          fit: BoxFit.fill,
          alignment: Alignment.center,
          width: double.infinity,
        ),
      );
    }
  }

///// CONVERTE IMAGEM PARA STRING //////

  void _upload() {
    if (image1 == null || image2 == null || image3 == null)
      return;
    else {
      String base64Image1 = base64Encode(image1.readAsBytesSync());
      String base64Image2 = base64Encode(image2.readAsbytesSync());
      String base64Image3 = base64Encode(image3.readAsbytesSync());
    }
  }
}

//class Categoria {
//  int id;
//  String descricao;
//
//  Categoria({
//    this.id,
//    this.descricao,
//  });
//
//  factory Categoria.fromJSON(Map<String, dynamic> jsonMap) {
//    return Categoria(id: jsonMap['id'], descricao: jsonMap['descricao']);
//  }
//}
void TrocaFoto() {}

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:app_produtor/pages/produtos/atualiza_produtos.dart';
// import 'package:toast/toast.dart';
// import 'package:app_produtor/pages/home.dart';
// import 'package:app_produtor/pages/dados_basicos.dart';
// import 'package:http/http.dart' as http;
// import 'dart:async';
// import 'dart:convert';
// import 'package:image_picker/image_picker.dart';
//
// import 'package:path/path.dart';
// import 'package:async/async.dart';
// import 'package:strings/strings.dart';
//
// import '../../soft_buttom.dart';
//
// class cadastroProduto2 extends StatefulWidget {
//   final id_sessao;
//
//   cadastroProduto2({
//     this.id_sessao,
//   });
//
//   @override
//   _cadastroProdutoState2 createState() => _cadastroProdutoState2();
// }
//
// class _cadastroProdutoState2 extends State<cadastroProduto2> {
//   final _formKey = GlobalKey<FormState>();
//
//   // List<String> lista_categorias = ['Verdura', 'Legume', 'Fruta'];
//
//   List<String> _category_list = []; // dados estaticos de categorias
//   List<String> _marcas_list = []; // dados estaticos de marcas
//   //String dropdownValue;
//
//   TextEditingController _produtoTextController = TextEditingController();
//   TextEditingController _descricao_completaTextController =
//       TextEditingController();
//   TextEditingController _codigoTextController = TextEditingController();
//   TextEditingController _qtdeEmbalagemTextController = TextEditingController();
//   TextEditingController _unidadeTextController = TextEditingController();
//   TextEditingController _cdgBarrasTextController = TextEditingController();
//   TextEditingController _descMarketingTextController = TextEditingController();
//   TextEditingController _observacoesTextController = TextEditingController();
//   TextEditingController _precoTextController = TextEditingController();
//   TextEditingController _buscaTextController = TextEditingController();
//
//   String gender;
//   bool hidePass = true;
//   bool Loading = false;
//   String _selectedIdcat;
//   String _selectedIdmarca;
//   double _top = -60;
//   List<String> _busca_produtos = []; // consulta produto para edição
//
//   ////////  VARIAVEIS PARA INSERÇÃO DA IMAGEM ///////
//   File _image1;
//   File _image2;
//   File _image3;
//   var image1;
//   var image2;
//   var image3;
//
//   int index_tab = 0;
//
//   @override
//   void initState() {
//     Future.delayed(Duration(milliseconds: 250), () {
//       setState(() {
//         _top = 0;
//       });
//     });
//     //inicializa categoria
//     buscaCategorias().then((resultado) {
//       setState(() {});
//     });
//     //inicializa marca
//     buscaMarca().then((resultado) {
//       setState(() {});
//     });
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(
//                 left: 10, right: 10.0, top: 65, bottom: 5),
//               child: Center(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey[200],
//                         blurRadius:
//                         20.0, // has the effect of softening the shadow
//                       )
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(
//                           left: 20, top: 20, right: 20, bottom: 5),
//                         child: Text(
//                           'Dados Cadastrais',
//                           style: TextStyle(
//                             fontSize: 24,
//                             fontFamily: "Poppins",
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: Scrollbar(
//                           child: ListView(
//                             children: <Widget>[
//                               Form(
//                                 key: _formKey,
//                                 child: Column(
//                                   children: <Widget>[
//                                     Container(
//                                       padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
//                                       height: 60,
//                                       alignment: Alignment(0, 0),
//                                       child: Padding(
//                                         padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
//                                         child: Material(
//                                           child: Padding(
//                                             padding: EdgeInsets.only(left: 0.0),
//                                             child: ListTile(
//                                                 title: TextFormField(
//                                               controller: _produtoTextController,
//                                               decoration: InputDecoration(
//                                                   suffix: Text('Nome do Produto',
//                                                       style: TextStyle(
//                                                         fontStyle: FontStyle.italic,
//                                                         fontSize: 14.0,
//                                                       )),
//                                                   hintText: "Nome do Produto",
//                                                   icon: Icon(
//                                                     Icons.subdirectory_arrow_left,
//                                                     size: 30,
//                                                     color: Colors.teal,
//                                                   )),
//                                               validator: (value) {
//                                                 if (value.isEmpty) {
//                                                   return "O Nome não pode ficar em branco";
//                                                 }
//                                                 return null;
//                                               },
//                                             )),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Container(
//                                       padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
//                                       height: 60,
//                                       alignment: Alignment(0, 0),
//                                       child: Padding(
//                                         padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
//                                         child: Material(
//                                           child: Padding(
//                                             padding: EdgeInsets.only(left: 0.0),
//                                             child: ListTile(
//                                                 title: TextFormField(
//                                               maxLines: null,
//                                               expands: true,
//                                               controller: _descricao_completaTextController,
//                                               decoration: InputDecoration(
//                                                   suffix: Text('Descrição',
//                                                       style: TextStyle(
//                                                         fontStyle: FontStyle.italic,
//                                                         fontSize: 14.0,
//                                                       )),
//                                                   hintText: "Descrição Completa",
//                                                   icon: Icon(
//                                                     Icons.description,
//                                                     size: 30,
//                                                     color: Colors.teal,
//                                                   )),
//                                               validator: (value) {
//                                                 if (value.isEmpty) {
//                                                   return "Descrição não pode ficar vazia.";
//                                                 }
//                                                 return null;
//                                               },
//                                             )),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Container(
//                                       child: Column(
//                                         children: <Widget>[
//                                           Container(
//                                             padding: EdgeInsets.fromLTRB(40.0, 20.0, 0.0, 0.0),
//                                             alignment: Alignment.bottomLeft,
//                 //                          child: (Text(
//                 //                            'Categoria',
//                 //                            textAlign: TextAlign.left,
//                 //                            style: TextStyle(
//                 //                              fontStyle: FontStyle.italic,
//                 //                              fontSize: 14.0,
//                 //                            ),
//                 //                          )),
//                                           ),
//                                           Padding(
//                                             padding:
//                                                 const EdgeInsets.fromLTRB(10.0, 0.0, 20.0, 0.0),
//                                             child: ListTile(
//                                               leading: Icon(
//                                                 Icons.category,
//                                                 size: 30,
//                                                 color: Colors.teal,
//                                               ),
//                                               subtitle: Padding(
//                                                 padding: const EdgeInsets.fromLTRB(
//                                                     0.0, 0.0, 10.0, 0.0),
//                                                 child: DropdownButton<String>(
//                                                   isExpanded: true,
//                                                   hint: const Text(
//                                                     "Categoria",
//                                                     style: TextStyle(
//                                                       fontStyle: FontStyle.italic,
//                                                       fontSize: 14.0,
//                                                       fontWeight: FontWeight.normal,
//                                                       color: Colors.black54,
//                                                     ),
//                                                   ),
//                                                   value: _selectedIdcat,
//                                                   onChanged: (String value) {
//                                                     setState(() {
//                                                       _selectedIdcat = value;
//                                                     });
//                                                   },
//                                                   items: _category_list.map((String value) {
//                                                     return DropdownMenuItem<String>(
//                                                       value: value,
//                                                       child: Text(
//                                                         value.substring(value.indexOf('-', 0) + 1,
//                                                             value.length),
//                                                         style: TextStyle(
//                                                           fontWeight: FontWeight.normal,
//                                                           color: Colors.black54,
//                                                           fontSize: 15.0,
//                                                         ),
//                                                       ),
//                                                     );
//                                                   }).toList(),
//                                                 ),
//                                               ),
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                     Container(
//                                       child: Column(
//                                         children: <Widget>[
//                                           Container(
//                                             padding: EdgeInsets.fromLTRB(40.0, 20.0, 0.0, 0.0),
//                                             alignment: Alignment.bottomLeft,
//                 //                          child: (Text(
//                 //                            'Marca',
//                 //                            textAlign: TextAlign.left,
//                 //                            style: TextStyle(
//                 //                              fontStyle: FontStyle.italic,
//                 //                              fontSize: 14.0,
//                 //                            ),
//                 //                          )),
//                                           ),
//                                           Padding(
//                                             padding:
//                                                 const EdgeInsets.fromLTRB(10.0, 0.0, 20.0, 0.0),
//                                             child: ListTile(
//                                               leading: Icon(
//                                                 Icons.bookmark,
//                                                 size: 30,
//                                                 color: Colors.teal,
//                                               ),
//                                               subtitle: Padding(
//                                                 padding: const EdgeInsets.fromLTRB(
//                                                     0.0, 0.0, 10.0, 0.0),
//                                                 child: DropdownButton<String>(
//                                                   isExpanded: true,
//                                                   hint: const Text(
//                                                     "Marca",
//                                                     style: TextStyle(
//                                                       fontStyle: FontStyle.italic,
//                                                       fontSize: 14.0,
//                                                       fontWeight: FontWeight.normal,
//                                                       color: Colors.black54,
//                                                     ),
//                                                   ),
//                                                   value: _selectedIdmarca,
//                                                   onChanged: (String value) {
//                                                     setState(() {
//                                                       _selectedIdmarca = value;
//                                                     });
//                                                   },
//                                                   items: _marcas_list.map((String value) {
//                                                     return DropdownMenuItem<String>(
//                                                       value: value,
//                                                       child: Text(
//                                                         value.substring(value.indexOf('-', 0) + 1,
//                                                             value.length),
//                                                         style: TextStyle(
//                                                           fontWeight: FontWeight.normal,
//                                                           color: Colors.black54,
//                                                           fontSize: 15.0,
//                                                         ),
//                                                       ),
//                                                     );
//                                                   }).toList(),
//                                                 ),
//                                               ),
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                     Container(
//                                       padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
//                                       height: 60,
//                                       alignment: Alignment(0, 0),
//                                       child: Padding(
//                                         padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
//                                         child: Material(
//                                           child: Padding(
//                                             padding: EdgeInsets.only(left: 0.0),
//                                             child: ListTile(
//                                                 title: TextFormField(
//                                               controller: _codigoTextController,
//                                               decoration: InputDecoration(
//                                                   suffix: Text('Código Embalagem',
//                                                       style: TextStyle(
//                                                         fontStyle: FontStyle.italic,
//                                                         fontSize: 14.0,
//                                                       )),
//                                                   hintText: "Código Embalagem",
//                                                   icon: Icon(
//                                                     Icons.code,
//                                                     size: 30,
//                                                     color: Colors.teal,
//                                                   )),
//                                               validator: (value) {
//                                                 if (value.isEmpty) {
//                                                   return "O Código não pode ficar em branco";
//                                                 }
//                                                 return null;
//                                               },
//                                               keyboardType: TextInputType.number,
//                                             )),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Container(
//                                       padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
//                                       height: 60,
//                                       alignment: Alignment(0, 0),
//                                       child: Padding(
//                                         padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
//                                         child: Material(
//                                           child: Padding(
//                                             padding: EdgeInsets.only(left: 0.0),
//                                             child: ListTile(
//                                                 title: TextFormField(
//                                               controller: _qtdeEmbalagemTextController,
//                                               decoration: InputDecoration(
//                                                   suffix: Text('Quantidade',
//                                                       style: TextStyle(
//                                                         fontStyle: FontStyle.italic,
//                                                         fontSize: 14.0,
//                                                       )),
//                                                   hintText: "Quantidade por embalagem",
//                                                   icon: Icon(
//                                                     Icons.check,
//                                                     size: 30,
//                                                     color: Colors.teal,
//                                                   )),
//                                               validator: (value) {
//                                                 if (value.isEmpty) {
//                                                   return "O campo não pode ficar em branco";
//                                                 }
//                                                 return null;
//                                               },
//                                               keyboardType: TextInputType.number,
//                                             )),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Container(
//                                       padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
//                                       height: 60,
//                                       alignment: Alignment(0, 0),
//                                       child: Padding(
//                                         padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
//                                         child: Material(
//                                           child: Padding(
//                                             padding: EdgeInsets.only(left: 0.0),
//                                             child: ListTile(
//                                                 title: TextFormField(
//                                               controller: _unidadeTextController,
//                                               decoration: InputDecoration(
//                                                   suffix: Text('Unidade',
//                                                       style: TextStyle(
//                                                         fontStyle: FontStyle.italic,
//                                                         fontSize: 14.0,
//                                                       )),
//                                                   hintText: "Unidade",
//                                                   icon: Icon(
//                                                     Icons.unarchive,
//                                                     size: 30,
//                                                     color: Colors.teal,
//                                                   )),
//                                               validator: (value) {
//                                                 if (value.isEmpty) {
//                                                   return "O campo não pode ficar em branco";
//                                                 }
//                                                 return null;
//                                               },
//                                               keyboardType: TextInputType.multiline,
//                                             )),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Container(
//                                       padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
//                                       height: 60,
//                                       alignment: Alignment(0, 0),
//                                       child: Padding(
//                                         padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
//                                         child: Material(
//                                           child: Padding(
//                                             padding: EdgeInsets.only(left: 0.0),
//                                             child: ListTile(
//                                                 title: TextFormField(
//                                               controller: _cdgBarrasTextController,
//                                               decoration: InputDecoration(
//                                                   suffix: Text('Código de Barras',
//                                                       style: TextStyle(
//                                                         fontStyle: FontStyle.italic,
//                                                         fontSize: 14.0,
//                                                       )),
//                                                   hintText: "Código de Barras",
//                                                   icon: Icon(
//                                                     Icons.reorder,
//                                                     size: 30,
//                                                     color: Colors.teal,
//                                                   )),
//                                               validator: (value) {
//                                                 if (value.isEmpty) {
//                                                   return "O campo não pode ficar em branco";
//                                                 }
//                                                 return null;
//                                               },
//                                               keyboardType: TextInputType.number,
//                                             )),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Container(
//                                       padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
//                                       height: 60,
//                                       alignment: Alignment(0, 0),
//                                       child: Padding(
//                                         padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
//                                         child: Material(
//                                           child: Padding(
//                                             padding: EdgeInsets.only(left: 0.0),
//                                             child: ListTile(
//                                                 title: TextFormField(
//                                               controller: _precoTextController,
//                                               decoration: InputDecoration(
//                                                   suffix: Text('Ex. 15,30',
//                                                       style: TextStyle(
//                                                         fontStyle: FontStyle.italic,
//                                                         fontSize: 14.0,
//                                                       )),
//                                                   hintText: "Preço Venda",
//                                                   icon: Icon(
//                                                     Icons.attach_money,
//                                                     size: 30,
//                                                     color: Colors.teal,
//                                                   )),
//                                               validator: (value) {
//                                                 if (value.isEmpty) {
//                                                   return "O campo não pode ficar em branco";
//                                                 } else {
//                                                   Pattern pattern = '^[0-9]+?(.|,[0-9]{2})\$';
//                                                   RegExp regex = new RegExp(pattern);
//                                                   if (!regex.hasMatch(value)) {
//                                                     return 'Insira um valor válido';
//                                                   }
//                                                   // ^R\$(\d{1,3}(\.\d{3})*|\d+)(\,\d{2})?$
//                                                 }
//                                                 return null;
//                                               },
//                                               keyboardType: TextInputType.number,
//                                             )),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Container(
//                                       padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
//                                       height: 60,
//                                       alignment: Alignment(0, 0),
//                                       child: Padding(
//                                         padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
//                                         child: Material(
//                                           child: Padding(
//                                             padding: EdgeInsets.only(left: 0.0),
//                                             child: ListTile(
//                                                 title: TextFormField(
//                                               controller: _descMarketingTextController,
//                                               decoration: InputDecoration(
//                                                   suffix: Text('Descrição Marketing',
//                                                       style: TextStyle(
//                                                         fontStyle: FontStyle.italic,
//                                                         fontSize: 14.0,
//                                                       )),
//                                                   hintText: "Descrição Marketing:",
//                                                   icon: Icon(
//                                                     Icons.equalizer,
//                                                     size: 30,
//                                                     color: Colors.teal,
//                                                   )),
//                                               validator: (value) {
//                                                 if (value.isEmpty) {
//                                                   return "O campo não pode ficar em branco";
//                                                 }
//                                                 return null;
//                                               },
//                                               keyboardType: TextInputType.multiline,
//                                             )),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Container(
//                                       padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
//                                       height: 80,
//                                       alignment: Alignment(0, 0),
//                                       child: Padding(
//                                         padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
//                                         child: Material(
//                                           child: Padding(
//                                             padding: EdgeInsets.only(left: 0.0),
//                                             child: ListTile(
//                                                 title: TextFormField(
//                                               controller: _observacoesTextController,
//                                               decoration: InputDecoration(
//                                                   suffix: Text('Observações',
//                                                       style: TextStyle(
//                                                         fontStyle: FontStyle.italic,
//                                                         fontSize: 14.0,
//                                                       )),
//                                                   hintText: "Observações",
//                                                   icon: Icon(
//                                                     Icons.edit,
//                                                     size: 30,
//                                                     color: Colors.teal,
//                                                   )),
//                                               validator: (value) {
//                                                 if (value.isEmpty) {
//                                                   return "O campo não pode ficar em branco";
//                                                 }
//                                                 return null;
//                                               },
//                                               keyboardType: TextInputType.multiline,
//                                             )),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 10),
//                                       child: Material(
//                                         borderRadius: BorderRadius.circular(12.0),
//                                         color: Colors.teal,
//                                         child: MaterialButton(
//                                           onPressed: () async {
//                                             String result = await validateForm();
//                                             print(result);
//                                             if (result == "sucesso") {
//                                               Toast.show(
//                                                 "Cadastro Realizado com Sucesso",
//                                                 context,
//                                                 duration: Toast.LENGTH_LONG,
//                                                 gravity: Toast.CENTER,
//                                                 backgroundRadius: 0.0,
//                                               );
//                                               Navigator.push(
//                                                   context,
//                                                   MaterialPageRoute(
//                                                       builder: (context) =>
//                                                           new home2(id_sessao: widget.id_sessao)));
//                                             } else {
//                                               if (result == "falha_local") {
//                                                 Toast.show(
//                                                     "Escolha uma Categoria ou Marca para o produto",
//                                                     context,
//                                                     duration: Toast.LENGTH_LONG,
//                                                     gravity: Toast.CENTER,
//                                                     backgroundRadius: 0.0);
//                                               } else {
//                                                 Toast.show("Erro ao cadastrar", context,
//                                                     duration: Toast.LENGTH_LONG,
//                                                     gravity: Toast.CENTER,
//                                                     backgroundRadius: 0.0);
//                                               }
//                                             }
//                                           },
//                                           minWidth: MediaQuery.of(context).size.width,
//                                           child: Text(
//                                             "Cadastrar",
//                                             textAlign: TextAlign.center,
//                                             style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 20.0),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                 //                  Padding(
//                 //                    padding: const EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 0),
//                 //                    child: Material(
//                 //                      borderRadius: BorderRadius.circular(20.0),
//                 //                      color: Colors.teal,
//                 //                      child: MaterialButton(
//                 //                        onPressed: () async {
//                 //                          Upload(image1);
//                 //
//                 ////                          String result = await validateForm();
//                 ////                          print(result);
//                 ////                          if (result == "sucesso") {
//                 ////                            Toast.show(
//                 ////                              "Cadastro Realizado com Sucesso",
//                 ////                              context,
//                 ////                              duration: Toast.LENGTH_LONG,
//                 ////                              gravity: Toast.CENTER,
//                 ////                              backgroundRadius: 0.0,
//                 ////                            );
//                 ////                            Navigator.push(
//                 ////                                context,
//                 ////                                MaterialPageRoute(
//                 ////                                    builder: (context) =>
//                 ////                                    new home(id_sessao: widget.id_sessao)));
//                 ////                          } else {
//                 ////                            if (result == "falha_local") {
//                 ////                              Toast.show(
//                 ////                                  "Escolha uma Categoria ou Marca para o produto",
//                 ////                                  context,
//                 ////                                  duration: Toast.LENGTH_LONG,
//                 ////                                  gravity: Toast.CENTER,
//                 ////                                  backgroundRadius: 0.0);
//                 ////                            } else {
//                 ////                              Toast.show("Erro ao cadastrar", context,
//                 ////                                  duration: Toast.LENGTH_LONG,
//                 ////                                  gravity: Toast.CENTER,
//                 ////                                  backgroundRadius: 0.0);
//                 ////                            }
//                 ////                          }
//                 //                          print('teste1');
//                 //                        },
//                 //                        minWidth: MediaQuery.of(context).size.width,
//                 //                        child: Text(
//                 //                          "teste envio imagem",
//                 //                          textAlign: TextAlign.center,
//                 //                          style: TextStyle(
//                 //                              color: Colors.white,
//                 //                              fontWeight: FontWeight.bold,
//                 //                              fontSize: 20.0),
//                 //                        ),
//                 //                      ),
//                 //                    ),
//                 //                  )
//                                     Card(),
//                                   ],
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             AnimatedPositioned(
//               duration: Duration(milliseconds: 250),
//               top: _top,
//               child: CircularSoftButton(
//                 icon: IconButton(
//                   icon: Icon(
//                     Icons.arrow_back,
//                     color: Colors.black,
//                     size: 28,
//                   ),
//                   // onPressed: widget.closedBuilder,
//                   onPressed: () {
//                     setState(() {
//                       _top = -60;
//                     });
//                     Future.delayed(Duration(milliseconds: 250), () {
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (context) =>
//                             home2(
//                               id_sessao: widget.id_sessao,
//                             )
//                         )
//                       );
//                     });
//                   }
//                 ),
//                 radius: 22,
//               ),
//             ),
//             AnimatedPositioned(
//               duration: Duration(milliseconds: 250),
//               top: _top,
//               right: 0,
//               child: CircularSoftButton(
//                 icon: IconButton(
//                   icon: Icon(
//                     Icons.edit,
//                     color: Colors.black,
//                     size: 28,
//                   ),
//                   // onPressed: widget.closedBuilder,
//                   onPressed: () {
//                     showDialog(
//                       context: context,
//                       barrierDismissible: false,
//                       builder: (context) {
//                         return new AlertDialog(
//                           title: new Text("Busca produto:"),
//                           content: Container(
//                             color: Colors.white, //Colors.black.withOpacity(.10),
//                             width: double.maxFinite,
//                             height: double.maxFinite, //700.0,
//                             child: Padding(
//                               padding: const EdgeInsets.all(4.0),
//                               child: ListView(
//                                 children: <Widget>[
//                                   //Text('Nome: '),
//                                   ListTile(
//                                       title: TextFormField(
//                                     controller: _buscaTextController,
//                                     textCapitalization: TextCapitalization.words,
//                                     decoration: InputDecoration(
//                                       labelText: 'Nome do Produto',
//                                       labelStyle: TextStyle(
//                                         fontStyle: FontStyle.italic,
//                                         fontSize: 20.0,
//                                       ),
//                                       counterText: "",
//                                       // remove os numero do contador do maxleng,
//                                       hintText: "Nome do Produto",
//                                     ),
//                                     maxLength: 30,
//                                     validator: (value) {
//                                       if (value.isEmpty) {
//                                         return "O Nome não pode ficar em branco";
//                                       }
//                                       return null;
//                                     },
//                                   )),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           actions: <Widget>[
//                             // usually buttons at the bottom of the dialog
//                             new FlatButton(
//                               child: new Text(
//                                 "Buscar",
//                                 style: TextStyle(color: Colors.teal),
//                               ),
//                               onPressed: () async {
//                                 if (_buscaTextController.text.length <= 3) {
//                                   Toast.show(
//                                       "Texto deve ter pelo menos 3 caracteres",
//                                       context,
//                                       duration: Toast.LENGTH_LONG,
//                                       gravity: Toast.CENTER,
//                                       backgroundRadius: 0.0);
//                                 } else {
//                                   String result = await busca_produto();
//                                   //if (result)
//                                   showDialog(
//                                     context: context,
//                                     barrierDismissible: false,
//                                     builder: (context) {
//                                       return new AlertDialog(
//                                         title: new Text("Editar produto:"),
//                                         content: Scrollbar(
//                                           child: GridView.builder(
//                                             padding: EdgeInsets.only(
//                                                 left: 5.0,
//                                                 right: 5.0,
//                                                 top: 10,
//                                                 bottom: 10),
//                                             shrinkWrap: false,
//                                             itemCount: _busca_produtos.length,
//                                             gridDelegate:
//                                                 SliverGridDelegateWithFixedCrossAxisCount(
//                                                     crossAxisCount: 1,
//                                                     childAspectRatio: 3.5),
//                                             itemBuilder: (context, index) {
//                                               final item = _busca_produtos[index];
//                                               return Card(
//                                                 color: Colors.teal.withOpacity(0.7),
//                                                 child: ListTile(
//                                                   //  leading: Icon(Icons.wb_sunny),
//                                                   title: Text(
//                                                     _busca_produtos[index]
//                                                         .toString(),
//                                                     style: TextStyle(
//                                                         color: Colors.white),
//                                                   ),
//                                                   trailing: Icon(
//                                                     Icons.keyboard_arrow_right,
//                                                     color: Colors.white,
//                                                   ),
//                                                   onTap: () {
//                                                     Basicos.offset = 0;
//                                                     Basicos.meus_pedidos = [];
//                                                     Navigator.of(context)
//                                                         .push(new MaterialPageRoute(
//                                                       // aqui temos passagem de valores id cliente(sessao) de login para home
//                                                       builder: (context) =>
//                                                           new Atualiza_Produto(
//                                                         id_sessao: widget.id_sessao,
//                                                         id_produto: _busca_produtos[
//                                                                 index]
//                                                             .substring(
//                                                                 0,
//                                                                 _busca_produtos[
//                                                                             index]
//                                                                         .indexOf(
//                                                                             '-',
//                                                                             0)),
//                                                       ),
//                                                     ));
//                                                   },
//                                                 ),
//                                               );
//                                             },
//                                           ),
//                                         ),
//                                         actions: <Widget>[
//                                           new FlatButton(
//                                             child: new Text(
//                                               "Voltar",
//                                               style:
//                                                   TextStyle(color: Colors.teal),
//                                             ),
//                                             onPressed: () {
//                                               //newestoque = null;
//                                               Navigator.of(context).pop();
//                                             },
//                                           ),
//                                         ],
//                                       );
//                                     },
//                                   );
//                                 }
//                                 ;
//                               },
//                             ),
//                             new FlatButton(
//                               child: new Text(
//                                 "Cancelar",
//                                 style: TextStyle(color: Colors.teal),
//                               ),
//                               onPressed: () {
//                                 //newestoque = null;
//                                 Navigator.of(context).pop();
//                               },
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                   }
//                 ),
//                 radius: 22,
//               ),
//             ),
//           ],
//         ),
//       )
//     );
//   }
//
//   Future<String> busca_produto() async {
//     _busca_produtos = []; // limpa busca
//     String link = Basicos.codifica(
//         "${Basicos.ip}/crud/?crud=consult88.${widget.id_sessao},%${_buscaTextController.text.substring(0, _buscaTextController.text.length - 1)}%,"); // retirar caracter em branco no final
//     // print("${Basicos.ip}/crud/?crud=consult88.${widget.id_sessao},%${_buscaTextController.text.substring(0, _buscaTextController.text.length - 1)}%,");
//     var res1 = await http
//         .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
//     var res = Basicos.decodifica(res1.body);
//
//     if (res1.body.length > 2) {
//       if (res1.statusCode == 200) {
//         List list = json.decode(res).cast<Map<String, dynamic>>();
//         for (var i = 0, len = list.length; i < len; i++) {
//           _busca_produtos.add(list[i]['id'].toString() +
//               '-' +
//               list[i]['descricao_simplificada'].toString() +
//               '(' +
//               list[i]['preco_venda'].toString().replaceAll('.', ',') +
//               ')');
//           //_busca_produtos.add(list[i]['descricao_simplificada'].toString());
//           //_busca_produtos.add(list[i]['estoque_atual'].toString());
//           // _busca_produtos.add(list[i]['preco_venda'].toString());
//           // print(list[i]);
//         }
//         // print(list);
//         return 'sucesso';
//       }
//     }
//   }
//
//   Upload(File imageFile) async {
//     var stream =
//         new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
//     var length = await imageFile.length();
// //
//     var uri = Uri.parse('teste');
// //
//     var request = new http.MultipartRequest("POST", uri);
//     var multipartFile = new http.MultipartFile('file', stream, length,
//         filename: basename(imageFile.path));
// //    //contentType: new MediaType('image', 'png'));
// //
//     request.files.add(multipartFile);
// //    var response = await request.send();
// //    print(response.statusCode);
// //    response.stream.transform(utf8.decoder).listen((value) {
// //      print(value);
// //    });
//     String link = Basicos.codifica("${Basicos.ip}/crud/?crud=consult48."
//         "teste1,"
//         "${length},"
//         "${request.files}" //   imagem
//         );
//     print(link);
//     var res1 = await http
//         .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
//     //var res = (res1.body);
//     print(res1.body);
//
//     //return "sucesso";
//   }
//
//   Future<String> validateForm() async {
//     FormState formState = _formKey.currentState;
//     if (formState.validate()) {
//       if (_selectedIdcat == null || _selectedIdmarca == null) {
//         return "falha_local";
//       } else {
//         String link = Basicos.codifica("${Basicos.ip}/crud/?crud=consult46."
//             //    id integer NOT NULL DEFAULT nextval('produtos_id_seq'::regclass),
//             "${capitalize(Basicos.strip(_produtoTextController.text))}," //    descricao_simplificada character varying(32),
//             "${_unidadeTextController.text}," //    unidade_medida character varying(10) NOT NULL,
//             //    estoque_minimo numeric(15,3) NOT NULL,
//             //    estoque_maximo numeric(15,3) NOT NULL,
//             //    estoque_atual numeric(15,3) NOT NULL,
//             //    fracionar_produto character varying(5) NOT NULL,
//             "${_codigoTextController.text}," //    id_embalagem_fechada integer NOT NULL,
//             "${_qtdeEmbalagemTextController.text}," //    quantidade_embalagem_fechada numeric(15,3) NOT NULL,
//             //    valor_compra numeric(15,3) NOT NULL,
//             //    percentual_lucro numeric(15,3) NOT NULL,
//             //    desconto_maximo numeric(5,3) NOT NULL,
//             //    atacado_apartir numeric(15,3) NOT NULL,
//             //    atacado_desconto numeric(5,3) NOT NULL,
//             //    status character varying(20) NOT NULL,
//             "${Basicos.strip(_observacoesTextController.text)}," //    observacoes text NOT NULL,
//             "${Basicos.strip(_descMarketingTextController.text)}," //    marketing character varying(500) NOT NULL,
//             "${_precoTextController.text.replaceAll(',','.')}," //    preco_venda numeric(15,2) NOT NULL,
//             //    data_registro timestamp with time zone NOT NULL,
//             //    data_alteracao timestamp with time zone NOT NULL,
//             "0," //    imagem character varying(100),
//             "${_cdgBarrasTextController.text}," //    codigo_barras character varying(50) NOT NULL,
//             //    anunciar_produto integer NOT NULL,
//             "${Basicos.strip(_descricao_completaTextController.text)}," //    descricao_completa character varying(500),
//             "${_selectedIdcat.substring(0, _selectedIdcat.indexOf('-'))}," //    categoria_produto_id integer NOT NULL,
//             "${widget.id_sessao.toString()}," //    empresa_id integer,
//             "${_selectedIdmarca.substring(0, _selectedIdmarca.indexOf('-'))}" //    marca_produto_id integer NOT NULL,
//             );
//         //print(link);
//         var res1 = await http
//             .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
//         var res = Basicos.decodifica(res1.body);
//         //print(res.body);
//
//         return "sucesso";
//       }
//     }
//   }
//
// // lista as categorias para preencher o combo
//   Future<List> buscaCategorias() async {
//     String link = Basicos.codifica("${Basicos.ip}/crud/?crud=consulta4.");
//     var res1 = await http
//         .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
//     var res = Basicos.decodifica(res1.body);
//     // print(res.body);
//     if (res1.body.length > 2) {
//       if (res1.statusCode == 200) {
//         List list = json.decode(res).cast<Map<String, dynamic>>();
//         for (var i = 0, len = list.length; i < len; i++) {
//           _category_list.add(
//               list[i]['id'].toString() + '-' + list[i]['descricao'].toString());
//         }
//         // await busca_cliente();
//         //print(list);
//         return list;
//       }
//     }
//   }
//
//   // lista marca para preencher o combo
//   Future<List> buscaMarca() async {
//     String link = Basicos.codifica("${Basicos.ip}/crud/?crud=consult47.");
//     var res1 = await http
//         .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
//     var res = Basicos.decodifica(res1.body);
//     // print(res.body);
//     if (res1.body.length > 2) {
//       if (res1.statusCode == 200) {
//         List list = json.decode(res).cast<Map<String, dynamic>>();
//         for (var i = 0, len = list.length; i < len; i++) {
//           _marcas_list.add(
//               list[i]['id'].toString() + '-' + list[i]['descricao'].toString());
//         }
//         // await busca_cliente();
//         //print(list);
//         return list;
//       }
//     }
//   }
//
//   ////////  FUNÇÃO QUE SELECIONA A IMAGEM E MUDA ESTADO DA MESMA ///////
//
//   void _selectImage(Future<File> pickImage, int imageNumber) async {
//     File tempImg = await pickImage;
//     switch (imageNumber) {
//       case 1:
//         setState(() => image1 = tempImg);
//         break;
//
//       case 2:
//         setState(() => image2 = tempImg);
//         break;
//
//       case 3:
//         setState(() => image3 = tempImg);
//         break;
//     }
//   }
//
//   ////////  WIDGET DE VISUALIZAÇÃO DA IMAGEM ////////
//
//   _displayChild1() {
//     if (image1 == null) {
//       return Padding(
//         padding: const EdgeInsets.all(25),
//         child: Text("Insira a foto do produto", textAlign: TextAlign.center),
//       );
//     } else {
//       return Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Image.file(
//           image1,
//           fit: BoxFit.fill,
//           alignment: Alignment.center,
//           width: double.infinity,
//         ),
//       );
//     }
//   }
//
//   _displayChild2() {
//     if (image2 == null) {
//       return Padding(
//         padding: const EdgeInsets.all(25),
//         child: Text("Insira a foto do produto", textAlign: TextAlign.center),
//       );
//     } else {
//       return Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Image.file(
//           image2,
//           fit: BoxFit.fill,
//           alignment: Alignment.center,
//           width: double.infinity,
//         ),
//       );
//     }
//   }
//
//   _displayChild3() {
//     if (image3 == null) {
//       return Padding(
//         padding: const EdgeInsets.all(25),
//         child: Text("Insira a foto do produto", textAlign: TextAlign.center),
//       );
//     } else {
//       return Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Image.file(
//           image3,
//           fit: BoxFit.fill,
//           alignment: Alignment.center,
//           width: double.infinity,
//         ),
//       );
//     }
//   }
//
// ///// CONVERTE IMAGEM PARA STRING //////
//
//   void _upload() {
//     if (image1 == null || image2 == null || image3 == null)
//       return;
//     else {
//       String base64Image1 = base64Encode(image1.readAsBytesSync());
//       String base64Image2 = base64Encode(image2.readAsbytesSync());
//       String base64Image3 = base64Encode(image3.readAsbytesSync());
//     }
//   }
// }
//
// //class Categoria {
// //  int id;
// //  String descricao;
// //
// //  Categoria({
// //    this.id,
// //    this.descricao,
// //  });
// //
// //  factory Categoria.fromJSON(Map<String, dynamic> jsonMap) {
// //    return Categoria(id: jsonMap['id'], descricao: jsonMap['descricao']);
// //  }
// //}
// void TrocaFoto() {}
