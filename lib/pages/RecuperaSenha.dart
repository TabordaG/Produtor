import 'package:flutter/material.dart';
import 'package:produtor/pages/login.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dados_basicos.dart';
//import 'package:produtor/pages/home.dart';

class RecuperaSenha extends StatefulWidget {
  @override
  _RecuperaSenhaState createState() => _RecuperaSenhaState();
}

class _RecuperaSenhaState extends State<RecuperaSenha> {
  final _formKey = GlobalKey<FormState>();

  //UserServices _userServices = UserServices();
  TextEditingController _emailTextController = TextEditingController();
  String gender;
  String groupValue = "Masculino";
  bool hidePass = true;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF004d4d),
      body: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Color(0xFF004d4d),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20.0, top: 8, bottom: 5),
              child: Center(
                child: Container(
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 50, bottom: 60),
                            child: Text(
                              'Recuperação De Senha',
                              style: TextStyle(
                                fontSize: 26,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            height: 55,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20.0, top: 0, bottom: 0),
                              child: Material(
                                borderRadius: BorderRadius.circular(12.0),
                                color: Colors.grey.withOpacity(0.2),
                                elevation: 0.0,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 14.0),
                                  child: ListTile(
                                    title: TextFormField(
                                      controller: _emailTextController,
                                      decoration: InputDecoration(
                                          hintText: "Email",
                                          icon: Icon(Icons.alternate_email),
                                          border: InputBorder.none),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          Pattern pattern =
                                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                          RegExp regex = new RegExp(pattern);
                                          if (!regex.hasMatch(value))
                                            return 'Entre com um email válido';
                                          else
                                            return null;
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20.0, top: 10, bottom: 50),
                            child: Material(
                                borderRadius: BorderRadius.circular(12.0),
                                color: Colors.teal,
                                elevation: 0.0,
                                child: MaterialButton(
                                  onPressed: () async {
                                    validateForm();
                                    if (await emailCadastrado() == 'existe') {
                                      envia_email(_emailTextController.text,
                                          'texto_email');
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return new AlertDialog(
                                              title: new Text("Aviso"),
                                              content: new Text(
                                                  "Voçê Receberá um email \ncom as instruções da nova senha"),
                                              actions: <Widget>[
                                                new MaterialButton(
                                                  onPressed: () {
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    Login()));
                                                  },
                                                  child: new Text("Fechar"),
                                                )
                                              ],
                                            );
                                          });
                                    } else
                                      Toast.show(
                                          "Email Não localizado", context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.CENTER,
                                          backgroundRadius: 0.0);
                                  },
                                  minWidth: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "Recuperar Senha",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24.0),
                                  ),
                                )),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Tenho uma conta",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color(0xFF004d4d), fontSize: 14),
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
    );
  }

  valueChanged(e) {
    setState(() {
      if (e == "Masculino") {
        groupValue = e;
        gender = e;
      } else if (e == "Feminino") {
        groupValue = e;
        gender = e;
      }
    });
  }

  Future validateForm() async {
    FormState formState = _formKey.currentState;

    if (formState.validate()) {
      String user = "teste"; //await firebaseAuth.currentUser();
      if (user == null) {
//        Navigator.pushReplacement(
//            context, MaterialPageRoute(builder: (context) => home()));
      }
    }
  }

  // verifica se email já cadastrado
  Future<String> emailCadastrado() async {
    FormState formState = _formKey.currentState;
    if (formState.validate()) {
      // verifica se email ja cadastrado
      String link = Basicos.codifica(
          "${Basicos.ip}/crud/?crud=consult-3.${_emailTextController.text.toLowerCase()}");
      var res1 = await http
          .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
      var res = Basicos.decodifica(res1.body);
      print(
          "${Basicos.ip}/crud/?crud=consult-3.${_emailTextController.text.toLowerCase()}");
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

  // envia email
  Future<String> envia_email(String email, String mensagem) async {
    FormState formState = _formKey.currentState;
    if (formState.validate()) {
      String link = Basicos.codifica(
          "${Basicos.ip}/crud/?crud=consul-24.${email},${mensagem}");
      // print("${Basicos.ip}/crud/?crud=consult24.${email},${mensagem}");
      var res1 = await http
          .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
      var res = Basicos.decodifica(res1.body);
      // print('teste');
      if (res1.body.length > 2) {
        if (res1.statusCode == 200) {
          return 'existe';
        }
      } else
        return 'falha';
    }
  }
}
