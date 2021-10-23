import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/Providers/cart.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final String id;
  CartItemWidget(this.cartItem, this.id);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => Platform.isIOS
                ? CupertinoAlertDialog(
                    title: Text("Are you sure?"),
                    content: Text("Do you want to remove this item from cart?"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop(false);
                          },
                          child: Text("No")),
                      TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop(true);
                          },
                          child: Text("Yes")),
                    ],
                  )
                : AlertDialog(
                    title: Text("Are you sure?"),
                    content: Text("Do you want to remove this item from cart?"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop(false);
                          },
                          child: Text("No")),
                      TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop(true);
                          },
                          child: Text("Yes")),
                    ],
                  ));
      },
      onDismissed: (direction) {
        var cart = Provider.of<Cart>(context, listen: false);
        cart.removeItem(id);
      },
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 10),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: FittedBox(
                child: Text(this.cartItem.price.toString()),
              ),
            ),
          ),
          title: Text(this.cartItem.title!),
          subtitle: Text(
              "Total : \$${this.cartItem.quantity! * this.cartItem.price!}"),
          trailing: Text("${this.cartItem.quantity!}x"),
        ),
      ),
    );
  }
}
