import 'package:flutter/material.dart';
import 'package:produtor/pages/dados_basicos.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:toast/toast.dart';
import 'package:produtor/pages/entrega_pedidos/entrega_pedidos.dart'; //formata numeros e datas
import 'dart:async';
import 'dart:convert';
import 'package:pdf/widgets.dart' as pw;
import 'package:toast/toast.dart';

import '../../soft_buttom.dart';

class Detalhe_Entrega extends StatefulWidget {
  // id_cliente da sessao
  final id_sessao;
  final id_pedido;
  final data_pedido;
  final frete;
  final tipo_entrega;
  final endereco;
  final numero;
  final bairro;
  final cidade;
  final estado;
  final complemento;
  final cep;
  final nome;
  final sobre_nome;
  String selectedStatus;

  Detalhe_Entrega(
      {this.id_sessao,
      this.id_pedido,
      this.data_pedido,
      this.frete,
      this.tipo_entrega,
      this.bairro,
      this.cep,
      this.cidade,
      this.complemento,
      this.endereco,
      this.estado,
      this.nome,
      this.numero,
      this.sobre_nome,
      this.selectedStatus});

  _Detalhe_Entrega createState() => _Detalhe_Entrega();
}

class _Detalhe_Entrega extends State<Detalhe_Entrega> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey(); // snackbar
  // barra de aviso
