import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../soft_buttom.dart';
import '../dados_basicos.dart';
import '../home.dart';
import 'estoque_abas.dart';

class EstoqueSaida extends StatefulWidget {
  final id_sessao;

  EstoqueSaida({
    this.id_sessao,
  });

  @override
  _EstoqueSaidaState createState() => _EstoqueSaidaState();
}

class _EstoqueSaidaState extends State<EstoqueSaida> {
  final formKey = GlobalKey<FormState>();
  double _top = -60, count = 1;

  List<String> produtos;
  StreamController streamProdutos, streamQuantidade;
  TextEditingController motivoText = TextEditingController();
  String itemSelecionadoRelatorio;

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 250), () {
      setState(() {
        _top = 0;
      });
    });
    streamProdutos = StreamController();
    streamQuantidade = StreamController();
    listaProdutos(widget.id_sessao);
    super.initState();
  }

  @override
  void dispose() {
    streamProdutos.close();
    streamQuantidade.close();
    super.dispose();
  }

  Future<bool> onWillPop() async {
    setState(() {
      _top = -60;
    });
    Future.delayed(Duration(milliseconds: 250), () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
            estoque_Abas(
              id_sessao: widget.id_sessao,
            )
        )
      );
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
                    left: 10.0, right: 10.0, top: 65, bottom: 5),
                child: Center(
                  child: Container(
                    width: double.infinity,
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
                              'Saída de Estoque',
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
                              children: [
                                Form(
                                  key: formKey,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 20.0),
                                          child: Text(
                                            'Produto',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,                
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          thickness: .5,
                                          endIndent: 20,
                                          indent: 20,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 10),
                                          child: StreamBuilder(
                                            stream: streamProdutos.stream,
                                            builder: (context, snapshot) {
                                              List<String> produtoList = snapshot.data;
                                              switch (snapshot.connectionState) {
                                                case ConnectionState.waiting:
                                                  return Center(child: CircularProgressIndicator());
                                                default:
                                                  return DropdownButton<String>(
                                                    isExpanded: true,
                                                    items : produtoList.map((String dropDownStringItem) {
                                                      return DropdownMenuItem<String>(
                                                        value: dropDownStringItem,
                                                        child: Text(
                                                          dropDownStringItem, 
                                                          style: TextStyle(fontWeight: FontWeight.w400),
                                                          softWrap: true,
                                                        ),
                                                      );
                                                    }).toList(),
                                                    onChanged: ( String novoItemSelecionado) {
                                                      setState(() {
                                                        itemSelecionadoRelatorio =  novoItemSelecionado;
                                                      });
                                                    },
                                                    value: itemSelecionadoRelatorio,
                                                    hint: Text('Selecione o Produto'),
                                                  );   
                                              }
                                            }
                                          ),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(top: 20.0),
                                          child: Text(
                                            'Quantidade',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,                
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          thickness: .5,
                                          endIndent: 20,
                                          indent: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                if(count > 1) {
                                                  count--;
                                                  streamQuantidade.sink.add(count);
                                                }
                                              },
                                              icon: Icon(Icons.indeterminate_check_box, color: Colors.teal,),
                                            ),
                                            StreamBuilder(
                                              stream: streamQuantidade.stream,
                                              initialData: 1.0,
                                              builder: (context, snapshot) {
                                                return Container(
                                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                                  child: Text(
                                                    '${snapshot.data} unidades',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: "Poppins",
                                                      fontWeight: FontWeight.w400,
                                                      color: Colors.black,                
                                                    ),
                                                  ),
                                                );
                                              }
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                count++;
                                                streamQuantidade.sink.add(count);
                                              },
                                              icon: Icon(Icons.add_box, color: Colors.teal,),
                                            ),
                                          ]
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(top: 10.0),
                                          child: Text(
                                            'Motivo',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,                
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          thickness: .5,
                                          endIndent: 20,
                                          indent: 20,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: TextField(
                                            controller: motivoText,
                                            maxLines: 8,
                                            decoration: InputDecoration.collapsed(
                                              hintText: " Informe o motivo aqui",
                                              border: OutlineInputBorder(
                                                gapPadding: 200,
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: BorderSide(width: .2)
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: 10),
                                          child: Material(
                                            borderRadius: BorderRadius.circular(12),
                                            color: Colors.teal,
                                            elevation: 0.0,
                                            child: MaterialButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (BuildContext context) {
                                                    return MyDialog();
                                                  },
                                                );
                                              },
                                              minWidth: MediaQuery.of(context).size.width,
                                              child: Text(
                                                "Confirmar",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20.0
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    )
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
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                              estoque_Abas(
                                id_sessao: widget.id_sessao,
                              )
                          )
                        );
                      });
                    }
                  ),
                  radius: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List> listaProdutos(String id_sessao) async {
  //print(id_sessao);
    produtos = [];
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
        print(list.length);
        for (var i = 0; i < list.length; i++) {
          setState(() {
            produtos.add(
              '${list[i]['descricao_simplificada']} - ${list[i]['id']}');
          });
        }
        produtos.sort((a, b) => a.compareTo(b));
        streamProdutos.sink.add(produtos);
        return list;
      }
    }
  }
}

class MyDialog extends StatefulWidget {
  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Confirmação"),
      content: Text("Você confirmar a saída de estoque ?"),
      actions: <Widget>[
        new FlatButton(
          child: new Text(
            "Confirmar",
            style: TextStyle(color: Colors.teal),
          ),
          onPressed: () {

          },
        ),
        new FlatButton(
          child: new Text(
            "Cancelar",
            style: TextStyle(color: Colors.teal),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}