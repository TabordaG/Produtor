import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import '../soft_buttom.dart';
import 'dados_basicos.dart';
import 'home.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Registrar_fornecedor_juridico extends StatefulWidget {
  final id_sessao;

  Registrar_fornecedor_juridico({
    this.id_sessao,
  });

  _Registrar_fornecedor_juridicoState createState() =>
      _Registrar_fornecedor_juridicoState();
}

class _Registrar_fornecedor_juridicoState
    extends State<Registrar_fornecedor_juridico> {
  final _formKey = GlobalKey<FormState>();
  List<String> lista_locais = [];

//UserServices _userServices = UserServices();
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _cpfTextController = TextEditingController();
  TextEditingController _telefoneTextController = TextEditingController();
  TextEditingController _enderecoTextController = TextEditingController();
  TextEditingController _numeroTextController = TextEditingController();

//TextEditingController _complementoTextController = TextEditingController();
  TextEditingController _bairroTextController = TextEditingController();
  TextEditingController _cidadeTextController = TextEditingController();
  TextEditingController _ufTextController = TextEditingController();
  TextEditingController _cepTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();

  String gender;
  bool hidePass = true;
  bool loading = false;
  String _selectedId;
  double _top = -60;

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 250), () {
      setState(() {
        _top = 0;
      });
    });
    super.initState();
  }

  Future<bool> onWillPop() async {
    setState(() {
      _top = -60;
    });
    Future.delayed(Duration(milliseconds: 250), () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
            home2(
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20, top: 20, right: 20, bottom: 5),
                          child: Text(
                            'Cadastrar Fornecedor',
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
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10.0, top: 0, bottom: 5),
                                    child: Form(
                                        key: _formKey,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              height: 60,
                                              alignment: Alignment(0, 0),
                                              padding: const EdgeInsets.all(0),
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(
                                                    20.0, 10.0, 20.0, 0.0),
                                                child: Material(
                                                  borderRadius: BorderRadius.circular(20.0),
                                                  color: Colors.grey.withOpacity(0.2),
                                                  elevation: 0.0,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 0.0),
                                                    child: ListTile(
                                                      title: TextFormField(
                                                        controller: _nameTextController,
                                                        decoration: InputDecoration(
                                                          suffix: Text('Razão Social',
                                                              style: TextStyle(
                                                                fontStyle: FontStyle.italic,
                                                                fontSize: 14.0,
                                                              )),
                                                          hintText: "Razão Social",
                                                          icon: Icon(Icons.person_outline),
                                                          border: InputBorder.none,
                                                          counterText: "",
                                                          // remove os numero do contador do maxleng
                                                        ),
                                                        maxLength: 100,
                                                        validator: (value) {
                                                          if (value.isEmpty) {
                                                            return "A Razão Social não pode ficar em branco";
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 60,
                                              padding: const EdgeInsets.all(0),
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(
                                                    20.0, 10.0, 20.0, 0.0),
                                                child: Material(
                                                  borderRadius: BorderRadius.circular(20.0),
                                                  color: Colors.grey.withOpacity(0.2),
                                                  elevation: 0.0,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 0.0),
                                                    child: ListTile(
                                                      title: TextFormField(
                                                        controller: _cpfTextController,
                                                        decoration: InputDecoration(
                                                          suffix: Text('CNPJ',
                                                              style: TextStyle(
                                                                fontStyle: FontStyle.italic,
                                                                fontSize: 14.0,
                                                              )),
                                                          hintText: "CNPJ",
                                                          counterText: "",
                                                          // remove os numero do contador do maxleng
                                                          icon: Icon(Icons.content_paste),
                                                          border: InputBorder.none,
                                                        ),
                                                        maxLength: 14,
                                                        keyboardType:
                                                            TextInputType.numberWithOptions(),
                                                        validator: (value) {
                                                          if (value.isEmpty) {
                                                            return 'Insira um CNPJ válido';
                                                          } else {
                                                            if (value.length < 11) {
                                                              return "CNPJ Tem Que Ter Pelo Menos 11 Dígitos";
                                                            } else {
                                                              Pattern pattern =
                                                                  '([0-9]{2}[\.]?[0-9]{3}[\.]?[0-9]{3}[\/]?[0-9]{4}[-]?[0-9]{2})|([0-9]{3}[\.]?[0-9]{3}[\.]?[0-9]{3}[-]?[0-9]{2})';
                                                              RegExp regex = new RegExp(pattern);
                                                              if (!regex.hasMatch(value)) {
                                                                return 'Insira um CNPJ válido';
                                                              } else
                                                                return null;
                                                            }
                                                          }

                                                          //if (value.isEmpty) {
                                                          // return "O CPF não pode ficar em branco";
                                                          //}
                                                          return null;
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.all(0),
                                              height: 60,
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(
                                                    20.0, 10.0, 20.0, 0.0),
                                                child: Material(
                                                  borderRadius: BorderRadius.circular(20.0),
                                                  color: Colors.grey.withOpacity(0.2),
                                                  elevation: 0.0,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 0.0),
                                                    child: ListTile(
                                                      title: TextFormField(
                                                        controller: _telefoneTextController,
                                                        decoration: InputDecoration(
                                                          suffix: Text('Telefone',
                                                              style: TextStyle(
                                                                fontStyle: FontStyle.italic,
                                                                fontSize: 14.0,
                                                              )),
                                                          hintText: "Telefone",
                                                          counterText: "",
                                                          // remove os numero do contador do maxleng
                                                          icon: Icon(Icons.settings_cell),
                                                          border: InputBorder.none,
                                                        ),
                                                        keyboardType:
                                                            TextInputType.numberWithOptions(),
                                                        maxLength: 11,
                                                        validator: (value) {
                                                          if (value.isEmpty) {
                                                            return 'Insira um telefone';
                                                          } else {
                                                            if (value.length < 10) {
                                                              return "Telefone com 10 ou 11 numeros (ex.65XXXXXNNNN)";
                                                            } else {
                                                              Pattern pattern = '([0-9]{10})';
                                                              RegExp regex = new RegExp(pattern);
                                                              if (!regex.hasMatch(value)) {
                                                                return 'Insira um numero de telefone válido';
                                                              } else if (value.length > 11) {
                                                                return "Numero muito grande";
                                                              } else
                                                                return null;
                                                            }
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 60,
                                              alignment: Alignment(0, 0),
                                              padding: const EdgeInsets.all(0),
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(
                                                    20.0, 10.0, 20.0, 0.0),
                                                child: Material(
                                                  borderRadius: BorderRadius.circular(20.0),
                                                  color: Colors.grey.withOpacity(0.2),
                                                  elevation: 0.0,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 0.0),
                                                    child: ListTile(
                                                      title: TextFormField(
                                                        controller: _enderecoTextController,
                                                        decoration: InputDecoration(
                                                          suffix: Text('Endereco',
                                                              style: TextStyle(
                                                                fontStyle: FontStyle.italic,
                                                                fontSize: 14.0,
                                                              )),
                                                          hintText: "Endereco",
                                                          counterText: "",
                                                          // remove os numero do contador do maxleng
                                                          icon: Icon(Icons.apps),
                                                          border: InputBorder.none,
                                                        ),
                                                        maxLength: 50,
                                                        validator: (value) {
                                                          if (value.isEmpty) {
                                                            return "O endereco não pode ficar em branco";
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 60,
                                              alignment: Alignment(0, 0),
                                              padding: const EdgeInsets.all(0),
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(
                                                    20.0, 10.0, 20.0, 0.0),
                                                child: Material(
                                                  borderRadius: BorderRadius.circular(20.0),
                                                  color: Colors.grey.withOpacity(0.2),
                                                  elevation: 0.0,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 0.0),
                                                    child: ListTile(
                                                      title: TextFormField(
                                                        controller: _numeroTextController,
                                                        decoration: InputDecoration(
                                                          suffix: Text('Número',
                                                              style: TextStyle(
                                                                fontStyle: FontStyle.italic,
                                                                fontSize: 14.0,
                                                              )),
                                                          hintText: "Número",
                                                          counterText: "",
                                                          // remove os numero do contador do maxleng
                                                          icon: Icon(Icons.confirmation_number),
                                                          border: InputBorder.none,
                                                        ),
                                                        maxLength: 10,
                                                        validator: (value) {
                                                          if (value.isEmpty) {
                                                            return "O número não pode ficar em branco";
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            //COMPLEMENTO -------- ENDEREÇO
                                            /*Container(
                                            height: 60,
                                            alignment: Alignment(0, 0),
                                            padding: const EdgeInsets.all(0),
                                            child: Padding(
                                              padding: const EdgeInsets.fromLTRB(
                                                  20.0, 10.0, 20.0, 0.0),
                                              child: Material(
                                                borderRadius: BorderRadius.circular(20.0),
                                                color: Colors.grey.withOpacity(0.2),
                                                elevation: 0.0,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 0.0),
                                                  child: ListTile(
                                                    title: TextFormField(
                                                      controller: _complementoTextController,
                                                      decoration: InputDecoration(
                                                        suffix: Text('Complemento',
                                                            style: TextStyle(
                                                              fontStyle: FontStyle.italic,
                                                              fontSize: 14.0,
                                                            )),
                                                        hintText: "Complemento",
                                                        icon: Icon(Icons.apps),
                                                        border: InputBorder.none,
                                                      ),
                                                      validator: (value) {
                                                        if (value.isEmpty) {
                                                          return "O complemento não pode ficar em branco";
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),*/
                                            Container(
                                              height: 60,
                                              alignment: Alignment(0, 0),
                                              padding: const EdgeInsets.all(0),
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(
                                                    20.0, 10.0, 20.0, 0.0),
                                                child: Material(
                                                  borderRadius: BorderRadius.circular(20.0),
                                                  color: Colors.grey.withOpacity(0.2),
                                                  elevation: 0.0,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 0.0),
                                                    child: ListTile(
                                                      title: TextFormField(
                                                        controller: _bairroTextController,
                                                        decoration: InputDecoration(
                                                          suffix: Text('Bairro',
                                                              style: TextStyle(
                                                                fontStyle: FontStyle.italic,
                                                                fontSize: 14.0,
                                                              )),
                                                          hintText: "Bairro",
                                                          counterText: "",
                                                          // remove os numero do contador do maxleng
                                                          icon: Icon(Icons.save_alt),
                                                          border: InputBorder.none,
                                                        ),
                                                        maxLength: 50,
                                                        validator: (value) {
                                                          if (value.isEmpty) {
                                                            return "O bairro não pode ficar em branco";
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            Container(
                                              height: 60,
                                              alignment: Alignment(0, 0),
                                              padding: const EdgeInsets.all(0),
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(
                                                    20.0, 10.0, 20.0, 0.0),
                                                child: Material(
                                                  borderRadius: BorderRadius.circular(20.0),
                                                  color: Colors.grey.withOpacity(0.2),
                                                  elevation: 0.0,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 0.0),
                                                    child: ListTile(
                                                      title: TextFormField(
                                                        controller: _cidadeTextController,
                                                        decoration: InputDecoration(
                                                          suffix: Text('Cidade',
                                                              style: TextStyle(
                                                                fontStyle: FontStyle.italic,
                                                                fontSize: 14.0,
                                                              )),
                                                          hintText: "Cidade",
                                                          counterText: "",
                                                          // remove os numero do contador do maxleng
                                                          icon: Icon(Icons.location_city),
                                                          border: InputBorder.none,
                                                        ),
                                                        maxLength: 50,
                                                        validator: (value) {
                                                          if (value.isEmpty) {
                                                            return "O cidade não pode ficar em branco";
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            Container(
                                              height: 60,
                                              alignment: Alignment(0, 0),
                                              padding: const EdgeInsets.all(0),
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(
                                                    20.0, 10.0, 20.0, 0.0),
                                                child: Material(
                                                  borderRadius: BorderRadius.circular(20.0),
                                                  color: Colors.grey.withOpacity(0.2),
                                                  elevation: 0.0,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 0.0),
                                                    child: ListTile(
                                                      title: TextFormField(
                                                        controller: _ufTextController,
                                                        decoration: InputDecoration(
                                                          suffix: Text('UF',
                                                              style: TextStyle(
                                                                fontStyle: FontStyle.italic,
                                                                fontSize: 14.0,
                                                              )),
                                                          counterText: "",
                                                          // remove os numero do contador do maxleng
                                                          hintText: "UF",
                                                          icon: Icon(Icons.ac_unit),
                                                          border: InputBorder.none,
                                                        ),
                                                        maxLength: 2,
                                                        validator: (value) {
                                                          if (value.isEmpty) {
                                                            return "O UF não pode ficar em branco";
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            //CEP

                                            Container(
                                              height: 60,
                                              alignment: Alignment(0, 0),
                                              padding: const EdgeInsets.all(0),
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(
                                                    20.0, 10.0, 20.0, 0.0),
                                                child: Material(
                                                  borderRadius: BorderRadius.circular(20.0),
                                                  color: Colors.grey.withOpacity(0.2),
                                                  elevation: 0.0,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 0.0),
                                                    child: ListTile(
                                                      title: TextFormField(
                                                        controller: _cepTextController,
                                                        decoration: InputDecoration(
                                                          suffix: Text('CEP',
                                                              style: TextStyle(
                                                                fontStyle: FontStyle.italic,
                                                                fontSize: 14.0,
                                                              )),
                                                          counterText: "",
                                                          // remove os numero do contador do maxleng
                                                          hintText: "CEP",
                                                          icon: Icon(Icons.crop),
                                                          border: InputBorder.none,
                                                        ),
                                                        maxLength: 8,
                                                        validator: (value) {
                                                          if (value.isEmpty) {
                                                            return "O cep não pode ficar em branco";
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            Container(
                                              padding: const EdgeInsets.all(0),
                                              height: 60,
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(
                                                    20.0, 10.0, 20.0, 0.0),
                                                child: Material(
                                                  borderRadius: BorderRadius.circular(20.0),
                                                  color: Colors.grey.withOpacity(0.2),
                                                  elevation: 0.0,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 0.0),
                                                    child: ListTile(
                                                      title: TextFormField(
                                                        controller: _emailTextController,
                                                        decoration: InputDecoration(
                                                            suffix: Text('Email',
                                                                style: TextStyle(
                                                                  fontStyle: FontStyle.italic,
                                                                  fontSize: 14.0,
                                                                )),
                                                            hintText: "Email",
                                                            counterText: "",
                                                            // remove os numero do contador do maxleng
                                                            icon: Icon(Icons.alternate_email),
                                                            border: InputBorder.none),
                                                        keyboardType: TextInputType.emailAddress,
                                                        maxLength: 254,
                                                        validator: (value) {
                                                          if (value.isEmpty) {
                                                            return 'Insira um endereço de email';
                                                          } else {
                                                            if (value.length < 3) {
                                                              return "Email Tem Que Ter Pelo Menos 3 Caracteres";
                                                            } else {
                                                              Pattern pattern =
                                                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                                              RegExp regex = new RegExp(pattern);
                                                              if (!regex.hasMatch(value)) {
                                                                return 'Insira um endereço de email válido';
                                                              } else
                                                                return null;
                                                            }
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(
                                                  20.0, 25.0, 20.0, 25.0),
                                              child: Material(
                                                  borderRadius: BorderRadius.circular(12.0),
                                                  color: Colors.teal,
                                                  elevation: 0.0,
                                                  child: MaterialButton(
                                                    onPressed: () async {
                                                      String result = await validateForm();
                                                      if (result == "sucesso") {
                                                        Toast.show(
                                                            "Cadastro Realizado Com Sucesso",
                                                            context,
                                                            duration: Toast.LENGTH_LONG,
                                                            gravity: Toast.CENTER,
                                                            backgroundRadius: 0.0);
                                                        Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => home2(
                                                                      id_sessao: widget.id_sessao,
                                                                    )));
                                                      } else {
//                                      if (result == "erro_email") {
//                                        Toast.show("erro: Email Já Cadastrado",
//                                            context,
//                                            duration: Toast.LENGTH_LONG,
//                                            gravity: Toast.CENTER,
//                                            backgroundRadius: 0.0);
//                                      }
                                                      }
                                                    },
                                                    minWidth: MediaQuery.of(context).size.width,
                                                    child: Text(
                                                      "Registrar",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 20.0),
                                                    ),
                                                  )),
                                            ),
                                          ],
                                        ))),
                                Visibility(
                                  visible: loading ?? true,
                                  child: Center(
                                    child: Container(
                                      alignment: Alignment.center,
                                      color: Colors.white.withOpacity(0.9),
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                                      ),
                                    ),
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
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                              home2(
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

// insere produtor pessoa fisica
  Future<String> validateForm() async {
    FormState formState = _formKey.currentState;
    if (formState.validate()) {
     // print('1');
      String teste = await emailCadastrado();

      print(teste);
      if (teste == "livre") {
        // se email livre insere tabela fornecedores ######################################
        String link = Basicos.codifica("${Basicos.ip}/crud/?crud=consult86."
            "${_nameTextController.text}," //              nome_razao_social character varying(100) NOT NULL,
            "${_cpfTextController.text}," //              cpf_cnpj character varying(20) NOT NULL,
            //              rg_inscricao_estadual character varying(15) NOT NULL,
            //              telefone character varying(30) NOT NULL,
            "${_telefoneTextController.text}," //        celular character varying(30) NOT NULL,
            //        contato character varying(30) NOT NULL,
            "${_emailTextController.text.toLowerCase()}," //email character varying(254) NOT NULL,
            //              status character varying(10) NOT NULL, ('ATIVO', 'INATIVO')
            "${_enderecoTextController.text}," //              endereco character varying(50) NOT NULL,
            "${_bairroTextController.text}," //          bairro character varying(50) NOT NULL,
            "${_cidadeTextController.text}," //           cidade character varying(50) NOT NULL,
            "${_cepTextController.text}," //              cep character varying(10) NOT NULL,
            "${_ufTextController.text}," //              estado character varying(2) NOT NULL,
            //              observacoes text NOT NULL,
            //    sexo character varying(10) NOT NULL,
            //    data_registro timestamp with time zone NOT NULL,
            //    data_alteracao timestamp with time zone NOT NULL,
            //    pessoa character varying(10) NOT NULL,
            "${_numeroTextController.text}," //  numero character varying(10) NOT NULL,
            //    complemento character varying(30) NOT NULL,
            //    data_nascimento_fundacao date NOT NULL,
            //    estado_civil character varying(15) NOT NULL,
            //    model_template character varying(20) NOT NULL,
            //    sobre_nome character varying(100) NOT NULL,
            //    nome_fantasia character varying(100) NOT NULL,
            //    inscricao_municipal character varying(15) NOT NULL,
            "${widget.id_sessao.toString()}"//    empresa_id integer,
            );
        //print(link);
        var res1 = await http.get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
        var res = Basicos.decodifica(res1.body);
        //  print(res.body);
        if (res1.body.length > 2) {
          if (res1.statusCode == 200) {
            var list = json.decode(res).cast<Map<String, dynamic>>();
//            print(
//                list[0]['id']); // retorna o id inserido na tabelas de fornecedores
            return "sucesso";
          }
        }
      } else {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return new AlertDialog(
                title: new Text(
                  "Fornecedor já Cadastrado  ",
                  textAlign: TextAlign.center,
                ),
                content: new Text(
                  "Utilize outro email",
                  textAlign: TextAlign.center,
                ),
                actions: <Widget>[
                  new MaterialButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pop(context); // aciona fechar do alerta
                    },
                    child: new Text("Fechar"),
                  )
                ],
              );
            });
        return "erro_email";
      }
    } else {
      Toast.show("Campos com Erros", context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER,
          backgroundRadius: 0.0);

    }
  }

// verifica se email já cadastrado fornecedor
  Future<String> emailCadastrado() async {

      // verifica se email ja cadastrado
      String link = Basicos.codifica(
          "${Basicos.ip}/crud/?crud=consult87.${_emailTextController.text.toLowerCase()}");
      var res1 = await http
          .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
      var res = Basicos.decodifica(res1.body);
      if (res1.body.length > 2) {
        if (res1.statusCode == 200) {
          List list = json.decode(res).cast<Map<String, dynamic>>();
          if (list.isEmpty)
            return 'livre';
          else
            return 'existe';
        }
      } else
        return 'falha';
      // verifica se email ja cadastrado


  }
}