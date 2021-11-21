import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/Providers/auth.dart';
import 'package:shopapp/Screens/orders_screen.dart';
import 'package:shopapp/Screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text("Hello There!"),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
              leading: Icon(Icons.shop),
              title: Text("Shop"),
              onTap: () {
                Navigator.of(context).pushReplacementNamed("/");
              }),
          Divider(),
          ListTile(
              leading: Icon(Icons.payment),
              title: Text("Orders"),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(OrdersScreen.routeName);
              }),
          Divider(),
          ListTile(
              leading: Icon(Icons.edit),
              title: Text("Products"),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(UserProductsScreen.routeName);
              }),
          Divider(),
          ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed("/");
                Provider.of<Auth>(context, listen: false).logout();
              }),
        ],
      ),
    );
  }
}
