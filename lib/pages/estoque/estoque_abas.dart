import 'dart:convert';

import 'package:produtor/pages/produtos/atualiza_produtos.dart';
import 'package:flutter/material.dart';
import 'package:produtor/pages/compras_terceiros/tela_compra_estoque.dart';
import 'package:produtor/pages/home.dart';
import 'package:http/http.dart' as http;
import 'package:produtor/pages/estoque/Estoque.dart';
import 'package:toast/toast.dart';

import '../../soft_buttom.dart';
import '../dados_basicos.dart';
import 'estoque_saida.dart';

class estoque_Abas extends StatefulWidget {
  final id_sessao;

  estoque_Abas({
    this.id_sessao,
  });
  @override
  _estoque_AbasState createState() => _estoque_AbasState();
}

class _estoque_AbasState extends State<estoque_Abas>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  double _top = -60;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    Future.delayed(Duration(milliseconds: 250), () {
      setState(() {
        _top = 0;
      });
    });
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
                        blurRadius:
                            20.0, // has the effect of softening the shadow
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 20, right: 20, bottom: 5),
                          child: Text(
                            'Entrada Estoque',
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                              color: Colors.teal),
                          child: TabBar(
                            unselectedLabelColor: Colors.white70,
                            labelColor: Colors.black,
                            tabs: [
                              new Tab(
                                  text: 'Produção \n Agrícola',
                                  icon: new Icon(Icons.spa)),
                              //new Tab(text: 'Produção \n Agrícola', icon: new Icon(Icons.spa)),
                              new Tab(
                                text: 'Compras \n Terceiros',
                                icon: new Icon(Icons.shopping_basket),
                              ),
                            ],
                            controller: _tabController,
                            indicatorColor: Colors.black,
                            indicatorSize: TabBarIndicatorSize.tab,
                          ),
                        ),
                        Expanded(
                          child: Scrollbar(
                            child: TabBarView(
                              children: [
                                new Estoque(id_sessao: widget.id_sessao),
                                new TelaComprasEstoque(
                                    id_sessao: widget.id_sessao),
                              ],
                              controller: _tabController,
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
                    // onPressed: widget.closedBuilder,
                    onPressed: () {
                      setState(() {
                        _top = -60;
                      });
                      Future.delayed(Duration(milliseconds: 250), () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => home2(
                                  id_sessao: widget.id_sessao,
                                )));
                      });
                    }),
                radius: 22,
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 250),
              right: 0,
              top: _top,
              child: CircularSoftButton(
                icon: IconButton(
                    icon: Icon(
                      Icons.remove_shopping_cart,
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
                            builder: (context) => EstoqueSaida(
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
    );
  }
}
