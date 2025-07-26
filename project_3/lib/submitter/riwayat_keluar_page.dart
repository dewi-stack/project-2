import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'scan_barcode_keluar_page.dart';
import 'package:project_3/screens/login_page.dart';

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
    setState(() => isLoading = true);
    await fetchItems();
    await fetchMyStockRequests();
    setState(() => isLoading = false);
  }

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
  }

  Future<void> fetchItems() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('https://saji.my.id/api/items'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        items = json.decode(response.body);
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        await _handleForcedLogout();
      }
    } catch (e) {
      print('Fetch items error: $e');
    }
  }

  Future<void> fetchMyStockRequests() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('https://saji.my.id/api/stock-requests/submitter'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final allRequests = json.decode(response.body);
        stockRequests = allRequests.where((e) => e['type'] == 'decrease').toList();
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        await _handleForcedLogout();
      }
    } catch (e) {
      print('Fetch requests error: $e');
    }
  }

  Future<void> _handleForcedLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Sesi login Anda telah berakhir. Silakan login kembali.")),
    );

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : stockRequests.isEmpty
                ? const Center(child: Text("Belum ada pengajuan pengeluaran barang."))
                : RefreshIndicator(
                    onRefresh: fetchData,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
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
                        final unit = item['unit'] ?? '-';

                        Color statusColor;
                        IconData statusIcon;
                        String statusText;

                        switch (status) {
                          case 'approved':
                            statusColor = Colors.green;
                            statusIcon = Icons.check_circle_outline;
                            statusText = 'Disetujui';
                            break;
                          case 'rejected':
                            statusColor = Colors.red;
                            statusIcon = Icons.cancel_outlined;
                            statusText = 'Ditolak';
                            break;
                          default:
                            statusColor = Colors.orange;
                            statusIcon = Icons.hourglass_top;
                            statusText = 'Menunggu Persetujuan';
                        }

                        return Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.inventory_2, color: Colors.indigo),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        itemName,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text("Kode Barang: $sku", style: const TextStyle(color: Colors.grey)),
                                const SizedBox(height: 8),

                                Row(children: [
                                  const Icon(Icons.remove_circle_outline, color: Colors.red),
                                  const SizedBox(width: 6),
                                  Text("Jumlah Keluar: $quantity $unit",
                                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                ]),

                                const SizedBox(height: 6),
                                Row(children: [
                                  const Icon(Icons.location_on, color: Colors.deepOrange),
                                  const SizedBox(width: 6),
                                  Text("Lokasi: $location", style: const TextStyle(color: Colors.black54)),
                                ]),

                                const SizedBox(height: 6),
                                Row(children: [
                                  const Icon(Icons.calendar_month, color: Colors.teal),
                                  const SizedBox(width: 6),
                                  Text("Tanggal: $createdAt", style: const TextStyle(color: Colors.black54)),
                                ]),

                                const SizedBox(height: 6),
                                Row(children: [
                                  const Icon(Icons.notes, color: Colors.deepPurple),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      "Keterangan: $description",
                                      style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                  ),
                                ]),

                                const Divider(height: 20, thickness: 1),
                                Row(children: [
                                  Icon(statusIcon, color: statusColor),
                                  const SizedBox(width: 6),
                                  Text(
                                    statusText,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: statusColor,
                                    ),
                                  ),
                                ]),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.indigoAccent,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.remove),
          label: const Text("Keluar Barang"),
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
      );
  }
}
