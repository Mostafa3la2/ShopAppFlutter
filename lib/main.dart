import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shopapp/Providers/auth.dart';
import 'package:shopapp/Providers/cart.dart';
import 'package:shopapp/Providers/orders_provider.dart';
import 'package:shopapp/Screens/auth_screen.dart';
import 'package:shopapp/Screens/cart_screen.dart';
import 'package:shopapp/Screens/edit_product_screen.dart';
import 'package:shopapp/Screens/orders_screen.dart';
import 'package:shopapp/Screens/product_overview_screen.dart';
import 'package:shopapp/Screens/product_details_screen.dart';
import 'package:shopapp/Screens/user_products_screen.dart';
import 'Providers/product.dart';
import 'Providers/products_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => Auth()),
          ChangeNotifierProvider(
            create: (ctx) => Products(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Orders(),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              // Notice that the counter didn't reset back to zero; the application
              // is not restarted.
              colorScheme: ColorScheme.fromSwatch(
                  primarySwatch: Colors.deepPurple,
                  accentColor: Colors.amberAccent),
              fontFamily: 'Lato'),
          home: AuthScreen(),
          routes: {
            //ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
            AuthScreen.routeName: (ctx) => AuthScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ));
  }
}
