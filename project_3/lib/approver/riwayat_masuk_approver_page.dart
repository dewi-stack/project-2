import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class RiwayatMasukApproverPage extends StatefulWidget {
  const RiwayatMasukApproverPage({super.key});

  @override
  State<RiwayatMasukApproverPage> createState() => _RiwayatMasukApproverPageState();
}

class _RiwayatMasukApproverPageState extends State<RiwayatMasukApproverPage> {
  List stockRequests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPendingStockRequests();
  }

  Future<void> fetchPendingStockRequests() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('http://192.168.1.6:8000/api/stock-requests'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (!mounted) return;

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        stockRequests = data.where((item) =>
          item['status'] == 'pending' &&
          (item['type'] == 'initial' || item['type'] == 'increase')
        ).toList();
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memuat data')),
        );
      }
    }
  }

  Future<void> processRequest(int requestId, String action) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.put(
      Uri.parse('http://192.168.1.6:8000/api/stock-requests/$requestId/approve'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'status': action}),
    );

    if (!mounted) return;

    if (response.statusCode == 200) {
      await fetchPendingStockRequests();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Permintaan berhasil ${action == 'approved' ? 'disetujui' : 'ditolak'}')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memproses permintaan: ${response.body}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: fetchPendingStockRequests,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : stockRequests.isEmpty
              ? const Center(child: Text('Tidak ada permintaan masuk yang menunggu persetujuan.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: stockRequests.length,
                  itemBuilder: (context, index) {
                    final request = stockRequests[index];
                    final item = request['item'];
                    final type = request['type'];
                    final tanggal = DateFormat('dd/MM/yy').format(DateTime.parse(request['created_at']));
                    final isInitial = type == 'initial';

                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item?['name'] ?? '-',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.qr_code, size: 18, color: Colors.grey),
                                const SizedBox(width: 6),
                                Text('SKU: ${item?['sku'] ?? '-'}'),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.inventory_2, size: 18, color: Colors.grey),
                                const SizedBox(width: 6),
                                Text('Jumlah: ${request['quantity']} unit'),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.description_outlined, size: 18, color: Colors.grey),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Keterangan: ${request['description'] ?? '-'}',
                                    style: const TextStyle(color: Colors.black87),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 18, color: Colors.grey),
                                const SizedBox(width: 6),
                                Text('Lokasi: ${item?['location'] ?? '-'}'),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.date_range, size: 18, color: Colors.grey),
                                const SizedBox(width: 6),
                                Text('Tanggal Pengajuan: $tanggal'),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.label_outline, size: 18, color: Colors.grey),
                                const SizedBox(width: 6),
                                Text(
                                  'Tipe: ${isInitial ? 'Barang Baru' : 'Penambahan Stok'}',
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () => processRequest(request['id'], 'approved'),
                                  icon: const Icon(Icons.check),
                                  label: const Text('Approve'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton.icon(
                                  onPressed: () => processRequest(request['id'], 'rejected'),
                                  icon: const Icon(Icons.close),
                                  label: const Text('Reject'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
    );
  }
}
