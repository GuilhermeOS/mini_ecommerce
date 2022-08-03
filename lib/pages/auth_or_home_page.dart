import 'package:flutter/material.dart';
import 'package:mini_ecommerce/models/auth.dart';
import 'package:mini_ecommerce/pages/auth_page.dart';
import 'package:mini_ecommerce/pages/products_overview_page.dart';
import 'package:provider/provider.dart';

class AuthOrHomePage extends StatelessWidget {
  const AuthOrHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context);
    return FutureBuilder(
      future: auth.tryAutoLogin(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.error != null) {
          return const Center(
            child: Text("Ocorreu um erro"),
          );
        } else {
          return auth.isAuth ? const ProductsOverviewPage() : const AuthPage();
        }
      }),
    );
  }
}
