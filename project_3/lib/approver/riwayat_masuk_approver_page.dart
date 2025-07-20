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
    validateTokenAndFetch();
  }

  Future<Map<String, String>> getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      await handleForcedLogout();
      return {};
    }

    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }

  bool isForcedLogout(http.Response res) {
    if (res.statusCode == 401 || res.statusCode == 403) {
      try {
        final data = json.decode(res.body);
        return data['forced_logout'] == true || data['message'] == 'Unauthenticated.';
      } catch (_) {
        return true;
      }
    }
    return false;
  }

  Future<void> handleForcedLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('⚠️ Sesi Anda telah berakhir. Silakan login kembali.'),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> validateTokenAndFetch() async {
    final headers = await getHeaders();
    if (headers.isEmpty) return;

    final response = await http.get(
      Uri.parse('https://saji.my.id/api/me'),
      headers: headers,
    );

    if (isForcedLogout(response)) {
      await handleForcedLogout();
      return;
    }

    if (response.statusCode == 200) {
      fetchPendingStockRequests();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('⚠️ Gagal memverifikasi token.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> fetchPendingStockRequests() async {
    setState(() => isLoading = true);
    final headers = await getHeaders();
    if (headers.isEmpty) return;

    final response = await http.get(
      Uri.parse('https://saji.my.id/api/stock-requests'),
      headers: headers,
    );

    if (isForcedLogout(response)) {
      await handleForcedLogout();
      return;
    }

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
          const SnackBar(content: Text('⚠️ Gagal memuat data'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> processRequest(int requestId, String action) async {
    final headers = await getHeaders();
    if (headers.isEmpty) return;

    final response = await http.put(
      Uri.parse('https://saji.my.id/api/stock-requests/$requestId/approve'),
      headers: headers,
      body: jsonEncode({'status': action}),
    );

    if (isForcedLogout(response)) {
      await handleForcedLogout();
      return;
    }

    if (response.statusCode == 200) {
      await fetchPendingStockRequests();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '✅ Permintaan berhasil ${action == 'approved' ? 'disetujui' : 'ditolak'}',
            ),
            backgroundColor: action == 'approved' ? Colors.green : Colors.red,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('⚠️ Gagal memproses permintaan: ${response.body}'),
            backgroundColor: Colors.red,
          ),
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
              ? const Center(
                  child: Text(
                    'Tidak ada permintaan masuk yang menunggu persetujuan.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: stockRequests.length,
                  itemBuilder: (context, index) {
                    final request = stockRequests[index];
                    final item = request['item'];
                    final type = request['type'];
                    final tanggal = DateFormat('dd/MM/yy').format(DateTime.parse(request['created_at']));
                    final isInitial = type == 'initial';

                    return Card(
                      elevation: 6,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header: Nama Item dan Tag
                            Row(
                              children: [
                                const Icon(Icons.inventory_2, color: Colors.indigo),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    item?['name'] ?? '-',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.indigo,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple.shade50,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    isInitial ? 'Barang Baru' : 'Penambahan Stok',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Info baris per baris
                            InfoRow(icon: Icons.qr_code, label: 'SKU', value: item?['sku']),
                            InfoRow(icon: Icons.format_list_numbered, label: 'Jumlah', value: '${request['quantity']} unit'),
                            InfoRow(icon: Icons.description_outlined, label: 'Keterangan', value: request['description'] ?? '-', isMultiLine: true),
                            InfoRow(icon: Icons.location_on_outlined, label: 'Lokasi', value: item?['location']),
                            InfoRow(icon: Icons.date_range, label: 'Tanggal Pengajuan', value: tanggal),

                            const SizedBox(height: 16),

                            // Tombol aksi
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () => processRequest(request['id'], 'approved'),
                                  icon: const Icon(Icons.check),
                                  label: const Text('Setujui'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton.icon(
                                  onPressed: () => processRequest(request['id'], 'rejected'),
                                  icon: const Icon(Icons.close),
                                  label: const Text('Tolak'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
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

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final bool isMultiLine;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.isMultiLine = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: isMultiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Text(
              value ?? '-',
              style: const TextStyle(color: Colors.black87),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}


