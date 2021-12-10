import 'package:flutter/material.dart';

class _ArticleDescription extends StatelessWidget {
  _ArticleDescription({
    Key key,
    this.title,
    this.subtitle,
    this.author,
    this.publishDate,
    this.readDuration,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String author;
  final DateTime publishDate;
  final String readDuration;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '$title',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 5.0)),
        Text(
          subtitle,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: const TextStyle(
            fontSize: 14.0,
            color: Colors.black87,
          ),
        ),
        Text(
          'Data Venda: ${publishDate.day}/${publishDate.month}/${publishDate.year}',
          style: const TextStyle(
            fontSize: 14.0,
            color: Colors.black87,
          ),
        ),
        Text(
          'Celular: $author',
          style: const TextStyle(
            fontSize: 14.0,
            color: Colors.black,
          ),
        ),
        Row(
          children: <Widget>[
            Text(
              'Status: ',
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.black,
              ),
            ),
            Container(
              //width: 102,
              child: Text(
                '$readDuration',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ],
    );
  }
}

class CustomListItemTwo extends StatelessWidget {
  CustomListItemTwo({
    Key key,
    this.title,
    this.subtitle,
    this.author,
    this.publishDate,
    this.readDuration,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String author;
  final DateTime publishDate;
  final String readDuration;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: _ArticleDescription(
          title: title,
          subtitle: subtitle,
          author: author,
          publishDate: publishDate,
          readDuration: readDuration,
        ),
      ),
    );
  }
}

class _ArticleDescriptionProduct extends StatelessWidget {
  _ArticleDescriptionProduct({
    Key key,
    this.idProduct,
    this.imagem,
    this.nameProduct,
    this.amountProduct,
  }) : super(key: key);

  final String idProduct;
  final String imagem;
  final String nameProduct;
  final String amountProduct;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.blue,
            image: DecorationImage(
              image: NetworkImage(imagem),
              fit: BoxFit.cover,
            ),
            border: Border.all(width: 1.0, color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Código: ${idProduct}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                ),
                Text(
                  nameProduct,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Quantidade:',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
              ),
              Text(
                '$amountProduct',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: const TextStyle(
                    fontSize: 22.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomListProduct extends StatelessWidget {
  CustomListProduct({
    Key key,
    this.idProduct,
    this.imagem,
    this.nameProduct,
    this.amountProduct,
  }) : super(key: key);

  final String idProduct;
  final String imagem;
  final String nameProduct;
  final String amountProduct;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: _ArticleDescriptionProduct(
          idProduct: idProduct,
          imagem: imagem,
          nameProduct: nameProduct,
          amountProduct: amountProduct,
        ),
      ),
    );
  }
}