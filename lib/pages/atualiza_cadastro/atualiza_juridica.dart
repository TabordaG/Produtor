import 'package:flutter/material.dart';
import 'package:produtor/pages/dados_basicos.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:produtor/pages/home.dart';
import 'package:produtor/pages/login.dart';
import 'package:toast/toast.dart';

class Dados_Cadastrais_jurica extends StatefulWidget {
  final id_sessao;

  @override
  _Dados_Cadastrais_juricaState createState() =>
      _Dados_Cadastrais_juricaState();

  Dados_Cadastrais_jurica({
    this.id_sessao,
  });
}

class _Dados_Cadastrais_juricaState extends State<Dados_Cadastrais_jurica> {
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

  String gender;
  bool hidePass = true;
  bool loading = false;
  String _selectedId;
  List empresa_list = [];

  @override
  void initState() {
    Local_retirada().then((resultado) {
      setState(() {});
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.1,
          backgroundColor: Colors.teal,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Basicos.pagina = 1;
              Navigator.of(context).push(
                new MaterialPageRoute(
                    // aqui temos passagem de valores id cliente(sessao) de login para home
                    builder: (context) => home2(id_sessao: widget.id_sessao)),
              );
            }, //RETORNA TELA ANTERIOR
          ),
          title: InkWell(
            onTap: () {
              Basicos.pagina = 1;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new home2(
                            id_sessao: widget.id_sessao,
                          )));
            },
            child: Text('Atualiza Pessoa Jurídica'),
          ),
          actions: <Widget>[
//            new IconButton(
//              icon: Icon(
//                Icons.refresh,
//                color: Colors.white,
//              ),
//              onPressed: () {},
//            )
          ]),
      body: ListView(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 10.0, top: 0, bottom: 5),
              child: Center(
                child: Container(
                  height: 950,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.teal,
                        blurRadius:
                            20.0, // has the effect of softening the shadow
                      )
                    ],
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
                                        suffix: Text('Nome',
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontSize: 14.0,
                                            )),
                                        hintText: "Nome",
                                        counterText:
                                            "", // remove os numero do contador do maxleng
                                        icon: Icon(Icons.person_outline),
                                        border: InputBorder.none,
                                      ),
                                      maxLength: 50,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "O Nome não pode ficar em branco";
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
                                        suffix: Text('Sobrenome',
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontSize: 14.0,
                                            )),
                                        hintText: "Sobrenome",
                                        counterText:
                                            "", // remove os numero do contador do maxleng
                                        icon: Icon(Icons.person_outline),
                                        border: InputBorder.none,
                                      ),
                                      maxLength: 50,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "O Sobrenome não pode ficar em branco";
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
                                        suffix: Text('CPF',
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontSize: 14.0,
                                            )),
                                        hintText: "CPF",
                                        counterText:
                                            "", // remove os numero do contador do maxleng
                                        icon: Icon(Icons.content_paste),
                                        border: InputBorder.none,
                                      ),
                                      maxLength: 11,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Insira um CPF válido';
                                        } else {
                                          if (value.length < 11) {
                                            return "CPF Tem Que Ter Pelo Menos 11 Dígitos";
                                          } else {
                                            Pattern pattern =
                                                '([0-9]{2}[\.]?[0-9]{3}[\.]?[0-9]{3}[\/]?[0-9]{4}[-]?[0-9]{2})|([0-9]{3}[\.]?[0-9]{3}[\.]?[0-9]{3}[-]?[0-9]{2})';
                                            RegExp regex = new RegExp(pattern);
                                            if (!regex.hasMatch(value)) {
                                              return 'Insira um CPF válido';
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
                                        counterText:
                                            "", // remove os numero do contador do maxleng
                                        icon: Icon(Icons.settings_cell),
                                        border: InputBorder.none,
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
                                        counterText:
                                            "", // remove os numero do contador do maxleng
                                        icon: Icon(Icons.apps),
                                        border: InputBorder.none,
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
                                      decoration: InputDecoration(
                                        suffix: Text('Número',
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontSize: 14.0,
                                            )),
                                        hintText: "Número",
                                        counterText:
                                            "", // remove os numero do contador do maxleng
                                        icon: Icon(Icons.apps),
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
                                        counterText:
                                            "", // remove os numero do contador do maxleng
                                        icon: Icon(Icons.apps),
                                        border: InputBorder.none,
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
                                        counterText:
                                            "", // remove os numero do contador do maxleng
                                        icon: Icon(Icons.apps),
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
                                        counterText:
                                            "", // remove os numero do contador do maxleng
                                        icon: Icon(Icons.apps),
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
                                        hintText: "UF",
                                        counterText:
                                            "", // remove os numero do contador do maxleng
                                        icon: Icon(Icons.apps),
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
                                        hintText: "CEP",
                                        counterText:
                                            "", // remove os numero do contador do maxleng
                                        icon: Icon(Icons.apps),
                                        border: InputBorder.none,
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
                                          counterText:
                                              "", // remove os numero do contador do maxleng
                                          icon: Icon(Icons.alternate_email),
                                          border: InputBorder.none),
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
//                          Container(
//                            padding: const EdgeInsets.all(0),
//                            height: 60,
//                            child: Padding(
//                              padding: const EdgeInsets.fromLTRB(
//                                  20.0, 10.0, 20.0, 0.0),
//                              child: Material(
//                                borderRadius: BorderRadius.circular(20.0),
//                                color: Colors.grey.withOpacity(0.2),
//                                elevation: 0.0,
//                                child: Padding(
//                                  padding: const EdgeInsets.only(left: 0.0),
//                                  child: ListTile(
//                                    title: TextFormField(
//                                      controller: _passwordTextController,
//                                      obscureText: hidePass,
//                                      decoration: InputDecoration(
//                                          suffix: Text('Senha',
//                                              style: TextStyle(
//                                                fontStyle: FontStyle.italic,
//                                                fontSize: 14.0,
//                                              )),
//                                          hintText: "Senha",
//                                          icon: Icon(Icons.lock_outline),
//                                          border: InputBorder.none),
//                                      validator: (value) {
//                                        if (value.isEmpty) {
//                                          return "A Senha não pode ficar em branco";
//                                        } else if (value.length < 6) {
//                                          return "A Senha tem que ter pelo menos 6 caracteres";
//                                        }
//                                        return null;
//                                      },
//                                    ),
//                                    trailing: IconButton(
//                                        icon: Icon(Icons.remove_red_eye),
//                                        onPressed: () {
//                                          setState(() {
//                                            hidePass = false;
//                                          });
//                                        }),
//                                  ),
//                                ),
//                              ),
//                            ),
//                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                20.0, 10.0, 20.0, 0.0),
                            child: Material(
                                borderRadius: BorderRadius.circular(20.0),
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
                                              builder: (context) => Login()));
                                    } else {
                                      if (result == "falha_local") {
                                        Toast.show(
                                            "Escolha um local para Retirada dos produtos",
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
                                    "Atualizar",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0),
                                  ),
                                )),
                          ),
