import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:produtor/pages/dados_basicos.dart';

import '../../soft_buttom.dart';
import 'home_colaborador.dart';

class SobreColaborador extends StatefulWidget {
  final id_sessao;
  final id_colaborador;

  SobreColaborador({
    this.id_sessao,
    this.id_colaborador,
  });

  @override
  _SobreColaboradorState createState() => _SobreColaboradorState();
}

class _SobreColaboradorState extends State<SobreColaborador> {
  @override
  String versao = '';
  double _top = -60;

  void initState() {
    Future.delayed(Duration(milliseconds: 250), () {
      setState(() {
        _top = 0;
      });
    });
    verifica_logado().then((resultado) {
      setState(() {});
    }); //verifica se houve login e esta armazenado na variavel de preferencias
    super.initState();
  }

  Future<bool> onWillPop() async {
    setState(() {
      _top = -60;
    });
    Future.delayed(Duration(milliseconds: 250), () {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => homeColaborador(
                id_sessao: widget.id_sessao,
                id_colaborador: widget.id_colaborador,
              )));
    });
    return true;
  }

  Widget build(BuildContext context) {
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
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 20, right: 20, bottom: 5),
                          child: Text(
                            'Sobre',
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Recoopsol ",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              // Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                              //   Padding(
                              //     padding: EdgeInsets.all(15),
                              //     child: Container(
                              //       height: 150.0,
                              //       width: 150.0,
                              //       child: Image.asset("/images/app_icon.jpg"),
                              //     ),
                              //   )
                              // ]),
                              Text(
                                "2015-2020 Recoopsol - versão: ${versao}",
                                style: TextStyle(
                                    color: Colors.teal,
                                    fontStyle: FontStyle.italic),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 150),
                              ),
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
                            builder: (context) => homeColaborador(
                                  id_sessao: widget.id_sessao,
                                  id_colaborador: widget.id_colaborador,
                                )));
                      });
                    }),
                radius: 22,
              ),
            ),
          ],
        ),
      )),
    );
  }

  Future<List> verifica_logado() async {
    //verifica versão
    String link0 = Basicos.codifica("${Basicos.ip}/crud/?crud=consult85.*");
//print("${Basicos.ip}/crud/?crud=consult85.*,");
    var res10 = await http
        .get(Uri.encodeFull(link0), headers: {"Accept": "application/json"});
    //var res0 = Basicos.decodifica(res10.body);
    //print('2');
    if (res10.body.length > 2) {
      if (res10.statusCode == 200) {
        //gera criptografia senha terminar depois
        //print('3');
        List listx = json.decode(res10.body).cast<Map<String, dynamic>>();
        versao = listx[0]['id_versao'].toString();
        //print(versao);
      }
    }
  }
}
