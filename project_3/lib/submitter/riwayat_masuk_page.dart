import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'scan_barcode_page.dart';

class RiwayatMasukPage extends StatefulWidget {
  const RiwayatMasukPage({Key? key}) : super(key: key);

  @override
  _RiwayatMasukPageState createState() => _RiwayatMasukPageState();
}

class _RiwayatMasukPageState extends State<RiwayatMasukPage> {
  List items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStockRequests();
  }

  Future<void> fetchStockRequests() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      setState(() => isLoading = false);
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.6:8000/api/my-stock-requests'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          // Ambil hanya request stok masuk
          items = data.where((item) =>
            item['type'] == 'increase' || item['type'] == 'initial'
          ).toList();
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Error: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : items.isEmpty
              ? const Center(child: Text("Tidak ada riwayat stok masuk."))
              : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    var item = items[index];
                    final itemName = item['item']['name'] ?? '-';
                    final sku = item['item']['sku'] ?? '-';
                    final location = item['item']['location'] ?? '-';
                    final quantity = item['quantity'] ?? 0;
                    final status = item['status'];
                    final createdAt = item['created_at']?.toString().substring(0, 10) ?? '-';
                    final type = item['type'];

                    final keterangan = type == 'initial'
                        ? '📦 Barang baru ditambahkan'
                        : '➕ Stok baru ditambahkan';

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Nama: $itemName", style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              Text("SKU: $sku"),
                              Text("Jumlah Stok Masuk: $quantity unit", style: const TextStyle(color: Colors.purple)),
                              Text("Lokasi: $location"),
                              Text("Tanggal Permintaan: $createdAt"),
                              Text("Keterangan: $keterangan", style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.deepPurple)),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.info_outline, size: 18),
                                  const SizedBox(width: 4),
                                  Text(
                                    status == 'pending'
                                        ? 'Menunggu persetujuan'
                                        : status == 'approved'
                                            ? '✅ Disetujui'
                                            : '❌ Ditolak',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: status == 'pending'
                                          ? Colors.orange
                                          : status == 'approved'
                                              ? Colors.green
                                              : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigoAccent,
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ScanBarcodePage()),
          );

          if (result != null && result is String) {
            print("SKU dari Scan: $result");
          }
        },
      ),
    );
  }
}
