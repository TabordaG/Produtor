import 'package:flutter/material.dart';
import 'package:produtor/pages/criar_conta/Cooperativa.dart';
import 'package:produtor/pages/criar_conta/juridica.dart';
import 'dart:async';

//import 'package:ecomerce/pages/home.dart';
import 'package:produtor/pages/criar_conta/registrar.dart';

import '../../soft_buttom.dart';

class Abas extends StatefulWidget {
  @override
  _AbasState createState() => _AbasState();
}

class _AbasState extends State<Abas> with SingleTickerProviderStateMixin {
  TabController _tabController;
  double _top = -60;

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 250), () {
      setState(() {
        _top = 0;
      });
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
                              left: 20, top: 10, right: 20, bottom: 10),
                          child: Text(
                            'Criar Conta',
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
                                  text: 'Pessoa \n Física',
                                  icon: new Icon(Icons.person)),
                              new Tab(
                                text: ' Pessoa\nJurídica',
                                icon: new Icon(Icons.portrait),
                              ),
                              new Tab(
                                text: 'Cooperativa',
                                icon: new Icon(Icons.supervisor_account),
                              )
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
                                new Registrar(),
                                new Registrar_juridica(),
                                new Cooperativa(),
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
                        Navigator.pop(context);
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
