import 'dart:convert';  // For JSON encoding/decoding
import 'package:http/http.dart' as http;  // For HTTP requests


class ApiService {
  // Backend server base URL
    
    // For physical device testing:
   //static const String baseUrl = "http://192.168.1.110:3000";
  
  // For production (VPS):
  static const String baseUrl = "http://38.242.246.126:3000";
  
  // Test if backend is reachable and database is connected
  static Future<void> testConnection() async {
    try {
      // Send GET request to test endpoint
      final response = await http.get(Uri.parse('$baseUrl/api/pick_my_dish'));
      print('Backend status: ${response.statusCode}');  // Should be 200 if successful
      print('Response: ${response.body}');  // Response data from backend
    } catch (e) {
      print('Connection error: $e');  // Handle network/database errors
    }
  }

  // Fetch all recipes from the backend
  static Future<List<dynamic>> getRecipes() async {
    // Send GET request to recipes endpoint
    final response = await http.get(Uri.parse('$baseUrl/api/recipes'));
    // Convert JSON response to Dart List
    return json.decode(response.body);
  }

  
  //login user
  static Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        body: json.encode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Login successful: ${data['message']}');
        print('👤 User: ${data['user']}');
        return true;
      } else {
        print('❌ Login failed: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Login error: $e');
      return false;
    }
  }

// Register a new user with name, email, and password
static Future<bool> register(String fullName, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/register'),
        body: json.encode({
          'fullName': fullName,
          'email': email,
          'password': password
        }),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        print('✅ Registration successful: ${data['message']}');
        return true;
      } else {
        print('❌ Registration failed: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Registration error: $e');
      return false;
    }
  }

  static Future<void> testAuth() async {
  print('🔐 Testing authentication...');
  
  // Test Registration
  bool registered = await register('Test User', 'test@example.com', 'password123');
  print(registered ? '✅ Registration successful' : '❌ Registration failed');
  
  // Test Login
  bool loggedIn = await login('test@example.com', 'password123');
  print(loggedIn ? '✅ Login successful' : '❌ Login failed');
}

// Add this test
static Future<void> testBaseUrl() async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/'));
    print('Base URL status: ${response.statusCode}');
    print('Base URL response: ${response.body}');
  } catch (e) {
    print('Base URL error: $e');
  }
}

}