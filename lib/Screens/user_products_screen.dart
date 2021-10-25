import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shopapp/Providers/products_provider.dart';
import 'package:shopapp/Screens/app_drawer.dart';
import 'package:shopapp/Screens/edit_product_screen.dart';
import 'package:shopapp/Widgets/user_products_items.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key? key}) : super(key: key);
  static const String routeName = "/userProductsScreen";
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);
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
        body: Padding(
          padding: EdgeInsets.all(10),
          child: ListView.builder(
              itemCount: products.items.length,
              itemBuilder: (ctx, i) => Column(children: [
                    UserProductsItem(products.items[i].title!,
                        products.items[i].imageURL!, products.items[i].id!),
                    Divider()
                  ])),
        ));
  }
}
