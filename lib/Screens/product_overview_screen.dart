import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shopapp/Providers/products_provider.dart';
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
  bool _isLoading = false;
  bool _isInit = true;

  Future<void> _pullToRefresh() async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      }).catchError((error) {
        setState(() {
          _isLoading = false;
        });
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                    title: Text("An Error Occured"),
                    content: Text(error.toString()),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("dismiss"))
                    ]));
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              child: ProductsGrid(_showFavorites),
              onRefresh: _pullToRefresh,
            ),
    );
  }
}
