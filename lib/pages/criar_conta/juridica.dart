import 'package:flutter/material.dart';
import 'package:produtor/pages/dados_basicos.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

//import 'package:ecomerce/pages/home.dart';
import 'package:produtor/pages/login.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class Registrar_juridica extends StatefulWidget {
  @override
  _Registrar_juridicaState createState() => _Registrar_juridicaState();
}

class _Registrar_juridicaState extends State<Registrar_juridica> {
  final _formKey = GlobalKey<FormState>();
  List<String> lista_locais = [];

  //UserServices _userServices = UserServices();
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _sobrenameTextController = TextEditingController();
  TextEditingController _cpfTextController = TextEditingController();
  TextEditingController _telefoneTextController = TextEditingController();
  TextEditingController _enderecoTextController = TextEditingController();
  TextEditingController _numeroTextController = TextEditingController();
  TextEditingController _complementoTextController = TextEditingController();
  TextEditingController _bairroTextController = TextEditingController();
  TextEditingController _cidadeTextController = TextEditingController();
  TextEditingController _ufTextController = TextEditingController();
  TextEditingController _cepTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _confirm_passwordTextController =
      TextEditingController();
  String gender;
  bool hidePass = true;
  bool loading = false;
  String _selectedId;
  bool termo = false; // check box termo de uso

