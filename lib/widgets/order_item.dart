import 'dart:math';

import 'package:flutter/material.dart';
import '../provider/order.dart' as ord;
import 'package:intl/intl.dart';
class OrderItem extends StatefulWidget {
final ord.OrderItem order;
OrderItem(this.order);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded =  false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.amount }'),
            subtitle: Text(
              DateFormat(' d MMMM yyyy hh:mm').format(widget.order.dateTime), // Format date
              style: TextStyle(fontSize: 16), // Customize style as needed
            ),
            trailing: IconButton(onPressed: (){
                setState(() {
                  _expanded = !_expanded;
                });
            },
                icon: Icon(_expanded? Icons.expand_less:Icons.expand_more)),
          ),
           if(_expanded)
             Container(
               padding: EdgeInsets.symmetric(horizontal: 15,vertical:4 ),
               height: min(widget.order.products.length *20.0+10,100),
               child: ListView(
                 children: widget.order.products.map((prod)=> Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text(prod.title,style: TextStyle(
                       fontSize: 15,

                       fontWeight:FontWeight.bold
                     ),),
                     Text('${prod.quantity}* \$${prod.price}',style: TextStyle(
                       fontSize: 18,
                       color: Colors.grey
                     ),)
                   ],
                 )).toList()


            ,   ),
             )
        ],
      ),
    );
  }
}
