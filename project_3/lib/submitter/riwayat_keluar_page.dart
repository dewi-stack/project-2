import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'scan_barcode_keluar_page.dart';

class RiwayatKeluarPage extends StatefulWidget {
  const RiwayatKeluarPage({Key? key}) : super(key: key);

  @override
  State<RiwayatKeluarPage> createState() => _RiwayatKeluarPageState();
}

class _RiwayatKeluarPageState extends State<RiwayatKeluarPage> {
  List items = [];
  List stockRequests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await fetchItems();
    await fetchMyStockRequests();
    setState(() => isLoading = false);
  }

  Future<void> fetchItems() async {
    final token = await _getToken();
    if (token == null) return;
    try {
      final response = await http.get(
        Uri.parse('https://green-dog-346335.hostingersite.com/api/items'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        items = json.decode(response.body);
      }
    } catch (e) {
      print('Fetch items error: $e');
    }
  }

  Future<void> fetchMyStockRequests() async {
    final token = await _getToken();
    if (token == null) return;
    try {
      final response = await http.get(
        Uri.parse('https://green-dog-346335.hostingersite.com/api/my-stock-requests'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final allRequests = json.decode(response.body);
        stockRequests = allRequests.where((e) => e['type'] == 'decrease').toList();
      }
    } catch (e) {
      print('Fetch requests error: $e');
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : stockRequests.isEmpty
              ? const Center(child: Text("Belum ada pengajuan pengeluaran barang."))
              : ListView.builder(
                  itemCount: stockRequests.length,
                  itemBuilder: (context, index) {
                    final req = stockRequests[index];
                    final item = req['item'] ?? {};
                    final itemName = item['name'] ?? '-';
                    final sku = item['sku'] ?? '-';
                    final location = item['location'] ?? '-';
                    final quantity = req['quantity'] ?? 0;
                    final createdAt = req['created_at']?.toString().substring(0, 10) ?? '-';
                    final description = req['description'] ?? '-';
                    final status = req['status'] ?? '-';

                    return Card(
                      margin: const EdgeInsets.all(10),
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Nama: $itemName", style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Text("SKU: $sku"),
                            Text("Jumlah Barang Keluar: $quantity unit", style: const TextStyle(color: Colors.red)),
                            Text("Lokasi: $location"),
                            Text("Tanggal Permintaan: $createdAt"),
                            Text("Keterangan: $description", style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.deepPurple)),
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
                    );
                  },
                ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.indigoAccent,
            child: const Icon(Icons.remove),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ScanBarcodeKeluarPage(),
                ),
              );
              if (result == true) {
                await fetchData();
              }
            },
          ),
        ],
      ),
    );
  }
}