//  void _showSnackBar(String message) {
//    _scaffoldKey.currentState.showSnackBar(SnackBar(
//      content: Text(' '+
//        message,
//        textAlign: TextAlign.center,
//      ),
//      backgroundColor: Colors.black,
//      duration: Duration(seconds: 2),
//    ));
//  }
  StreamController streamTotal;
  ScrollController _controller; // controle o listview
  List Product_on_the_pedido = [];
  double _top = -60;

  @override
  void initState() {
    streamTotal = StreamController();
    Future.delayed(Duration(milliseconds: 250), () {
      setState(() {
        _top = 0;
      });
    });
    listPedido().then((resultado) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    streamTotal.close();
    super.dispose();
  }

  Future<bool> onWillPop() async {
    setState(() {
      _top = -60;
    });
    Basicos.offset = 0;
    Basicos.product_list = [];
    // Basicos.meus_pedidos = [];
    Future.delayed(Duration(milliseconds: 250), () {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => EntregaPedidoPage(
            id_sessao: widget.id_sessao,
            contemLista: 'Sim',
            selectedStatus: widget.selectedStatus),
      ));
    });
    return true;
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
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
                              'Itens do Pedido (${widget.id_pedido})',
                              style: TextStyle(
                                fontSize: 24,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 20.0, top: 10),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Text(entrega(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  )),
                            ),
                          ),
                          Divider(
                            thickness: .5,
                            indent: 20,
                            endIndent: 80,
                          ),
                          Expanded(
                            child: Scrollbar(
                              child: ListView.builder(
                                  controller: _controller,
                                  // retorna o laco com lista de produtos
                                  itemCount: Product_on_the_pedido.length,
                                  itemBuilder: (context, index) {
                                    return Single_pedido_product(
                                      sessao: widget.id_sessao,
                                      id_pedido: widget.id_pedido,
                                      data_pedido: widget.data_pedido,
                                      pedido_prod_name:
                                          Product_on_the_pedido[index]
                                              ["descricao_simplificada"],
                                      pedido_prod_id:
                                          Product_on_the_pedido[index]["ids"],
                                      pedido_prod_qtd:
                                          Product_on_the_pedido[index]
                                              ["quantidade"],
                                      //pedido_prod_size: Product_on_the_pedido[index]["Tamanho"],
                                      pedido_prod_price:
                                          Product_on_the_pedido[index]
                                              ["preco_venda"],
                                      pedido_prod_picture:
                                          Product_on_the_pedido[index]
                                              ["imagem"],
                                      pedido_situacao:
                                          Product_on_the_pedido[index]
                                              ["status"],
                                      marca: Product_on_the_pedido[index]
                                          ["descricao"],
                                      frete: widget.frete,
                                      tipo_entrega: widget.tipo_entrega,
                                      endereco: widget.endereco,
                                      numero: widget.numero,
                                      bairro: widget.bairro,
                                      cidade: widget.cidade,
                                      estado: widget.estado,
                                      complemento: widget.complemento,
                                      cep: widget.cep,
                                      pedido_nome_cliente: widget.nome,
                                      sobre_nome: widget.sobre_nome,
                                    );
                                  }),
                            ),
                          ),
                          Container(
                            color: Colors.grey.withOpacity(0.3),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  child: Expanded(
                                    child: ListTile(
                                      title: new Text(
                                        "Pedido: ", //  # ${widget.id_pedido}",
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          // fontWeight: FontWeight.bold,
                                          //color: Colors.red,
                                        ),
                                      ),
                                      subtitle: new Text(
                                        "# ${widget.id_pedido}",
                                        //"Situação: ${ widget.status_pedido}",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Expanded(
                                    child: ListTile(
                                      title: new Text(
                                        "Data Pedido:",
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          // fontWeight: FontWeight.bold,
                                          //color: Colors.red,
                                        ),
                                      ),
                                      subtitle: new Text(
                                        //"${widget.data_pedido}",
                                        '${widget.data_pedido.toString()}',
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Expanded(
                                    child: ListTile(
                                      title: new Text(
                                        "Total:",
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          // fontWeight: FontWeight.bold,
                                          //color: Colors.red,
                                        ),
                                      ),
                                      subtitle: StreamBuilder<Object>(
                                          stream: streamTotal.stream,
                                          initialData: 0,
                                          builder: (context, snapshot) {
                                            return Text(
                                              //"R\$ ${total().substring(0,total().indexOf('.'))}"+','+'${total().substring(total().indexOf('.')+1,4)}',
                                              "R\$ ${snapshot.data}",
                                              style: TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.teal,
                                              ),
                                            );
                                          }),
                                    ),
                                  ),
                                ),
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
                        Basicos.offset = 0;
                        Basicos.product_list = [];
                        // Basicos.meus_pedidos = [];
                        Future.delayed(Duration(milliseconds: 250), () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EntregaPedidoPage(
                                id_sessao: widget.id_sessao,
                                contemLista: 'Sim',
                                selectedStatus: widget.selectedStatus),
                          ));
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
    circular('inicio');

    doc.addPage(
      pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) => [
                pw.Wrap(alignment: pw.WrapAlignment.end, children: [
                  pw.Center(
                    child: pw.Text('Comprovante de Entrega',
                        style: pw.TextStyle(font: ttfBold, fontSize: 20),
                        textAlign: pw.TextAlign.center),
                  ),
                  pw.Center(
                    child: pw.Text(
                        '\nCliente: ${widget.nome} ${widget.sobre_nome}',
                        style: pw.TextStyle(font: ttfRegular, fontSize: 16),
                        textAlign: pw.TextAlign.center),
                  ),
                  pw.Center(
                    child: pw.Text(
                        'Pedido: nº ${widget.id_pedido}     ' +
                            'Entrega: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}',
                        style: pw.TextStyle(font: ttfRegular, fontSize: 16)),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.symmetric(horizontal: 10),
                    child: pw.Center(
                      child: pw.Text(
                          'Endereço: ' +
                              '${widget.endereco}, ${widget.numero} - ${widget.bairro}, '
                                  '${widget.cidade} - ${widget.estado}, ${widget.cep}. '
                                  'Complemento: ${widget.complemento}',
                          style: pw.TextStyle(font: ttfRegular, fontSize: 16),
                          textAlign: pw.TextAlign.center),
                    ),
                  ),
                  pw.Text(
                      '\n---------------------------------------------------------------------------------------------\n\n',
                      style: pw.TextStyle(font: ttfRegular, fontSize: 14),
                      textAlign: pw.TextAlign.center),
                  pw.Table(children: [
                    pw.TableRow(children: [
                      pw.Text('ID',
                          style: pw.TextStyle(font: ttfBold, fontSize: 16),
                          textAlign: pw.TextAlign.center),
                      pw.Text(' Produto',
                          style: pw.TextStyle(font: ttfBold, fontSize: 16),
                          textAlign: pw.TextAlign.center),
                      pw.Text('Qtd.',
                          style: pw.TextStyle(font: ttfBold, fontSize: 16),
                          textAlign: pw.TextAlign.center),
                      pw.Text(' Unit.',
                          style: pw.TextStyle(font: ttfBold, fontSize: 16),
                          textAlign: pw.TextAlign.center),
                      pw.Text(' Situação',
                          style: pw.TextStyle(font: ttfBold, fontSize: 16),
                          textAlign: pw.TextAlign.center),
                    ]),
                    for (int index = 0;
                        index < 18 && index < Product_on_the_pedido.length;
                        index++)
                      pw.TableRow(children: [
                        pw.Text(Product_on_the_pedido[index]["id"].toString(),
                            style: pw.TextStyle(font: ttfRegular, fontSize: 16),
                            textAlign: pw.TextAlign.center),
                        pw.Text(
                          ' ' +
                              Product_on_the_pedido[index]
                                  ["descricao_simplificada"],
                          style: pw.TextStyle(font: ttfRegular, fontSize: 16),
                          textAlign: pw.TextAlign.left,
                          maxLines: 2,
                        ),
                        pw.Text(
                            double.parse(
                                    Product_on_the_pedido[index]["quantidade"])
                                .toStringAsFixed(2),
                            style: pw.TextStyle(font: ttfRegular, fontSize: 16),
                            textAlign: pw.TextAlign.center),
                        pw.Text(
                            ' ' +
                                double.parse(Product_on_the_pedido[index]
                                        ["valor_unitario"])
                                    .toStringAsFixed(2),
                            style: pw.TextStyle(font: ttfRegular, fontSize: 16),
                            textAlign: pw.TextAlign.center),
                        pw.Container(
                          width: 130,
                          child: pw.Text(
                              ' ' + Product_on_the_pedido[index]["status"],
                              style:
                                  pw.TextStyle(font: ttfRegular, fontSize: 16),
                              textAlign: pw.TextAlign.center,
                              softWrap: false),
                        ),
                      ]),
                  ]),
                  if (Product_on_the_pedido.length >= 18)
                    pw.Table(children: [
                      for (int index = 18;
                          index <= 36 && index < Product_on_the_pedido.length;
                          index++)
                        pw.TableRow(children: [
                          pw.Text(Product_on_the_pedido[index]["id"].toString(),
                              style:
                                  pw.TextStyle(font: ttfRegular, fontSize: 16),
                              textAlign: pw.TextAlign.center),
                          pw.Text(
                            ' ' +
                                Product_on_the_pedido[index]
                                    ["descricao_simplificada"],
                            style: pw.TextStyle(font: ttfRegular, fontSize: 16),
                            textAlign: pw.TextAlign.left,
                            maxLines: 2,
                          ),
                          pw.Text(
                              double.parse(Product_on_the_pedido[index]
                                      ["quantidade"])
                                  .toStringAsFixed(2),
                              style:
                                  pw.TextStyle(font: ttfRegular, fontSize: 16),
                              textAlign: pw.TextAlign.center),
                          pw.Text(
                              ' ' +
                                  double.parse(Product_on_the_pedido[index]
                                          ["valor_unitario"])
                                      .toStringAsFixed(2),
                              style:
                                  pw.TextStyle(font: ttfRegular, fontSize: 16),
                              textAlign: pw.TextAlign.center),
                          pw.Container(
                            width: 130,
                            child: pw.Text(
                                ' ' + Product_on_the_pedido[index]["status"],
                                style: pw.TextStyle(
                                    font: ttfRegular, fontSize: 16),
                                textAlign: pw.TextAlign.center,
                                softWrap: false),
                          ),
                        ]),
                    ]),
                  if (Product_on_the_pedido.length >= 37)
                    pw.Table(children: [
                      for (int index = 37;
                          index <= 50 && index < Product_on_the_pedido.length;
                          index++)
                        pw.TableRow(children: [
                          pw.Text(Product_on_the_pedido[index]["id"].toString(),
                              style:
                                  pw.TextStyle(font: ttfRegular, fontSize: 16),
                              textAlign: pw.TextAlign.center),
                          pw.Text(
                            ' ' +
                                Product_on_the_pedido[index]
                                    ["descricao_simplificada"],
                            style: pw.TextStyle(font: ttfRegular, fontSize: 16),
                            textAlign: pw.TextAlign.left,
                            maxLines: 2,
                          ),
                          pw.Text(
                              double.parse(Product_on_the_pedido[index]
                                      ["quantidade"])
                                  .toStringAsFixed(2),
                              style:
                                  pw.TextStyle(font: ttfRegular, fontSize: 16),
                              textAlign: pw.TextAlign.center),
                          pw.Text(
                              ' ' +
                                  double.parse(Product_on_the_pedido[index]
                                          ["valor_unitario"])
                                      .toStringAsFixed(2),
                              style:
                                  pw.TextStyle(font: ttfRegular, fontSize: 16),
                              textAlign: pw.TextAlign.center),
                          pw.Container(
                            width: 130,
                            child: pw.Text(
                                ' ' + Product_on_the_pedido[index]["status"],
                                style: pw.TextStyle(
                                    font: ttfRegular, fontSize: 16),
                                textAlign: pw.TextAlign.center,
                                softWrap: false),
                          ),
                        ]),
                    ]),
                  pw.Text(
                      '\n---------------------------------------------------------------------------------------------\n',
                      style: pw.TextStyle(font: ttfRegular, fontSize: 14),
                      textAlign: pw.TextAlign.center),
                  pw.Text('Frete: R\$ ${widget.frete}',
                      style: pw.TextStyle(font: ttfRegular, fontSize: 16),
                      textAlign: pw.TextAlign.center),
                  pw.Divider(thickness: .5),
                  pw.Text('Total: R\$ ${total().toString()}',
                      style: pw.TextStyle(font: ttfBold, fontSize: 18),
                      textAlign: pw.TextAlign.center),
                ]),
              ]),
    );
    circular('fim');
    Printing.sharePdf(
        bytes: await doc.save(), filename: 'Comprovante de Entrega.pdf');
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
          ),
        ),
      );
    } else
      Navigator.pop(context);
  }

  String entrega() {
    if (widget.tipo_entrega == 'Retirar no Local')
      return widget.tipo_entrega;
    else
      return 'Entrega em Domicílio';
  }

  // Lista itens do cesta
  Future<List> listPedido() async {
    String link = Basicos.codifica(
        "${Basicos.ip}/crud/?crud=consult15.${widget.id_pedido}");
    var res1 = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    var res = Basicos.decodifica(res1.body);
    //print(res.body.length);
    //    new Future.delayed(const Duration(seconds: 1)) //snackbar
    //        .then((_) => _showSnackBar('Carregando...')); //snackbar
    if (res1.body.length > 2) {
      if (res1.statusCode == 200) {
        // converte a lista de consulta em uma lista dinamica
        List list = json.decode(res).cast<Map<String, dynamic>>();
        print(list[0]);
        Product_on_the_pedido = list;
        //print(Product_on_the_pedido);
        await total();
        //print(Product_on_the_pedido.length);
        return list;
      }
    }
  }

