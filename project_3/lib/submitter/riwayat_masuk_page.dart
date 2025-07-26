import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'scan_barcode_page.dart';
import 'package:project_3/screens/login_page.dart';

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

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
  }

  Future<void> _handleForcedLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Sesi login Anda telah berakhir. Silakan login kembali.")),
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  Future<void> fetchStockRequests() async {
    setState(() => isLoading = true);

    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('https://saji.my.id/api/stock-requests/submitter'), // ✅ endpoint baru
        headers: headers,
      );

      if (!mounted) return;

      if (response.statusCode == 401 || response.statusCode == 403) {
        await _handleForcedLogout();
        return;
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final filtered = data.where((item) =>
            item['type'] == 'increase' || item['type'] == 'initial').toList();

        setState(() {
          items = filtered;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Error: $e');
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : items.isEmpty
                ? const Center(
                    child: Text("Belum ada pengajuan penambahan stok barang."),
                  )
                : RefreshIndicator(
                    onRefresh: fetchStockRequests,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final itemData = item['item'] ?? {};
                        final itemName = itemData['name'] ?? '-';
                        final sku = itemData['sku'] ?? '-';
                        final location = itemData['location'] ?? '-';
                        final quantity = item['quantity'] ?? 0;
                        final status = item['status'];
                        final createdAt = item['created_at']?.toString().substring(0, 10) ?? '-';
                        final keterangan = item['description'] ?? '-';
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
                                  const Icon(Icons.add_circle_outline, color: Colors.purple),
                                  const SizedBox(width: 6),
                                  Text("Jumlah Masuk: $quantity $unit",
                                      style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
                                ]),
                                const SizedBox(height: 6),
                                Row(children: [
                                  const Icon(Icons.location_on, color: Colors.deepOrange),
                                  const SizedBox(width: 6),
                                  Text("Lokasi: $location", style: const TextStyle(color: Colors.black54)),
                                ]),
                                const SizedBox(height: 6),
                                Row(children: [
                                  const Icon(Icons.calendar_today, color: Colors.teal),
                                  const SizedBox(width: 6),
                                  Text("Tanggal: $createdAt", style: const TextStyle(color: Colors.black54)),
                                ]),
                                const SizedBox(height: 6),
                                Row(children: [
                                  const Icon(Icons.notes, color: Colors.deepPurple),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      "Keterangan: $keterangan",
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
          icon: const Icon(Icons.add),
          label: const Text("Tambah Stok"),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ScanBarcodePage()),
            );
            if (result == true) {
              await fetchStockRequests();
            }
          },
        ),
      );
  }
}
