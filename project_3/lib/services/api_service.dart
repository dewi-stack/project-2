import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "https://green-dog-346335.hostingersite.com/api";

  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static Future<String?> getToken() async {
    final prefs = await _prefs;
    return prefs.getString('token');
  }

  static Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    final token = await getToken();
    return http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
      body: jsonEncode(data),
    );
  }

  static Future<http.Response> get(String endpoint) async {
    final token = await getToken();
    return http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
  }

  static Future<http.Response> put(String endpoint, Map<String, dynamic> data) async {
    final token = await getToken();
    return http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
      body: jsonEncode(data),
    );
  }

  static Future<http.Response> delete(String endpoint) async {
    final token = await getToken();
    return http.delete(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
  }

  static Future<List<dynamic>> fetchKategori() async {
    final response = await get("categories");
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Gagal mengambil data kategori");
    }
  }

  static Future<List<dynamic>> fetchSubKategori(int categoryId) async {
    final response = await get("sub-categories?category_id=$categoryId");
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Gagal mengambil data sub kategori");
    }
  }

  static Future<List<dynamic>> searchItems(String keyword) async {
    final token = await getToken(); // Ambil token dari SharedPreferences

    final response = await http.get(
      Uri.parse('https://green-dog-346335.hostingersite.com/api/items/search?q=$keyword'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Gagal mencari item");
    }
  }



  static Future<bool> simpanBarangMasuk(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('$baseUrl/items'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Gagal menyimpan item baru');
    }
  }

  static Future<Map<String, dynamic>?> fetchItemBySKU(String sku) async {
    final response = await get("items/sku/$sku");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception("Gagal mengecek SKU");
    }
  }

  static Future<bool> tambahStokItem(int itemId, int tambahanStok) async {
    final response = await put("items/$itemId/add-stock", {
      'quantity': tambahanStok,
    });

    return response.statusCode == 200;
  }

  static Future<bool> ajukanPermintaanStok(Map<String, dynamic> data) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/stock-requests'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    return response.statusCode == 201;
  }

  static Future<List<dynamic>> fetchMyStockRequests() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/my-stock-requests'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

 static Future<bool> ajukanStockRequest({
    required int itemId,
    required int quantity,
    required String description,
    required String unit,
    String type = 'increase',
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.post(
        Uri.parse('$baseUrl/stock-requests'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'item_id': itemId,
          'quantity': quantity,
          'type': type,
          'description': description,
          'unit': unit, // ✅ dikirim ke backend
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> simpanMutasiBarangBaru({
    required String sku,
    required String lokasi,
    required int jumlah,
    required String deskripsi,
  }) async {
    final response = await post("items/mutasi-baru", {
      'sku': sku,
      'location': lokasi,
      'quantity': jumlah,
      'description': deskripsi,
    });

    return response.statusCode == 201;
  }

  
  static Future<bool> sendDeleteStockRequest(int itemId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('https://green-dog-346335.hostingersite.com/api/stock-requests'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'item_id': itemId,
        'quantity': 1,
        'type': 'delete',
        'description': 'Permintaan penghapusan oleh Submitter',
      }),
    );

    return response.statusCode == 201;
  }
}
