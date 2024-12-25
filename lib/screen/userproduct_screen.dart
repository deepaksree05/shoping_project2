import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingproject2/provider/products.dart';
import 'package:shoppingproject2/screen/edit_product_screen.dart';
import 'package:shoppingproject2/widgets/app_drawer.dart';
import 'package:shoppingproject2/widgets/user_product_item.dart';

class UserproductScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProduct(BuildContext context)async {
   await Provider.of<Products>(context , listen: false).fetchAndSetProducts();

  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Product'),
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).pushNamed(EditProductScreen.routeName);
          }, icon: Icon(Icons.add))
        ],
      ),
      drawer: AppDrawer(),
      body:
        RefreshIndicator(
          onRefresh: () => _refreshProduct(context),
          child: Padding(padding: EdgeInsets.all(18),
          child: ListView.builder(
            itemCount: productsData.items.length,
              itemBuilder: (_,i) => Column(children: [UserProductItem(
                  productsData.items[i].id,
                  productsData.items[i].title,
                  productsData.items[i].imageUrl),
              Divider(),
              ]),),
          ),
        ),

      
      
    );
  }
}
