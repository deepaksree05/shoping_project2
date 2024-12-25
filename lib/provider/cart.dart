import 'package:flutter/material.dart';

class CartItem{
  final String id;
  final String title;
  final int quantity;
  final double price;



  CartItem ({
    required this.title,
    required this.id,
    required this.quantity,
    required this.price

});

}
class Cart with ChangeNotifier{
  Map<String, CartItem> _items = {};


  Map<String, CartItem> get items {
    return {..._items};
  }
  int get itemCount {
    return _items.values.fold(0, (sum, item) => sum + item.quantity);
  }
  int get length {
    return _items.length;
  }
  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity; // Calculate total price
    });
    return total;
  }


  void addItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      // If item already exists, increase quantity
      _items.update(
        productId,
            (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          quantity: existingCartItem.quantity + 1,
          price: existingCartItem.price,
        ),
      );
    } else {
      // If item doesn't exist, add it
      _items.putIfAbsent(
        productId,
            () => CartItem(
          id: productId,
          title: title,
          quantity: 1,
          price: price,
        ),
      );
    }
    notifyListeners();
  }
  void removeId (String productId){
    _items.remove(productId);
    notifyListeners();
  }
  void removeSingleItem(String productId){
  if(!_items.containsKey(productId)){
    return;
  }
  if (_items[productId]!.quantity > 1) {
    _items.update(productId, (existingCartItem) => CartItem(
        title: existingCartItem.title, id: existingCartItem.id,
        quantity: existingCartItem.quantity,
        price: existingCartItem. price));
  }
  else{
    _items.remove(productId);
  }
  notifyListeners();
  }
  void clear ( ) {
    _items = {};
    notifyListeners();
  }
}