// soma os valores da cesta retorna o total
  String total() {
    var soma = 0.0;

    for (int i = 0; i < Product_on_the_pedido.length; i++) {
      if (Product_on_the_pedido[i]["status"] != "CANCELADO") {
        soma = soma +
            (double.parse(Product_on_the_pedido[i]["preco_venda"]) *
                double.parse(Product_on_the_pedido[i]["quantidade"]));
      } else
        soma += 0.0;
    }
    try {
      soma += double.parse(widget.frete);
      streamTotal.sink.add(soma.toStringAsFixed(2));
      return soma.toStringAsFixed(2);
    } catch (e) {
      streamTotal.sink.add(soma.toStringAsFixed(2));
      return soma.toStringAsFixed(2);
    }
  }
}

class Single_pedido_product extends StatelessWidget {
  final sessao;
  final id_pedido;
  final data_pedido;
  final pedido_prod_id;
  final pedido_prod_name;
  final pedido_prod_picture;
  final pedido_prod_price;
  final pedido_prod_size;
  final pedido_situacao;
  final pedido_prod_qtd;
  final marca;
  final frete;
  final tipo_entrega;
  final endereco;
  final numero;
  final bairro;
  final cidade;
  final estado;
  final complemento;
  final cep;
  final pedido_nome_cliente;
  final sobre_nome;

