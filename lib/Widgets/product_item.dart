import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/Providers/auth.dart';
import 'package:shopapp/Providers/product.dart';
import '../Providers/cart.dart';
import 'package:shopapp/Screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () {
          //Navigator.of(context).pushNamed(ProductDetailsScreen.routeName, arguments: product.id);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider.value(
                        value: product,
                        child: ProductDetailsScreen(product.id!),
                      )));
        },
        child: GridTile(
          child: Image.network(
            product.imageURL!,
            fit: BoxFit.cover,
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black54,
            leading: Consumer<Product>(
                builder: (ctx, product, _) => IconButton(
                    icon: product.isFavorite
                        ? Icon(Icons.favorite)
                        : Icon(Icons.favorite_border_outlined),
                    onPressed: () async {
                      try {
                        await product.toggleFavorite(
                            authData.token ?? "", authData.userID);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                          "something went wrong",
                          textAlign: TextAlign.center,
                        )));
                      }
                    },
                    color: Theme.of(context).colorScheme.secondary)),
            title: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                product.title!,
                style: TextStyle(fontSize: 15),
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                cart.addItem(product.id!, product.title!, product.price!);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Item added successfully"),
                  action: SnackBarAction(
                    label: "Undo",
                    onPressed: () {
                      cart.removeSingleItem(product.id!);
                    },
                  ),
                ));
              },
            ),
          ),
        ),
      ),
    );
  }
}
