import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pushNamed('/edit-product'),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: products.items.length,
        itemBuilder: (_, i) => Column(
          children: <Widget>[
            UserProductItem(
              products.items[i].title,
              products.items[i].imgUrl,
            ),
            Divider()
          ],
        ),
      ),
    );
  }
}