//                          Padding(
//                              padding: const EdgeInsets.only(
//                                  left: 0.0,
//                                  top: 20.0,
//                                  right: 0.0,
//                                  bottom: 0.0),
//                              child: InkWell(
//                                  onTap: () {
//                                    Navigator.pop(context);
//                                  },
//                                  child: Text(
//                                    "Tenho uma conta",
//                                    textAlign: TextAlign.center,
//                                    style: TextStyle(
//                                        color: Colors.teal, fontSize: 14),
//                                  ))),
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
    );
  }

// insere produtor pessoa fisica
  Future<String> validateForm() async {
    FormState formState = _formKey.currentState;
    if (formState.validate()) {
      //print(teste);
      if (_selectedId == null) {
        return "falha_local";
      } else {
        // se email livre insere tabela empresa ######################################
        String link = Basicos.codifica("${Basicos.ip}/crud/?crud=consult71."
            "${widget.id_sessao.toString()},"
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
            //    contrato character varying(30) NOT NULL, (1- PESSOA_FISICA, 2- PESSOA_JURIDICA, 3 - COOPERATIVA
            );
        //print(link);
        var res1 = await http
            .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
        var res = Basicos.decodifica(res1.body);
        //  print(res.body);
        if (res1.body.length > 2) {
          if (res1.statusCode == 200) {
            var list = json.decode(res).cast<Map<String, dynamic>>();
            //print(list[0]['id']); // retorna o id inserido na tabelas de empresas
            //print('s');
          }
        }
      }
    } else {
      Toast.show("Campos com Erros", context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER,
          backgroundRadius: 0.0);
    }
  }

