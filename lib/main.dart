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
import 'package:shopapp/helpers/custom_route.dart';
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
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (ctx, auth, previousProducts) => Products(
                auth.token,
                auth.userID,
                previousProducts != null ? previousProducts.items : []),
            create: (ctx) => Products.c(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            update: (ctx, auth, previousOrders) => Orders(
                auth.token,
                auth.userID,
                previousOrders != null ? previousOrders!.orders : []),
            create: (ctx) => Orders.c(),
          ),
        ],
        child: Consumer<Auth>(
            builder: (ctx, auth, child) => MaterialApp(
                  title: 'Shop App',
                  theme: ThemeData(
                      colorScheme: ColorScheme.fromSwatch(
                          primarySwatch: Colors.deepPurple,
                          accentColor: Colors.amberAccent),
                      fontFamily: 'Lato',
                      pageTransitionsTheme: PageTransitionsTheme(builders: {
                        TargetPlatform.android: CustomPageTransitionBuilder(),
                        TargetPlatform.iOS: CustomPageTransitionBuilder()
                      })),
                  home: auth.isAuth
                      ? ProductOverViewScreen()
                      : FutureBuilder(
                          future: auth.tryAutoLogin(),
                          builder: (ctx, authSnapShot) =>
                              authSnapShot.connectionState ==
                                      ConnectionState.waiting
                                  ? Scaffold(
                                      body: Center(
                                      child: CircularProgressIndicator(),
                                    ))
                                  : AuthScreen()),
                  routes: {
                    //ProductDetailsScreen.routeName: (ctx) =>ProductDetailsScreen(),
                    AuthScreen.routeName: (ctx) => AuthScreen(),
                    CartScreen.routeName: (ctx) => CartScreen(),
                    OrdersScreen.routeName: (ctx) => OrdersScreen(),
                    UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
                    EditProductScreen.routeName: (ctx) => EditProductScreen(),
                    ProductOverViewScreen.routeName: (ctx) =>
                        ProductOverViewScreen()
                  },
                )));
  }
}
