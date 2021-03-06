import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shopapp/Providers/product.dart';
import 'package:shopapp/Providers/products_provider.dart';
import 'package:shopapp/Screens/app_drawer.dart';
import 'package:shopapp/Screens/edit_product_screen.dart';
import 'package:shopapp/Widgets/user_products_items.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key? key}) : super(key: key);
  static const String routeName = "/userProductsScreen";

  Future<void> _pullToRefresh(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text("Your Products"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(EditProductScreen.routeName);
                },
                icon: Icon(Icons.add)),
          ],
        ),
        body: FutureBuilder(
          future: _pullToRefresh(context),
          builder: (ctx, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: () => _pullToRefresh(context),
                      child: Consumer<Products>(
                        builder: (ctx, productsData, _) => Padding(
                          padding: EdgeInsets.all(10),
                          child: ListView.builder(
                              itemCount: productsData.items.length,
                              itemBuilder: (ctx, i) => Column(children: [
                                    UserProductsItem(
                                        productsData.items[i].title!,
                                        productsData.items[i].imageURL!,
                                        productsData.items[i].id!),
                                    Divider()
                                  ])),
                        ),
                      ),
                    ),
        ));
  }
}
