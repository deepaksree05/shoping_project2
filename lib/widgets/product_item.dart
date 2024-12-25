import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingproject2/provider/auth.dart';
import 'package:shoppingproject2/provider/cart.dart';
import 'package:shoppingproject2/screen/product_detail_screen.dart';

import '../provider/product.dart';
class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  //
  // ProductItem(this.id,this.title,this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context,listen: false);
    final cart = Provider.of<Cart>(context,listen: false);
    final authData = Provider.of<Auth>(context,listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: GridTile(

        footer: GridTileBar(

          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
              onPressed: () {
                product.toggleFavourite(authData.token!,authData.userId!,product.id);

              },
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.deepOrangeAccent,
              ),
            ),
          ),
          backgroundColor: Colors.black87,

          title: Text(
              product.title,textAlign: TextAlign.center),
          trailing: IconButton(
            onPressed: () {
              cart.addItem(product.id, product.title, product.price);

              // Use ScaffoldMessenger to show the SnackBar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Item Added to Cart",textAlign: TextAlign.center,),
                  duration: Duration(seconds: 2), // Optional: duration for how long the SnackBar will be displayed
                  action: SnackBarAction(label: 'Undo', onPressed: (){
                    cart.removeSingleItem(product.id);
                  }),
                ),
              );
            },

              icon: Icon(Icons.shopping_cart),
                color: Colors.deepOrangeAccent,),
        ),

        child: GestureDetector(
          onTap: (){
           Navigator.of(context).pushNamed(ProductDetailScreen.routName,arguments: product.id);
          },

          // child: Image.network(product.imageUrl,fit: BoxFit.cover,),),
        child: Hero(
          tag: product.id,
          child: FadeInImage(
              placeholder: AssetImage('assets/images/product-placeholder.png'), // Replace with your placeholder image
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 500), // Optional: adjust fade-in duration
              ),
        ),

        ),
      ),
    );
  }
}
