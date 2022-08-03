import 'package:flutter/material.dart';
import 'package:mini_ecommerce/models/auth.dart';
import 'package:mini_ecommerce/models/cart.dart';
import 'package:mini_ecommerce/models/order_list.dart';
import 'package:mini_ecommerce/models/product_list.dart';
import 'package:mini_ecommerce/pages/auth_or_home_page.dart';
import 'package:mini_ecommerce/pages/cart_page.dart';
import 'package:mini_ecommerce/pages/orders_page.dart';
import 'package:mini_ecommerce/pages/product_detail_page.dart';
import 'package:mini_ecommerce/pages/product_form_page.dart';
import 'package:mini_ecommerce/pages/product_page.dart';
import 'package:provider/provider.dart';

// IMPORT ROUTES
import './utils/app_routes.dart';

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
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductList>(
          create: (_) => ProductList("", [], ""),
          update: (ctx, auth, previous) {
            return ProductList(
                auth.token ?? "", previous?.items ?? [], auth.uid ?? "");
          },
        ),
        ChangeNotifierProxyProvider<Auth, OrderList>(
          create: (_) => OrderList("", [], ""),
          update: (context, auth, previous) {
            return OrderList(
                auth.token ?? "", previous?.item ?? [], auth.uid ?? "");
          },
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
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
          AppRoutes.authOrHome: ((context) => const AuthOrHomePage()),
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
