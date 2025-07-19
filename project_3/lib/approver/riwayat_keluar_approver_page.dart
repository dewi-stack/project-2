import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class RiwayatKeluarApproverPage extends StatefulWidget {
  const RiwayatKeluarApproverPage({super.key});

  @override
  State<RiwayatKeluarApproverPage> createState() => _RiwayatKeluarApproverPageState();
}

class _RiwayatKeluarApproverPageState extends State<RiwayatKeluarApproverPage> {
  List requests = [];
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
      Uri.parse('http://192.168.1.6:8000/api/me'),
      headers: headers,
    );

    if (isForcedLogout(response)) {
      await handleForcedLogout();
      return;
    }

    if (response.statusCode == 200) {
      fetchRequests();
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

  Future<void> fetchRequests() async {
    setState(() => isLoading = true);
    final headers = await getHeaders();
    if (headers.isEmpty) return;

    final response = await http.get(
      Uri.parse('http://192.168.1.6:8000/api/stock-requests'),
      headers: headers,
    );

    if (isForcedLogout(response)) {
      await handleForcedLogout();
      return;
    }

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (mounted) {
        setState(() {
          requests = data
              .where((r) => r['type'] == 'decrease' && r['status'] == 'pending')
              .toList();
          isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('⚠️ Gagal memuat data.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> handleApproval(int id, String status) async {
    final headers = await getHeaders();
    if (headers.isEmpty) return;

    final response = await http.put(
      Uri.parse('http://192.168.1.6:8000/api/stock-requests/$id/approve'),
      headers: headers,
      body: jsonEncode({'status': status}),
    );

    if (isForcedLogout(response)) {
      await handleForcedLogout();
      return;
    }

    if (response.statusCode == 200) {
      await fetchRequests();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('✅ Permintaan berhasil ${status == 'approved' ? 'disetujui' : 'ditolak'}'),
            backgroundColor: Colors.green,
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

  int parseInt(dynamic value) {
    return int.tryParse(value.toString()) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: fetchRequests,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : requests.isEmpty
              ? const Center(
                  child: Text(
                    'Tidak ada permintaan keluar yang menunggu persetujuan.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final req = requests[index];
                    final item = req['item'];
                    final createdAt = DateFormat('dd/MM/yy').format(DateTime.parse(req['created_at']));
                    final int currentStock = parseInt(item['stock']);


                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 5,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Nama item
                            Row(
                              children: [
                                const Icon(Icons.inventory, color: Colors.indigo),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    item['name'] ?? '-',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.indigo,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple.shade50,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    "Pengurangan Stok",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // SKU
                            RowInfo(icon: Icons.qr_code, label: "SKU", value: item['sku']),
                            // Jumlah
                            RowInfo(icon: Icons.remove_circle, label: "Jumlah Keluar", value: "${req['quantity']} unit"),
                            // Keterangan
                            RowInfo(
                                icon: Icons.description_outlined,
                                label: "Keterangan",
                                value: req['description'] ?? "-",
                                isMultiLine: true),
                            // Lokasi
                            RowInfo(icon: Icons.location_on, label: "Lokasi", value: item['location']),
                            // Tanggal
                            RowInfo(icon: Icons.calendar_today, label: "Tanggal Permintaan", value: createdAt),

                            const SizedBox(height: 16),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    if (currentStock <= 0) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Stok kosong. Tidak bisa dikurangi.'),
                                            backgroundColor: Colors.redAccent,
                                          ),
                                        );
                                      }
                                      return;
                                    }
                                    handleApproval(req['id'], 'approved');
                                  },
                                  icon: const Icon(Icons.check),
                                  label: const Text('Setujui'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton.icon(
                                  onPressed: () => handleApproval(req['id'], 'rejected'),
                                  icon: const Icon(Icons.close),
                                  label: const Text('Tolak'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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

class RowInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isMultiLine;

  const RowInfo({
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
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
