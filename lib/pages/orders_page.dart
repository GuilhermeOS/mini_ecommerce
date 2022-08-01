import 'package:flutter/material.dart';
import 'package:mini_ecommerce/components/app_drawer.dart';
import 'package:mini_ecommerce/components/order.dart';
import 'package:mini_ecommerce/models/order_list.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus pedidos!"),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<OrderList>(
          context,
          listen: false,
        ).loadOrders(),
        builder: (ctx, snapsshot) {
          if (snapsshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapsshot.error != null) {
            return const Center(
              child: Text("Ocorreu um erro!"),
            );
          } else {
            return Consumer<OrderList>(
              builder: (ctx, orders, child) => ListView.builder(
                itemCount: orders.itemsCount,
                itemBuilder: (ctx, index) => OrderWidget(
                  order: orders.item[index],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
