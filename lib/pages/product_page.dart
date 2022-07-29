import 'package:flutter/material.dart';
import 'package:mini_ecommerce/components/app_drawer.dart';
import 'package:mini_ecommerce/models/product_list.dart';
import 'package:mini_ecommerce/utils/app_routes.dart';
import 'package:provider/provider.dart';

import '../components/product_item.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductList products = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gerenciar Produtos!"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.productForm);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: products.itemsCount,
          itemBuilder: (context, index) => Column(
            children: [
              ProductItem(
                product: products.items[index],
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
