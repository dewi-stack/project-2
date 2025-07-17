import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class AuthService {
  static const String apiUrl = 'http://192.168.1.6:8000/api'; // Ganti sesuai server

  /// 🔐 Login dan simpan data user
  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/login'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final user = data['user'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['access_token']);
      await prefs.setString('role', user['role']);
      await prefs.setInt('user_id', user['id']);
      return true;
    } else {
      return false;
    }
  }

  /// 🚪 Logout API dan hapus session
  static Future<void> logout() async {
    final token = await getToken();
    if (token != null) {
      await http.post(
        Uri.parse('$apiUrl/logout'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Hapus semua session
  }

  /// 🔁 Ambil role user
  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }

  /// 🔁 Ambil token autentikasi
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// 🔁 Ambil user ID
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  /// ✅ Cek apakah sudah login
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  /// 🚦 Navigasi berdasarkan role (bisa dipakai di splash screen)
  static Future<void> navigateBasedOnRole(BuildContext context, Widget approverPage, Widget submitterPage) async {
    final role = await getRole();
    if (role == 'Approver') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => approverPage));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => submitterPage));
    }
  }
}
