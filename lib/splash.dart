import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:produtor/pages/dados_basicos.dart';
import 'package:produtor/pages/login.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  // AnimationController rotationController;
  String versao = '';
  List usuario = [];
  Timer timer;

  void initState() {
    // rotationController = AnimationController(
    //   duration: const Duration(milliseconds: 1000),
    //   vsync: this,
    // )..repeat(period: Duration(milliseconds: 500));
    // rotationController = AnimationController(vsync: this, duration: Duration(seconds: 2), upperBound: pi * 2)..repeat(period: Duration(microseconds: 1000));
    // Future.delayed(Duration(milliseconds: 500), (){
    //   rotationController.forward();
    // });
    verifica_logado().then((resultado) {
      setState(() {});
    }); //verifica se houve login e esta armazenado na variavel de preferencias
    super.initState();
    autoPress();
    //   SystemChrome.setEnabledSystemUIOverlays([]);

//    Future.delayed(Duration(seconds: 4)).then((_) {
////      Navigator.pushReplacement(
////          context, MaterialPageRoute(builder: (context) => HomePage1(id_sessao: 0,)));
//    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF004d4d),
      width: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Bem Vindo(a) ao\nRecoopsol',
            style: TextStyle(
              fontSize: 24,
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(34),
            child: Image(
                height: 200,
                width: 300,
                fit: BoxFit.contain,
                image: AssetImage('images/logoverde.png')),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              "Versão: $versao",
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  decoration: TextDecoration.none),
            ),
          ),
        ],
      ),
    );
  }

  void autoPress() {
    timer = new Timer(const Duration(seconds: 3), () {
      Navigator.of(context).push(new MaterialPageRoute(
        // aqui temos passagem de valores id cliente(sessao) de login para home
        builder: (context) => new Login(),
      ));
    });
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
        print(versao);
      }
    }
  }
}
