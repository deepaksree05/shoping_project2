import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingproject2/provider/order.dart' show Orders;
import 'package:shoppingproject2/widgets/app_drawer.dart';

import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
static const routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();

}



class _OrdersScreenState extends State<OrdersScreen> {
var _isLoading = false;
@override
  void initState() {
   Future.delayed(Duration.zero).then((_) async{
     setState(() {
       _isLoading = true;
     });
      await Provider.of<Orders>(context,listen: false).fetchAndSetOrders();
      setState(() {
        _isLoading = false;
      });
   });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your order'),
      ),
    drawer: AppDrawer(),
    body: _isLoading
        ? Center(
        child: CircularProgressIndicator()
          )
        : ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder:(ctx,i) => OrderItem(orderData.orders[i])),
    );
  }
}
