import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final product =
        Provider.of<Products>(context, listen: false).findById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 200,
            child: Image.network(
              product.imgUrl,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 16),
          Text(
            '\$${product.price}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            '${product.description}',
            softWrap: true,
          ),
        ],
      ),
    );
  }
}
