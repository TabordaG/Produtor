import 'dart:async';
import 'package:produtor/pages/relatorio/relatorio_page.dart';
import 'package:produtor/pages/relatorio/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';

import '../../soft_buttom.dart';
import '../dados_basicos.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class RelatorioDiario extends StatefulWidget {
  final id_sessao;
  final DateTime data1;

  @override
  _RelatorioDiaroState createState() => _RelatorioDiaroState();

  RelatorioDiario({this.id_sessao, this.data1});
}

class _RelatorioDiaroState extends State<RelatorioDiario> {
  double _top = -60;
  ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    Future.delayed(Duration(milliseconds: 250), () {
      setState(() {
        _top = 0;
      });
    });
    super.initState();
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
                              'Relatório Diário',
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
                              color: Colors.teal, //Color(0xFF004d4d),
                            ),
                            child: TabBar(tabs: <Widget>[
                              Tab(
                                text: 'Entrega',
                                icon: Icon(Icons.local_shipping),
                              ),
                              Tab(
                                text: 'Retirada no Local',
                                icon: Icon(Icons.store),
                              )
                            ], indicatorColor: Colors.grey),
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
                                                                right: 20.0,
                                                                top: 10),
                                                        child: Align(
                                                          alignment: Alignment
                                                              .bottomRight,
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
                                                        indent: 20,
                                                        endIndent: 80,
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
                                                                right: 20.0,
                                                                top: 10),
                                                        child: Align(
                                                          alignment: Alignment
                                                              .bottomRight,
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
                                                        indent: 20,
                                                        endIndent: 80,
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
                          Navigator.of(context).pop();
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          //       RelatorioPage(
                          //         id_sessao: widget.id_sessao,
                          //       )
                          //   )
                          // );
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
                    onPressed: _printDocument,
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

  Future<void> _printDocument() async {
    pw.Document.debug = false;
    final doc = pw.Document();
    final fontBold = await rootBundle.load("assets/OpenSans-Bold.ttf");
    final fontRegular = await rootBundle.load("assets/OpenSans-Regular.ttf");
    final ttfBold = pw.Font.ttf(fontBold);
    final ttfRegular = pw.Font.ttf(fontRegular);
    List<MarcaProduto> marcaProdutoEntrega2 = [];
    List<MarcaProduto> marcaProdutoRetirada2 = [];
    List<List<Venda>> pedidosNovosEntrega2 = [];
    List<List<Venda>> pedidosNovosRetirada2 = [];
    List<Venda> pedidosList = [];
    circular('inicio');

    //#### Pedido Entrega
    pedidosNovosEntrega.forEach((element) {
      if (pedidosList.length < 3) {
        pedidosList.add(element);
      } else {
        pedidosList.add(element);
        pedidosNovosEntrega2.add(pedidosList);
        pedidosList = [];
      }
    });
    if (pedidosList.length > 0) {
      pedidosNovosEntrega2.add(pedidosList);
      pedidosList = [];
    }

    //#### Pedido Retirada
    pedidosNovosRetirada.forEach((element) {
      if (pedidosList.length < 3) {
        pedidosList.add(element);
      } else {
        pedidosList.add(element);
        pedidosNovosRetirada2.add(pedidosList);
        pedidosList = [];
      }
    });
    if (pedidosList.length > 0) {
      pedidosNovosRetirada2.add(pedidosList);
      pedidosList = [];
    }

    //#### Produto Entrega
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

    marcaProdutoEntrega2.sort((a, b) => a.marca.compareTo(b.marca));
    marcaProdutoEntrega2.forEach((element) {
      element.produtos.sort((a, b) => a.nomeProduto.compareTo(b.nomeProduto));
    });

    //#### Produto Retirada
    marcaProdutoRetirada.forEach((element) {
      List<ProdutosRelatorio> produtosList = [];
      if (element.produtos.length > 25) {
        int i = 0;
        while (i < element.produtos.length) {
          produtosList.add(element.produtos[i]);
          if (i % 25 == 0) {
            marcaProdutoRetirada2.add(
                MarcaProduto(marca: element.marca, produtos: element.produtos));
            produtosList = [];
          }
          i++;
        }
        marcaProdutoRetirada2.add(
            MarcaProduto(marca: element.marca, produtos: element.produtos));
      } else {
        marcaProdutoRetirada2.add(
            MarcaProduto(marca: element.marca, produtos: element.produtos));
      }
    });

    marcaProdutoRetirada2.sort((a, b) => a.marca.compareTo(b.marca));
    marcaProdutoRetirada2.forEach((element) {
      element.produtos.sort((a, b) => a.nomeProduto.compareTo(b.nomeProduto));
    });

    doc.addPage(
      pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) => [
                pw.Wrap(children: [
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
                        'Período Diário: ${widget.data1.day}/${widget.data1.month}/${widget.data1.year}',
                        style: pw.TextStyle(font: ttfBold, fontSize: 18)),
                  ),
                  pw.Center(
                    child: pw.Text(
                        'Data de Consulta: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}\n',
                        style: pw.TextStyle(font: ttfRegular, fontSize: 18),
                        textAlign: pw.TextAlign.center),
                  ),
                  produtosNovos == false
                      ? pw.Text(
                          '\nPedidos para Entrega ______________________________\n',
                          style: pw.TextStyle(font: ttfBold, fontSize: 20))
                      : pw.Container(),
                  if (produtosNovos == false)
                    for (List<Venda> listaPedidos in pedidosNovosEntrega2)
                      pw.Table(children: [
                        for (Venda pedido in listaPedidos)
                          pw.TableRow(children: [
                            pw.RichText(
                                text: pw.TextSpan(children: [
                              pw.TextSpan(
                                  text:
                                      '\n#${pedido.id}  Cliente: ${pedido.cliente}',
                                  style: pw.TextStyle(
                                      font: ttfBold, fontSize: 18)),
                              pw.TextSpan(
                                  text: '\nEndereço: ',
                                  style: pw.TextStyle(
                                      font: ttfBold, fontSize: 18)),
                              pw.TextSpan(
                                  text:
                                      '${pedido.endereco}, ${pedido.numero} - ${pedido.bairro}, ${pedido.cidade} - ${pedido.estado}',
                                  style: pw.TextStyle(
                                      font: ttfRegular, fontSize: 18)),
                              pw.TextSpan(
                                  text: '\nCelular: ',
                                  style: pw.TextStyle(
                                      font: ttfBold, fontSize: 18)),
                              pw.TextSpan(
                                  text: '${pedido.produtor}',
                                  style: pw.TextStyle(
                                      font: ttfRegular, fontSize: 18)),
                              pw.TextSpan(
                                  text: '\t\t\tData: ',
                                  style: pw.TextStyle(
                                      font: ttfBold, fontSize: 18)),
                              pw.TextSpan(
                                  text:
                                      '${pedido.dataVenda.day}/${pedido.dataVenda.month}/${pedido.dataVenda.year}',
                                  style: pw.TextStyle(
                                      font: ttfRegular, fontSize: 18)),
                              pw.TextSpan(
                                  text: '\nSituação do Pedido: ',
                                  style: pw.TextStyle(
                                      font: ttfBold, fontSize: 18)),
                              pw.TextSpan(
                                  text: '${pedido.statusPedido}',
                                  style: pw.TextStyle(
                                      font: ttfRegular, fontSize: 18)),
                              pw.TextSpan(
                                  text: '\nTotal Sem Frete: ',
                                  style: pw.TextStyle(
                                      font: ttfBold, fontSize: 18)),
                              pw.TextSpan(
                                  text: '${pedido.total}\n',
                                  style: pw.TextStyle(
                                      font: ttfRegular, fontSize: 18)),
                            ])),
                          ])
                      ]),
                  produtosNovos == true
                      ? pw.Center(
                          child: pw.Text('\nProdutos para Entrega\n',
                              style: pw.TextStyle(font: ttfBold, fontSize: 18),
                              textAlign: pw.TextAlign.center),
                        )
                      : pw.Container(),
                  for (MarcaProduto marca in marcaProdutoEntrega2)
                    produtosNovos == true
                        ? pw.Table(children: [
                            pw.TableRow(children: [
                              pw.Padding(
                                padding:
                                    pw.EdgeInsets.only(right: 20.0, top: 10),
                                child: pw.Align(
                                  alignment: pw.Alignment.bottomLeft,
                                  child: pw.Text(marca.marca,
                                      style: pw.TextStyle(
                                          font: ttfBold, fontSize: 18)),
                                ),
                              ),
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
                                  textAlign: pw.TextAlign.center),
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
                                    textAlign: pw.TextAlign.center),
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
                  pw.Text(
                      '\n------------------------------------------------------------------------\n',
                      style: pw.TextStyle(font: ttfRegular, fontSize: 20),
                      textAlign: pw.TextAlign.center),
                  produtosNovos == false
                      ? pw.Text(
                          '\nPedidos para Retirada ______________________________\n',
                          style: pw.TextStyle(font: ttfBold, fontSize: 20))
                      : pw.Container(),
                  if (produtosNovos == false)
                    for (List<Venda> listaPedidos in pedidosNovosRetirada2)
                      pw.Table(children: [
                        for (Venda pedido in listaPedidos)
                          pw.TableRow(children: [
                            pw.RichText(
                                text: pw.TextSpan(children: [
                              pw.TextSpan(
                                  text:
                                      '\n#${pedido.id}  Cliente: ${pedido.cliente}',
                                  style: pw.TextStyle(
                                      font: ttfBold, fontSize: 18)),
                              pw.TextSpan(
                                  text: '\nEndereço: ',
                                  style: pw.TextStyle(
                                      font: ttfBold, fontSize: 18)),
                              pw.TextSpan(
                                  text:
                                      '${pedido.endereco}, ${pedido.numero} - ${pedido.bairro}, ${pedido.cidade} - ${pedido.estado}',
                                  style: pw.TextStyle(
                                      font: ttfRegular, fontSize: 18)),
                              pw.TextSpan(
                                  text: '\nCelular: ',
                                  style: pw.TextStyle(
                                      font: ttfBold, fontSize: 18)),
                              pw.TextSpan(
                                  text: '${pedido.produtor}',
                                  style: pw.TextStyle(
                                      font: ttfRegular, fontSize: 18)),
                              pw.TextSpan(
                                  text: '\t\t\tData: ',
                                  style: pw.TextStyle(
                                      font: ttfBold, fontSize: 18)),
                              pw.TextSpan(
                                  text:
                                      '${pedido.dataVenda.day}/${pedido.dataVenda.month}/${pedido.dataVenda.year}',
                                  style: pw.TextStyle(
                                      font: ttfRegular, fontSize: 18)),
                              pw.TextSpan(
                                  text: '\nSituação do Pedido: ',
                                  style: pw.TextStyle(
                                      font: ttfBold, fontSize: 18)),
                              pw.TextSpan(
                                  text: '${pedido.statusPedido}',
                                  style: pw.TextStyle(
                                      font: ttfRegular, fontSize: 18)),
                              pw.TextSpan(
                                  text: '\nTotal Sem Frete: ',
                                  style: pw.TextStyle(
                                      font: ttfBold, fontSize: 18)),
                              pw.TextSpan(
                                  text: '${pedido.total}\n',
                                  style: pw.TextStyle(
                                      font: ttfRegular, fontSize: 18)),
                            ])),
                          ])
                      ]),
                  produtosNovos == true
                      ? pw.Center(
                          child: pw.Text('\nProdutos para Retirada\n',
                              style: pw.TextStyle(font: ttfBold, fontSize: 18),
                              textAlign: pw.TextAlign.center),
                        )
                      : pw.Container(),
                  for (MarcaProduto marca in marcaProdutoRetirada2)
                    produtosNovos == true
                        ? pw.Wrap(children: [
                            pw.Padding(
                              padding: pw.EdgeInsets.only(right: 20.0, top: 10),
                              child: pw.Align(
                                alignment: pw.Alignment.bottomLeft,
                                child: pw.Text(marca.marca,
                                    style: pw.TextStyle(
                                        font: ttfBold, fontSize: 18)),
                              ),
                            ),
                            pw.Divider(
                              thickness: .5,
                              indent: 70,
                              endIndent: 10,
                            ),
                            pw.Table(children: [
                              pw.TableRow(children: [
                                pw.Text(' ID',
                                    style: pw.TextStyle(
                                        font: ttfBold, fontSize: 16),
                                    textAlign: pw.TextAlign.center),
                                pw.Text('Produto',
                                    style: pw.TextStyle(
                                        font: ttfBold, fontSize: 16),
                                    textAlign: pw.TextAlign.center),
                                pw.Text('Quantidade',
                                    style: pw.TextStyle(
                                        font: ttfBold, fontSize: 16),
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
                                      textAlign: pw.TextAlign.center),
                                  pw.Text(
                                      marca.produtos[index].quantidade
                                          .toString(),
                                      style: pw.TextStyle(
                                          font: ttfRegular, fontSize: 16),
                                      textAlign: pw.TextAlign.center),
                                ]),
                            ]),
                            pw.SizedBox(height: 20),
                          ])
                        : pw.Container(),
                ]),
              ]),
    );
    circular('fim');
    Printing.sharePdf(
        bytes: await doc.save(),
        filename:
            produtosNovos ? 'Relatório Produtos.pdf' : 'Relatório Pedidos.pdf');
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
}

////FUNÇÃO PARA PEGAR OS PEDIDOS COM A RESPECTIVA DATA /////

Future recebePedidosDiario({DateTime data}) {
  //print('--------->${data}');
  pedidosNovosRetirada.clear();
  pedidosNovosEntrega.clear();
  for (int i = 0; i < pedidos.length; i++) {
    if (pedidos[i].statusPedido == itemSelecionadoRelatorio &&
        pedidos[i].dataVenda.day == data.day &&
        pedidos[i].dataVenda.month == data.month &&
        pedidos[i].dataVenda.year == data.year) {
      if (pedidos[i].tipoEntrega == 'Retirar no Local')
        pedidosNovosRetirada.add(pedidos[i]);
      else
        pedidosNovosEntrega.add(pedidos[i]);
    }
  }
}

String get_picture(String imagem) {
  if (imagem == '') {
    return '${Basicos.ip}/media/estoque/produtos/img/product-01.jpg';
  } else {
    return "${Basicos.ip}/media/${imagem}";
  }
}
