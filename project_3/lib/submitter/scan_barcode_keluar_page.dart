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
  String selectedSatuan = 'pcs';

  final satuanList = ['pcs', 'kg', 'gr', 'liter', 'mililiter', 'box'];

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

  Future<void> cekSKU(String sku, {bool fromSearch = false}) async {
    if (!fromSearch && _selectedKategoriId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih kategori terlebih dahulu!")),
      );
      return;
    }

    final existingItem = await ApiService.fetchItemBySKU(sku);

    if (existingItem != null) {
      final itemCategoryId = existingItem['category_id']?.toString();
      final itemSubCategoryId = existingItem['sub_category_id']?.toString();

      if (fromSearch ||
          (itemCategoryId == _selectedKategoriId &&
              (_selectedSubKategoriId == null || itemSubCategoryId == _selectedSubKategoriId))) {
        final success = await showKeluarStokDialog(existingItem);
        if (success == true && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Berhasil mengajukan pengurangan stok")),
          );
          Navigator.pop(context, true);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Barang ditemukan, tapi tidak sesuai kategori/subkategori yang dipilih")),
        );
      }
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Barang tidak ditemukan dalam sistem")),
    );
  }

Future<bool?> showKeluarStokDialog(Map<String, dynamic> item) async {
  _qtyController.clear();
  _descriptionController.clear();
  selectedSatuan = item['unit'] ?? 'pcs';

  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
      actionsPadding: const EdgeInsets.only(right: 12, bottom: 8),
      title: Row(
        children: const [
          Icon(Icons.remove_shopping_cart, color: Colors.indigoAccent),
          SizedBox(width: 8),
          Text("Pengeluaran Stok"),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("📦 Kode Barang: ${item['sku']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text("📝 Nama: ${item['name']}"),
                  const SizedBox(height: 4),
                  Text("📊 Stok Saat Ini: ${item['stock']} ${item['unit'] ?? ''}", style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Jumlah keluar
            TextField(
              controller: _qtyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Jumlah Keluar",
                prefixIcon: Icon(Icons.remove_circle_outline),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Satuan
            TextFormField(
              initialValue: selectedSatuan,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Satuan',
                prefixIcon: Icon(Icons.category_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Keterangan
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: "Keterangan",
                prefixIcon: Icon(Icons.note_alt_outlined),
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
      actions: [
        TextButton.icon(
          onPressed: () => Navigator.pop(context, false),
          icon: const Icon(Icons.cancel_outlined, color: Colors.redAccent),
          label: const Text("Batal"),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigoAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          onPressed: () async {
            final qty = int.tryParse(_qtyController.text.trim()) ?? 0;

            if (qty <= 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Jumlah tidak valid")),
              );
              return;
            }

            final availableStock = item['stock'] ?? 0;

            if (availableStock <= 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Stok barang 0, tidak bisa dikurangi")),
              );
              return;
            }

            if (qty > availableStock) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Jumlah melebihi stok tersedia ($availableStock ${item['unit'] ?? ''})")),
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
              unit: item['unit'],
            );

            if (result) Navigator.pop(context, true);
          },
          icon: const Icon(Icons.send_rounded),
          label: const Text("Ajukan"),
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
        title: const Text("Scan / Input Kode Barang"),
        backgroundColor: Colors.indigoAccent,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.amberAccent,
          tabs: const [
            Tab(text: 'Kategori'),
            Tab(text: 'Input/Scan Kode Barang'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab Kategori
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedKategoriId,
                  decoration: const InputDecoration(
                    labelText: "Pilih Kategori",
                    border: OutlineInputBorder(),
                  ),
                  items: _kategoriList
                      .map((item) => DropdownMenuItem(
                            value: item['id'].toString(),
                            child: Text(item['name']),
                          ))
                      .toList(),
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
                  decoration: const InputDecoration(
                    labelText: "Pilih Sub Kategori",
                    border: OutlineInputBorder(),
                  ),
                  items: _subKategoriList
                      .map((item) => DropdownMenuItem(
                            value: item['id'].toString(),
                            child: Text(item['name']),
                          ))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedSubKategoriId = val),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.navigate_next),
                    label: const Text("Lanjut Input / Scan Kode barang"),
                    onPressed: () => _tabController.animateTo(1),
                  ),
                ),
              ],
            ),
          ),

          // Tab Input/Scan
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Cari Nama atau Kode Barang",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                  onChanged: (value) {
                    if (value.trim().isEmpty) {
                      setState(() => _filteredItems.clear());
                    } else {
                      searchItem(value);
                    }
                  },
                ),
                const SizedBox(height: 16),

                if (_searchController.text.isNotEmpty && _filteredItems.isNotEmpty)
                  Expanded(
                    child: ListView.separated(
                      itemCount: _filteredItems.length,
                      separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.grey),
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        return Card(
                          color: Colors.indigo.shade50,
                          elevation: 2,
                          child: ListTile(
                            leading: const Icon(Icons.qr_code, color: Colors.indigoAccent),
                            title: Text(
                              item['name'],
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            subtitle: Text(
                              'Kode: ${item['sku']} | Stok: ${item['stock']} ${item['unit'] ?? ''}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            trailing: const Icon(Icons.remove_circle, color: Colors.indigoAccent),
                            onTap: () => cekSKU(item['sku'], fromSearch: true),
                          ),
                        );
                      },
                    ),
                  )
                else if (_searchController.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: Column(
                      children: [
                        const Text(
                          "Barang tidak ditemukan.",
                          style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.qr_code_scanner),
                          label: const Text("Scan dengan Kamera"),
                          onPressed: _scanWithCamera,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigoAccent,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
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
                      const SizedBox(height: 24),
                      const Divider(thickness: 1),
                      const Text(
                        "Atau Input Kode Barang manual:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _skuController,
                        decoration: InputDecoration(
                          hintText: "Masukkan Kode Barang",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.check_circle),
                        label: const Text("OK"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        onPressed: () {
                          final sku = _skuController.text.trim();
                          if (sku.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Kode barang tidak boleh kosong")),
                            );
                            return;
                          }
                          cekSKU(sku);
                        },
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