  Single_pedido_product(
      {this.sessao,
      this.id_pedido,
      this.data_pedido,
      this.pedido_prod_id,
      this.pedido_prod_name,
      this.pedido_situacao,
      this.pedido_prod_picture,
      this.pedido_prod_price,
      this.pedido_prod_qtd,
      this.pedido_prod_size,
      this.marca,
      this.bairro,
      this.cep,
      this.cidade,
      this.complemento,
      this.endereco,
      this.estado,
      this.frete,
      this.numero,
      this.pedido_nome_cliente,
      this.sobre_nome,
      this.tipo_entrega});

  @override
  Status _currentState;
  List<Status> status = <Status>[
    //  const Status("AGUARDANDO"),
    const Status('EM SEPARACAO'),
    const Status('SEPARADO'),
    //  const Status('ENTREGUE'),
    const Status('CANCELADO')
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      color: pedido_situacao == 'CANCELADO' ? Colors.red[50] : Colors.white,
      child: ListTile(
// ===================== sessao lista de compras
// imagem
        leading: Column(
          children: <Widget>[
            Container(
              width: 50.0,
              height: 43.0,
              padding: EdgeInsets.all(0.0), //diminui a figura
              child: Image.network(get_picture(), fit: BoxFit.fill),
            ),
            Text('# ${pedido_prod_id}',
                textScaleFactor: 0.7,
                style: TextStyle(
                  color: Colors.grey,
                )),
          ],
        ),
//texto descritivo

//=============== subttitulo da sessao
        title: Column(
          children: <Widget>[
            new Row(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // dentro da coluna
                Expanded(
                  child: new Text(
                    pedido_prod_name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            Text(
              marca,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            Row(
              children: <Widget>[
                new Text(
                  "Situação: ",
                  textAlign: TextAlign.left,
                  textScaleFactor: 0.9,
                ),
                new DropdownButton<Status>(
                  hint: Text(pedido_situacao),
                  value: _currentState,
                  onChanged: (Status newValue) async {
                    await grava_status(
                        pedido_prod_id.toString(),
                        newValue.name,
                        id_pedido.toString(),
                        pedido_situacao.toString(),
                        pedido_prod_price.toString(),
                        pedido_prod_qtd.toString());

                    Toast.show(
                        "Atualizando Situação \n do Ítem: " +
                            pedido_prod_id.toString(),
                        context,
                        duration: Toast.LENGTH_LONG,
                        gravity: Toast.CENTER,
                        backgroundRadius: 0.0);
                    _currentState = newValue;
                    //print(data_pedido);
                    Navigator.of(context).push(new MaterialPageRoute(
                      // aqui temos passagem de valores id cliente(sessao) de login para home
                      builder: (context) => new Detalhe_Entrega(
                        id_sessao: sessao,
                        id_pedido: id_pedido,
                        data_pedido: data_pedido,
                        frete: frete,
                        tipo_entrega: tipo_entrega,
                        endereco: endereco,
                        numero: numero,
                        bairro: bairro,
                        cidade: cidade,
                        estado: estado,
                        complemento: complemento,
                        cep: cep,
                        nome: pedido_nome_cliente,
                        sobre_nome: sobre_nome,
                      ),
                    ));
                  },
                  items: status.map((Status status) {
                    return new DropdownMenuItem<Status>(
                      value: status,
                      child: new Text(
                        status.name,
                        style: new TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 15,
                  ),
                )
              ],
            ),
          ],
        ),
        subtitle: Row(children: <Widget>[
          new Text(
            "Qtd: ",
            textAlign: TextAlign.left,
            textScaleFactor: 1.0,
          ),
          Padding(
            padding: EdgeInsets.only(left: 0, right: 10, bottom: 0, top: 0),
            child: IconButton(
              onPressed: () async {
                if (double.parse(pedido_prod_qtd) > 1.0) {
                  // verifica se é um
                  Toast.show(
                      "Atualizando Situação \n do Ítem: " +
                          pedido_prod_id.toString(),
                      context,
                      duration: Toast.LENGTH_LONG,
                      gravity: Toast.CENTER,
                      backgroundRadius: 0.0);

                  await decrementa_qtd(
                      pedido_prod_id.toString(),
                      id_pedido.toString(),
                      pedido_prod_price.toString(),
                      pedido_prod_qtd.toString());
                } else {
                  Toast.show(
                      " O mínimo é um item, para excluir mude \n a situação para cancelado ",
                      context,
                      duration: Toast.LENGTH_LONG,
                      gravity: Toast.CENTER,
                      backgroundRadius: 0.0);
                }

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Detalhe_Entrega(
                              id_sessao: sessao,
                              id_pedido: id_pedido,
                              data_pedido: data_pedido,
                            )));
              },
              icon: new Icon(
                Icons.remove_circle,
                // IconData(0xe15b, fontFamily: 'MaterialIcons'),
                // SINAL DE MENOS
                color: Colors.grey,
              ),
            ),
          ),
          Text(
            "${pedido_prod_qtd.toString().substring(0, pedido_prod_qtd.toString().indexOf('.', 0))}   ",
            textAlign: TextAlign.left,
            key: Key('texto1'),
            textScaleFactor: 1.1,
          ),
          Padding(
            padding: EdgeInsets.only(left: 0, right: 0, bottom: 0, top: 0),
            child: IconButton(
              onPressed: () async {
                Toast.show(
                    "Atualizando Situação \n do Ítem: " +
                        pedido_prod_id.toString(),
                    context,
                    duration: Toast.LENGTH_LONG,
                    gravity: Toast.CENTER,
                    backgroundRadius: 0.0);
                await incrementa_qtd(
                    pedido_prod_id.toString(),
                    id_pedido.toString(),
                    pedido_prod_price.toString(),
                    pedido_prod_qtd.toString());
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Detalhe_Entrega(
                              id_sessao: sessao,
                              id_pedido: id_pedido,
                              data_pedido: data_pedido,
                            )));
              },
              icon: new Icon(
                Icons.add_circle,
                color: Colors.grey,
              ),
            ),
          ),
          Flexible(
            child: Text(
              "R\$ ${pedido_prod_price}",
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ),
        ]),

//        trailing: Column(children: <Widget>[
//          Padding(
//            padding:
//                const EdgeInsets.only(left: 0, right: 10, bottom: 0, top: 0),
//            child: IconButton(
//              onPressed: () {
//                showDialog(
//                  context: context,
//                  barrierDismissible: false,
//                  // user must tap button for close dialog!
//                  builder: (BuildContext context) {
//                    return AlertDialog(
//                      title: Text('Remover'),
//                      content: const Text('Confirma Remover o Ítem?'),
//                      actions: <Widget>[
//                        FlatButton(
//                          child: const Text('Cancela'),
//                          onPressed: () {
//                            Navigator.of(context).pop(context);
//                          },
//                        ),
//                        FlatButton(
//                          child: const Text('Sim'),
//                          onPressed: () async {
//                            remove_item();
//                            Navigator.push(
//                                context,
//                                MaterialPageRoute(
//                                    builder: (context) =>
//                                        Detalhe_Entrega( id_sessao: sessao,
//                                          id_pedido: id_pedido,
//                                          data_pedido: data_pedido,)));
//                          },
//                        )
//                      ],
//                    );
//                  },
//                );
//              },
//              icon: new Icon(
//                Icons.delete,
//                color: Colors.grey,
//              ),
//            ),
//          ),
//        ]),
      ),
    );
  }

  Future<String> incrementa_qtd(final numero_produto, final id_pedido,
      final preco_produto, final quantidade) async {
    //print('${pedido_prod_qtd}');
    //adiciona um a quantidade do iten a cesta de compras
    String link = Basicos.codifica("${Basicos.ip}/crud/?crud=consult33."
        "${pedido_prod_id}"); //id_produto_pedido
    //print(link);
    var res1 = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    var res = Basicos.decodifica(res1.body);
    if (res1.body.length > 2) {
      if (res1.statusCode == 200) {
        // var list = json.decode(res.body) as String;

        //soma
        // atualiza saida produto soma do valor_total
        double valor = double.parse(preco_produto);
        String link = Basicos.codifica("${Basicos.ip}"
            "/crud/?crud=consu312.${numero_produto},${valor.toString()}");
        // print(valor);
        var res = await http
            .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
        if (res.body.length > 2) {
          if (res.statusCode == 200) {
            // atualiza vendas soma do valor_total
            String link = Basicos.codifica("${Basicos.ip}"
                "/crud/?crud=consu314.${id_pedido},${valor.toString()}");
            // print(valor);
            var res = await http.get(Uri.encodeFull(link),
                headers: {"Accept": "application/json"});
            if (res.body.length > 2) {
              if (res.statusCode == 200) {
                // atualiza contas a receber soma do valor_conta
                String link = Basicos.codifica("${Basicos.ip}"
                    "/crud/?crud=consu316.${id_pedido},${valor.toString()}");
                // print(valor);
                var res = await http.get(Uri.encodeFull(link),
                    headers: {"Accept": "application/json"});
                if (res.body.length > 2) {
                  if (res.statusCode == 200) {
                    // atualiza pagamentos recebidos soma do valor_conta
                    String link = Basicos.codifica("${Basicos.ip}"
                        "/crud/?crud=consu318.${'Pagamento referente ao pedido ' + id_pedido},${valor.toString()}");
                    // print(valor)
                    var res = await http.get(Uri.encodeFull(link),
                        headers: {"Accept": "application/json"});
                    if (res.body.length > 2) {
                      if (res.statusCode == 200) {}
                    }
                  }
                }
              }
            }
          }
        }
        return 'sucesso';
      }
    }
  }

  Future<String> decrementa_qtd(final numero_produto, final id_pedido,
      final preco_produto, final quantidade) async {
    //subtrai um a quantidade do iten a cesta de compras
    //print('${pedido_prod_qtd}');
    if (double.parse(pedido_prod_qtd) > 1.0) {
      // atualiza quantidade na tabela saida produto
      String link = Basicos.codifica("${Basicos.ip}/crud/?crud=consult34."
          "${pedido_prod_id}"); //id_produto_pedido
      //print(link);
      var res1 = await http
          .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
      var res = Basicos.decodifica(res1.body);
      if (res1.body.length > 2) {
        if (res1.statusCode == 200) {
          // (subtrai)
          // atualiza saida produto subtrai do valor_total
          double valor = double.parse(preco_produto);
          String link = Basicos.codifica("${Basicos.ip}"
              "/crud/?crud=consu311.${numero_produto},${valor.toString()}");
          // print(valor);
          var res = await http.get(Uri.encodeFull(link),
              headers: {"Accept": "application/json"});
          if (res.body.length > 2) {
            if (res.statusCode == 200) {
              // atualiza vendas subtrai do valor_total
              String link = Basicos.codifica("${Basicos.ip}"
                  "/crud/?crud=consu313.${id_pedido},${valor.toString()}");
              //   print(valor);
              var res = await http.get(Uri.encodeFull(link),
                  headers: {"Accept": "application/json"});
              if (res.body.length > 2) {
                if (res.statusCode == 200) {
                  // atualiza contas a receber subtrai do valor_conta
                  String link = Basicos.codifica("${Basicos.ip}"
                      "/crud/?crud=consu315.${id_pedido},${valor.toString()}");
                  // print(valor);
                  var res = await http.get(Uri.encodeFull(link),
                      headers: {"Accept": "application/json"});
                  if (res.body.length > 2) {
                    if (res.statusCode == 200) {
                      // atualiza pagamentos recebidos subtrai do valor_conta
                      String link = Basicos.codifica("${Basicos.ip}"
                          "/crud/?crud=consu317.${'Pagamento referente ao pedido ' + id_pedido},${valor.toString()}");
                      //     print(valor);
                      var res = await http.get(Uri.encodeFull(link),
                          headers: {"Accept": "application/json"});
                      if (res.body.length > 2) {
                        if (res.statusCode == 200) {}
                      }
                    }
                  }
                }
              }
            }
          }

          return 'sucesso';
        }
      }
    }
  }

// void remove_item() async {
//   // print(ObjectKey('${pedido_prod_id}').value);
//
//   //remove os itens da cesta de compras
//   String link = Basicos.codifica("${Basicos.ip}/crud/?crud=consult32."
//       "${pedido_prod_id}"); //id_produto_pedido
//   //print(link);
//   var res1 = await http
//       .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
//   var res = Basicos.decodifica(res1.body);
//   if (res1.body.length > 2) {
//     if (res1.statusCode == 200) {
//       // var list = json.decode(res.body) as String;
//       // var list = json.decode(res.body) as String;
//     }
//   }
// }

  String get_picture() {
    if (pedido_prod_picture == '') {
      return '${Basicos.ip2}/media/estoque/produtos/img/product-01.jpg';
    } else {
      //print("${basicos().ip}/media/${prod_picture}");
      return "${Basicos.ip2}/media/$pedido_prod_picture";
    }
  }

  //converte data em ingles para padrao brasileiro
  String inverte_data(String substring) {
    String temp = '';
    if (substring == 'null')
      return temp;
    else {
      temp = substring[8] + substring[9];
      temp = temp + '-' + substring[5] + substring[6];
      temp = temp + '-' + substring.toString().substring(0, 4);
      return temp;
    }
  }
}
//
//class Parametro {
//  static String tipo_pagamento = "DINHEIRO";
//
//  Parametro();
//}

Future<String> grava_status(
    final numero_produto,
    final situacao,
    final id_pedido,
    final estadoAtual,
    final preco_produto,
    final quantidade) async {
  String link = Basicos.codifica("${Basicos.ip}"
      "/crud/?crud=consult31.${numero_produto},${situacao}");
  //print(situacao);
  var res = await http
      .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
  //var res =Basicos.decodifica(res1.body);
  if (res.body.length > 2) {
    if (res.statusCode == 200) {
      if ((estadoAtual == 'EM SEPARACAO' && situacao == 'CANCELADO') ||
          (estadoAtual == 'SEPARADO' && situacao == 'CANCELADO')) {
        // (subtrai)
// atualiza saida produto subtrai do valor_total
        double valor = double.parse(preco_produto) * double.parse(quantidade);
        String link = Basicos.codifica("${Basicos.ip}"
            "/crud/?crud=consu311.${numero_produto},${valor.toString()}");
        // print(valor);
        var res = await http
            .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
        if (res.body.length > 2) {
          if (res.statusCode == 200) {
// atualiza vendas subtrai do valor_total
            String link = Basicos.codifica("${Basicos.ip}"
                "/crud/?crud=consu313.${id_pedido},${valor.toString()}");
            //   print(valor);
            var res = await http.get(Uri.encodeFull(link),
                headers: {"Accept": "application/json"});
            if (res.body.length > 2) {
              if (res.statusCode == 200) {
// atualiza contas a receber subtrai do valor_conta
                String link = Basicos.codifica("${Basicos.ip}"
                    "/crud/?crud=consu315.${id_pedido},${valor.toString()}");
                //    print(valor);
                var res = await http.get(Uri.encodeFull(link),
                    headers: {"Accept": "application/json"});
                if (res.body.length > 2) {
                  if (res.statusCode == 200) {
// atualiza pagamentos recebidos subtrai do valor_conta
                    String link = Basicos.codifica("${Basicos.ip}"
                        "/crud/?crud=consu317.${'Pagamento referente ao pedido ' + id_pedido},${valor.toString()}");
                    //       print(valor);
                    var res = await http.get(Uri.encodeFull(link),
                        headers: {"Accept": "application/json"});
                    if (res.body.length > 2) {
                      if (res.statusCode == 200) {}
                    }
                  }
                }
              }
            }
          }
        }
      } else if ((estadoAtual == 'CANCELADO' && situacao == 'EM SEPARACAO') ||
          (estadoAtual == 'CANCELADO' && situacao == 'SEPARADO')) {
        //soma
// atualiza saida produto soma do valor_total
        double valor = double.parse(preco_produto) * double.parse(quantidade);
        String link = Basicos.codifica("${Basicos.ip}"
            "/crud/?crud=consu312.${numero_produto},${valor.toString()}");
        // print(valor);
        var res = await http
            .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
        if (res.body.length > 2) {
          if (res.statusCode == 200) {
// atualiza vendas soma do valor_total
            String link = Basicos.codifica("${Basicos.ip}"
                "/crud/?crud=consu314.${id_pedido},${valor.toString()}");
            //  print(valor);
            var res = await http.get(Uri.encodeFull(link),
                headers: {"Accept": "application/json"});
            if (res.body.length > 2) {
              if (res.statusCode == 200) {
// atualiza contas a receber soma do valor_conta
                String link = Basicos.codifica("${Basicos.ip}"
                    "/crud/?crud=consu316.${id_pedido},${valor.toString()}");
                //   print(valor);
                var res = await http.get(Uri.encodeFull(link),
                    headers: {"Accept": "application/json"});
                if (res.body.length > 2) {
                  if (res.statusCode == 200) {
// atualiza pagamentos recebidos soma do valor_conta
                    String link = Basicos.codifica("${Basicos.ip}"
                        "/crud/?crud=consu318.${'Pagamento referente ao pedido ' + id_pedido},${valor.toString()}");
                    //     print(valor);
                    var res = await http.get(Uri.encodeFull(link),
                        headers: {"Accept": "application/json"});
                    if (res.body.length > 2) {
                      if (res.statusCode == 200) {}
                    }
                  }
                }
              }
            }
          }
        }
      }
      return 'sucesso';
    }
  }
}

//converte data em ingles para padrao brasileiro
String inverte_data(String substring) {
  String temp = '';
  if (substring == 'null')
    return temp;
  else {
    temp = substring[8] + substring[9];
    temp = temp + '-' + substring[5] + substring[6];
    temp = temp + '-' + substring.toString().substring(0, 4);
    return temp;
  }
}

class Status {
  const Status(this.name);

  final String name;
}