  @override
  void initState() {
    Local_retirada().then((resultado) {
      setState(() {});
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        child: ListView(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(
                    left: 5, right: 5.0, top: 10, bottom: 5),
                child: Center(
                  child: Container(
                    height: 1110,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
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
                                        ),
                                        maxLength: 50,
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
                                        controller: _sobrenameTextController,
                                        decoration: InputDecoration(
                                          suffix: Text('Nome Fantasia',
                                              style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontSize: 14.0,
                                              )),
                                          hintText: "Nome Fantasia",
                                          icon: Icon(Icons.border_color),
                                          border: InputBorder.none,
                                          counterText: "",
                                        ),
                                        maxLength: 50,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "O Nome Fantasia não pode ficar em branco";
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
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          suffix: Text('CNPJ',
                                              style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontSize: 14.0,
                                              )),
                                          hintText: "CNPJ",
                                          icon: Icon(Icons.content_paste),
                                          border: InputBorder.none,
                                          counterText:
                                              "", // remove os numero do contador do maxleng
                                        ),
                                        maxLength: 14,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Insira um CNPJ válido';
                                          } else {
                                            if (value.length < 14) {
                                              return "CNPJ somente números com 14 Dígitos";
                                            } else {
                                              Pattern pattern =
                                                  '([0-9]{2}[\.]?[0-9]{3}[\.]?[0-9]{3}[\/]?[0-9]{4}[-]?[0-9]{2})|([0-9]{3}[\.]?[0-9]{3}[\.]?[0-9]{3}[-]?[0-9]{2})';
                                              RegExp regex =
                                                  new RegExp(pattern);
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
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          suffix: Text('Telefone',
                                              style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontSize: 11.0,
                                              )),
                                          hintText: "Telefone",
                                          icon: Icon(Icons.settings_cell),
                                          border: InputBorder.none,
                                          counterText:
                                              "", // remove os numero do contador do maxleng
                                        ),
                                        maxLength: 11,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Insira um telefone';
                                          } else {
                                            if (value.length < 10) {
                                              return "Telefone com 10 ou 11 numeros (ex.65XXXXXNNNN)";
                                            } else {
                                              Pattern pattern = '([0-9]{10})';
                                              RegExp regex =
                                                  new RegExp(pattern);
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
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          suffix: Text('Endereco',
                                              style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontSize: 14.0,
                                              )),
                                          hintText: "Endereco",
                                          icon: Icon(Icons.apps),
                                          border: InputBorder.none,
                                          counterText:
                                              "", // remove os numero do contador do maxleng
                                        ),
                                        maxLength: 40,
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
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          suffix: Text('Número',
                                              style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontSize: 14.0,
                                              )),
                                          hintText: "Número",
                                          icon: Icon(Icons.confirmation_number),
                                          border: InputBorder.none,
                                          counterText:
                                              "", // remove os numero do contador do maxleng
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
                                        controller: _complementoTextController,
                                        decoration: InputDecoration(
                                          suffix: Text('Complemento',
                                              style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontSize: 14.0,
                                              )),
                                          hintText: "Complemento",
                                          icon: Icon(Icons.check),
                                          border: InputBorder.none,
                                          counterText:
                                              "", // remove os numero do contador do maxleng
                                        ),
                                        maxLength: 30,
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
                                        controller: _bairroTextController,
                                        decoration: InputDecoration(
                                          suffix: Text('Bairro',
                                              style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontSize: 14.0,
                                              )),
                                          hintText: "Bairro",
                                          icon: Icon(Icons.save_alt),
                                          border: InputBorder.none,
                                          counterText:
                                              "", // remove os numero do contador do maxleng
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
                                          icon: Icon(Icons.location_city),
                                          border: InputBorder.none,
                                          counterText:
                                              "", // remove os numero do contador do maxleng
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
                                          hintText: "UF",
                                          icon: Icon(Icons.ac_unit),
                                          border: InputBorder.none,
                                          counterText:
                                              "", // remove os numero do contador do maxleng
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
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          suffix: Text('CEP',
                                              style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontSize: 14.0,
                                              )),
                                          hintText: "CEP",
                                          icon: Icon(Icons.crop),
                                          border: InputBorder.none,
                                          counterText:
                                              "", // remove os numero do contador do maxleng
                                        ),
                                        maxLength: 9,
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
                                  child: ListTile(
                                    leading: Icon(Icons.local_shipping),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0.0, 0.0, 10.0, 0.0),
                                      child: new DropdownButton<String>(
                                        isExpanded: true,
                                        hint: const Text(
                                          "Local de Retirada de Produtos",
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black54,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        value: _selectedId,
                                        onChanged: (String value) {
                                          setState(() {
                                            _selectedId = value;
                                          });
                                        },
                                        items: lista_locais.map((String value) {
                                          return new DropdownMenuItem<String>(
                                              value: value,
                                              child: new Text(
                                                value.substring(
                                                    value.indexOf('-', 0) + 1,
                                                    value.length),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black54,
                                                  fontSize: 15.0,
                                                ),
                                              ));
                                        }).toList(),
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
                                          icon: Icon(Icons.alternate_email),
                                          border: InputBorder.none,
                                          counterText:
                                              "", // remove os numero do contador do maxleng
                                        ),
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
                                              RegExp regex =
                                                  new RegExp(pattern);
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
                            Row(
                              children: <Widget>[
                                Container(
                                  width: 100,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        25.0, 15.0, 0.0, 0.0),
                                    child: Text('Senha:',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
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
                                        controller: _passwordTextController,
                                        obscureText: hidePass,
                                        decoration: InputDecoration(
                                          suffix: Text('Senha',
                                              style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontSize: 14.0,
                                              )),
                                          hintText: "Senha",
                                          icon: Icon(Icons.lock_outline),
                                          border: InputBorder.none,
                                          counterText:
                                              "", // remove os numero do contador do maxleng
                                        ),
                                        maxLength: 10,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "A Senha não pode ficar em branco";
                                          } else if (value.length < 6) {
                                            return "A Senha tem que ter pelo menos 6 caracteres";
                                          }
                                          return null;
                                        },
                                      ),
                                      trailing: IconButton(
                                          icon: Icon(Icons.remove_red_eye),
                                          onPressed: () {
                                            setState(() {
                                              hidePass = !hidePass;
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
                                        controller:
                                            _confirm_passwordTextController,
                                        obscureText: hidePass,
                                        decoration: InputDecoration(
                                          suffix: Text('Confirma Senha',
                                              style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontSize: 14.0,
                                              )),
                                          hintText: "Confirma Senha",
                                          icon: Icon(Icons.phonelink_lock),
                                          border: InputBorder.none,
                                          counterText:
                                              "", // remove os numero do contador do maxleng
                                        ),
                                        maxLength: 10,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "A Senha não pode ficar em branco";
                                          } else if (value.length < 6) {
                                            return "A Senha tem que ter pelo menos 6 caracteres";
                                          }
                                          return null;
                                        },
                                      ),
                                      trailing: IconButton(
                                          icon: Icon(Icons.remove_red_eye),
                                          onPressed: () {
                                            setState(() {
                                              hidePass = !hidePass;
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
                                padding: const EdgeInsets.fromLTRB(
                                    20.0, 10.0, 20.0, 0.0),
                                child: new Material(
                                  borderRadius: BorderRadius.circular(20.0),
                                  //color: Colors.grey.withOpacity(0.2),
                                  color: Colors.white,
                                  child: Row(
                                    children: <Widget>[
                                      // Expanded(
                                      MaterialButton(
                                          onPressed: () async {
                                            //http://recoopsol.ic.ufmt.br/index.php/termo-de-uso/
                                            //Link da pagina de Termo
                                            const url =
                                                "http://recoopsol.ic.ufmt.br/index.php/termo-de-uso";
                                            if (await canLaunch(url)) {
                                              await launch(url);
                                            } else {
                                              throw 'erro $url';
                                            }
                                          },

                                          //  child: ListTile(
                                          child: Container(
                                            //color: Colors.blueAccent,
                                            width: 190,
                                            child: Text("Lí o Termo de Uso",
                                                style: TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    color: Colors.blueAccent,
                                                    fontSize: 18)),
                                          )
                                          // ),
                                          ),
                                      //),
                                      Expanded(
                                        // child: ListTile(
//                                        title: Text("Fem:",
//                                            textAlign: TextAlign.end,
//                                            style: TextStyle(
//                                                color: Colors.blueAccent,
//                                                fontSize: 15)),
                                        child: Checkbox(
                                          value: termo,
                                          onChanged: _onTermoChanged,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 10.0, 20.0, 0.0),
                              child: Material(
                                  borderRadius: BorderRadius.circular(12.0),
                                  color: Colors.teal,
                                  elevation: 0.0,
                                  child: MaterialButton(
                                    onPressed: () async {
                                      Toast.show("Cadastrando...", context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.CENTER,
                                          backgroundRadius: 0.0);
                                      String result = await validateForm();
                                      if (result == "sucesso") {
                                        // mostra dialog
                                        // print('xxx');
                                        showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext context) {
                                            // return object of type Dialog
                                            return AlertDialog(
                                              title: new Text(
                                                "Cadastro Realizado com Sucesso",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              content: new Text(
                                                "Você receberá um email com a validação do seu cadastro pela equipe do Recoopsol",
                                                textAlign: TextAlign.center,
                                              ),
                                              actions: <Widget>[
                                                // usually buttons at the bottom of the dialog

                                                new FlatButton(
                                                  child: new Text("Fechar"),
                                                  onPressed: () {
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    Login()));
                                                    // Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      } else {
                                        if (result == "falha_local") {
                                          Toast.show(
                                              "Escolha um local para distribuição dos produtos",
                                              context,
                                              duration: Toast.LENGTH_LONG,
                                              gravity: Toast.CENTER,
                                              backgroundRadius: 0.0);
                                        } else {
                                          if (result == "erro_email") {}
                                        }
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
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 0.0,
                                    top: 20.0,
                                    right: 0.0,
                                    bottom: 0.0),
                                child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Tenho uma conta",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.teal, fontSize: 14),
                                    ))),
                          ],
                        )),
                  ),
                )),
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
    );
  }

  void _onTermoChanged(bool newValue) => setState(() {
        termo = newValue;
      });

// insere produtor pessoa fisica
  Future<String> validateForm() async {
    String teste1, msg1, msg2;
    if (termo == true) {
      FormState formState = _formKey.currentState;
      if (formState.validate()) {
        String teste = await emailCadastrado();
        if (_passwordTextController.text ==
            _confirm_passwordTextController.text)
          teste1 = 'livre';
        else
          teste1 = 'falha_senha';
        //print(teste);
        if (teste == "livre" && teste1 == "livre") {
          if (_selectedId == null) {
            return "falha_local";
          } else {
            // se email livre insere tabela empresa ######################################
            String link = Basicos.codifica("${Basicos.ip}/crud/?crud=consult35."
                "${_nameTextController.text}," //    razao_social character varying(50) NOT NULL,
                "${_sobrenameTextController.text}," //    nome_fantasia character varying(50) NOT NULL,
                "${_cpfTextController.text}," //    cnpj character varying(20) NOT NULL,
                "${_telefoneTextController.text}," //    celular character varying(30) NOT NULL,
                "${_enderecoTextController.text}," //    endereco character varying(40) NOT NULL,
                "${_numeroTextController.text}," //    numero character varying(10) NOT NULL,
                "${_complementoTextController.text}," //    complemento character varying(30) NOT NULL,
                "${_bairroTextController.text}," //    bairro character varying(50) NOT NULL,
                "${_cidadeTextController.text}," //    cidade character varying(50) NOT NULL,
                "${_ufTextController.text}," //    uf character varying(2) NOT NULL,
                "${_cepTextController.text}," //    cep character varying(9) NOT NULL,
                //    status character varying(20) NOT NULL, ('ATIVO', 'INATIVO', 'SUSPENSO', 'EXCLUIDO','NEGATIVADO')
                //    plano_id integer NOT NULL,
                "${_emailTextController.text.toLowerCase()}," //    email character varying(254) NOT NULL,
                //"${_passwordTextController.text}," // senha
                //    data_inicio date,
                //    data_registro timestamp with time zone NOT NULL,
                //    data_alteracao timestamp with time zone NOT NULL,
                "PESSOA_JURIDICA" //    contrato character varying(30) NOT NULL, (1- PESSOA_FISICA, 2- PESSOA_JURIDICA, 3 - COOPERATIVA
                );
            //print(link);
            var res1 = await http.get(Uri.encodeFull(link),
                headers: {"Accept": "application/json"});
            var res = Basicos.decodifica(res1.body);
            //  print(res.body);
            if (res1.body.length > 2) {
              if (res1.statusCode == 200) {
                var list = json.decode(res).cast<Map<String, dynamic>>();
                // print(list[0]['id']); // retorna o id inserido na tabelas de empresas
                //print('s');

                //Inserir local_empresa ###############################################
                // se email livre
                String link2 = Basicos.codifica(
                    "${Basicos.ip}/crud/?crud=consult39."
                    "Cadastro_Local_APP," //    obs text NOT NULL,
                    //    data_registro timestamp with time zone NOT NULL,
                    //    data_alteracao timestamp with time zone NOT NULL,
                    "${list[0]['id']}," //    empresa_id_id integer NOT NULL,
                    "${_selectedId.substring(0, _selectedId.indexOf('-'))}," //    local_id_id integer NOT NULL,
                    );
                var res2 = await http.get(Uri.encodeFull(link2),
                    headers: {"Accept": "application/json"});
                var res3 = Basicos.decodifica(res2.body);

                // insere colaborador  ###############################################
                String link = Basicos.codifica(
                    "${Basicos.ip}/crud/?crud=consult40."
                    // id integer - autoincremento
                    "${_nameTextController.text}," // -   nome character varying(30) NOT NULL,
                    "${_sobrenameTextController.text}," //  -  sobre_nome character varying(50) NOT NULL,
                    //rg character varying(15) NOT NULL,
                    "${_cpfTextController.text}," // -   cpf character varying(15) NOT NULL,
                    //telefone character varying(30) NOT NULL,
                    "${_telefoneTextController.text}," // -   celular character varying(30) NOT NULL,
                    "${_emailTextController.text.toLowerCase()}," //  -     email character varying(30) NOT NULL,
                    //data_nascimento date NOT NULL,
                    //estado_civil character varying(15) NOT NULL,
                    //sexo character varying(10) NOT NULL,
                    "${_cepTextController.text}," // -   cep character varying(10) NOT NULL,
                    "${_enderecoTextController.text}," // -      endereco character varying(50) NOT NULL
                    "${_numeroTextController.text}," // -   numero character varying(10) NOT NULL,
                    "${_complementoTextController.text}," // - complemento character varying(30) NOT NULL,
                    "${_bairroTextController.text}," //  -   bairro character varying(50) NOT NULL,
                    "${_cidadeTextController.text}," //  -      cidade character varying(50) NOT NULL,
                    "${_ufTextController.text}," // -       estado character varying(2) NOT NULL,
                    // - status character varying(10) NOT NULL, ('ATIVO', 'INATIVO', 'AFASTADO', 'DEMITIDO','APOSENTADO',' EXCLUIDO')
                    //observacoes text NOT NULL,
                    // -data_registro timestamp with time zone NOT NULL,
                    // -data_alteracao timestamp with time zone NOT NULL,
                    "${list[0]['id']}" //    empresa_id_id integer NOT NULL,// -empresa_id integer,
                    );
                //print(link);
                var res4 = await http.get(Uri.encodeFull(link),
                    headers: {"Accept": "application/json"});
                var res5 = Basicos.decodifica(res4.body);
                //  print(res.body);
                if (res4.body.length > 2) {
                  if (res4.statusCode == 200) {
                    var list2 = json.decode(res5).cast<Map<String, dynamic>>();
                    // print(list2[0]['id']); // retorna o id inserido na tabelas de colaboradores

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
                        var list8 =
                            json.decode(res7).cast<Map<String, dynamic>>();
                        //print(list8[0]['id']);

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
                            "${list[0]['id']}," //    empresa_id integer,
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
            }
          }
        } else {
          msg1 = "Usuário já Cadastrado  ";
          msg2 = "Tente a Recuperação de Senha ou Use Outro Nome e Email";
          print(teste1);
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
    } else {
      Toast.show(
          "Leia o Termo de Uso e Marque a Leiura dos Termos de Uso do Aplicativo",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER,
          backgroundRadius: 0.0);
    }
  }

// verifica se email já cadastrado
  Future<String> emailCadastrado() async {
    FormState formState = _formKey.currentState;
    if (formState.validate()) {
      // verifica se email ja cadastrado
      String link = Basicos.codifica(
          "${Basicos.ip}/crud/?crud=consult36.${_emailTextController.text.toLowerCase()}");
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

//  // carrega lista de locais de retirada
  Future<List> Local_retirada() async {
    // verifica se email ja cadastrado
    String link = Basicos.codifica("${Basicos.ip}/crud/?crud=consult38.");
    //print(link);
    var res1 = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    var res = Basicos.decodifica(res1.body);
    // print(res.body);
    if (res1.body.length > 2) {
      if (res1.statusCode == 200) {
        List list = json.decode(res).cast<Map<String, dynamic>>();
        //print(list);
        for (var i = 0, len = list.length; i < len; i++) {
          lista_locais
              .add(list[i]['id'].toString() + '-' + list[i]['nome'].toString());
        }
        //print(_selectedId);
        return list;
      }
      // verifica se email ja cadastrado
    }
  }
}