//// verifica se email já cadastrado
//  Future<String> emailCadastrado() async {
//    FormState formState = _formKey.currentState;
//    if (formState.validate()) {
//      // verifica se email ja cadastrado
//      String link = Basicos.codifica(
//          "${Basicos.ip}/crud/?crud=consult36.${_emailTextController.text.toLowerCase()}");
//      var res1 = await http
//          .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
//      var res = Basicos.decodifica(res1.body);
//      if (res1.body.length > 2) {
//        if (res1.statusCode == 200) {
//          List list = json.decode(res).cast<Map<String, dynamic>>();
//          if (list.isEmpty)
//            return 'livre';
//          else
//            return 'existe';
//        }
//      } else
//        return 'falha';
//      // verifica se email ja cadastrado
//    }
//  }
//
//  // verifica se razao_social  e nome_fantasia já cadastrados
//  Future<String> razao_nome_Cadastrado() async {
//    FormState formState = _formKey.currentState;
//    if (formState.validate()) {
//      // verifica se email ja cadastrado
//      String link = Basicos.codifica(
//          "${Basicos.ip}/crud/?crud=consult37.${_nameTextController.text}");
//      //print(link);
//      var res1 = await http
//          .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
//      var res = Basicos.decodifica(res1.body);
//      // print(res.body);
//      if (res1.body.length > 2) {
//        if (res1.statusCode == 200) {
//          List list = json.decode(res).cast<Map<String, dynamic>>();
//          print(list);
//          if (list.isEmpty)
//            return 'livre';
//          else
//            return 'existe';
//        }
//      } else
//        return 'falha';
//      // verifica se email ja cadastrado
//    }
//  }

//  // carrega lista de locais de retirada
  Future<List> Local_retirada() async {
    //carrega todos os locais
    String link = Basicos.codifica("${Basicos.ip}/crud/?crud=consult38.");
    var res11 = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    var res2 = Basicos.decodifica(res11.body);
    // print(res.body);
    if (res11.body.length > 2) {
      if (res11.statusCode == 200) {
        List list1 = json.decode(res2).cast<Map<String, dynamic>>();
        //print(list);
        for (var i = 0, len = list1.length; i < len; i++) {
          lista_locais.add(
              list1[i]['id'].toString() + '-' + list1[i]['nome'].toString());
        }

        // verifica local cadastrado
        String link = Basicos.codifica(
            "${Basicos.ip}/crud/?crud=consult70.${widget.id_sessao}");
        var res1 = await http
            .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
        var res = Basicos.decodifica(res1.body);
        if (res1.body.length > 2) {
          if (res1.statusCode == 200) {
            List list = json.decode(res).cast<Map<String, dynamic>>();
            //print(list[0]['nome']);
            for (var i = 0, len = lista_locais.length; i < len; i++) {
              if (lista_locais[i].substring(0, lista_locais[i].indexOf('-')) ==
                  list[0]['id'].toString()) {
                _selectedId = lista_locais[i];
              }
            }

            await Dados_empresa();
            return list;
          }
        }
      }
    }
  }

//   carrega dados da empresa
  Future<List> Dados_empresa() async {
    // verifica se email ja cadastrado
    String link = Basicos.codifica(
        "${Basicos.ip}/crud/?crud=consult69.${widget.id_sessao}");
    //print(link);
    var res1 = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    var res = Basicos.decodifica(res1.body);
    if (res1.body.length > 2) {
      if (res1.statusCode == 200) {
        List list = json.decode(res).cast<Map<String, dynamic>>();
        //print(list);
        empresa_list = list;
//        for (var i = 0, len = list.length; i < len; i++) {
////          lista_locais
//              empresa_list.add(list[i].toString());
//        }

        _nameTextController.text = empresa_list[0]['razao_social'];
        _sobrenameTextController.text = empresa_list[0]['nome_fantasia'];
        _cpfTextController.text = empresa_list[0]['cnpj'];
        _telefoneTextController.text = empresa_list[0]['celular'];
        _enderecoTextController.text = empresa_list[0]['endereco'];
        _numeroTextController.text = empresa_list[0]['numero'];
        _complementoTextController.text = empresa_list[0]['complemento'];
        _bairroTextController.text = empresa_list[0]['bairro'];
        _cidadeTextController.text = empresa_list[0]['cidade'];
        _ufTextController.text = empresa_list[0]['uf'];
        _cepTextController.text = empresa_list[0]['cep'];
        _emailTextController.text = empresa_list[0]['email'];

        return list;
      }
      // verifica se email ja cadastrado
    }
  }
}
