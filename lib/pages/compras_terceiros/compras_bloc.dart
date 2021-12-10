import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:produtor/pages/compras_terceiros/tela_compra_estoque.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

//import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

import '../dados_basicos.dart';

class ComprasBloc extends BlocBase {
  List<Produto> listaProdutos = [];

  String selectedPgto;
  String selectedFornecedor;
  String selectedProduto;
  int count = 0;
  int parcela = 1;
  String dataEmissao;
  String status = '';

  final _numeroNotaFiscal = TextEditingController();
  final _naturezaOperacao = TextEditingController();
  final _razaoSocial = TextEditingController();
  final _dropDownFormadePagamento = TextEditingController();
  final _produtosNome = TextEditingController();
  final _produtosQuantidade = TextEditingController();
  final _produtosPreco = TextEditingController();
  final _parcelas = BehaviorSubject<int>();
  final _valorFaturamento = TextEditingController();

  TextEditingController get outNumeroNota => _numeroNotaFiscal;

  TextEditingController get outNaturezaOperacao => _naturezaOperacao;

  TextEditingController get outDropDownRazaoSocial => _razaoSocial;

  Stream<int> get outParcelas => _parcelas.stream;

  TextEditingController get outDropDownFormadePagamento =>
      _dropDownFormadePagamento;

  TextEditingController get outProdutosNome => _produtosNome;

  TextEditingController get outProdutosQuantidade => _produtosQuantidade;

  TextEditingController get outProdutosPreco => _produtosPreco;

  TextEditingController get outValorFaturamento => _valorFaturamento;

  addProduto() {
    if (selectedProduto.isNotEmpty &&
        _produtosQuantidade.text.isNotEmpty &&
        _produtosPreco.text.isNotEmpty) {
      listaProdutos.add(Produto(
        nome: selectedProduto,
        quantidade: _produtosQuantidade.value.text,
        preco: _produtosPreco.value.text,
      ));

      _produtosQuantidade.clear();
      _produtosPreco.clear();
      return "sucesso";
    } else
      return "erro";
  }

  addParcelas() {
    parcela++;
    _parcelas.value = parcela;
  }

  removeParcelas() {
    if (parcela > 1) {
      parcela--;
      _parcelas.value = parcela;
    }
  }

  removeProduto(int index) {
    listaProdutos.removeAt(index);
  }

  iniciaProduto(Produto produto) {
    listaProdutos.add(produto);
  }

  Future finalizaCompra(String id_sessao) async {
    status = '';
    if (_numeroNotaFiscal.text.length > 0) {
      if (selectedFornecedor != null) {
        if (selectedFornecedor.length > 0) {
          if (listaProdutos.length > 0) {
            if (formasdePagamento.length != 0) {
              if (_parcelas.value != 0) {
                // print('parcela: ${_parcelas.value}');
                if (_valorFaturamento.text.length != 0) {
                  double total = 0.0;
                  for (int i = 0; i < listaProdutos.length; i++) {
                    total += double.parse(listaProdutos[i].preco) *
                        double.parse(listaProdutos[i].quantidade);
                    //print(listaProdutos[i].nome);
                  }
                  if (total == double.parse(_valorFaturamento.value.text)) {
                    if (dataEmissao == null)
                      dataEmissao = DateTime.now().toString().substring(0, 10);
                    print('Numero da nota: ' + _numeroNotaFiscal.text);
                    print("Fornecedor:" + selectedFornecedor);
                    print(
                        "Quantidade de Produtos: " + '${listaProdutos.length}');
                    print("Tipo de Pagamento: " + selectedPgto);
                    print("Quantidade de Parcelas: " + '${_parcelas.value}');
                    print(
                        "Total do Faturamento: " + "${_valorFaturamento.text}");
                    // AQUI COLOCAR A CONSULTA PARA INSERIR A COMPRA NO BANCO DE DADOS//
                    //1) inserir na tabela compras compras
                    //2) inseir em conta a pagar
                    //3) fazer update em compras com o pagamento id
                    //4) inserir em entrada produtos a quantidade no estoque de produtos
                    //5) update quantidade e valor do produto

                    await gravaEstoque(
                        _numeroNotaFiscal.text,
                        dataEmissao,
                        selectedFornecedor,
                        _naturezaOperacao.text,
                        selectedPgto,
                        _parcelas.value,
                        _valorFaturamento.text,
                        id_sessao);

                    status = "Sucesso!";
                    print("status: " + "${status}");
                  } else {
                    total = 0;
                    status = "Valor de Faturamento Inválido";
                  }
                } else {
                  status = "Insira Valor Total da Nota";
                }
              } else {
                status = "Adicone Parcela";
              }
            } else {
              status = "Selecione Forma de Pagamento";
            }
          } else {
            status = "Insira um Produto";
          }
        } else {
          status = "Preencha Razão Social";
        }
      } else {
        status = "Preencha Razão Social";
      }
    } else {
      status = "Preencha Nº Fiscal";
    }
  }

