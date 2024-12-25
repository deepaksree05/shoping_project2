// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shoppingproject2/provider/cart.dart' show Cart;
// import 'package:shoppingproject2/provider/order.dart';
//
// import '../widgets/cart_item.dart';
//
// class CartScreen extends StatelessWidget {
//   static const routeName = '/cart';
//
//   const CartScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final cart = Provider.of<Cart>(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Your Cart"),
//       ),
//       body: Column(
//         children: [
//           Card(
//             margin: const EdgeInsets.all(15),
//             child: Padding(
//               padding: const EdgeInsets.all(8),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     'Total',
//                     style: TextStyle(fontSize: 20),
//                   ),
//                   const Spacer(), // Space between text and chip
//                   Chip(
//                     label: Text(
//                       '\$${cart.totalAmount.toStringAsFixed(2)}', // Display total amount formatted to two decimal places
//                       style: const TextStyle(color: Colors.white), // Text color
//                     ),
//                     backgroundColor: Colors.pinkAccent,
//                     // Background color of the chip
//                   ),
//
//                   TextButton(
//                     style: TextButton.styleFrom(
//                       foregroundColor: Colors.pinkAccent,
//                     ),
//                     onPressed: () {
//                       Provider.of<Orders>(context).addOrder(
//                           cart.items.values.toList(),
//                           cart.totalAmount);
//                       cart.clear();
//
//                     },
//                     child: const Text('OrderNow'),
//                   )
//                 ],
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 10), // Space between card and list
//           Expanded(
//             child: ListView.builder(
//               itemCount:
//                   cart.items.length, // Ensure cart.items is a List or Map
//               itemBuilder: (ctx, i) {
//                 final item =
//                     cart.items.values.toList()[i]; // Get the item from the cart
//                 return CartItem(
//                     id: item.id,
//                     productId: cart.items.keys.toList()[i],
//                     price: item.price,
//                     quantity: item.quantity,
//                     title: item.title);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingproject2/provider/cart.dart' show Cart;
import 'package:shoppingproject2/provider/order.dart'; // Ensure this is imported

import '../widgets/cart_item.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.pinkAccent,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.pinkAccent,
                    ),
                    onPressed: (cart.totalAmount <= 0 || _isLoading)
                        ? null // Disable button if cart is empty or loading
                        : () async {
                      setState(() {
                        _isLoading = true; // Set loading state
                      });
                      try {
                      await   Provider.of<Orders>(context, listen: false).addOrder(
                          cart.items.values.toList(),
                          cart.totalAmount,
                        );
                        cart.clear();
                      } catch (error) {
                        // Handle any errors here if needed
                      } finally {
                        setState(() {
                          _isLoading = false; // Reset loading state
                        });
                      }
                    },
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Text('Order Now'),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: cart.items.isEmpty // Check if cart is empty
                ? const Center(child: Text('Your cart is empty!'))
                : ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) {
                final item = cart.items.values.toList()[i];
                return CartItem(
                  id: item.id,
                  productId: cart.items.keys.toList()[i],
                  price: item.price,
                  quantity: item.quantity,
                  title: item.title,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}