import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StokBarangApproverPage extends StatelessWidget {
  final List items;
  final bool isLoading;
  final String? selectedCategory;
  final String? selectedSubCategoryName;
  final String? selectedJenis;
  final String searchQuery;
  final List<Map<String, dynamic>> categories;
  final List<Map<String, dynamic>> subCategories;
  final Future<void> Function() onRefresh;
  final Function(String?, String?, String?, String) onFilterChanged;
  final Function(String) onFetchSubCategories;

  const StokBarangApproverPage({
    super.key,
    required this.items,
    required this.isLoading,
    required this.selectedCategory,
    required this.selectedSubCategoryName,
    required this.selectedJenis,
    required this.searchQuery,
    required this.categories,
    required this.subCategories,
    required this.onRefresh,
    required this.onFilterChanged,
    required this.onFetchSubCategories,
  });

  Future<void> updateStockRequestStatus(BuildContext context, int requestId, String newStatus) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      await prefs.clear();
      if (context.mounted) Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    final response = await http.put(
      Uri.parse('https://saji.my.id/api/stock-requests/$requestId/approve'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode({'status': newStatus}),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status berhasil diperbarui menjadi $newStatus')),
      );
      onRefresh();
    } else {
      try {
        final resBody = json.decode(response.body);
        final shouldLogout = resBody['forced_logout'] == true || resBody['message'] == 'Unauthenticated.';
        if (response.statusCode == 401 || response.statusCode == 403 || shouldLogout) {
          await prefs.clear();
          if (context.mounted) Navigator.pushReplacementNamed(context, '/login');
          return;
        }
      } catch (_) {}

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memperbarui status.')),
      );
    }
  }

  void _confirmDelete(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Penghapusan'),
        content: Text('Apakah Anda yakin ingin menghapus item "${item['name']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur hapus belum diimplementasikan.')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List filteredItems = items.where((item) {
      final matchesCategory = selectedCategory == null || item['category']?['name'] == selectedCategory;
      final matchesSubCategory = selectedSubCategoryName == null || item['sub_category']?['name'] == selectedSubCategoryName;
      final matchesSearch = searchQuery.isEmpty || item['name'].toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSubCategory && matchesSearch;
    }).toList();

    filteredItems.sort((a, b) {
      final aReqs = a['stock_requests'] as List<dynamic>? ?? [];
      final bReqs = b['stock_requests'] as List<dynamic>? ?? [];

      final aLatest = aReqs.isEmpty
          ? DateTime.fromMillisecondsSinceEpoch(0)
          : DateTime.tryParse((aReqs..sort((x, y) => DateTime.parse(y['created_at']).compareTo(DateTime.parse(x['created_at'])))).first['created_at']) ?? DateTime.fromMillisecondsSinceEpoch(0);

      final bLatest = bReqs.isEmpty
          ? DateTime.fromMillisecondsSinceEpoch(0)
          : DateTime.tryParse((bReqs..sort((x, y) => DateTime.parse(y['created_at']).compareTo(DateTime.parse(x['created_at'])))).first['created_at']) ?? DateTime.fromMillisecondsSinceEpoch(0);

      return bLatest.compareTo(aLatest);
    });

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('📊 Data Stok Barang',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.indigo)),
                        const SizedBox(height: 4),
                        Text("Total ${items.length} item • Update realtime", style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 1,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth > 800;

                        return Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            SizedBox(
                              width: isWide ? 300 : double.infinity,
                              child: DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  labelText: "Kategori",
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.category_outlined),
                                ),
                                value: selectedCategory,
                                items: categories
                                    .map((cat) => DropdownMenuItem<String>(
                                          value: cat['name'] as String,
                                          child: Text(
                                            cat['name'] as String,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  onFilterChanged(value, null, null, searchQuery);
                                  onFetchSubCategories(value!);
                                },
                              ),
                            ),
                            SizedBox(
                              width: isWide ? 300 : double.infinity,
                              child: DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  labelText: "Sub Kategori",
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.subdirectory_arrow_right_outlined),
                                ),
                                value: selectedSubCategoryName,
                                items: subCategories
                                    .map((sub) => DropdownMenuItem<String>(
                                          value: sub['name'] as String,
                                          child: Text(
                                            sub['name'] as String,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (value) => onFilterChanged(
                                    selectedCategory, value, selectedJenis, searchQuery),
                              ),
                            ),
                            SizedBox(
                              width: isWide ? 250 : double.infinity,
                              child: TextField(
                                decoration: const InputDecoration(
                                  labelText: 'Cari nama barang...',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.search),
                                ),
                                onChanged: (value) => onFilterChanged(
                                    selectedCategory, selectedSubCategoryName, selectedJenis, value),
                              ),
                            ),
                            SizedBox(
                              height: 48,
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.refresh),
                                label: const Text("Reset Filter"),
                                onPressed: () => onFilterChanged(null, null, null, ''),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.indigo,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                Text("Menampilkan ${filteredItems.length} hasil", style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 16),
                ...filteredItems.map((item) => buildItemCard(context, item)),
              ],
            ),
    );
  }

  Widget _buildMutasiStatusRichWidget(Map<String, dynamic> request, String unit) {
    final String type = request['type'];
    final String status = request['status'];
    final int qty = request['quantity'] ?? 0;

    // Menentukan warna dan ikon berdasarkan status/type
    Color? bgColor;
    Color? textColor;
    String labelText = "";
    String detailText = "";

    if (status == 'approved') {
      if (type == 'delete') {
        bgColor = Colors.red[100];
        textColor = Colors.red;
        labelText = "✅ Penghapusan Disetujui";
      } else {
        bgColor = Colors.green[100];
        textColor = Colors.green[900]!;
        labelText = "✅ Mutasi: ${type == 'increase' ? 'Masuk' : 'Keluar'} $qty $unit";
        detailText = " (Telah Disetujui)";
      }
    } else if (status == 'pending') {
      if (type == 'delete') {
        bgColor = Colors.amber[100];
        textColor = Colors.amber[800]!;
        labelText = "📝 Pengajuan Penghapusan";
      } else {
        bgColor = Colors.amber[100];
        textColor = Colors.orange[800]!;
        labelText = "🕒 Mutasi: ${type == 'increase' ? 'Masuk' : 'Keluar'} $qty $unit";
        detailText = " (Menunggu Persetujuan)";
      }
    } else if (status == 'rejected') {
      if (type == 'delete') {
        bgColor = Colors.grey[300];
        textColor = Colors.grey[800]!;
        labelText = "❌ Penghapusan Ditolak";
      } else {
        bgColor = Colors.red[100];
        textColor = Colors.red[800]!;
        labelText = "❌ Mutasi: ${type == 'increase' ? 'Masuk' : 'Keluar'} $qty $unit";
        detailText = " (Ditolak)";
      }
    } else {
      bgColor = Colors.grey[200];
      textColor = Colors.black87;
      labelText = "Status mutasi tidak diketahui";
    }

    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                labelText,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          if (detailText.isNotEmpty)
            TextSpan(
              text: detailText,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }

  Widget buildItemCard(BuildContext context, Map<String, dynamic> item) {
    final int stock = (item['stock'] ?? 0);
    final bool isOutOfStock = stock == 0;
    final String unit = item['unit'] ?? 'unit';

    final stockRequests = item['stock_requests'] as List<dynamic>? ?? [];
    final sortedRequests = [...stockRequests];
    sortedRequests.sort((a, b) =>
        DateTime.parse(b['created_at']).compareTo(DateTime.parse(a['created_at'])));
    final latestRequest = sortedRequests.isNotEmpty ? sortedRequests.first : null;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      color: Colors.white,
      shadowColor: Colors.black.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Nama Barang
                Text(
                  item['name'] ?? 'Nama tidak tersedia',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),

                const SizedBox(height: 6),

                /// SKU
                Text(
                "Kode Barang: ${item['sku'] ?? '-'}",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),

                const SizedBox(height: 16),

                /// Stok
                Row(
                  children: [
                    const Icon(Icons.inventory_2_rounded, color: Colors.brown),
                    const SizedBox(width: 8),
                    Text(
                      "Jumlah Stok: $stock $unit",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.deepOrange,
                      ),
                    ),
                    if (isOutOfStock)
                      _buildBadge("❌ Stok Habis", Colors.red[100], Colors.red)
                    else if (stock <= 10)
                      _buildBadge("⚠️ Stok Menipis", Colors.amber[100], Colors.amber[800]),
                  ],
                ),

                const SizedBox(height: 16),

                /// Mutasi Terakhir
                latestRequest != null
                    ? Row(
                        children: [
                          Icon(
                            latestRequest['type'] == 'increase'
                                ? Icons.arrow_downward
                                : latestRequest['type'] == 'decrease'
                                    ? Icons.arrow_upward
                                    : Icons.delete,
                            color: latestRequest['type'] == 'increase'
                                ? Colors.green
                                : latestRequest['type'] == 'decrease'
                                    ? Colors.orange
                                    : Colors.red,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                             child: _buildMutasiStatusRichWidget(latestRequest, unit),
                          ),
                        ],
                      )
                    : Row(
                        children: const [
                          Icon(Icons.info_outline, color: Colors.grey),
                          SizedBox(width: 6),
                          Text(
                            "Belum ada mutasi",
                            style: TextStyle(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),

                const SizedBox(height: 16),
                Divider(color: Colors.grey[300]),

                /// Informasi Lanjutan
                const SizedBox(height: 12),
                _buildInfoRow(
                  Icons.category_outlined,
                  "Kategori",
                  item['category']?['name'] ?? "-",
                  iconColor: Colors.blue,
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.location_on_outlined,
                  "Lokasi",
                  item['location'] ?? "-",
                  iconColor: Colors.teal,
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.description_outlined,
                  "Keterangan",
                  latestRequest?['description'] ?? "-",
                  iconColor: Colors.deepPurple,
                ),
              ],
            ),

            /// Tombol Hapus
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                tooltip: 'Hapus item',
                onPressed: () => _confirmDelete(context, item),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color? bgColor, Color? textColor) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {Color iconColor = Colors.blueGrey}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(width: 6),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              children: [
                TextSpan(
                  text: "$label: ",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: value,
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
