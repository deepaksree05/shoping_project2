import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'cart.dart';

class OrderItem{
  final String id;
  final double amount;
  final List<CartItem>products;
  final DateTime dateTime;

  OrderItem( {required this.id,
    required this.amount,
    required this.products,
    required this.dateTime} );
}

class Orders with ChangeNotifier {
  List<OrderItem> _order = [];

  final String authToken;
  Orders(this.authToken,this._order);

  List<OrderItem> get orders{
    return [..._order];
  }
  // void addOrder(List<CartItem> cartProducts, double total) {
  //
  //   _order.insert(0,  OrderItem(
  //     id: DateTime.now().toString(),
  //     amount: total,
  //     products: cartProducts,
  //     dateTime: DateTime.now(),
  //   ),
  //   );
  //
  //
  //   notifyListeners();
  // }

  Future<void> fetchAndSetOrders() async {
    final url = 'https://flutter-project-63d8b-default-rtdb.firebaseio.com/orders.json?auth=$authToken';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body); // Decode the JSON response
        final List<OrderItem> loadedOrders = [];

        // Loop through the data and convert each entry to an OrderItem
        data.forEach((orderId, orderData) {
          loadedOrders.add(OrderItem(
            id: orderId,
            amount: orderData['amount'] ?? 0.0, // Handle null
            dateTime: DateTime.parse(orderData['dateTime']),
            products: (orderData['products'] as List<dynamic>).map((item) {
              return CartItem(
                id: item['id'],
                price: item['price'] ?? 0.0 , // Handle null
                quantity: item['quantity'] ?? 0, // Default to 0 if null
                title: item['title'] ?? 'Unknown', // Default title if null
              );
            }).toList(),
          ));
        });

        _order = loadedOrders; // Assuming _order is a List<OrderItem>
        notifyListeners();
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (error) {
      print('Error fetching orders: $error'); // Handle exceptions
      rethrow; // Rethrow the caught error
    }
  }




  Future <void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = 'https://flutter-project-63d8b-default-rtdb.firebaseio.com/orders.json?auth=$authToken'; // Updated URL

    // Create a new order item
    final newOrder = OrderItem(
      id: DateTime.now().toString(),
      amount: total,
      products: cartProducts,
      dateTime: DateTime.now(),
    );

    // Attempt to add the order to the database
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'id': newOrder.id,
          'amount': newOrder.amount,
          'products': newOrder.products.map((item) => {
            'id': item.id,
            'quantity': item.quantity,
            'title':item.title,
             'price':item.price
          }).toList(),
          'dateTime': newOrder.dateTime.toIso8601String(),
        }),
      );

      if (response.statusCode >= 400) {
        throw Exception('Failed to add order');
      }

      // Insert the new order into the local list
      _order.insert(0, newOrder);
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print('Error adding order: $error');
      }
    }
  }
}

