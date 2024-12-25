import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
   String? _token;
   DateTime _expiryDate = DateTime.now();
   String? _userId;

  bool get isAuth {
    // Check if token is valid and not expired
    return _token != null && _token!.isNotEmpty && _expiryDate.isAfter(DateTime.now());
  }

  String? get token {
    // Return the token if it exists and is not expired
    if (_expiryDate.isAfter(DateTime.now()) && _token!.isNotEmpty) {
      return _token;
    }
    return null; // Return null if the token is invalid or expired
  }

  String? get userId{
    return _userId;
  }

   Future<void> _authenticate(String email, String password, String urlSegment) async {
     final url = 'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBTdDaeryWYOyMEGuXyMDpDSN_l28hgDNg';

     try {
       final response = await http.post(
         Uri.parse(url),
         headers: {
           'Content-Type': 'application/json', // Set content type to JSON
         },
         body: json.encode({
           'email': email,
           'password': password,
           'returnSecureToken': true,
         }),
       );

       if (response.statusCode == 200) {
         final responseData = json.decode(response.body);
         _token = responseData['idToken'];
         _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
         _userId = responseData['localId'];
         print('User authenticated successfully: $responseData');

         // Notify listeners about changes
         notifyListeners();

         // Save user data in SharedPreferences
         final prefs = await SharedPreferences.getInstance(); // Await the instance
         final userData = json.encode({
           'token': _token,
           'userId': _userId,
           'expiryDate': _expiryDate.toIso8601String(),
         });

         await prefs.setString('userData', userData); // Await the setString call
       } else {
         print('Failed to authenticate: ${response.body}');
         // Handle error response here (e.g., showing error message)
       }
     } catch (error) {
       print('An error occurred: $error');
       // Handle network or other errors here
     }
   }

   Future<bool> tryAutoLogin() async {
     final prefs = await SharedPreferences.getInstance(); // Get SharedPreferences instance

     // Retrieve user data from SharedPreferences
     if (!prefs.containsKey('userData')) {
       return false; // No user data found, cannot auto-login
     }

     final userDataString = prefs.getString('userData');
     if (userDataString == null) {
       return false; // No user data string found
     }

     final Map<String, dynamic> userData = json.decode(userDataString); // Decode JSON string
     final expiryDate = DateTime.parse(userData['expiryDate']); // Parse expiry date

     // Check if token is still valid
     if (expiryDate.isBefore(DateTime.now())) {
       return false; // Token has expired
     }

     _token = userData['token']; // Set the token
     _userId = userData['userId']; // Set the user ID

     notifyListeners(); // Notify listeners about changes (if using ChangeNotifier)

     return true; // Auto-login successful
   }


  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> logout() async{
    _token = null;
    _userId = null;
    _expiryDate = DateTime.now();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();

  }
}