  @override
  void dispose() {
    _numeroNotaFiscal.dispose();
    _naturezaOperacao.dispose();
    _razaoSocial.dispose();
    _parcelas.close();
    _produtosNome.dispose();
    _produtosQuantidade.dispose();
    _produtosPreco.dispose();
    _dropDownFormadePagamento.dispose();
    _valorFaturamento.dispose();
  }

  // grava os dados de estoque
//Future<String> gravaEstoque(
//    String estoque,
//    String preco,
//    String data_cadastro,
//    String data_validade,
//    String produto,
//    String estoque_atual) async {

  Future<String> gravaEstoque(
      String numeroNotaFiscal,
      String dataEmissao_,
      String _selectedFornecedor,
      String naturezaOperacao,
      String _selectedPgto,
      int par,
      String valorFaturamento,
      String id_sessao_) async {
    print(
        '${numeroNotaFiscal},${dataEmissao_},${_selectedFornecedor.substring(0, _selectedFornecedor.indexOf('-', 0))},'
        '${naturezaOperacao},${_selectedPgto},${par.toString()},${valorFaturamento},${id_sessao_}');
// sequencia para registro de entrada no estoque
    par = 1; // fixa parcela em uma depois implementar parcelamento
//  //1) inserir na tabela compras
    String link = Basicos.codifica("${Basicos.ip}/crud/?crud=consult95."
        //    id integer NOT NULL DEFAULT nextval('compras_id_seq'::regclass),
        //    solicitante character varying(20) NOT NULL,
        "${dataEmissao_}," //    data_compra date NOT NULL,
        "${numeroNotaFiscal}," //    nota_fiscal character varying(15) NOT NULL,
        "${valorFaturamento}," //    valor_total numeric(15,2) NOT NULL,
        //    status_compra character varying(30) NOT NULL,
        //    observacoes text NOT NULL,
        //    data_registro timestamp with time zone NOT NULL,
        //    data_alteracao timestamp with time zone NOT NULL,
        "${id_sessao_}," //    empresa_id integer,
        "${_selectedFornecedor.substring(0, _selectedFornecedor.indexOf('-', 0))}," //    fornecedor_id integer NOT NULL,
        //    pagamento_id integer,
        );

    var res1 = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    var res2 = Basicos.decodifica(res1.body);
    if (res1.body.length > 2) {
      if (res1.statusCode == 200) {
        var list = json.decode(res2).cast<Map<String, dynamic>>();
        print(list[0]['id']); // retorna o id inserido na tabelas
        // caso inserido com sucesso e id retornado insere os produtos na tabela saida_produtos
        if (list[0]['id'] != Null) {
//2) inseir em conta a pagar
          String link2 = Basicos.codifica("${Basicos.ip}/crud/?crud=consult96."
              //    id integer NOT NULL DEFAULT nextval('produtos_id_seq'::regclass),
              //        data_conta,
              "${valorFaturamento}," //        valor_conta,
              "${_selectedPgto}," //        forma_de_pagamento,
              //        meio_de_pagamento,
              "${par.toString()}," //        quantidade_parcelas,
              //        primeiro_vencimento,
              //        valor_entrada,
              //        documento_vinculado,
              //        status_conta,
              //        descricao,
              //        data_registro,
              //        data_alteracao,
              //        observacoes_conta,
              "${id_sessao_}," //        empresa_id,
              "${list[0]['id']}," //        favorecido_id,
              "${_selectedFornecedor.substring(0, _selectedFornecedor.indexOf('-', 0))}" // fornecedor_id
              );

          var res3 = await http.get(Uri.encodeFull(link2),
              headers: {"Accept": "application/json"});
          var res4 = Basicos.decodifica(res3.body);

          if (res3.body.length > 2) {
            if (res3.statusCode == 200) {
              var list2 = json.decode(res4).cast<Map<String, dynamic>>();
              //print(list[0]['id']); // retorna o id inserido na tabelas
              // caso inserido com sucesso e id retornado insere os produtos na tabela saida_produtos
              if (list2[0]['id'] != Null) {
// fazer update em compras com o pagamento id
                String link3 =
                    Basicos.codifica("${Basicos.ip}/crud/?crud=consult54."
                        "${list[0]['id']}," //        id de compras,
                        "${list2[0]['id']}" //        pagamento_id,
                        );
                var res3 = await http.get(Uri.encodeFull(link3),
                    headers: {"Accept": "application/json"});

//// inserir em entrada produtos a quantidade no estoque de produtos
                for (int i = 0; i < listaProdutos.length; i++) {
                  String link4 = Basicos.codifica(
                      "${Basicos.ip}/crud/?crud=consult97."
                      //    id integer NOT NULL DEFAULT nextval('entrada_produtos_id_seq'::regclass),
                      "${listaProdutos[i].quantidade}," //    quantidade numeric(15,3) NOT NULL
                      "${listaProdutos[i].preco}," //    preco_compra numeric(15,3) NOT NULL,
                      "${DateTime.now().toString().substring(0, 10)}," //    data_entrada date NOT NULL,
                      //    data_fabricacao date,
                      "${DateTime.now().toString().substring(0, 10)}," //    data_validade date,
                      //    numero_lote character varying(20) NOT NULL
                      "${(double.parse(listaProdutos[i].quantidade) * double.parse(listaProdutos[i].preco)).toString()}," //    total numeric(15,2) NOT NULL,
                      //    balanco character varying(20) NOT NULL,
                      //    status_entrada character varying(15) NOT NULL,
                      //    observacoes_entrada text NOT NULL,
                      "${DateTime.now()}," //    data_registro timestamp with time zone NOT NULL,
                      //    data_alteracao timestamp with time zone NOT NULL,
                      "${list[0]['id']}," //    compra_id integer,
                      "${id_sessao_}," //    empresa_id integer,
                      "${listaProdutos[i].nome.substring(0, listaProdutos[i].nome.indexOf('-', 0))}" //    produto_id integer,
                      );
                  var res5 = await http.get(Uri.encodeFull(link4),
                      headers: {"Accept": "application/json"});
                  var res6 = Basicos.decodifica(res5.body);
                  if (res5.body.length > 2) {
                    if (res5.statusCode == 200) {
                      var list2 =
                          json.decode(res6).cast<Map<String, dynamic>>();
// update quantidade e valor do produto

                      String link5 = Basicos.codifica(
                          "${Basicos.ip}/crud/?crud=consult56."
                          "${listaProdutos[i].nome.substring(0, listaProdutos[i].nome.indexOf('-', 0))}," //        id de produto,
                          "${(double.parse(listaProdutos[i].quantidade) + double.parse(listaProdutos[i].nome.substring(listaProdutos[i].nome.indexOf('(', 0) + 1, listaProdutos[i].nome.indexOf(')', 0)))).toString()}," //        estoque atual,
                          "${listaProdutos[i].preco}" //        preco venda,
                          );
                      print("${Basicos.ip}/crud/?crud=consult56."
                          "${listaProdutos[i].nome.substring(0, listaProdutos[i].nome.indexOf('-', 0))}," //        id de produto,
                          "${(double.parse(listaProdutos[i].quantidade) + double.parse(listaProdutos[i].nome.substring(listaProdutos[i].nome.indexOf('(', 0) + 1, listaProdutos[i].nome.indexOf(')', 0)))).toString()}," //        estoque atual,
                          "${listaProdutos[i].preco}");
                      var res7 = await http.get(Uri.encodeFull(link5),
                          headers: {"Accept": "application/json"});
                      return "sucesso";
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

class Produto {
  String nome;
  String quantidade;
  String preco;

  Produto({this.nome, this.quantidade, this.preco});

  factory Produto.toMap(Map<String, dynamic> parsedStream) {
    return Produto(
        nome: parsedStream['nome'],
        quantidade: parsedStream['quantidade'],
        preco: parsedStream['preco']);
  }
}
