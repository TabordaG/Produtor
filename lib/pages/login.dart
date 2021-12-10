import 'package:produtor/pages/colaboradores/home_colaborador.dart';
import 'package:flutter/material.dart';
import 'package:produtor/pages/criar_conta/cadastro_abas.dart';
import 'package:produtor/pages/home.dart';
import 'package:produtor/pages/RecuperaSenha.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:produtor/pages/dados_basicos.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String versao = '1.0.2'; // versao do app
  final GlobalKey<FormState> _formkey = new GlobalKey<FormState>();
  bool _validate = false;
  TextEditingController _emailTextController = new TextEditingController();
  TextEditingController _passwordTextController = new TextEditingController();
  bool hidePass = true;
  bool liga_circular = false;
  List usuario = [];

  @override
  void initState() {
    super.initState;

    liga_circular = false;
    verifica_logado(); //verifica se houve login e esta armazenado na variavel de preferencias
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF004d4d),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  bottom: 20.0,
                  top: (MediaQuery.of(context).size.height / 2) - 250),
              child: Container(
                child: Text(
                  'Agricultor',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 60.0),
              child: Image.asset(
                'images/logo sem fundo.png',
                width: 400.0,
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
              child: Form(
                key: _formkey,
                autovalidate: _validate, //valida  a entrada do email
                child: Material(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.white.withOpacity(.8),
                  elevation: 0.0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: ListTile(
                      subtitle: TextFormField(
                          //autofocus: true,
                          controller: _emailTextController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Email",
                            icon: Icon(Icons.alternate_email),
                          ),
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
                          }),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
              child: Material(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.white.withOpacity(.8),
                  elevation: 0.0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: ListTile(
                      subtitle: TextFormField(
                        controller: _passwordTextController,
                        obscureText: hidePass,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Password",
                          icon: Icon(Icons.lock_outline),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "O campo password não pode ficar vazio";
                          } else if (value.length < 6) {
                            return "A senha tem que ter pelo menos 6 caracteres";
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
                  )),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
              child: Material(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.teal,
                  elevation: 0.0,
                  child: MaterialButton(
                    onPressed: () async {
                      if (_formkey.currentState.validate()) {
                        // valida formulario'
                        // acesso ao banco de dados
                        circular('inicio'); // mostra circular indicator
                        String valida =
                            await getData(_emailTextController.text);
                        circular('fim'); // apaga circular indicator
                        if (valida == null)
                          Toast.show(
                              "Login Inválido, ou erro de Conexão", context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.CENTER,
                              backgroundRadius: 0.0);
                        else {
                          if (valida == 'inativo') {
                            Toast.show(
                                "Seu usuário ainda não foi validado", context,
                                duration: Toast.LENGTH_LONG,
                                gravity: Toast.CENTER,
                                backgroundRadius: 0.0);
                          } else {
                            print('passou por aqui ------------');
                            print(usuario[0]['id'].toString());
                            await addStringToSF(_emailTextController
                                .text); // armazena email para lembrar do login
                            if (valida == 'colaborador') {
                              print(usuario[0]['empresa_id'].toString());
                              print(usuario[0]['id'].toString());
                              Navigator.of(context).push(new MaterialPageRoute(
                                // aqui temos passagem de valores id cliente(sessao) de login para home
                                builder: (context) => new homeColaborador(
                                    id_sessao:
                                        usuario[0]['empresa_id'].toString(),
                                    id_colaborador:
                                        usuario[0]['id'].toString()),
                              ));
                            } else {
                              Navigator.of(context).push(new MaterialPageRoute(
                                // aqui temos passagem de valores id cliente(sessao) de login para home
                                builder: (context) => new home2(
                                    id_sessao: usuario[0]['id'].toString()),
                              ));
                            }
                          }
                        }
                      } else {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => Dialog(
                                    child: new Container(
                                  color: Colors.black,
                                  child: new Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Versão Desatualizada, Acesse o Portal ou Atualize',
                                        style: new TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                )));
                      }
                    },
                    minWidth: MediaQuery.of(context).size.width,
                    child: Text(
                      "Entrar",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0),
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              RecuperaSenha())); //recupera senha
                },
                child: Text(
                  "< Recuperar Senha >",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
//===============verificar
            InkWell(
              onTap: () {
//                    Navigator.push(context,
//                        MaterialPageRoute(builder: (context) => Registrar()));
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Abas()));
              },
              child: Text(
                "< Criar Uma Conta > ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> getData(String newsType) async {
    String link = Basicos.codifica("${Basicos.ip}/crud/?crud=consult43."
        "${newsType},"
        "${_passwordTextController.text}");
//    print("${Basicos.ip}/crud/?crud=consult43."
//        "${newsType},"
//        "${_passwordTextController.text}");
    try {
      // consulta usuario e verifica senha valida
      var res1 = await http
          .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
      var res = Basicos.decodifica(res1.body);
      if (res1.body.length > 2) {
        if (res1.statusCode == 200) {
          String valida = res;
          //print(valida);
          if (valida == 'sucesso') {
            // aqui colaborador identificado e senha valida
            //consulta se é colaborador ou empressa
            String link1 =
                Basicos.codifica("${Basicos.ip}/crud/?crud=consul101."
                    "${newsType},");
            var res7 = await http.get(Uri.encodeFull(link1),
                headers: {"Accept": "application/json"});
            var res8 = Basicos.decodifica(res7.body);
            if (res7.body.length > 2) {
              if (res7.statusCode == 200) {
                String colaborador = res8;
                //print("xxx->"+colaborador);

                if (colaborador == 'sucesso1') {
// consulta empresa para pegar o codigo
                  String link = Basicos.codifica(
                      "${Basicos.ip}/crud/?crud=consul102.${newsType}");
                  var res1 = await http.get(Uri.encodeFull(link),
                      headers: {"Accept": "application/json"});
                  var res = Basicos.decodifica(res1.body);

                  if (res1.body.length > 2) {
                    if (res1.statusCode == 200) {
                      //gera criptografia senha terminar depois
                      List list = json.decode(res).cast<Map<String, dynamic>>();
                      //print(list);
                      if (list.isEmpty)
                        return 'inativo';
                      else {
                        usuario = list;
                        //print(usuario[0]['id'].toString());
                        Basicos.colaborador_id = usuario[0]['id'].toString();
                        // print(Basicos.empresa_id );
                        return 'colaborador';
                      }
                    }
                  }
                } else {
                  // consulta empresa para pegar o codigo
                  String link = Basicos.codifica(
                      "${Basicos.ip}/crud/?crud=consult44.${newsType}");
                  var res1 = await http.get(Uri.encodeFull(link),
                      headers: {"Accept": "application/json"});
                  var res = Basicos.decodifica(res1.body);

                  if (res1.body.length > 2) {
                    if (res1.statusCode == 200) {
                      //gera criptografia senha terminar depois
                      List list = json.decode(res).cast<Map<String, dynamic>>();
                      //print(list);
                      if (list.isEmpty)
                        return 'inativo';
                      else {
                        usuario = list;
                        //print(usuario[0]['id'].toString());
                        Basicos.empresa_id = usuario[0]['id'].toString();
                        // print(Basicos.empresa_id );
                        return 'sucesso';
                      }
                    }
                  }
                }
              }
            }
          } else
            return null;
        }
        // return list;
      }
    } on Exception catch (E) {
      showDialog(
          context: context,
          builder: (context) {
            return new AlertDialog(
              title: new Text("Erro"),
              content: new Text("Falha na Conexão"),
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
    }
  }

  addStringToSF(String s) async {
    SharedPreferences prefs2 = await SharedPreferences.getInstance();
    prefs2.setString('email', s);
  }

  getValuesSF() async {
    SharedPreferences prefs2 = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs2.getString('email') ?? '';
    //final myString = prefs.getString('my_string_key') ?? '';
    return stringValue;
  }

  removeValues() async {
    SharedPreferences prefs2 = await SharedPreferences.getInstance();
    prefs2.remove('email');
  }

  void verifica_logado() async {
    final email = await getValuesSF();

    // if (email != '') {
    //   //print(email);

    //   String link =
    //       Basicos.codifica("${Basicos.ip}/crud/?crud=consul102.$email");

    //   var res1 = await http
    //       .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    //   var res = Basicos.decodifica(res1.body);
    //   if (res1.body.length > 2) {
    //     if (res1.statusCode == 200) {
    //       //gera criptografia senha terminar depois
    //       List list = json.decode(res).cast<Map<String, dynamic>>();
    //       usuario = list;
    //       Basicos.colaborador_id = usuario[0]['id'].toString();
    //       Basicos.empresa_id = usuario[0]['empresa_id'].toString();
    //     }
    //   }
    //   //  print(usuario[0]['observacoes']);
    //   if (usuario[0]['observacoes'] != 'EMPRESA') {
    //     print(usuario[0]['empresa_id'].toString());
    //     print(usuario[0]['id'].toString());
    //     Navigator.of(context).push(new MaterialPageRoute(
    //       // aqui temos passagem de valores id cliente(sessao) de login para home
    //       builder: (context) =>
    //           // homeColaborador(id_sessao: usuario[0]['id'].toString()),
    //           homeColaborador(
    //               id_sessao: usuario[0]['empresa_id'].toString(),
    //               id_colaborador: usuario[0]['id'].toString()),
    //     ));
    //   } else {
    //     String link =
    //         Basicos.codifica("${Basicos.ip}/crud/?crud=consult44.$email");
    //     var res1 = await http
    //         .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    //     var res = Basicos.decodifica(res1.body);
    //     if (res1.body.length > 2) {
    //       if (res1.statusCode == 200) {
    //         //gera criptografia senha terminar depois
    //         List list = json.decode(res).cast<Map<String, dynamic>>();
    //         usuario = list;
    //         Basicos.empresa_id = usuario[0]['empresa_id'].toString();
    //         //print(Basicos.empresa_id );
    //       }
    //     }
    //     Navigator.of(context).push(new MaterialPageRoute(
    //       // aqui temos passagem de valores id cliente(sessao) de login para home
    //       builder: (context) =>
    //           // homeColaborador(id_sessao: usuario[0]['id'].toString()),
    //           home2(id_sessao: usuario[0]['id'].toString()),
    //     ));
    //   }
    // }
  }

// mostra circular indicator
  void circular(String tipo) {
    if (tipo == 'inicio') {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => Dialog(
                  child: new Container(
                color: Colors.black,
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Text(
                      'carregando',
                      style: new TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    new CircularProgressIndicator(),
                    // new Text("Carrengando ..."),
                  ],
                ),
              )));
    } else
      Navigator.pop(context);
  }
}
