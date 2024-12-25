import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingproject2/provider/auth.dart';
import 'package:shoppingproject2/screen/userproduct_screen.dart';

import '../screen/orderscreen.dart';

class AppDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Hello Friend'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: (){
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: (){
              Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manager Product'),
            onTap: (){
              Navigator.of(context).pushReplacementNamed(UserproductScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: (){
              Navigator.of(context).pop();
           Provider.of<Auth>(context,listen: false).logout();
            },
          )



        ],
      ),
    );
  }
}
