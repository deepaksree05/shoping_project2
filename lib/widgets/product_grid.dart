import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingproject2/widgets/product_item.dart';
import '../provider/product.dart';
import '../provider/products.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFav;
  ProductsGrid(this.showFav);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final products = showFav ? productData.favouriteItem : productData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, i) =>
          ChangeNotifierProvider.value(
            value: products[i],
            // create: (c) => products[i], // Corrected to use 'create' instead of 'builder'
            child: ProductItem(
              // id: products[i].id, // Pass the id of the product
              // title: products[i].title, // Pass the title of the product
              // imageUrl: products[i].imageUrl, // Pass the image URL of the product
            ),
          ),
    );
  }
  }