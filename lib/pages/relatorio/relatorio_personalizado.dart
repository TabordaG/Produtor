import 'dart:async';
import 'dart:convert';
import 'package:produtor/pages/relatorio/widgets.dart';
import 'package:flutter/services.dart';
import '../../soft_buttom.dart';
import '../dados_basicos.dart';
import 'relatorio_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:http/http.dart' as http;
import 'package:produtor/pages/dados_basicos.dart';

class RelatorioPersonalizado extends StatefulWidget {
  final id_sessao;
  final DateTime data1;
  final DateTime data2;

  @override
  _RelatorioPersonalizadoState createState() => _RelatorioPersonalizadoState();

  RelatorioPersonalizado({this.id_sessao, this.data1, this.data2});
}

class _RelatorioPersonalizadoState extends State<RelatorioPersonalizado> {
  double _top = -60;
  ScrollController scrollController;
  StreamController listaProdutos;

  @override
  void initState() {
    scrollController = ScrollController();
    listaProdutos = StreamController();
    Future.delayed(Duration(milliseconds: 250), () {
      setState(() {
        _top = 0;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    listaProdutos.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, top: 20, right: 20, bottom: 5),
                            child: Text(
                              'Relatório Personalizado',
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
                                  topRight: Radius.circular(20),
                                ),
                                color: Colors.teal),
                            child: TabBar(tabs: <Widget>[
                              Tab(
                                text: 'Entrega',
                                icon: Icon(Icons.local_shipping),
                              ),
                              Tab(
                                text: 'Retirada no Local',
                                icon: Icon(Icons.store),
                              )
                            ], indicatorColor: Colors.black),
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                //#### TabBarView 1 (Entrega)
                                produtosNovos == false
                                    ? Scrollbar(
                                        child: pedidosNovosEntrega.length > 0
                                            ? ListView.builder(
                                                shrinkWrap: true,
                                                itemCount:
                                                    pedidosNovosEntrega.length,
                                                itemBuilder: (context, index) {
                                                  return Card(
                                                    child: CustomListItemTwo(
                                                      title:
                                                          '#${pedidosNovosEntrega[index].id}  Cliente: ${pedidosNovosEntrega[index].cliente}',
                                                      subtitle:
                                                          '${pedidosNovosEntrega[index].endereco}, ${pedidosNovosEntrega[index].numero} - ${pedidosNovosEntrega[index].bairro}, ${pedidosNovosEntrega[index].cidade} - ${pedidosNovosEntrega[index].estado}',
                                                      author:
                                                          '${pedidosNovosEntrega[index].produtor}',
                                                      publishDate:
                                                          pedidosNovosEntrega[
                                                                  index]
                                                              .dataVenda,
                                                      readDuration:
                                                          '${pedidosNovosEntrega[index].statusPedido}',
                                                    ),
                                                  );
                                                })
                                            : Center(
                                                child: Text(
                                                    'Não há Pedidos para\nEntrega',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontFamily: "Poppins",
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black,
                                                    )),
                                              ))
                                    : Scrollbar(
                                        child: marcaProdutoEntrega.length > 0
                                            ? ListView.builder(
                                                controller: scrollController,
                                                itemCount:
                                                    marcaProdutoEntrega.length,
                                                itemBuilder: (context, index) {
                                                  return Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 20.0,
                                                                top: 10),
                                                        child: Align(
                                                          alignment: Alignment
                                                              .bottomLeft,
                                                          child: Text(
                                                              marcaProdutoEntrega[
                                                                      index]
                                                                  .marca,
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    "Poppins",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black,
                                                              )),
                                                        ),
                                                      ),
                                                      Divider(
                                                        thickness: .5,
                                                        indent: 80,
                                                        endIndent: 20,
                                                      ),
                                                      ListView.builder(
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          shrinkWrap: true,
                                                          controller:
                                                              scrollController,
                                                          itemCount:
                                                              marcaProdutoEntrega[
                                                                      index]
                                                                  .produtos
                                                                  .length, //relatorioProdutos.length,
                                                          itemBuilder: (context,
                                                              index2) {
                                                            String imagem = get_picture(
                                                                marcaProdutoEntrega[
                                                                        index]
                                                                    .produtos[
                                                                        index2]
                                                                    .imagem);
                                                            return Card(
                                                              child: CustomListProduct(
                                                                  idProduct:
                                                                      '${marcaProdutoEntrega[index].produtos[index2].id}',
                                                                  imagem:
                                                                      imagem,
                                                                  nameProduct:
                                                                      '${marcaProdutoEntrega[index].produtos[index2].nomeProduto}',
                                                                  amountProduct:
                                                                      '${marcaProdutoEntrega[index].produtos[index2].quantidade}'),
                                                            );
                                                          }),
                                                    ],
                                                  );
                                                },
                                              )
                                            : Center(
                                                child: Text(
                                                    'Não há Produtos para\nEntrega',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontFamily: "Poppins",
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black,
                                                    )),
                                              )),

                                //###### TabBarView 2 (Retirada no Local)
                                produtosNovos == false
                                    ? Scrollbar(
                                        child: pedidosNovosRetirada.length > 0
                                            ? ListView.builder(
                                                shrinkWrap: true,
                                                itemCount:
                                                    pedidosNovosRetirada.length,
                                                itemBuilder: (context, index) {
                                                  return Card(
                                                    child: CustomListItemTwo(
                                                      title:
                                                          '#${pedidosNovosRetirada[index].id}  Cliente: ${pedidosNovosRetirada[index].cliente}',
                                                      subtitle:
                                                          '${pedidosNovosRetirada[index].endereco}, ${pedidosNovosRetirada[index].numero} - ${pedidosNovosRetirada[index].bairro}, ${pedidosNovosRetirada[index].cidade} - ${pedidosNovosRetirada[index].estado}',
                                                      author:
                                                          '${pedidosNovosRetirada[index].produtor}',
                                                      publishDate:
                                                          pedidosNovosRetirada[
                                                                  index]
                                                              .dataVenda,
                                                      readDuration:
                                                          '${pedidosNovosRetirada[index].statusPedido}',
                                                    ),
                                                  );
                                                })
                                            : Center(
                                                child: Text(
                                                    'Não há Pedidos para\nRetirada',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontFamily: "Poppins",
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black,
                                                    )),
                                              ))
                                    : Scrollbar(
                                        child: marcaProdutoRetirada.length > 0
                                            ? ListView.builder(
                                                controller: scrollController,
                                                itemCount:
                                                    marcaProdutoRetirada.length,
                                                itemBuilder: (context, index) {
                                                  return Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 20.0,
                                                                top: 10),
                                                        child: Align(
                                                          alignment: Alignment
                                                              .bottomLeft,
                                                          child: Text(
                                                              marcaProdutoRetirada[
                                                                      index]
                                                                  .marca,
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    "Poppins",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black,
                                                              )),
                                                        ),
                                                      ),
                                                      Divider(
                                                        thickness: .5,
                                                        indent: 80,
                                                        endIndent: 20,
                                                      ),
                                                      ListView.builder(
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          shrinkWrap: true,
                                                          controller:
                                                              scrollController,
                                                          itemCount:
                                                              marcaProdutoRetirada[
                                                                      index]
                                                                  .produtos
                                                                  .length, //relatorioProdutos.length,
                                                          itemBuilder: (context,
                                                              index2) {
                                                            String imagem = get_picture(
                                                                marcaProdutoRetirada[
                                                                        index]
                                                                    .produtos[
                                                                        index2]
                                                                    .imagem);
                                                            return Card(
                                                              child: CustomListProduct(
                                                                  idProduct:
                                                                      '${marcaProdutoRetirada[index].produtos[index2].id}',
                                                                  imagem:
                                                                      imagem,
                                                                  nameProduct:
                                                                      '${marcaProdutoRetirada[index].produtos[index2].nomeProduto}',
                                                                  amountProduct:
                                                                      '${marcaProdutoRetirada[index].produtos[index2].quantidade}'),
                                                            );
                                                          }),
                                                    ],
                                                  );
                                                },
                                              )
                                            : Center(
                                                child: Text(
                                                    'Não há Produtos para\nRetirada',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontFamily: "Poppins",
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black,
                                                    )),
                                              )),
                              ],
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
                              builder: (context) => RelatorioPage(
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
                      Icons.picture_as_pdf,
                      color: Colors.black,
                      size: 28,
                    ),
                    // onPressed: widget.closedBuilder,
                    onPressed: () async {
                      circular('inicio');
                      itensPedidosNovosEntrega = [];
                      itensPedidosNovosRetirada = [];
                      pedidosNovosEntrega.forEach((element) async {
                        await listPedido(1, element);
                      });
                      pedidosNovosRetirada.forEach((element) async {
                        await listPedido(0, element);
                      });
                      Future.delayed(Duration(seconds: 5), () {
                        circular('fim');
                        _printDocument();
                      });
                    },
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

  String total(String vtotal, String vfrete) {
    try {
      // print('Frete: $vfrete');
      double soma = double.parse(vtotal) + double.parse(vfrete);
      // print(soma);
      return soma.toStringAsFixed(2);
    } catch (e) {
      return vtotal;
    }
  }

  Future<void> _printDocument() async {
    pw.Document.debug = false;
    final doc = pw.Document();
    final fontBold = await rootBundle.load("assets/OpenSans-Bold.ttf");
    final fontRegular = await rootBundle.load("assets/OpenSans-Regular.ttf");
    final ttfBold = pw.Font.ttf(fontBold);
    final ttfRegular = pw.Font.ttf(fontRegular);
    List<MarcaProduto> marcaProdutoEntrega2 = [];
    List<MarcaProduto> marcaProdutoRetirada2 = [];
    List<MarcaProduto> marcaProdutoTotal2 = [];
    double totalProdutos = 0;

    //#### Produto Entrega
    marcaProdutoEntrega.forEach((element) {
      element.produtos.sort((a, b) =>
          a.nomeProduto.toLowerCase().compareTo(b.nomeProduto.toLowerCase()));
    });
    marcaProdutoEntrega.forEach((element) {
      List<ProdutosRelatorio> produtosList = [];
      if (element.produtos.length > 25) {
        int i = 0;
        while (i < element.produtos.length) {
          produtosList.add(element.produtos[i]);
          if (i % 25 == 0 && i != 0) {
            marcaProdutoEntrega2.add(
                MarcaProduto(marca: element.marca, produtos: produtosList));
            produtosList = [];
          }
          i++;
        }
        marcaProdutoEntrega2
            .add(MarcaProduto(marca: element.marca, produtos: produtosList));
      } else {
        marcaProdutoEntrega2.add(
            MarcaProduto(marca: element.marca, produtos: element.produtos));
      }
    });

    marcaProdutoEntrega2
        .sort((a, b) => a.marca.toLowerCase().compareTo(b.marca.toLowerCase()));

    //#### Produto Retirada
    marcaProdutoRetirada.forEach((element) {
      element.produtos.sort((a, b) =>
          a.nomeProduto.toLowerCase().compareTo(b.nomeProduto.toLowerCase()));
    });
    marcaProdutoRetirada.forEach((element) {
      List<ProdutosRelatorio> produtosList = [];
      if (element.produtos.length > 25) {
        int i = 0;
        while (i < element.produtos.length) {
          produtosList.add(element.produtos[i]);
          if (i % 25 == 0 && i != 0) {
            marcaProdutoRetirada2.add(
                MarcaProduto(marca: element.marca, produtos: produtosList));
            produtosList = [];
          }
          i++;
        }
        marcaProdutoRetirada2
            .add(MarcaProduto(marca: element.marca, produtos: produtosList));
      } else {
        marcaProdutoRetirada2.add(
            MarcaProduto(marca: element.marca, produtos: element.produtos));
      }
    });

    marcaProdutoRetirada2
        .sort((a, b) => a.marca.toLowerCase().compareTo(b.marca.toLowerCase()));

    //#### Produto Total
    marcaProdutoTotal.forEach((element) {
      element.produtos.sort((a, b) =>
          a.nomeProduto.toLowerCase().compareTo(b.nomeProduto.toLowerCase()));
    });
    for (int index = 0; index < marcaProdutoTotal.length; index++) {
      List<ProdutosRelatorio> produtosList = [];
      if (marcaProdutoTotal[index].produtos.length > 25) {
        int i = 0;
        while (i < marcaProdutoTotal[index].produtos.length) {
          produtosList.add(marcaProdutoTotal[index].produtos[i]);
          if (i % 25 == 0 && i != 0) {
            marcaProdutoTotal2.add(MarcaProduto(
                marca: marcaProdutoTotal[index].marca,
                produtos: produtosList,
                quantidade: quantidademarcaTotal[index]));
            // quantidademarcaTotal2.add(quantidademarcaTotal[index]);
            // quantidademarcaTotal.insert(marcaProdutoTotal2.length - 1, quantidademarcaTotal[marcaProdutoTotal2.length - 1]);
            produtosList = [];
          }
          i++;
        }
        marcaProdutoTotal2.add(MarcaProduto(
            marca: marcaProdutoTotal[index].marca,
            produtos: produtosList,
            quantidade: quantidademarcaTotal[index]));
        // quantidademarcaTotal.insert(marcaProdutoTotal2.length - 1, quantidademarcaTotal[marcaProdutoTotal2.length - 1]);
      } else {
        marcaProdutoTotal2.add(MarcaProduto(
            marca: marcaProdutoTotal[index].marca,
            produtos: marcaProdutoTotal[index].produtos,
            quantidade: quantidademarcaTotal[index]));
      }
    }

    marcaProdutoTotal2
        .sort((a, b) => a.marca.toLowerCase().compareTo(b.marca.toLowerCase()));

    quantidademarcaTotal.forEach((element) {
      totalProdutos += element;
    });

    doc.addPage(
      pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) => <pw.Widget>[
                // pw.Wrap(
                //   children: [
                pw.Center(
                  child: pw.Text(
                      'Relatório dos Pedidos Para Entrega ou Retirada',
                      style: pw.TextStyle(font: ttfBold, fontSize: 22),
                      textAlign: pw.TextAlign.center),
                ),
                pw.Center(
                  child: pw.Text('Situação: $itemSelecionadoRelatorio',
                      style: pw.TextStyle(font: ttfBold, fontSize: 18),
                      textAlign: pw.TextAlign.center),
                ),
                pw.Center(
                  child: pw.Text(
                      'Período: ${widget.data1.day}/${widget.data1.month}/${widget.data1.year} à ${widget.data2.day}/${widget.data2.month}/${widget.data2.year}',
                      style: pw.TextStyle(font: ttfBold, fontSize: 18)),
                ),
                pw.Center(
                  child: pw.Text(
                      'Data de Consulta: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}\n',
                      style: pw.TextStyle(font: ttfRegular, fontSize: 18),
                      textAlign: pw.TextAlign.center),
                ),

                produtosNovos == true
                    ? pw.Center(
                        child: pw.RichText(
                          textAlign: pw.TextAlign.center,
                          text: pw.TextSpan(children: [
                            pw.TextSpan(
                                text:
                                    '\n------------------- Produtos Totais -------------------\n',
                                style:
                                    pw.TextStyle(font: ttfBold, fontSize: 20)),
                            pw.TextSpan(
                                text: 'Nº Produtos: ' +
                                    totalProdutos.toStringAsFixed(0) +
                                    '\n',
                                style: pw.TextStyle(
                                    font: ttfRegular, fontSize: 16)),
                          ]),
                        ),
                      )
                    : pw.Container(),

                for (MarcaProduto marca in marcaProdutoTotal2)
                  produtosNovos == true
                      ? pw.Table(children: [
                          pw.TableRow(children: [
                            pw.Expanded(
                              flex: 2,
                              child: pw.Padding(
                                padding: pw.EdgeInsets.only(top: 10),
                                child: pw.Align(
                                  alignment: pw.Alignment.bottomLeft,
                                  child: pw.RichText(
                                    text: pw.TextSpan(children: [
                                      pw.TextSpan(
                                          text: marca.marca,
                                          style: pw.TextStyle(
                                              font: ttfBold, fontSize: 18)),
                                      pw.TextSpan(
                                          text: '\nNº Produtos: ' +
                                              marca.quantidade
                                                  .toStringAsFixed(0),
                                          style: pw.TextStyle(
                                              font: ttfRegular, fontSize: 16)),
                                    ]),
                                  ),
                                ),
                              ),
                            ),
                            pw.Expanded(flex: 4, child: pw.Container()),
                            pw.Expanded(flex: 2, child: pw.Container()),
                          ]),
                          pw.TableRow(children: [
                            pw.Divider(
                              thickness: .5,
                              indent: 70,
                              endIndent: 10,
                            ),
                          ]),
                          pw.TableRow(children: [
                            pw.Text(' ID',
                                style:
                                    pw.TextStyle(font: ttfBold, fontSize: 16),
                                textAlign: pw.TextAlign.center),
                            pw.Text('Produto',
                                style:
                                    pw.TextStyle(font: ttfBold, fontSize: 16),
                                textAlign: pw.TextAlign.left),
                            pw.Text('Quantidade',
                                style:
                                    pw.TextStyle(font: ttfBold, fontSize: 16),
                                textAlign: pw.TextAlign.center),
                          ]),
                          for (int index = 0;
                              index <= 25 && index < marca.produtos.length;
                              index++)
                            pw.TableRow(children: [
                              pw.Text(' ' + marca.produtos[index].id,
                                  style: pw.TextStyle(
                                      font: ttfRegular, fontSize: 16),
                                  textAlign: pw.TextAlign.center),
                              pw.Text(marca.produtos[index].nomeProduto,
                                  style: pw.TextStyle(
                                      font: ttfRegular, fontSize: 16),
                                  textAlign: pw.TextAlign.left),
                              pw.Text(
                                  marca.produtos[index].quantidade.toString(),
                                  style: pw.TextStyle(
                                      font: ttfRegular, fontSize: 16),
                                  textAlign: pw.TextAlign.center),
                            ]),
                          pw.TableRow(children: [
                            pw.SizedBox(height: 20),
                          ]),
                        ])
                      : pw.Container(),

                // pw.Text(
                //   '\n------------------------------------------------------------------------\n',
                //   style: pw.TextStyle(font: ttfRegular, fontSize: 20),
                //   textAlign: pw.TextAlign.center
                // ),

                produtosNovos == false
                    ? pw.Text(
                        '\n| Pedidos para Entrega ______________________________\n',
                        style: pw.TextStyle(font: ttfBold, fontSize: 20))
                    : pw.Container(),
                if (produtosNovos == false)
                  for (int i = 0; i < itensPedidosNovosEntrega.length; i++)
                    pw.Column(children: [
                      if (i == 0 ||
                          itensPedidosNovosEntrega[i - 1].venda.id !=
                              itensPedidosNovosEntrega[i].venda.id)
                        pw.RichText(
                            text: pw.TextSpan(children: [
                          pw.TextSpan(
                              text:
                                  '\n\n#${itensPedidosNovosEntrega[i].venda.id}  Cliente: ${itensPedidosNovosEntrega[i].venda.cliente}',
                              style: pw.TextStyle(font: ttfBold, fontSize: 18)),
                          pw.TextSpan(
                              text: '\nEndereço: ',
                              style: pw.TextStyle(font: ttfBold, fontSize: 18)),
                          pw.TextSpan(
                              text:
                                  '${itensPedidosNovosEntrega[i].venda.endereco}, ${itensPedidosNovosEntrega[i].venda.numero} - ${itensPedidosNovosEntrega[i].venda.bairro}, ${itensPedidosNovosEntrega[i].venda.cidade} - ${itensPedidosNovosEntrega[i].venda.estado}',
                              style:
                                  pw.TextStyle(font: ttfRegular, fontSize: 18)),
                          pw.TextSpan(
                              text: '\nCelular: ',
                              style: pw.TextStyle(font: ttfBold, fontSize: 18)),
                          pw.TextSpan(
                              text:
                                  '${itensPedidosNovosEntrega[i].venda.produtor}',
                              style:
                                  pw.TextStyle(font: ttfRegular, fontSize: 18)),
                          pw.TextSpan(
                              text: '\t\t\tData: ',
                              style: pw.TextStyle(font: ttfBold, fontSize: 18)),
                          pw.TextSpan(
                              text:
                                  '${itensPedidosNovosEntrega[i].venda.dataVenda.day}/${itensPedidosNovosEntrega[i].venda.dataVenda.month}/${itensPedidosNovosEntrega[i].venda.dataVenda.year}',
                              style:
                                  pw.TextStyle(font: ttfRegular, fontSize: 18)),
                          pw.TextSpan(
                              text: '\nSituação do Pedido: ',
                              style: pw.TextStyle(font: ttfBold, fontSize: 18)),
                          pw.TextSpan(
                              text:
                                  '${itensPedidosNovosEntrega[i].venda.statusPedido}',
                              style:
                                  pw.TextStyle(font: ttfRegular, fontSize: 18)),
                          pw.TextSpan(
                              text: '\nTotal: ',
                              style: pw.TextStyle(font: ttfBold, fontSize: 18)),
                          pw.TextSpan(
                              text:
                                  'R\$${itensPedidosNovosEntrega[i].venda.total} + R\$${itensPedidosNovosEntrega[i].venda.frete} =',
                              style:
                                  pw.TextStyle(font: ttfRegular, fontSize: 18)),
                          pw.TextSpan(
                              text:
                                  ' R\$${total(itensPedidosNovosEntrega[i].venda.total, itensPedidosNovosEntrega[i].venda.frete)}\n\n',
                              style: pw.TextStyle(font: ttfBold, fontSize: 18)),
                        ])),
                      if (i == 0 ||
                          itensPedidosNovosEntrega[i - 1].venda.id !=
                              itensPedidosNovosEntrega[i].venda.id)
                        pw.Table.fromTextArray(
                            headerStyle:
                                pw.TextStyle(font: ttfBold, fontSize: 12),
                            cellStyle:
                                pw.TextStyle(font: ttfRegular, fontSize: 12),
                            headerAlignment: pw.Alignment.center,
                            columnWidths: {
                              0: pw.FlexColumnWidth(10.0),
                              1: pw.FlexColumnWidth(6.0),
                              2: pw.FlexColumnWidth(3.0),
                              3: pw.FlexColumnWidth(3.0),
                            },
                            data: <List>[
                              ['Produto', 'Produtor', 'Qtd', 'Preço Unit.'],
                            ]),
                      pw.Table.fromTextArray(
                          headerStyle:
                              pw.TextStyle(font: ttfRegular, fontSize: 12),
                          cellStyle:
                              pw.TextStyle(font: ttfRegular, fontSize: 12),
                          headerAlignments: {
                            0: pw.Alignment.centerLeft,
                            1: pw.Alignment.centerLeft,
                            2: pw.Alignment.center,
                            3: pw.Alignment.center,
                          },
                          columnWidths: {
                            0: pw.FlexColumnWidth(10.0),
                            1: pw.FlexColumnWidth(6.0),
                            2: pw.FlexColumnWidth(3.0),
                            3: pw.FlexColumnWidth(3.0),
                          },
                          // border: pw.TableBorder(
                          //   left: false,
                          //   right: false,
                          //   top: false,
                          //   bottom: true,
                          // ),
                          data: <List>[
                            [
                              itensPedidosNovosEntrega[i]
                                  .pedido["descricao_simplificada"],
                              itensPedidosNovosEntrega[i].pedido["descricao"],
                              itensPedidosNovosEntrega[i].pedido["quantidade"],
                              itensPedidosNovosEntrega[i].pedido["preco_venda"],
                            ],
                          ]),
                    ]),

                // O código comentado abaixo, refere-se a separação no relatório de PRODUTOS, entre
                // os produtos PARA ENTREGA e os produtos PARA RETIRADA.
                // Tudo foi substituído em um trecho a cima juntando as duas tabelas.

                // produtosNovos == true
                //   ? pw.Center(
                //       child: pw.Text(
                //         '\nProdutos para Entrega\n',
                //         style: pw.TextStyle(font: ttfBold, fontSize: 18),
                //         textAlign: pw.TextAlign.center
                //       ),
                //     )
                //   : pw.Container(),

                // for(MarcaProduto marca in marcaProdutoEntrega2)
                //   produtosNovos == true
                //   ? pw.Table(
                //     children: [
                //       pw.TableRow(
                //         children: [
                //           pw.Expanded(
                //             flex: 2,
                //             child: pw.Padding(
                //               padding: pw.EdgeInsets.only(right: 20.0, top: 10),
                //               child: pw.Align(
                //                 alignment: pw.Alignment.bottomLeft,
                //                 child: pw.Text(
                //                   marca.marca,
                //                   style: pw.TextStyle(font: ttfBold, fontSize: 18)
                //                 ),
                //               ),
                //             ),
                //           ),
                //           pw.Expanded(
                //             flex: 4,
                //             child: pw.Container()
                //           ),
                //           pw.Expanded(
                //             flex: 2,
                //             child: pw.Container()
                //           ),
                //         ]
                //       ),

                //       pw.TableRow(
                //         children: [
                //           pw.Divider(
                //             thickness: .5,
                //             indent: 70,
                //             endIndent: 10,
                //           ),
                //         ]
                //       ),

                //       pw.TableRow(
                //         children: [
                //           pw.Text(
                //             ' ID',
                //             style: pw.TextStyle(font: ttfBold, fontSize: 16),
                //             textAlign: pw.TextAlign.center
                //           ),
                //           pw.Text(
                //             'Produto',
                //             style: pw.TextStyle(font: ttfBold, fontSize: 16),
                //             textAlign: pw.TextAlign.left
                //           ),
                //           pw.Text(
                //             'Quantidade',
                //             style: pw.TextStyle(font: ttfBold, fontSize: 16),
                //             textAlign: pw.TextAlign.center
                //           ),
                //         ]
                //       ),
                //       for(int index = 0; index <= 25 && index < marca.produtos.length; index++)
                //         pw.TableRow(
                //           children: [
                //             pw.Text(
                //               ' ' + marca.produtos[index].id,
                //               style: pw.TextStyle(font: ttfRegular, fontSize: 16),
                //               textAlign: pw.TextAlign.center
                //             ),
                //             pw.Text(
                //               marca.produtos[index].nomeProduto,
                //               style: pw.TextStyle(font: ttfRegular, fontSize: 16),
                //               textAlign: pw.TextAlign.left
                //             ),
                //             pw.Text(
                //               marca.produtos[index].quantidade.toString(),
                //               style: pw.TextStyle(font: ttfRegular, fontSize: 16),
                //               textAlign: pw.TextAlign.center
                //             ),
                //           ]
                //         ),
                //       pw.TableRow(
                //         children: [
                //           pw.SizedBox(height: 20),
                //         ]
                //       ),

                //     ]
                //   )
                //   : pw.Container(),

                pw.Text(
                    '\n------------------------------------------------------------------------\n',
                    style: pw.TextStyle(font: ttfRegular, fontSize: 20),
                    textAlign: pw.TextAlign.center),

                produtosNovos == false
                    ? pw.Text(
                        '\n| Pedidos para Retirada ______________________________\n',
                        style: pw.TextStyle(font: ttfBold, fontSize: 20))
                    : pw.Container(),
                if (produtosNovos == false)
                  for (int i = 0; i < itensPedidosNovosRetirada.length; i++)
                    pw.Column(children: [
                      if (i == 0 ||
                          itensPedidosNovosRetirada[i - 1].venda.id !=
                              itensPedidosNovosRetirada[i].venda.id)
                        pw.RichText(
                            text: pw.TextSpan(children: [
                          pw.TextSpan(
                              text:
                                  '\n\n#${itensPedidosNovosRetirada[i].venda.id}  Cliente: ${itensPedidosNovosRetirada[i].venda.cliente}',
                              style: pw.TextStyle(font: ttfBold, fontSize: 18)),
                          pw.TextSpan(
                              text: '\nEndereço: ',
                              style: pw.TextStyle(font: ttfBold, fontSize: 18)),
                          pw.TextSpan(
                              text:
                                  '${itensPedidosNovosRetirada[i].venda.endereco}, ${itensPedidosNovosRetirada[i].venda.numero} - ${itensPedidosNovosRetirada[i].venda.bairro}, ${itensPedidosNovosRetirada[i].venda.cidade} - ${itensPedidosNovosRetirada[i].venda.estado}',
                              style:
                                  pw.TextStyle(font: ttfRegular, fontSize: 18)),
                          pw.TextSpan(
                              text: '\nCelular: ',
                              style: pw.TextStyle(font: ttfBold, fontSize: 18)),
                          pw.TextSpan(
                              text:
                                  '${itensPedidosNovosRetirada[i].venda.produtor}',
                              style:
                                  pw.TextStyle(font: ttfRegular, fontSize: 18)),
                          pw.TextSpan(
                              text: '\t\t\tData: ',
                              style: pw.TextStyle(font: ttfBold, fontSize: 18)),
                          pw.TextSpan(
                              text:
                                  '${itensPedidosNovosRetirada[i].venda.dataVenda.day}/${itensPedidosNovosRetirada[i].venda.dataVenda.month}/${itensPedidosNovosRetirada[i].venda.dataVenda.year}',
                              style:
                                  pw.TextStyle(font: ttfRegular, fontSize: 18)),
                          pw.TextSpan(
                              text: '\nSituação do Pedido: ',
                              style: pw.TextStyle(font: ttfBold, fontSize: 18)),
                          pw.TextSpan(
                              text:
                                  '${itensPedidosNovosRetirada[i].venda.statusPedido}',
                              style:
                                  pw.TextStyle(font: ttfRegular, fontSize: 18)),
                          pw.TextSpan(
                              text: '\nTotal: ',
                              style: pw.TextStyle(font: ttfBold, fontSize: 18)),
                          pw.TextSpan(
                              text:
                                  'R\$${itensPedidosNovosRetirada[i].venda.total} + R\$${itensPedidosNovosRetirada[i].venda.frete} =',
                              style:
                                  pw.TextStyle(font: ttfRegular, fontSize: 18)),
                          pw.TextSpan(
                              text:
                                  ' R\$${total(itensPedidosNovosRetirada[i].venda.total, itensPedidosNovosRetirada[i].venda.frete)}\n\n',
                              style: pw.TextStyle(font: ttfBold, fontSize: 18)),
                        ])),
                      if (i == 0 ||
                          itensPedidosNovosRetirada[i - 1].venda.id !=
                              itensPedidosNovosRetirada[i].venda.id)
                        pw.Table.fromTextArray(
                            headerStyle:
                                pw.TextStyle(font: ttfBold, fontSize: 12),
                            cellStyle:
                                pw.TextStyle(font: ttfRegular, fontSize: 12),
                            headerAlignment: pw.Alignment.center,
                            columnWidths: {
                              0: pw.FlexColumnWidth(10.0),
                              1: pw.FlexColumnWidth(6.0),
                              2: pw.FlexColumnWidth(3.0),
                              3: pw.FlexColumnWidth(3.0),
                            },
                            data: <List>[
                              ['Produto', 'Produtor', 'Qtd', 'Preço Unit.'],
                            ]),
                      pw.Table.fromTextArray(
                          headerStyle:
                              pw.TextStyle(font: ttfRegular, fontSize: 12),
                          cellStyle:
                              pw.TextStyle(font: ttfRegular, fontSize: 12),
                          headerAlignments: {
                            0: pw.Alignment.centerLeft,
                            1: pw.Alignment.centerLeft,
                            2: pw.Alignment.center,
                            3: pw.Alignment.center,
                          },
                          columnWidths: {
                            0: pw.FlexColumnWidth(10.0),
                            1: pw.FlexColumnWidth(6.0),
                            2: pw.FlexColumnWidth(3.0),
                            3: pw.FlexColumnWidth(3.0),
                          },
                          // border: pw.TableBorder(
                          //   left: false,
                          //   right: false,
                          //   top: false,
                          //   bottom: true,
                          // ),
                          data: <List>[
                            [
                              itensPedidosNovosRetirada[i]
                                  .pedido["descricao_simplificada"],
                              itensPedidosNovosRetirada[i].pedido["descricao"],
                              itensPedidosNovosRetirada[i].pedido["quantidade"],
                              itensPedidosNovosRetirada[i]
                                  .pedido["preco_venda"],
                            ],
                          ]),
                    ]),

                // produtosNovos == true
                //   ? pw.Center(
                //       child: pw.Text(
                //         '\nProdutos para Retirada\n',
                //         style: pw.TextStyle(font: ttfBold, fontSize: 18),
                //         textAlign: pw.TextAlign.center
                //       ),
                //     )
                //   : pw.Container(),

                // for(MarcaProduto marca in marcaProdutoRetirada2)
                //   produtosNovos == true
                //   ? pw.Table(
                //     children: [
                //       pw.TableRow(
                //         children: [
                //           pw.Expanded(
                //             flex: 2,
                //             child: pw.Padding(
                //               padding: pw.EdgeInsets.only(right: 20.0, top: 10),
                //               child: pw.Align(
                //                 alignment: pw.Alignment.bottomLeft,
                //                 child: pw.Text(
                //                   marca.marca,
                //                   style: pw.TextStyle(font: ttfBold, fontSize: 18)
                //                 ),
                //               ),
                //             ),
                //           ),
                //           pw.Expanded(
                //             flex: 4,
                //             child: pw.Container()
                //           ),
                //           pw.Expanded(
                //             flex: 2,
                //             child: pw.Container()
                //           ),
                //         ]
                //       ),

                //       pw.TableRow(
                //         children: [
                //           pw.Divider(
                //             thickness: .5,
                //             indent: 70,
                //             endIndent: 10,
                //           ),
                //         ]
                //       ),

                //       pw.TableRow(
                //         children: [
                //           pw.Text(
                //             ' ID',
                //             style: pw.TextStyle(font: ttfBold, fontSize: 16),
                //             textAlign: pw.TextAlign.center
                //           ),
                //           pw.Text(
                //             'Produto',
                //             style: pw.TextStyle(font: ttfBold, fontSize: 16),
                //             textAlign: pw.TextAlign.left
                //           ),
                //           pw.Text(
                //             'Quantidade',
                //             style: pw.TextStyle(font: ttfBold, fontSize: 16),
                //             textAlign: pw.TextAlign.center
                //           ),
                //         ]
                //       ),
                //       for(int index = 0; index <= 25 && index < marca.produtos.length; index++)
                //         pw.TableRow(
                //           children: [
                //             pw.Text(
                //               ' ' + marca.produtos[index].id,
                //               style: pw.TextStyle(font: ttfRegular, fontSize: 16),
                //               textAlign: pw.TextAlign.center
                //             ),
                //             pw.Text(
                //               marca.produtos[index].nomeProduto,
                //               style: pw.TextStyle(font: ttfRegular, fontSize: 16),
                //               textAlign: pw.TextAlign.left
                //             ),
                //             pw.Text(
                //               marca.produtos[index].quantidade.toString(),
                //               style: pw.TextStyle(font: ttfRegular, fontSize: 16),
                //               textAlign: pw.TextAlign.center
                //             ),
                //           ]
                //         ),
                //       pw.TableRow(
                //         children: [
                //           pw.SizedBox(height: 20),
                //         ]
                //       ),

                //     ]
                //   )
                //   : pw.Container(),
                //   ]
                // ),
              ]),
    );
    Printing.sharePdf(
        bytes: await doc.save(),
        filename:
            produtosNovos ? 'Relatório Produtos.pdf' : 'Relatório Pedidos.pdf');
  }
}

