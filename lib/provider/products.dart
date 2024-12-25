import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  // var _ShowFavoritesOnly = false;

  final String authtoken;
  final String userId;
  Products(this.authtoken,this.userId,this._items);


  List<Product> get items {
    // if(_ShowFavoritesOnly){
    //
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items]; // Return a copy of the items list
  }

  List<Product> get favouriteItem {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  //  void showFavouriteOnlu(){
  //   _ShowFavoritesOnly = true;
  //   notifyListeners();
  //  }
  // void showAll(){
  //   _ShowFavoritesOnly = false;
  //   notifyListeners();
  // }
  Future<void> fetchAndSetProducts() async {
    var url = 'https://flutter-project-63d8b-default-rtdb.firebaseio.com/products.json?auth=$authtoken';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> extractData = json.decode(response.body);

        // Fetch favorite products
        url = 'https://flutter-project-63d8b-default-rtdb.firebaseio.com/userFavourite/$userId.json?auth=$authtoken';
        final favouriteResponse = await http.get(Uri.parse(url)); // Corrected casting to Uri
        final favouriteData = jsonDecode(favouriteResponse.body) as Map<String, dynamic>?; // Cast to Map

        final List<Product> loadedProducts = [];

        extractData.forEach((prodId, prodData) {
          loadedProducts.add(Product(
            id: prodId,
            title: prodData['title'] ?? 'No Title', // Provide default value
            description: prodData['description'] ?? 'No Description', // Corrected spelling from 'descripition' to 'description'
            isFavorite: favouriteData != null && favouriteData[prodId] == true, // Check if favorite
            imageUrl: prodData['imageUrl'] ?? '', // Provide default value
            price: (prodData['price'] != null) ? double.tryParse(prodData['price'].toString()) ?? 0.0 : 0.0, // Handle price safely
          ));
        });

        _items = loadedProducts; // Assuming _items is a List<Product>
        notifyListeners();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      print('Error fetching products: $error');
      rethrow; // Rethrow the caught error
    }
  }

  Future<void> addProduct(Product product)  {
    var datas = {
      'title': product.title,
      'descripition': product.description,
      'imageUrl': product.imageUrl,
      'price': product.price,
      // 'isFavorite': product.isFavorite
    };
    final url =
        'https://flutter-project-63d8b-default-rtdb.firebaseio.com/products.json?auth=$authtoken';
    return http
        .post(

      Uri.parse(url),
      body: json.encode(datas),
    )
        .then((response) {
      if (kDebugMode) {
        print(json.decode(response.body));
      }
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
      );
      _items.add(newProduct);
      //_items.insert(0, newProduct);
      notifyListeners();
    }).catchError((error) {
      if (kDebugMode) {
        print(error);
      }
      throw error;
    });
  }

  void updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = 'https://flutter-project-63d8b-default-rtdb.firebaseio.com/products/$id.json?auth=$authtoken';

      // Update the product in the database
      try {
        final response = await http.patch(
          Uri.parse(url),
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            // Include other fields as necessary
          }),
        );

        if (response.statusCode >= 400) {
          // Handle error response
          throw Exception('Failed to update product');
        }

        // Update the local item list
        _items[prodIndex] = newProduct;
        notifyListeners();
      } catch (error) {
        if (kDebugMode) {
          print('Error updating product: $error');
        }
      }
    } else {
      if (kDebugMode) {
        print('Product not found');
      }
    }
  }

  void deleteProduct(String id) async {
    final url = 'https://flutter-project-63d8b-default-rtdb.firebaseio.com/products/$id.json?auth=$authtoken';

    // Attempt to delete the product from the database
    try {
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode >= 400) {
        // Handle error response
        throw Exception('Failed to delete product');
      }

      // Remove the product from the local list
      _items.removeWhere((prod) => prod.id == id);
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print('Error deleting product: $error');
      }
    }
  }
}
