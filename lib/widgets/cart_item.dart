import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart.dart';

class CartItem extends StatelessWidget {
final String id;
final String productId;
final double price;
final int quantity;
final String title;



const CartItem({

  required this.id,
  required this.productId,
  required this.price,
  required this.quantity,
  required this.title,
}) ;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
          color:Colors.pinkAccent,
        child: Icon(Icons.delete,color: Colors.white,size: 40,),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(vertical: 4,horizontal: 15),

      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction){
        return showDialog(context: context,
        builder: (ctx) => AlertDialog(
       title: Text('Are You Sure'),
          content: Text('Do You Want To Remove The Item For You Cart?'),
          actions: [
            FloatingActionButton(onPressed: (){
              Navigator.of(context).pop(false);
            },child: Text('No'),),
            FloatingActionButton(onPressed: (){
              Navigator.of(context).pop(true);
            },child: Text('Yes'),)
          ],
        ));
      },
      onDismissed: (direction){
          Provider.of<Cart>(context,listen: false).removeId(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 4,horizontal: 15),
        child: Padding(padding: EdgeInsets.all(8),
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(padding: EdgeInsets.all(5),
              child: FittedBox(
                child:  Text('\$$price'),
              ),
            )

          ),
          title: Text(title),
          subtitle: Text('Total:\$${(price*quantity)}'),
          trailing: Text('$quantity x'),
        ),),
      ),
    );




  }
}

