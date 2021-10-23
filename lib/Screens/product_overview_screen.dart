import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shopapp/Screens/app_drawer.dart';
import 'package:shopapp/Screens/cart_screen.dart';
import '../Widgets/badge.dart';
import '../Providers/cart.dart';
import 'package:shopapp/Widgets/products_grid.dart';

enum PopupMenu { Favorites, All }

class ProductOverViewScreen extends StatefulWidget {
  @override
  State<ProductOverViewScreen> createState() => _ProductOverViewScreenState();
}

class _ProductOverViewScreenState extends State<ProductOverViewScreen> {
  bool _showFavorites = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text("Shop App!"),
        actions: [
          PopupMenuButton(
              onSelected: (PopupMenu selectedValue) {
                setState(() {
                  if (selectedValue == PopupMenu.Favorites) {
                    _showFavorites = true;
                  } else {
                    _showFavorites = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text("Show Favorites"),
                      value: PopupMenu.Favorites,
                    ),
                    PopupMenuItem(
                      child: Text("Show All"),
                      value: PopupMenu.All,
                    ),
                  ]),
          Consumer<Cart>(
            builder: (_, cart, child) =>
                Badge(child: child, value: cart.itemCount.toString()),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      body: ProductsGrid(_showFavorites),
    );
  }
}
