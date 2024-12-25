import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingproject2/provider/auth.dart';
import 'package:shoppingproject2/provider/cart.dart';
import 'package:shoppingproject2/provider/order.dart';
import 'package:shoppingproject2/provider/products.dart';
import 'package:shoppingproject2/screen/auth_screen.dart';
import 'package:shoppingproject2/screen/cart_screen.dart';
import 'package:shoppingproject2/screen/edit_product_screen.dart';
import 'package:shoppingproject2/screen/orderscreen.dart';
import 'package:shoppingproject2/screen/product_detail_screen.dart';
import 'package:shoppingproject2/screen/product_overview_screen.dart';
import 'package:shoppingproject2/screen/spalash_screen.dart';
import 'package:shoppingproject2/screen/userproduct_screen.dart';

void main() {
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers:[
      ChangeNotifierProvider(create: (context) => Auth(),),
      ChangeNotifierProxyProvider<Auth, Products>(
        create: (ctx) => Products('', '', []), // Initialize Products with empty token, userId, and an empty list
        update: (ctx, auth, previousProducts) => Products(
          auth.token ?? '', // Use an empty string if token is null
          auth.userId ?? '', // Use an empty string if userId is null
          previousProducts?.items ?? [], // Use previous items or an empty list if previousProducts is null
        ),
      ),
      ChangeNotifierProvider(
        create: (context) => Cart(),),
      // ChangeNotifierProvider(
      //   create: (context) => Orders(),)
      ChangeNotifierProxyProvider<Auth, Orders>(
        create: (ctx) => Orders('', []), // Initialize Products with an empty token and an empty list
        update: (ctx, auth, previousOrders) => Orders(
          auth.token ?? '', // Use an empty string if token is null
          previousOrders == null? [] : previousOrders.orders,
        ),
      ),
    ],
      child: Consumer<Auth>(builder: (ctx,auth,_) =>MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(

          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: 'Lato',
        ),
        debugShowCheckedModeBanner: false,

        home:  auth.isAuth? ProductOverviewScreen(): FutureBuilder(
          future: auth.tryAutoLogin(),
          builder: (ctx,authResultSnapshot)=>
          authResultSnapshot.connectionState ==
              ConnectionState.waiting?SpalashScreen():AuthScreen(),),

        // home: ProductOverviewScreen(),
        routes: {
          ProductDetailScreen.routName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName:(ctx) => CartScreen(),
          OrdersScreen.routeName:(ctx)=> OrdersScreen(),
          UserproductScreen.routeName:(ctx)=>UserproductScreen(),
          EditProductScreen.routeName:(ctx) => EditProductScreen()
        },
      ),)
    );
  }
}


