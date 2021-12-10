import 'dart:convert';

import 'package:produtor/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import '../../soft_buttom.dart';
import 'package:animations/animations.dart';
import 'package:http/http.dart' as http;
import '../dados_basicos.dart';

List<Colaborador> listaColaboradores = [];

class RegistrarColaborador extends StatefulWidget {
  final id_sessao;

  // ignore: non_constant_identifier_names
  const RegistrarColaborador({Key key, this.id_sessao}) : super(key: key);

  @override
  _RegistrarColaboradorState createState() => _RegistrarColaboradorState();
}

class _RegistrarColaboradorState extends State<RegistrarColaborador>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  double _top = -60;
  final _formKey = GlobalKey<FormState>();

  // List<String> lista_locais = [];
  List<String> _marcas_list = []; // dados estaticos de marcas

  //UserServices _userServices = UserServices();
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _sobrenameTextController = TextEditingController();

  //TextEditingController _rgTextController = TextEditingController();
  TextEditingController _cpfTextController = TextEditingController();
  TextEditingController _telefoneTextController = TextEditingController();
  TextEditingController _enderecoTextController = TextEditingController();
  TextEditingController _numeroTextController = TextEditingController();
  TextEditingController _complementoTextController = TextEditingController();
  TextEditingController _bairroTextController = TextEditingController();
  TextEditingController _cidadeTextController = TextEditingController();
  TextEditingController _ufTextController = TextEditingController();
  TextEditingController _cepTextController = TextEditingController();

  // TextEditingController _data_registroTextController = TextEditingController();
  // TextEditingController _statusTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _confirm_passwordTextController =
      TextEditingController();
  String gender;
  bool hidePass = true;
  bool loading = false;

  //String _selectedId;
  bool termo = false;
  String _selectedIdmarca;

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 250), () {
      setState(() {
        _top = 0;
      });
    });
    Lista_empreendimentos().then((resultado) {
      setState(() {});
    });

    _tabController = new TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
                        blurRadius: 20.0,
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 20, right: 20, bottom: 15),
                          child: Text(
                            'Registrar Colaborador',
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
                                      left: 5, right: 5.0, top: 0, bottom: 5),
                                  child: Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Form(
                                        key: _formKey,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              height: 60,
                                              alignment: Alignment(0, 0),
                                              padding: const EdgeInsets.all(0),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        20.0, 10.0, 20.0, 0.0),
                                                child: Material(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  elevation: 0.0,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 0.0,
                                                            top: 0.0),
                                                    child: ListTile(
                                                      title: TextFormField(
                                                        controller:
                                                            _nameTextController,
                                                        decoration:
                                                            InputDecoration(
                                                          suffix: Text('Nome',
                                                              style: TextStyle(
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                fontSize: 14.0,
                                                              )),
                                                          hintText: "Nome",
                                                          icon: Icon(
                                                            Icons.person,
                                                          ),
                                                          border:
                                                              InputBorder.none,
                                                          counterText:
                                                              "", // remove os numero do contador do maxleng
                                                        ),
                                                        maxLength: 50,
                                                        validator: (value) {
                                                          if (value.isEmpty) {
                                                            return "O Nome não pode ficar em branco";
                                                          } else {
                                                            if (value.length >
                                                                50) {
                                                              return "O nome deve ter comprimento máximo de 50 caracteres";
                                                            }
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
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        20.0, 10.0, 20.0, 0.0),
                                                child: Material(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  elevation: 0.0,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 0.0),
                                                    child: ListTile(
                                                      title: TextFormField(
                                                        controller:
                                                            _sobrenameTextController,
                                                        decoration:
                                                            InputDecoration(
                                                          suffix: Text(
                                                              'Sobrenome',
                                                              style: TextStyle(
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                fontSize: 14.0,
                                                              )),
                                                          hintText: "Sobrenome",
                                                          icon: Icon(Icons
                                                              .person_outline),
                                                          border:
                                                              InputBorder.none,
                                                          counterText: "",
                                                        ),
                                                        maxLength: 50,
                                                        validator: (value) {
                                                          if (value.isEmpty) {
                                                            return "O Sobrenome não pode ficar em branco";
                                                          } else {
                                                            if (value.length >
                                                                50) {
                                                              return "O sobrenome deve ter comprimento máximo de 50 caracteres";
                                                            }
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // Container(
                                            //   height: 60,
                                            //   padding: const EdgeInsets.all(0),
                                            //   child: Padding(
                                            //     padding:
                                            //         const EdgeInsets.fromLTRB(
                                            //             20.0, 10.0, 20.0, 0.0),
                                            //     child: Material(
                                            //       borderRadius:
                                            //           BorderRadius.circular(
                                            //               20.0),
                                            //       color: Colors.grey
                                            //           .withOpacity(0.2),
                                            //       elevation: 0.0,
                                            //       child: Padding(
                                            //         padding:
                                            //             const EdgeInsets.only(
                                            //                 left: 0.0),
                                            //         child: ListTile(
                                            //           title: TextFormField(
                                            //             controller:
                                            //                 _rgTextController,
                                            //             keyboardType:
                                            //                 TextInputType
                                            //                     .number,
                                            //             decoration:
                                            //                 InputDecoration(
                                            //               suffix: Text('RG',
                                            //                   style: TextStyle(
                                            //                     fontStyle:
                                            //                         FontStyle
                                            //                             .italic,
                                            //                     fontSize: 14.0,
                                            //                   )),
                                            //               hintText: "RG",
                                            //               icon: Icon(Icons
                                            //                   .assignment_ind),
                                            //               border:
                                            //                   InputBorder.none,
                                            //               counterText: "",
                                            //             ),
                                            //             maxLength: 8,
                                            //             validator: (value) {
                                            //               if (value.isEmpty) {
                                            //                 return 'Insira um CPF válido';
                                            //               } else {
                                            //                 if (value.length <
                                            //                     8) {
                                            //                   return "CPF somente números com 11 Dígitos";
                                            //                 } else {
                                            //                   // Pattern pattern =
                                            //                   //     '([0-9]{2}[\.]?[0-9]{3}[\.]?[0-9]{3}[\/]?[0-9]{4}[-]?[0-9]{2})|([0-9]{3}[\.]?[0-9]{3}[\.]?[0-9]{3}[-]?[0-9]{2})';
                                            //                   // RegExp regex =
                                            //                   //     new RegExp(
                                            //                   //         pattern);
                                            //                   // if (!regex
                                            //                   //     .hasMatch(
                                            //                   //         value)) {
                                            //                   //   return 'Insira um CPF válido';
                                            //                   // } else
                                            //                   return null;
                                            //                 }
                                            //               }
                                            //             },
                                            //           ),
                                            //         ),
                                            //       ),
                                            //     ),
                                            //   ),
                                            // ),
                                            Container(
                                              height: 60,
                                              padding: const EdgeInsets.all(0),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        20.0, 10.0, 20.0, 0.0),
                                                child: Material(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  elevation: 0.0,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 0.0),
                                                    child: ListTile(
                                                      title: TextFormField(
                                                        controller:
                                                            _cpfTextController,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        decoration:
                                                            InputDecoration(
                                                          suffix: Text('CPF',
                                                              style: TextStyle(
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                fontSize: 14.0,
                                                              )),
                                                          hintText: "CPF",
                                                          icon: Icon(Icons
                                                              .content_paste),
                                                          border:
                                                              InputBorder.none,
                                                          counterText: "",
                                                        ),
                                                        maxLength: 11,
                                                        validator: (value) {
                                                          if (value.isEmpty) {
                                                            return 'Insira um CPF válido';
                                                          } else {
                                                            if (value.length <
                                                                11) {
                                                              return "CPF somente números com 11 Dígitos";
                                                            } else {
                                                              Pattern pattern =
                                                                  '([0-9]{2}[\.]?[0-9]{3}[\.]?[0-9]{3}[\/]?[0-9]{4}[-]?[0-9]{2})|([0-9]{3}[\.]?[0-9]{3}[\.]?[0-9]{3}[-]?[0-9]{2})';
                                                              RegExp regex =
                                                                  new RegExp(
                                                                      pattern);
                                                              if (!regex
                                                                  .hasMatch(
                                                                      value)) {
                                                                return 'Insira um CPF válido';
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
                                              padding: const EdgeInsets.all(0),
                                              height: 60,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        20.0, 10.0, 20.0, 0.0),
                                                child: Material(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  elevation: 0.0,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 0.0),
                                                    child: ListTile(
                                                      title: TextFormField(
                                                        controller:
                                                            _telefoneTextController,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        decoration:
                                                            InputDecoration(
                                                          suffix: Text(
                                                              'Telefone',
                                                              style: TextStyle(
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                fontSize: 14.0,
                                                              )),
                                                          hintText: "Telefone",
                                                          icon: Icon(Icons
                                                              .settings_cell),
                                                          border:
                                                              InputBorder.none,
                                                          counterText:
                                                              "", // remove os numero do contador do maxleng
                                                        ),
                                                        maxLength: 11,
                                                        validator: (value) {
                                                          if (value.isEmpty) {
                                                            return 'Insira um telefone';
                                                          } else {
                                                            if (value.length <
                                                                10) {
                                                              return "Telefone com 10 ou 11 numeros (ex.65XXXXXNNNN)";
                                                            } else {
                                                              Pattern pattern =
                                                                  '([0-9]{10})';
                                                              RegExp regex =
                                                                  new RegExp(
                                                                      pattern);
                                                              if (!regex
                                                                  .hasMatch(
                                                                      value)) {
                                                                return 'Insira um numero de telefone válido';
                                                              } else if (value
                                                                      .length >
                                                                  11) {
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
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        20.0, 10.0, 20.0, 0.0),
                                                child: Material(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  elevation: 0.0,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 0.0),
                                                    child: ListTile(
                                                      title: TextFormField(
                                                        controller:
                                                            _enderecoTextController,
                                                        decoration:
                                                            InputDecoration(
                                                          suffix: Text(
                                                              'Endereco',
                                                              style: TextStyle(
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                fontSize: 14.0,
                                                              )),
                                                          hintText: "Endereco",
                                                          icon:
                                                              Icon(Icons.apps),
                                                          border:
                                                              InputBorder.none,
                                                          counterText:
                                                              "", // remove os numero do contador do maxleng
                                                        ),
                                                        maxLength: 40,
                                                        validator: (value) {
                                                          if (value.isEmpty) {
                                                            return "O endereco não pode ficar em branco";
                                                          } else {
                                                            if (value.length >
                                                                40) {
                                                              return "O endereço deve ter comprimento máximo de 40 caracteres";
                                                            }
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
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        20.0, 10.0, 20.0, 0.0),
                                                child: Material(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  elevation: 0.0,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 0.0),
                                                    child: ListTile(
                                                      title: TextFormField(
                                                        controller:
                                                            _numeroTextController,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        decoration:
                                                            InputDecoration(
                                                          suffix: Text('Número',
                                                              style: TextStyle(
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                fontSize: 14.0,
                                                              )),
                                                          hintText: "Número",
                                                          icon: Icon(Icons
                                                              .confirmation_number),
                                                          border:
                                                              InputBorder.none,
                                                          counterText:
                                                              "", // remove os numero do contador do maxleng
                                                        ),
                                                        maxLength: 10,
                                                        validator: (value) {
                                                          if (value.isEmpty) {
                                                            return "O número não pode ficar em branco";
                                                          } else {
                                                            if (value.length >
                                                                10) {
                                                              return "O número deve ter comprimento máximo de 10 caracteres";
                                                            }
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
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        20.0, 10.0, 20.0, 0.0),
                                                child: Material(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  elevation: 0.0,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 0.0),
                                                    child: ListTile(
                                                      title: TextFormField(
                                                        controller:
                                                            _complementoTextController,
                                                        decoration:
                                                            InputDecoration(
                                                          suffix: Text(
                                                              'Complemento',
                                                              style: TextStyle(
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                fontSize: 14.0,
                                                              )),
                                                          hintText:
                                                              "Complemento",
                                                          icon:
                                                              Icon(Icons.check),
                                                          border:
                                                              InputBorder.none,
                                                          counterText:
                                                              "", // remove os numero do contador do maxleng
                                                        ),
                                                        maxLength: 29,
                                                        validator: (value) {
                                                          if (value.isEmpty) {
                                                            return "O complemento não pode ficar em branco";
                                                          } else {
                                                            if (value.length >
                                                                30) {
                                                              return "O complemento deve ter comprimento máximo de 40 caracteres";
                                                            }
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
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        20.0, 10.0, 20.0, 0.0),
                                                child: Material(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  elevation: 0.0,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 0.0),
                                                    child: ListTile(
                                                      title: TextFormField(
                                                        controller:
                                                            _bairroTextController,
                                                        decoration:
                                                            InputDecoration(
                                                          suffix: Text('Bairro',
                                                              style: TextStyle(
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                fontSize: 14.0,
                                                              )),
                                                          hintText: "Bairro",
                                                          icon: Icon(
                                                              Icons.save_alt),
                                                          border:
                                                              InputBorder.none,
                                                          counterText:
                                                              "", // remove os numero do contador do maxleng
                                                        ),
                                                        maxLength: 50,
                                                        validator: (value) {
                                                          if (value.isEmpty) {
                                                            return "O bairro não pode ficar em branco";
                                                          } else {
                                                            if (value.length >
                                                                50) {
                                                              return "O bairro deve ter comprimento máximo de 50 caracteres";
                                                            }
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
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        20.0, 10.0, 20.0, 0.0),
                                                child: Material(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  elevation: 0.0,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 0.0),
                                                    child: ListTile(
                                                      title: TextFormField(
                                                        controller:
                                                            _cidadeTextController,
                                                        decoration:
                                                            InputDecoration(
                                                          suffix: Text('Cidade',
                                                              style: TextStyle(
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                fontSize: 14.0,
                                                              )),
                                                          hintText: "Cidade",
                                                          icon: Icon(Icons
                                                              .location_city),
                                                          border:
                                                              InputBorder.none,
                                                          counterText:
                                                              "", // remove os numero do contador do maxleng
                                                        ),
                                                        maxLength: 50,
                                                        validator: (value) {
                                                          if (value.isEmpty) {
                                                            return "O cidade não pode ficar em branco";
                                                          } else {
                                                            if (value.length >
                                                                50) {
                                                              return "O bairro deve ter comprimento máximo de 50 caracteres";
                                                            }
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
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        20.0, 10.0, 20.0, 0.0),
                                                child: Material(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  elevation: 0.0,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 0.0),
                                                    child: ListTile(
                                                      title: TextFormField(
                                                        controller:
                                                            _ufTextController,
                                                        keyboardType:
                                                            TextInputType.text,
                                                        decoration:
                                                            InputDecoration(
                                                          suffix: Text('UF',
                                                              style: TextStyle(
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                fontSize: 14.0,
                                                              )),
                                                          hintText: "UF",
                                                          icon: Icon(
                                                              Icons.ac_unit),
                                                          border:
                                                              InputBorder.none,
                                                          counterText:
                                                              "", // remove os numero do contador do maxleng
                                                        ),
                                                        maxLength: 2,
                                                        validator: (value) {
                                                          if (value.isEmpty) {
                                                            return "O UF não pode ficar em branco";
                                                          } else {
                                                            if (value.length >
                                                                2) {
                                                              return "A UF deve ter comprimento máximo de 2 caracteres";
                                                            }
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
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        20.0, 10.0, 20.0, 0.0),
                                                child: Material(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  elevation: 0.0,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 0.0),
                                                    child: ListTile(
                                                      title: TextFormField(
                                                        controller:
                                                            _cepTextController,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        decoration:
                                                            InputDecoration(
                                                          suffix: Text('CEP',
                                                              style: TextStyle(
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                fontSize: 14.0,
                                                              )),
                                                          hintText: "CEP",
                                                          icon:
                                                              Icon(Icons.crop),
                                                          border:
                                                              InputBorder.none,
                                                          counterText:
                                                              "", // remove os numero do contador do maxleng
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
                                              child: Column(
                                                children: <Widget>[
                                                  Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            20.0,
                                                            10.0,
                                                            20.0,
                                                            0.0),

                                                    alignment:
                                                        Alignment.bottomLeft,
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
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        20.0, 0.0, 20.0, 0.0),
                                                    child: Material(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      color: Colors.grey
                                                          .withOpacity(0.2),
                                                      elevation: 0.0,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                10.0,
                                                                0.0,
                                                                20.0,
                                                                0.0),
                                                        child: ListTile(
                                                          leading: Icon(
                                                            Icons.bookmark,
                                                            size: 30,
                                                            color: Colors.grey,
                                                          ),
                                                          subtitle: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    0.0,
                                                                    0.0,
                                                                    10.0,
                                                                    0.0),
                                                            child:
                                                                DropdownButton<
                                                                    String>(
                                                              isExpanded: true,
                                                              hint: const Text(
                                                                "Empreendimento",
                                                                style:
                                                                    TextStyle(
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                  fontSize:
                                                                      14.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  color: Colors
                                                                      .black54,
                                                                ),
                                                              ),
                                                              value:
                                                                  _selectedIdmarca,
                                                              onChanged: (String
                                                                  value) {
                                                                setState(() {
                                                                  _selectedIdmarca =
                                                                      value;
                                                                });
                                                              },
                                                              items: _marcas_list
                                                                  .map((String
                                                                      value) {
                                                                return DropdownMenuItem<
                                                                    String>(
                                                                  value: value,
                                                                  child: Text(
                                                                    value.substring(
                                                                        value.indexOf('-',
                                                                                0) +
                                                                            1,
                                                                        value
                                                                            .length),
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
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),

                                            // Container(
                                            //   padding: const EdgeInsets.all(0),
                                            //   height: 60,
                                            //   child: Padding(
                                            //     padding:
                                            //         const EdgeInsets.fromLTRB(
                                            //             20.0, 10.0, 20.0, 0.0),
                                            //     child: Material(
                                            //       borderRadius:
                                            //           BorderRadius.circular(
                                            //               20.0),
                                            //       color: Colors.grey
                                            //           .withOpacity(0.2),
                                            //       elevation: 0.0,
                                            //       child: ListTile(
                                            //         leading: Icon(
                                            //             Icons.local_shipping),
                                            //         subtitle: Padding(
                                            //           padding: const EdgeInsets
                                            //                   .fromLTRB(
                                            //               0.0, 0.0, 10.0, 0.0),
                                            //           child: new DropdownButton<
                                            //               String>(
                                            //             isExpanded: true,
                                            //             hint: const Text(
                                            //               "Status",
                                            //               style: TextStyle(
                                            //                 fontWeight:
                                            //                     FontWeight
                                            //                         .normal,
                                            //                 color:
                                            //                     Colors.black54,
                                            //                 fontSize: 16.0,
                                            //               ),
                                            //             ),
                                            //             value: _selectedId,
                                            //             onChanged:
                                            //                 (String value) {
                                            //               setState(() {
                                            //                 _selectedId = value;
                                            //               });
                                            //             },
                                            //             items: [
                                            //               'Ativo',
                                            //               'Inativo'
                                            //             ].map(
                                            //               (String value) {
                                            //                 return new DropdownMenuItem<
                                            //                     String>(
                                            //                   value: value,
                                            //                   child: Text(
                                            //                     value,
                                            //                     style:
                                            //                         TextStyle(
                                            //                       fontWeight:
                                            //                           FontWeight
                                            //                               .normal,
                                            //                       color: Colors
                                            //                           .black54,
                                            //                       fontSize:
                                            //                           15.0,
                                            //                     ),
                                            //                   ),
                                            //                 );
                                            //               },
                                            //             ).toList(),
                                            //           ),
                                            //         ),
                                            //       ),
                                            //     ),
                                            //   ),
                                            // ),
                                            Container(
                                              padding: const EdgeInsets.all(0),
                                              height: 60,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        20.0, 10.0, 20.0, 0.0),
                                                child: Material(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  elevation: 0.0,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 0.0),
                                                    child: ListTile(
                                                      title: TextFormField(
                                                        controller:
                                                            _emailTextController,
                                                        decoration:
                                                            InputDecoration(
                                                          suffix: Text('Email',
                                                              style: TextStyle(
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                fontSize: 14.0,
                                                              )),
                                                          hintText: "Email",
                                                          icon: Icon(Icons
                                                              .alternate_email),
                                                          border:
                                                              InputBorder.none,
                                                          counterText:
                                                              "", // remove os numero do contador do maxleng
                                                        ),
                                                        maxLength: 254,
                                                        validator: (value) {
                                                          if (value.isEmpty) {
                                                            return 'Insira um endereço de email';
                                                          } else {
                                                            if (value.length <
                                                                3) {
                                                              return "Email Tem Que Ter Pelo Menos 3 Caracteres";
                                                            } else {
                                                              Pattern pattern =
                                                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                                              RegExp regex =
                                                                  new RegExp(
                                                                      pattern);
                                                              if (!regex
                                                                  .hasMatch(
                                                                      value)) {
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
                                            Row(
                                              children: <Widget>[
                                                Container(
                                                  width: 100,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        25.0, 15.0, 0.0, 0.0),
                                                    child: Text('Senha:',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 16.0,
                                                        )),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              padding: const EdgeInsets.all(0),
                                              height: 60,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        20.0, 10.0, 20.0, 0.0),
                                                child: Material(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  elevation: 0.0,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 0.0),
                                                    child: ListTile(
                                                      title: TextFormField(
                                                        controller:
                                                            _passwordTextController,
                                                        obscureText: hidePass,
                                                        decoration:
                                                            InputDecoration(
                                                          suffix: Text('Senha',
                                                              style: TextStyle(
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                fontSize: 14.0,
                                                              )),
                                                          hintText: "Senha",
                                                          icon: Icon(Icons
                                                              .lock_outline),
                                                          border:
                                                              InputBorder.none,
                                                          counterText:
                                                              "", // remove os numero do contador do maxleng
                                                        ),
                                                        maxLength: 10,
                                                        validator: (value) {
                                                          if (value.isEmpty) {
                                                            return "A Senha não pode ficar em branco";
                                                          } else if (value
                                                                  .length <
                                                              6) {
                                                            return "A Senha tem que ter pelo menos 6 caracteres";
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                      trailing: IconButton(
                                                          icon: Icon(Icons
                                                              .remove_red_eye),
                                                          onPressed: () {
                                                            setState(() {
                                                              hidePass =
                                                                  !hidePass;
                                                            });
                                                          }),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.all(0),
                                              height: 60,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        20.0, 10.0, 20.0, 0.0),
                                                child: Material(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  elevation: 0.0,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 0.0),
                                                    child: ListTile(
                                                      title: TextFormField(
                                                        controller:
                                                            _confirm_passwordTextController,
                                                        obscureText: hidePass,
                                                        decoration:
                                                            InputDecoration(
                                                          suffix: Text(
                                                              'Confirma Senha',
                                                              style: TextStyle(
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                fontSize: 14.0,
                                                              )),
                                                          hintText:
                                                              "Confirma Senha",
                                                          icon: Icon(Icons
                                                              .phonelink_lock),
                                                          border:
                                                              InputBorder.none,
                                                          counterText:
                                                              "", // remove os numero do contador do maxleng
                                                        ),
                                                        maxLength: 10,
                                                        validator: (value) {
                                                          if (value.isEmpty) {
                                                            return "A Senha não pode ficar em branco";
                                                          } else if (value
                                                                  .length <
                                                              6) {
                                                            return "A Senha tem que ter pelo menos 6 caracteres";
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                      trailing: IconButton(
                                                          icon: Icon(Icons
                                                              .remove_red_eye),
                                                          onPressed: () {
                                                            setState(() {
                                                              hidePass =
                                                                  !hidePass;
                                                            });
                                                          }),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20.0, 20.0, 20.0, 20.0),
                                              child: Material(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                                color: Colors.teal,
                                                elevation: 0.0,
                                                child: MaterialButton(
                                                  onPressed: () async {
                                                    String result =
                                                        await validateForm();
                                                    print(result);
                                                    if (result == "sucesso") {
                                                      Toast.show(
                                                          "Cadastro Realizado Com Sucesso",
                                                          context,
                                                          duration:
                                                              Toast.LENGTH_LONG,
                                                          gravity: Toast.CENTER,
                                                          backgroundRadius:
                                                              0.0);
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      home2(
                                                                        id_sessao:
                                                                            widget.id_sessao,
                                                                      )));
                                                    } else {
                                                      Toast.show(
                                                          "Falha no Cadastro",
                                                          context,
                                                          duration:
                                                              Toast.LENGTH_LONG,
                                                          gravity: Toast.CENTER,
                                                          backgroundRadius:
                                                              0.0);
                                                    }
                                                  },
                                                  minWidth:
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                  child: Text(
                                                    "Registrar",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: loading ?? true,
                                  child: Center(
                                    child: Container(
                                      alignment: Alignment.center,
                                      color: Colors.white.withOpacity(0.9),
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.red),
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
                  onPressed: () {
                    setState(() {
                      _top = -60;
                    });
                    Future.delayed(Duration(milliseconds: 250), () {
                      // Navigator.pop(context);
                      Navigator.of(context).push(
                        new MaterialPageRoute(
                          // aqui temos passagem de valores id cliente(sessao) de login para home
                          builder: (context) => new home2(
                            id_sessao: widget.id_sessao,
                          ),
                        ),
                      );
                    });
                  },
                ),
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
                    onPressed: () async {
                      listaColaboradores.clear();
                      await Lista_colaboradores();
                      showModal<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return _AtivarColaborador();
                        },
                      );
                    }),
                radius: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> validateForm() async {
    FormState formState = _formKey.currentState;
    String teste1, msg1, msg2;
    if (formState.validate()) {
      String teste = await emailCadastrado();
      print('aqui');
      if (_passwordTextController.text == _confirm_passwordTextController.text)
        teste1 = 'livre';
      else
        teste1 = 'falha_senha';

      //print(teste);
      if (teste == "livre" && teste1 == "livre") {
        if (_selectedIdmarca == null) {
          return "falha_local";
        } else {
          // se email livre insere tabela colaboradores
          print('.,.,');
          String link = Basicos.codifica("${Basicos.ip}/crud/?crud=consult99."
              "${_nameTextController.text}," //    razao_social character varying(50) NOT NULL,
              "${_sobrenameTextController.text}," //    nome_fantasia character varying(50) NOT NULL,
              // "${_rgTextController.text},"
              "${_cpfTextController.text}," //    cnpj character varying(20) NOT NULL,
              "${_telefoneTextController.text}," //    celular character varying(30) NOT NULL,
              "${_emailTextController.text.toLowerCase()}," //    email character varying(254) NOT NULL,
              "${_cepTextController.text}," //    cep character varying(9) NOT NULL,
              "${Basicos.strip(_enderecoTextController.text)}," //    endereco character varying(40) NOT NULL,
              "${_numeroTextController.text}," //    numero character varying(10) NOT NULL,
              "${Basicos.strip(_complementoTextController.text)}," //    complemento character varying(30) NOT NULL,
              "${_bairroTextController.text}," //    bairro character varying(50) NOT NULL,
              "${_cidadeTextController.text}," //    cidade character varying(50) NOT NULL,
              "${_ufTextController.text}," //    uf character varying(2) NOT NULL,
              "${_selectedIdmarca.substring(0, _selectedIdmarca.indexOf('-'))}," // empreendimento
              "${widget.id_sessao}," //empresa_id_id integer NOT NULL,// -empresa_id integer,
              );
          print(link);
          var res1 = await http.get(Uri.encodeFull(link),
              headers: {"Accept": "application/json"});
          var res = Basicos.decodifica(res1.body);

          // ################################################################################
          // ## Precisa terminar a sequência de cadastro,                                  ##
          // ## inserindo os campos na tabela de Usuário, Auth_User e Empresa_Responsável  ##
          // ################################################################################
          if (res1.body.length > 2) {
            if (res1.statusCode == 200) {
              var list2 = json.decode(res).cast<Map<String, dynamic>>();
              //print(list2[0]['id']); // retorna o id inserido na tabelas de colaboradores

              // insere usuario #######################################################
              // usuario auth_user
              String link3 = Basicos.codifica(
                  "${Basicos.ip}/crud/?crud=consult41."
                  //  id integer NOT NULL DEFAULT nextval('auth_user_id_seq'::regclass),
                  "${_passwordTextController.text}," //    password character varying(128) NOT NULL,
                  //    last_login timestamp with time zone,
                  //    is_superuser boolean NOT NULL,
                  "${_emailTextController.text.toLowerCase()}," //    username character varying(150) NOT NULL,
                  "${_nameTextController.text}," //    first_name character varying(30) NOT NULL,
                  "${_sobrenameTextController.text}," //    last_name character varying(150) NOT NULL,
                  "${_emailTextController.text.toLowerCase()}," //    email character varying(254) NOT NULL,
                  //    is_staff boolean NOT NULL,
                  //    is_active boolean NOT NULL,
                  //    date_joined timestamp with time zone NOT NULL,
                  );
              var res6 = await http.get(Uri.encodeFull(link3),
                  headers: {"Accept": "application/json"});
              var res7 = Basicos.decodifica(res6.body);
              if (res6.body.length > 2) {
                if (res6.statusCode == 200) {
                  var list8 = json.decode(res7).cast<Map<String, dynamic>>();
                  // print(list8[0]['id']);

                  // usuario tabela usuario
                  String link4 = Basicos.codifica(
                      "${Basicos.ip}/crud/?crud=consult42."
                      // id integer NOT NULL DEFAULT nextval('usuarios_id_seq'::regclass),
                      "${_nameTextController.text}," //    nome character varying(30) NOT NULL,
                      "${_cpfTextController.text}," //    cpf character varying(15) NOT NULL,
                      "${_emailTextController.text.toLowerCase()}," //    email character varying(30) NOT NULL,
                      //    status character varying(10) NOT NULL, ('ATIVO','INATIVO','BLOQUEADO','EXCLUIDO'),
                      //    suporte_tecnico integer NOT NULL,
                      //    observacoes text NOT NULL,
                      //    model_template character varying(100),
                      //    data_registro timestamp with time zone NOT NULL,
                      //    data_alteracao timestamp with time zone NOT NULL,
                      "${list2[0]['id']}," //       colaborador_id integer,
                      "${widget.id_sessao}," //    empresa_id integer,
                      //    permissoes_id integer,
                      "${list8[0]['id']}," //    usuario_id integer,
                      );
                  var res8 = await http.get(Uri.encodeFull(link4),
                      headers: {"Accept": "application/json"});
                  var res9 = Basicos.decodifica(res8.body);
                }
              }
            }
          }
          return "sucesso";
        }
      } else {
        msg1 = "Usuário já Cadastrado  ";
        msg2 = "Tente a Recuperação de Senha ou Use Outro Nome e Email";
        // print(teste1);
        if (teste1 == 'falha_senha') {
          msg1 = 'Senhas Diferentes';
          msg2 = 'Verifique se as senhas digitadas são iguais';
        }

        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return new AlertDialog(
                title: new Text(
                  msg1,
                  textAlign: TextAlign.center,
                ),
                content: new Text(
                  msg2,
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

// verifica se email já cadastrado
  Future<String> emailCadastrado() async {
    FormState formState = _formKey.currentState;
    if (formState.validate()) {
      String link = Basicos.codifica(
          "${Basicos.ip}/crud/?crud=consul100.${_emailTextController.text.toLowerCase()}"); // Mudar consulta para verificar na tabela colaboradores
      print(
          '${Basicos.ip}/crud/?crud=consul100.${_emailTextController.text.toLowerCase()}');
      print(link);
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
    }
  }

  // carrega lista de empreendimentos
  Future<List> Lista_empreendimentos() async {
    //carrega todos os emprendimentos da tabela marca
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

  // carrega lista de colaboradores
  Future<String> Lista_colaboradores() async {
    //carrega todos os emprendimentos da tabela marca
    String link = Basicos.codifica(
        "${Basicos.ip}/crud/?crud=consul105.${widget.id_sessao.toString()}");
    var res1 = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    var res = res1;
    // print(res.body);
    if (res1.body.length > 2) {
      if (res1.statusCode == 200) {
        List list = json.decode(res.body).cast<Map<String, dynamic>>();
        for (var i = 0, len = list.length; i < len; i++) {
          listaColaboradores.add(Colaborador(
            id: list[i]['id'].toString(),
            nome: list[i]['nome'].toString(),
            sobrenome: list[i]['sobre_nome'].toString(),
            status: list[i]['status'].toString(),
          ));
        }

        //print(list);
        // print('${Basicos.ip}/crud/?crud=consul105.${widget.id_sessao.toString()}');
        return 'sucesso';
      }
    }
  }
}

class _AtivarColaborador extends StatefulWidget {
  @override
  __AtivarColaboradorState createState() => __AtivarColaboradorState();
}

class __AtivarColaboradorState extends State<_AtivarColaborador> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Ativar/Desativar Colaborador'),
      content: Scrollbar(
        child: ListView.builder(
          shrinkWrap: false,
          itemCount: listaColaboradores.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Switch(
                activeColor: Colors.teal,
                value:
                    listaColaboradores[index].status == 'ATIVO' ? true : false,
                onChanged: (value) {
                  Toast.show("Atualizando...", context,
                      duration: Toast.LENGTH_LONG,
                      gravity: Toast.CENTER,
                      backgroundRadius: 0.0);
                  setState(() {
                    listaColaboradores[index].status =
                        value ? 'ATIVO' : 'INATIVO';
                    //await Atualiza_status(listaColaboradores[index].id,listaColaboradores[index].status);
                    Atualiza_status(listaColaboradores[index].id,
                        listaColaboradores[index].status);
                  });
                },
              ),
              title: Text(listaColaboradores[index].nome +
                  " " +
                  listaColaboradores[index].sobrenome),
              subtitle: Text(
                listaColaboradores[index].status,
                style: TextStyle(
                  color: listaColaboradores[index].status == 'ATIVO'
                      ? Colors.teal
                      : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          },
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Fechar',
            style: TextStyle(
              color: Colors.teal,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Future Atualiza_status(String id, status) async {
    //atualiza status
    String link =
        Basicos.codifica("${Basicos.ip}/crud/?crud=consul106.${id},${status}");
    var res1 = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    var res = Basicos.decodifica(res1.body);
    //print(res.body);
    if (res1.body.length > 2) {
      if (res1.statusCode == 200) {
        List list = json.decode(res).cast<Map<String, dynamic>>();
        //print(list);
        // return 'sucesso';
      }
    }
  }
}

class Colaborador {
  final String id, nome, sobrenome, rg, cpf, telefone, celular, email;
  final DateTime nascimento, registro;
  final String cep,
      endereco,
      numero,
      complemento,
      bairro,
      cidade,
      observacoes,
      estado;
  String status;
  final int empresaID;

  Colaborador({
    this.id,
    this.nome,
    this.sobrenome,
    this.rg,
    this.cpf,
    this.telefone,
    this.celular,
    this.email,
    this.nascimento,
    this.registro,
    this.cep,
    this.endereco,
    this.numero,
    this.complemento,
    this.bairro,
    this.cidade,
    this.estado,
    this.status,
    this.observacoes,
    this.empresaID,
  });
}
