import 'package:produtor/pages/estoque/estoque_abas.dart';
import 'package:flutter/material.dart';
import 'package:produtor/pages/home.dart';
import 'package:toast/toast.dart';
import '../../soft_buttom.dart';
import '../dados_basicos.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

Produto produto = Produto();

class Atualiza_Produto extends StatefulWidget {
  final id_sessao;
  final id_produto;

  Atualiza_Produto({this.id_sessao, this.id_produto});

  @override
  _Atualiza_ProdutoState createState() => _Atualiza_ProdutoState();
}

class _Atualiza_ProdutoState extends State<Atualiza_Produto> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _produtoTextController = TextEditingController();
  TextEditingController _descricaocompletaTextController =
      TextEditingController();
  TextEditingController _codigoTextController = TextEditingController();
  TextEditingController _qtdeEmbalagemTextController = TextEditingController();
  TextEditingController _unidadeTextController = TextEditingController();
  TextEditingController _cdgBarrasTextController = TextEditingController();
  TextEditingController _descMarketingTextController = TextEditingController();
  TextEditingController _observacoesTextController = TextEditingController();
  TextEditingController _precoTextController = TextEditingController();
  double _top = -60;

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 250), () {
      setState(() {
        _top = 0;
      });
    });
    buscarProduto();
    super.initState();
  }

  Future<bool> onWillPop() async {
    Navigator.of(context).push(
      new MaterialPageRoute(
          // aqui temos passagem de valores id cliente(sessao) de login para home
          builder: (context) => estoque_Abas(id_sessao: widget.id_sessao)),
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: onWillPop,
        child: SafeArea(
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
                              'Editar Produto',
                              style: TextStyle(
                                fontSize: 24,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView(
                              children: <Widget>[
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: <Widget>[
                                      //////  NOME DO PRODUTO /////
                                      Container(
                                        padding: EdgeInsets.fromLTRB(
                                            0.0, 8.0, 0.0, 0.0),
                                        height: 60,
                                        alignment: Alignment(0, 0),
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              20.0, 0.0, 20.0, 0.0),
                                          child: Material(
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 0.0),
                                              child: ListTile(
                                                  title: TextFormField(
                                                controller:
                                                    _produtoTextController,
                                                decoration: InputDecoration(
                                                    suffix: Text(
                                                        'Nome do Produto',
                                                        style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontSize: 14.0,
                                                        )),
                                                    hintText: "Nome do Produto",
                                                    icon: Icon(
                                                      Icons
                                                          .subdirectory_arrow_left,
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
                                      Container(
                                        padding: EdgeInsets.fromLTRB(
                                            0.0, 15.0, 0.0, 0.0),
                                        height: 120,
                                        alignment: Alignment(0, 0),
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              20.0, 0.0, 20.0, 0.0),
                                          child: Material(
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 0.0),
                                              child: ListTile(
                                                  title: TextFormField(
                                                maxLines: null,
                                                expands: true,
                                                controller:
                                                    _descricaocompletaTextController,
                                                decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        const Radius.circular(
                                                            5.0),
                                                      ),
                                                      borderSide:
                                                          new BorderSide(
                                                        color: Colors.black,
                                                        width: 0.2,
                                                      ),
                                                    ),
                                                    suffix: Text('Descrição',
                                                        style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontSize: 14.0,
                                                        )),
                                                    hintText:
                                                        "Descrição Completa",
                                                    icon: Icon(
                                                      Icons.description,
                                                      size: 30,
                                                      color: Colors.teal,
                                                    )),
                                                validator: (value) {
                                                  if (value.isEmpty) {
                                                    return "Descrição não pode ficar vazia.";
                                                  }
                                                  return null;
                                                },
                                              )),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.fromLTRB(
                                            0.0, 10.0, 0.0, 0.0),
                                        height: 60,
                                        alignment: Alignment(0, 0),
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              20.0, 0.0, 20.0, 0.0),
                                          child: Material(
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 0.0),
                                              child: ListTile(
                                                  title: TextFormField(
                                                controller:
                                                    _codigoTextController,
                                                decoration: InputDecoration(
                                                    suffix: Text(
                                                        'Código Embalagem',
                                                        style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontSize: 14.0,
                                                        )),
                                                    hintText:
                                                        "Código Embalagem",
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
                                                keyboardType:
                                                    TextInputType.number,
                                              )),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.fromLTRB(
                                            0.0, 10.0, 0.0, 0.0),
                                        height: 60,
                                        alignment: Alignment(0, 0),
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              20.0, 0.0, 20.0, 0.0),
                                          child: Material(
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 0.0),
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
                                                keyboardType:
                                                    TextInputType.number,
                                              )),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.fromLTRB(
                                            0.0, 10.0, 0.0, 0.0),
                                        height: 60,
                                        alignment: Alignment(0, 0),
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              20.0, 0.0, 20.0, 0.0),
                                          child: Material(
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 0.0),
                                              child: ListTile(
                                                  title: TextFormField(
                                                controller:
                                                    _unidadeTextController,
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
                                        padding: EdgeInsets.fromLTRB(
                                            0.0, 10.0, 0.0, 0.0),
                                        height: 60,
                                        alignment: Alignment(0, 0),
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              20.0, 0.0, 20.0, 0.0),
                                          child: Material(
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 0.0),
                                              child: ListTile(
                                                  title: TextFormField(
                                                controller:
                                                    _cdgBarrasTextController,
                                                decoration: InputDecoration(
                                                    suffix: Text(
                                                        'Código de Barras',
                                                        style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontSize: 14.0,
                                                        )),
                                                    hintText:
                                                        "Código de Barras",
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
                                                keyboardType:
                                                    TextInputType.number,
                                              )),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.fromLTRB(
                                            0.0, 10.0, 0.0, 0.0),
                                        height: 60,
                                        alignment: Alignment(0, 0),
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              20.0, 0.0, 20.0, 0.0),
                                          child: Material(
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 0.0),
                                              child: ListTile(
                                                  title: TextFormField(
                                                controller:
                                                    _precoTextController,
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
                                                    if (!regex
                                                        .hasMatch(value)) {
                                                      return 'Insira um valor válido';
                                                    }
                                                    // ^R\$(\d{1,3}(\.\d{3})*|\d+)(\,\d{2})?$
                                                  }
                                                  return null;
                                                },
                                                keyboardType:
                                                    TextInputType.number,
                                              )),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.fromLTRB(
                                            0.0, 10.0, 0.0, 0.0),
                                        height: 60,
                                        alignment: Alignment(0, 0),
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              20.0, 0.0, 20.0, 0.0),
                                          child: Material(
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 0.0),
                                              child: ListTile(
                                                  title: TextFormField(
                                                controller:
                                                    _descMarketingTextController,
                                                decoration: InputDecoration(
                                                    suffix: Text(
                                                        'Descrição Marketing',
                                                        style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontSize: 14.0,
                                                        )),
                                                    hintText:
                                                        "Descrição Marketing:",
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
                                        padding: EdgeInsets.fromLTRB(
                                            0.0, 10.0, 0.0, 0.0),
                                        height: 80,
                                        alignment: Alignment(0, 0),
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              20.0, 0.0, 20.0, 0.0),
                                          child: Material(
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 0.0),
                                              child: ListTile(
                                                  title: TextFormField(
                                                controller:
                                                    _observacoesTextController,
                                                decoration: InputDecoration(
                                                    suffix: Text('Observações',
                                                        style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontSize: 14.0,
                                                        )),
                                                    hintText: "Observações",
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
                                            40.0, 20.0, 40.0, 20),
                                        child: Material(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          color: Colors.teal,
                                          child: MaterialButton(
                                            onPressed: () async {
                                              String result =
                                                  await validateForm();
                                              print(result);
                                              if (result == "sucesso") {
                                                Toast.show(
                                                  "Atualização Realizada com Sucesso",
                                                  context,
                                                  duration: Toast.LENGTH_LONG,
                                                  gravity: Toast.CENTER,
                                                  // backgroundRadius: 0.0,
                                                );
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            new home2(
                                                                id_sessao: widget
                                                                    .id_sessao)));
                                              }
                                            },
                                            minWidth: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Text(
                                              "Atualizar",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
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
                        Future.delayed(Duration(milliseconds: 250), () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => estoque_Abas(
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

  //  Faz uma busca do produto e preenche os controllers do formulário com os dados deste produto
  Future<String> buscarProduto() async {
    //Future.delayed(Duration(seconds: 3));
    //print(widget.id_produto);
    List _busca_produtos = []; // consulta produto para edição
    try {
      //  Recebe os dados e salva no objeto "produto"
      // verifica local_retirada_id
      String link = Basicos.codifica(
          "${Basicos.ip}/crud/?crud=consult89.${widget.id_produto}");
      var res = await http
          .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
      // var res =Basicos.decodifica(res1.body);
      //print(res.body);
      if (res.body.length > 2) {
        if (res.statusCode == 200) {
          List list = json.decode(res.body).cast<Map<String, dynamic>>();
          _busca_produtos = list;
          // print(list);
          //print(list[0]['descricao_simplificada']);
          _produtoTextController.text =
              _busca_produtos[0]['descricao_simplificada'].toString();
          _descricaocompletaTextController.text =
              _busca_produtos[0]['descricao_completa'].toString();
          _codigoTextController.text =
              _busca_produtos[0]['id_embalagem_fechada'].toString();
          _qtdeEmbalagemTextController.text =
              _busca_produtos[0]['quantidade_embalagem_fechada'].toString();
          _unidadeTextController.text =
              _busca_produtos[0]['unidade_medida'].toString();
          _cdgBarrasTextController.text =
              _busca_produtos[0]['codigo_barras'].toString();
          _descMarketingTextController.text =
              _busca_produtos[0]['marketing'].toString();
          _observacoesTextController.text =
              _busca_produtos[0]['observacoes'].toString();
          _precoTextController.text =
              _busca_produtos[0]['preco_venda'].toString().replaceAll('.', ',');
        }
      }
    } catch (error) {
      print(error);
    }
  }

  //  Valida o formulário e atualiza no banco os dados do produto
  Future<String> validateForm() async {
    FormState formState = _formKey.currentState;
    if (formState.validate()) {
      String link = Basicos.codifica("${Basicos.ip}/crud/?crud=consul_90."
          "${Basicos.strip(_produtoTextController.text)},"
          "${Basicos.strip(_descricaocompletaTextController.text)},"
          "${_codigoTextController.text},"
          "${_qtdeEmbalagemTextController.text},"
          "${_unidadeTextController.text},"
          "${_cdgBarrasTextController.text},"
          "${Basicos.strip(_descMarketingTextController.text)},"
          "${Basicos.strip(_observacoesTextController.text)},"
          "${_precoTextController.text.replaceAll(',', '.')},"
          "${widget.id_produto.toString()}");
      // print(link);
      var res1 = await http
          .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
      // print(res.body);
      var res = Basicos.decodifica(res1.body);
      if (res1.body.length > 2) {
        if (res1.statusCode == 200) {
          return "sucesso";
        }
      }
    }
  }
}

class Produto {
  String produto,
      descricaocompleta,
      unidade,
      cdgBarras,
      descMarketing,
      observacoes,
      codigo;
  double qtdeEmbalagem, preco;

  Produto(
      {this.cdgBarras,
      this.codigo,
      this.descMarketing,
      this.descricaocompleta,
      this.observacoes,
      this.preco,
      this.produto,
      this.qtdeEmbalagem,
      this.unidade});
}
