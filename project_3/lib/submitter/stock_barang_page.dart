import 'package:flutter/material.dart';
import '../services/api_service.dart';

class StokBarangPage extends StatelessWidget {
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
  final Function(int) onDeleteItem;
  final Function(String) onFetchSubCategories;

  const StokBarangPage({
    Key? key,
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
    required this.onDeleteItem,
    required this.onFetchSubCategories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List filteredItems = items.where((item) {
      final matchesCategory = selectedCategory == null || item['category']?['name'] == selectedCategory;
      final matchesSubCategory = selectedSubCategoryName == null || item['sub_category']?['name'] == selectedSubCategoryName;
      final matchesSearch = searchQuery.isEmpty || item['name'].toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSubCategory && matchesSearch;
    }).toList();

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
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        DropdownButton<String>(
                          hint: const Text('Kategori'),
                          value: selectedCategory,
                          items: categories
                              .map((cat) => DropdownMenuItem<String>(
                                    value: cat['name'] as String,
                                    child: Text(cat['name'] as String),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            onFilterChanged(value, null, null, searchQuery);
                            onFetchSubCategories(value!);
                          },
                        ),
                        DropdownButton<String>(
                          hint: const Text('Sub Kategori'),
                          value: selectedSubCategoryName,
                          items: subCategories
                              .map((sub) => DropdownMenuItem<String>(
                                    value: sub['name'] as String,
                                    child: Text(sub['name'] as String),
                                  ))
                              .toList(),
                          onChanged: (value) => onFilterChanged(
                              selectedCategory, value, selectedJenis, searchQuery),
                        ),
                        SizedBox(
                          width: 200,
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: 'Cari nama barang...',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 8),
                            ),
                            onChanged: (value) => onFilterChanged(
                                selectedCategory, selectedSubCategoryName, selectedJenis, value),
                          ),
                        ),
                        TextButton(
                          onPressed: () => onFilterChanged(null, null, null, ''),
                          child: const Text('Reset Filter'),
                        ),
                      ],
                    ),
                  ),
                ),
                Text("Menampilkan ${filteredItems.length} hasil", style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 16),
                ...filteredItems.map((item) => buildItemCard(context, item)).toList(),
              ],
            ),
    );
  }

  Widget buildItemCard(BuildContext context, Map<String, dynamic> item) {
    final int stock = (item['stock'] ?? 0);
    final bool isOutOfStock = stock == 0;
    final stockRequests = item['stock_requests'] as List<dynamic>? ?? [];
    final sortedRequests = [...stockRequests];
    sortedRequests.sort((a, b) => DateTime.parse(b['created_at']).compareTo(DateTime.parse(a['created_at'])));
    final latestRequest = sortedRequests.isNotEmpty ? sortedRequests.first : null;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${item['name']}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Kode Barang: ${item['sku']}"),
            const SizedBox(height: 8),

            // Jumlah stok
            Row(children: [
              const Icon(Icons.inventory_2, color: Colors.brown),
              const SizedBox(width: 5),
              Text(
                "Jumlah Stok: $stock unit",
                style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
              ),
            ]),

            // Kondisi stok habis atau menipis
            if (isOutOfStock) ...[
              Row(children: const [
                Icon(Icons.block, color: Colors.red),
                SizedBox(width: 5),
                Text("❌ Stok Habis!", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ]),
            ] else if (stock <= 10) ...[
              Row(children: const [
                Icon(Icons.warning, color: Colors.redAccent),
                SizedBox(width: 5),
                Text("⚠️ Stok menipis!", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
              ]),
            ],

            // Mutasi terakhir
            if (latestRequest != null) ...[
              Row(children: [
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
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    _buildMutasiStatus(latestRequest),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ]),
            ] else ...[
              Row(children: const [
                Icon(Icons.info_outline, color: Colors.grey),
                SizedBox(width: 5),
                Text("Tidak ada mutasi", style: TextStyle(color: Colors.grey)),
              ]),
            ],

            // Info kategori, lokasi, keterangan
            Row(children: [
              const Icon(Icons.category, color: Colors.blue),
              const SizedBox(width: 5),
              Text("Kategori: ${item['category']?['name'] ?? '-'}"),
            ]),
            Row(children: [
              const Icon(Icons.location_on, color: Colors.red),
              const SizedBox(width: 5),
              Text("Lokasi: ${item['location']}"),
            ]),
            Row(children: [
              const Icon(Icons.more_horiz),
              const SizedBox(width: 5),
              Text("Keterangan: ${item['description'] ?? '-'}"),
            ]),

            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _confirmDelete(context, item),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _buildMutasiStatus(Map<String, dynamic> request) {
    final String type = request['type'];
    final String status = request['status'];
    final int qty = request['quantity'] ?? 0;

    if (status == 'approved') {
      return type == 'delete'
          ? "✅ Penghapusan Disetujui"
          : "✅ Mutasi: ${type == 'increase' ? 'Masuk' : 'Keluar'} $qty Unit (Telah Disetujui)";
    } else if (status == 'pending') {
      if (type == 'delete') {
        return "📝 Pengajuan Penghapusan Telah Diajukan";
      } else {
        return "🕒 Mutasi: ${type == 'increase' ? 'Masuk' : 'Keluar'} $qty Unit (Menunggu Persetujuan)";
      }
    } else if (status == 'rejected') {
      return type == 'delete'
          ? "❌ Penghapusan Ditolak"
          : "❌ Mutasi: ${type == 'increase' ? 'Masuk' : 'Keluar'} $qty Unit (Ditolak)";
    } else {
      return "Status mutasi tidak diketahui";
    }
  }

  void _confirmDelete(BuildContext context, Map<String, dynamic> item) async {
    final scaffold = ScaffoldMessenger.of(context);

    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: Text("Ajukan penghapusan '${item['name']}'?"),
        actions: [
          TextButton(
            child: const Text("Batal"),
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          TextButton(
            child: const Text("Ya"),
            style: TextButton.styleFrom(
              backgroundColor: Colors.indigoAccent,
              foregroundColor: Colors.white, // warna biru untuk teks
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final response = await ApiService.sendDeleteStockRequest(item['id']);
        scaffold.showSnackBar(SnackBar(
          content: Text(response
              ? "Pengajuan hapus '${item['name']}' berhasil dikirim"
              : "Gagal mengajukan hapus barang"),
        ));
      } catch (e) {
        scaffold.showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }
}
