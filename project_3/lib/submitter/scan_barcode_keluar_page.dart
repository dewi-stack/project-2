import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/api_service.dart';

class ScanBarcodeKeluarPage extends StatefulWidget {
  const ScanBarcodeKeluarPage({super.key});

  @override
  State<ScanBarcodeKeluarPage> createState() => _ScanBarcodeKeluarPageState();
}

class _ScanBarcodeKeluarPageState extends State<ScanBarcodeKeluarPage> with SingleTickerProviderStateMixin {
  final TextEditingController _skuController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<dynamic> _kategoriList = [];
  List<dynamic> _subKategoriList = [];
  List<dynamic> _filteredItems = [];
  String? _selectedKategoriId;
  String? _selectedSubKategoriId;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    fetchKategori();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> fetchKategori() async {
    try {
      final kategori = await ApiService.fetchKategori();
      setState(() => _kategoriList = kategori);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal mengambil data kategori")),
        );
      }
    }
  }

  Future<void> fetchSubKategori(int categoryId) async {
    try {
      final subkategori = await ApiService.fetchSubKategori(categoryId);
      setState(() => _subKategoriList = subkategori);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal mengambil sub kategori")),
        );
      }
    }
  }

  Future<void> searchItem(String keyword) async {
    try {
      final result = await ApiService.searchItems(keyword);
      setState(() => _filteredItems = result);
    } catch (_) {
      setState(() => _filteredItems = []);
    }
  }

  Future<void> cekSKU(String sku) async {
    if (_selectedKategoriId == null || _selectedSubKategoriId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih kategori dan subkategori terlebih dahulu!")),
      );
      return;
    }

    final existingItem = await ApiService.fetchItemBySKU(sku);
    
    if (existingItem != null) {
      // ✅ Cek apakah termasuk kategori & subkategori terpilih
      final itemCategoryId = existingItem['category_id']?.toString();
      final itemSubCategoryId = existingItem['sub_category_id']?.toString();

      if (itemCategoryId == _selectedKategoriId && itemSubCategoryId == _selectedSubKategoriId) {
        final success = await showKeluarStokDialog(existingItem);
        if (success == true && mounted) {
          Navigator.pop(context, true);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Barang ditemukan, tapi tidak sesuai kategori/subkategori yang dipilih")),
        );
      }
      return;
    }

    // ❌ SKU tidak ditemukan
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Barang tidak ditemukan dalam sistem")),
    );
  }

  Future<bool?> showKeluarStokDialog(Map<String, dynamic> item) async {
    _qtyController.clear();
    _descriptionController.clear();

    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Barang Keluar"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("SKU: ${item['sku']}"),
              Text("Nama: ${item['name']}"),
              Text("Stok: ${item['stock']}"),
              const SizedBox(height: 10),
              const SizedBox(height: 10),
              TextField(
                controller: _qtyController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Jumlah Keluar",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: "Keterangan",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigoAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              final qty = int.tryParse(_qtyController.text.trim()) ?? 0;

              if (qty <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Jumlah tidak valid")),
                );
                return;
              }

              if ((item['stock'] ?? 0) <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Stok barang 0, tidak bisa dikurangi")),
                );
                return;
              }

              final stockRequests = item['stock_requests'] as List<dynamic>? ?? [];
              if (!stockRequests.any((req) => req['status'] == 'approved')) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Barang belum disetujui, tidak bisa dikurangi")),
                );
                return;
              }

              final result = await ApiService.ajukanStockRequest(
                itemId: item['id'],
                quantity: qty,
                type: 'decrease',
                description: _descriptionController.text.trim(),
                unit: item['unit'], // ✅ Ambil unit dari item
              );

              if (result) Navigator.pop(context, true);
            },
            child: const Text("Ajukan"),
          ),
        ],
      ),
    );
  }

  void _scanWithCamera() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BarcodeScannerPage(onDetect: (sku) => Navigator.pop(context, sku)),
      ),
    );
    if (result != null) cekSKU(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan / Input Barang Keluar"),
        backgroundColor: Colors.indigoAccent,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,             
          unselectedLabelColor: Colors.white70, 
          indicatorColor: Colors.white,         
          tabs: const [
            Tab(text: 'Kategori'),
            Tab(text: 'Input/Scan SKU'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedKategoriId,
                  decoration: const InputDecoration(labelText: "Pilih Kategori", border: OutlineInputBorder()),
                  items: _kategoriList.map((item) {
                    return DropdownMenuItem(value: item['id'].toString(), child: Text(item['name']));
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedKategoriId = val;
                      _selectedSubKategoriId = null;
                      _subKategoriList.clear();
                      if (val != null) fetchSubKategori(int.parse(val));
                    });
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedSubKategoriId,
                  decoration: const InputDecoration(labelText: "Pilih Sub Kategori", border: OutlineInputBorder()),
                  items: _subKategoriList.map((item) {
                    return DropdownMenuItem(value: item['id'].toString(), child: Text(item['name']));
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedSubKategoriId = val),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.navigate_next),
                    label: const Text("Lanjut Input / Scan SKU"),
                    onPressed: () => _tabController.animateTo(1),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: "Cari nama atau SKU",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => searchItem(value),
                ),
                const SizedBox(height: 10),
                if (_filteredItems.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        return Card(
                          child: ListTile(
                            title: Text(item['name']),
                            subtitle: Text('SKU: ${item['sku']} | Stok: ${item['stock']}'),
                            trailing: const Icon(Icons.remove_circle, color: Colors.indigoAccent),
                            onTap: () => cekSKU(item['sku']),
                          ),
                        );
                      },
                    ),
                  )
                else if (_searchController.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: const Text("Barang tidak ditemukan."),
                  )
                else
                  Column(
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.qr_code_scanner),
                        label: const Text("Scan dengan Kamera"),
                        onPressed: _scanWithCamera,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigoAccent,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      const Divider(height: 32),
                      const Text("Atau input SKU manual:"),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _skuController,
                        decoration: const InputDecoration(
                          hintText: "Masukkan kode SKU",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => cekSKU(_skuController.text),
                        child: const Text("OK"),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BarcodeScannerPage extends StatelessWidget {
  final Function(String) onDetect;
  const BarcodeScannerPage({super.key, required this.onDetect});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pindai Barcode")),
      body: MobileScanner(
        onDetect: (capture) {
          final code = capture.barcodes.first.rawValue;
          if (code != null) onDetect(code);
        },
      ),
    );
  }
}
