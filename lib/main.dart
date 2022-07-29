import 'package:flutter/material.dart';
import 'package:mini_ecommerce/models/cart.dart';
import 'package:mini_ecommerce/models/order_list.dart';
import 'package:mini_ecommerce/models/product_list.dart';
import 'package:mini_ecommerce/pages/cart_page.dart';
import 'package:mini_ecommerce/pages/orders_page.dart';
import 'package:mini_ecommerce/pages/product_detail_page.dart';
import 'package:mini_ecommerce/pages/product_form_page.dart';
import 'package:mini_ecommerce/pages/product_page.dart';
import 'package:provider/provider.dart';

// IMPORT ROUTES
import './utils/app_routes.dart';

// IMPORT PAGES APP
import 'package:mini_ecommerce/pages/products_overview_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductList(),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderList(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        routes: {
          AppRoutes.home: ((context) => const ProductsOverviewPage()),
          AppRoutes.productDetail: ((context) => const ProductDetailPage()),
          AppRoutes.cart: ((context) => const CartPage()),
          AppRoutes.orders: ((context) => const OrdersPage()),
          AppRoutes.products: ((context) => const ProductsPage()),
          AppRoutes.productForm: ((context) => const ProductFormPage()),
        },
      ),
    );
  }
}
