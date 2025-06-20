import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RiwayatKeluarPage extends StatefulWidget {
  const RiwayatKeluarPage({Key? key}) : super(key: key);

  @override
  State<RiwayatKeluarPage> createState() => _RiwayatKeluarPageState();
}

class _RiwayatKeluarPageState extends State<RiwayatKeluarPage> {
  List stockRequests = [];
  List items = [];
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
        Uri.parse('http://192.168.1.6:8000/api/items'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        items = json.decode(response.body);
      }
    } catch (e) {
      print('Error fetch items: $e');
    }
  }

  Future<void> fetchMyStockRequests() async {
    final token = await _getToken();
    if (token == null) return;

    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.6:8000/api/my-stock-requests'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final allRequests = json.decode(response.body);
        stockRequests = allRequests.where((e) => e['type'] == 'decrease').toList();
      }
    } catch (e) {
      print('Error fetch stock requests: $e');
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  void _showItemPickerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Ajukan Barang Keluar"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(item['name']),
                subtitle: Text("Stok: ${item['stock']} | Lokasi: ${item['location']}"),
                onTap: () {
                  Navigator.pop(context);
                  _showRequestDialog(item);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showRequestDialog(Map item) {
    final TextEditingController jumlahController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Ajukan Pengeluaran"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Nama: ${item['name']}"),
            Text("Stok tersedia: ${item['stock']}"),
            TextField(
              controller: jumlahController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Jumlah Stok Keluar",
                labelStyle: TextStyle(color: Colors.purple),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigoAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              final jumlah = int.tryParse(jumlahController.text);
              if (jumlah == null || jumlah <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Jumlah tidak valid")));
                return;
              }
              Navigator.pop(context);
              await _submitRequest(item['id'], jumlah);
            },
            child: const Text("Ajukan"),
          )
        ],
      ),
    );
  }

  Future<void> _submitRequest(int itemId, int jumlah) async {
    final token = await _getToken();
    if (token == null) return;

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.6:8000/api/stock-requests'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: json.encode({
          'item_id': itemId,
          'quantity': jumlah,
          'type': 'decrease'
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pengajuan berhasil dikirim")));
        await fetchData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal: ${response.body}")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal mengirim pengajuan")));
    }
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
                    final status = req['status'];
                    final description = req['description'];
                    final type = req['type'];
                    final createdAt = req['created_at']?.toString().substring(0, 10) ?? '-';

                    final keterangan = (type == 'decrease' && description != null && description.toString().isNotEmpty)
                        ? '✍️ $description'
                        : '📤 Permintaan pengeluaran barang';

                    return Card(
                      margin: const EdgeInsets.all(10),
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      color: Colors.grey.shade100,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("SKU: ${item['sku'] ?? '-'}", style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text("Nama: ${item['name'] ?? '-'}"),
                            Text("Jumlah Stok Keluar: ${req['quantity']}", style: const TextStyle(color: Colors.purple)),
                            Text("Lokasi: ${item['location'] ?? '-'}"),
                            Text("Tanggal: $createdAt"),
                            Text("Keterangan: $keterangan", style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.deepPurple)),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.info_outline, size: 18),
                                const SizedBox(width: 6),
                                Text(
                                  status == 'pending'
                                      ? 'Menunggu persetujuan'
                                      : status == 'approved'
                                          ? '✅ Disetujui'
                                          : '❌ Ditolak',
                                  style: TextStyle(
                                    color: status == 'pending'
                                        ? Colors.orange
                                        : status == 'approved'
                                            ? Colors.green
                                            : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showItemPickerDialog,
        backgroundColor: Colors.indigoAccent,
        child: const Icon(Icons.remove),
      ),
    );
  }
}
