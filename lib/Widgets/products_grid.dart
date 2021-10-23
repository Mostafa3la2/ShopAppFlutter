import 'package:flutter/material.dart';
import 'package:shopapp/Providers/products_provider.dart';

import 'product_item.dart';
import 'package:provider/provider.dart';
class ProductsGrid extends StatelessWidget {


  bool _showFavorites;
  ProductsGrid(this._showFavorites);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final loadedProducts = _showFavorites ? productsData.favorites : productsData.items;
    return GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: loadedProducts.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 3/2
        ),
        itemBuilder: (ctx,i)=>
            ChangeNotifierProvider.value(
                value: loadedProducts[i],
                child: ProductItem())
    );
  }
}
