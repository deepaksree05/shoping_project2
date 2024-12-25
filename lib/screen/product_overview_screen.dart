import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingproject2/provider/products.dart';
import 'package:shoppingproject2/screen/cart_screen.dart';
import 'package:shoppingproject2/widgets/app_drawer.dart';

import '../provider/cart.dart';
import 'package:shoppingproject2/widgets/badge.dart';

import '../widgets/product_grid.dart'; // Import your provider

enum FilterOption { Favorites, All }

class ProductOverviewScreen extends StatefulWidget {
  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen>
    with TickerProviderStateMixin {
  late AnimationController animationController;

  var _showFavourites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isLoading = true;
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          PopupMenuButton(
              onSelected: (FilterOption selectedValue) {
                setState(() {
                  if (selectedValue == FilterOption.Favorites) {
                    _showFavourites = true;
                  } else {
                    _showFavourites = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('OnlyFavouritr'),
                      value: FilterOption.Favorites,
                    ),
                    PopupMenuItem(
                      child: Text('ShowAll'),
                      value: FilterOption.All,
                    )
                  ]),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badges(

              child: ch!,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),

      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              valueColor: animationController
                  .drive(ColorTween(begin: Colors.blueAccent, end: Colors.red)),
            ))
          : ProductsGrid(_showFavourites), // Use ProductsGrid here
    );
  }
}
