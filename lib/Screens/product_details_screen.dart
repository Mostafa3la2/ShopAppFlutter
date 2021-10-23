import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/Providers/cart.dart';
import 'package:shopapp/Providers/product.dart';
import 'package:shopapp/Providers/products_provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const String routeName = "/product-details";
  final String productID;

  ProductDetailsScreen(this.productID);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    //final productID = ModalRoute.of(context)!.settings.arguments as String;
    final cart = Provider.of<Cart>(context, listen: false);
    final myproduct = Provider.of<Product>(context, listen: false);
    final selectedProductData = Provider.of<Products>(context)
        .items
        .firstWhere((element) => element.id == widget.productID);

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedProductData.title!),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Image.network(selectedProductData.imageURL!),
              height: 300,
            ),
            SizedBox(
              height: 30,
            ),
            Text("\$${selectedProductData.price}"),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer<Product>(
                    builder: (ctx, product, _) => IconButton(
                        icon: product.isFavorite
                            ? Icon(Icons.favorite)
                            : Icon(Icons.favorite_border_outlined),
                        onPressed: product.toggleFavorite,
                        color: Theme.of(context).colorScheme.secondary)),
                SizedBox(
                  width: 50,
                ),
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    cart.addItem(
                        myproduct.id!, myproduct.title!, myproduct.price!);
                  },
                )
              ],
            ),
            SizedBox(height: 30),
            Text(myproduct.description!)
          ],
        ),
      ),
    );
  }
}
