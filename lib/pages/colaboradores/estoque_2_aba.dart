import 'package:flutter/material.dart';
import '../../soft_buttom.dart';
import 'Estoque_2.dart';
import 'home_colaborador.dart';

class estoque_aba2 extends StatefulWidget {
  final id_sessao;
  final id_colaborador;

  estoque_aba2({
    this.id_sessao,
    this.id_colaborador,
  });
  @override
  _estoque_aba2State createState() => _estoque_aba2State();
}

class _estoque_aba2State extends State<estoque_aba2>
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
                      // alteração do MainAxisAlignment.start -> .center
                      mainAxisAlignment: MainAxisAlignment.center,

                      //
                      crossAxisAlignment: CrossAxisAlignment.center,

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

                          //ABAS
                          // child: TabBar(
                          //   unselectedLabelColor: Colors.white70,
                          //   labelColor: Colors.black,
                          //   tabs: [
                          //     new Tab(text: 'Produção \n Agrícola', icon: new Icon(Icons.spa)),
                          //     //new Tab(text: 'Produção \n Agrícola', icon: new Icon(Icons.spa)),
                          //     new Tab(
                          //       text: 'Compras \n Terceiros',
                          //       icon: new Icon(Icons.shopping_basket),
                          //     ),
                          //   ],
                          //   controller: _tabController,
                          //   indicatorColor: Colors.black,
                          //   indicatorSize: TabBarIndicatorSize.tab,
                          // ),

                          //SUBISTITUI AS ABAS POR UMA ABA UNICA
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.dvr),
                                Text(
                                  'Estoque',
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Scrollbar(
                            child: TabBarView(
                              //para nao poder arrastar para trocar de ABAS
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                new EstoqueP2(
                                  id_sessao: widget.id_sessao,
                                  id_colaborador: widget.id_colaborador,
                                ),
                                new EstoqueP2(
                                  id_sessao: widget.id_sessao,
                                  id_colaborador: widget.id_colaborador,
                                ),
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
                            builder: (context) => homeColaborador(
                                  id_sessao: widget.id_sessao,
                                  id_colaborador: widget.id_colaborador,
                                )));
                      });
                    }),
                radius: 22,
              ),
            ),
            // AnimatedPositioned(
            //   duration: Duration(milliseconds: 250),
            //   right: 0,
            //   top: _top,
            //   child: CircularSoftButton(
            //     icon: IconButton(
            //       icon: Icon(
            //         Icons.remove_shopping_cart,
            //         color: Colors.black,
            //         size: 28,
            //       ),
            //       // onPressed: widget.closedBuilder,
            //       onPressed: () {
            //         setState(() {
            //           _top = -60;
            //         });
            //         Future.delayed(Duration(milliseconds: 250), () {
            //           Navigator.of(context).push(
            //             MaterialPageRoute(
            //               builder: (context) =>
            //                 EstoqueSaidaColaborador(
            //                   id_sessao: widget.id_sessao,
            //                   id_colaborador: widget.id_colaborador,
            //                 )
            //             )
            //           );
            //         });
            //       }
            //     ),
            //     radius: 22,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
