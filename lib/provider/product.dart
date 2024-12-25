import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.isFavorite = false,
  });

  // void ToggleFavourite() {
  //   isFavorite = !isFavorite;
  //   notifyListeners();
  //
  // }
  // void toggleFavourite(String token,String userId) async {
  //   isFavorite = !isFavorite; // Toggle the favorite status
  //   notifyListeners(); // Notify listeners about the change
  //
  //   // Construct the URL for the specific product
  //   final url = 'https://flutter-project-63d8b-default-rtdb.firebaseio.com/userFavourite/$userId/$id.json?auth = $token';
  //
  //   // Attempt to update the favorite status in the database
  //   try {
  //     final response = await http.patch(
  //       Uri.parse(url),
  //       body: json.encode({
  //         'isFavorite': isFavorite, // Update the favorite status
  //       }),
  //     );
  //
  //     if (response.statusCode >= 400) {
  //       throw Exception('Failed to update favorite status');
  //     }
  //   } catch (error) {
  //     if (kDebugMode) {
  //       print('Error updating favorite status: $error');
  //     }
  //   }
  // }
  void toggleFavourite(String token, String userId, String id) async {
    isFavorite = !isFavorite; // Toggle the favorite status
    notifyListeners(); // Notify listeners about the change

    // Construct the URL for the specific product
    final url = 'https://flutter-project-63d8b-default-rtdb.firebaseio.com/userFavourite/$userId/$id.json?auth=$token';

    // Attempt to update the favorite status in the database
    try {
      final response = await http.put(
        Uri.parse(url),
        body: json.encode(
           isFavorite,// Update the favorite status
        ),
        headers: {
          'Content-Type': 'application/json', // Set content type to JSON
        },
      );

      if (response.statusCode >= 400) {
        throw Exception('Failed to update favorite status');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error updating favorite status: $error');
      }
    }
  }

}