//// FUNÇÃO PARA REQUISIÇÃO DOS PEDIDOS DAS RESPECTIVAS DATAS////

Future recebePedidosPersonalizado({DateTime data1, DateTime data2}) {
  pedidosNovosEntrega.clear();
  pedidosNovosRetirada.clear();
  itensPedidosNovosEntrega = [];
  itensPedidosNovosRetirada = [];
  for (int i = 0; i < pedidos.length; i++) {
    DateFormat.yMd().format(pedidos[i].dataVenda);
    if (pedidos[i].statusPedido == itemSelecionadoRelatorio &&
        pedidos[i].dataVenda.isAfter(data1.add(Duration(days: -1))) &&
        pedidos[i].dataVenda.isBefore(data2.add(Duration(days: 1)))) {
      if (pedidos[i].tipoEntrega == 'Retirar no Local')
        pedidosNovosRetirada.add(pedidos[i]);
      else
        pedidosNovosEntrega.add(pedidos[i]);
    }
  }
}

// Lista itens do cesta
Future<List> listPedido(double type, Venda venda) async {
  String link =
      Basicos.codifica("${Basicos.ip}/crud/?crud=consult15.${venda.id}");
  var res1 = await http
      .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
  var res = Basicos.decodifica(res1.body);
  //print(res.body.length);
  //    new Future.delayed(const Duration(seconds: 1)) //snackbar
  //        .then((_) => _showSnackBar('Carregando...')); //snackbar
  print("Status Code: ${res1.statusCode}");
  if (res1.statusCode == 200) {
    // converte a lista de consulta em uma lista dinamica
    List list = json.decode(res).cast<Map<String, dynamic>>();
    // print("ID Pedido: ${venda.id}");
    // print(list);
    list.forEach((element) {
      print(venda.frete);
      print(venda.frete.runtimeType);
      if (double.parse(venda.frete) > 0.0) {
        itensPedidosNovosEntrega.add(RelatorioPedidosVendas(
          venda: venda,
          pedido: element,
        ));
      } else {
        itensPedidosNovosRetirada.add(RelatorioPedidosVendas(
          venda: venda,
          pedido: element,
        ));
      }
    });
    // if(type == 0) {
    //   itensPedidosNovosRetirada.add(
    //     RelatorioPedidosVendas(
    //       venda: venda,
    //       pedidos: list,
    //     )
    //   );
    //   print("entrou aqui 0");
    // }
    // else {
    // itensPedidosNovosEntrega.add(
    //   RelatorioPedidosVendas(
    //     venda: venda,
    //     pedidos: list,
    //   )
    // );
    //   print("entrou aqui 1.. Tamanho: ${itensPedidosNovosEntrega.length}");
    // }
    return list;
  }
  return null;
}

String get_picture(String imagem) {
  if (imagem == '') {
    return '${Basicos.ip}/media/estoque/produtos/img/product-01.jpg';
  } else {
    //print("${basicos().ip}/media/${prod_picture}");
    return "${Basicos.ip}/media/${imagem}";
  }
}
