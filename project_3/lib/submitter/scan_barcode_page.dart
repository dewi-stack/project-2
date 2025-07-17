import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/api_service.dart';

class ScanBarcodePage extends StatefulWidget {
  const ScanBarcodePage({super.key});

  @override
  State<ScanBarcodePage> createState() => _ScanBarcodePageState();
}

class _ScanBarcodePageState extends State<ScanBarcodePage> with SingleTickerProviderStateMixin {
  final TextEditingController _skuController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _stokController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

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
    final kategori = await ApiService.fetchKategori();
    setState(() => _kategoriList = kategori);
  }

  Future<void> fetchSubKategori(int categoryId) async {
    final subkategori = await ApiService.fetchSubKategori(categoryId);
    setState(() => _subKategoriList = subkategori);
  }

  Future<void> searchItem(String keyword) async {
    final result = await ApiService.searchItems(keyword);
    setState(() => _filteredItems = result);
  }

  Future<void> cekSKU(String sku, {bool skipManualInput = false, bool fromSearch = false}) async {
    final existingItem = await ApiService.fetchItemBySKU(sku);

    if (existingItem != null) {
      final itemCategoryId = existingItem['category_id']?.toString();
      final itemSubCategoryId = existingItem['sub_category_id']?.toString();

      if (_selectedKategoriId != null && _selectedKategoriId != itemCategoryId) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("⚠️ Kategori tidak sesuai dengan data barang.")),
        );
      }

      if (_selectedSubKategoriId != null && _selectedSubKategoriId != itemSubCategoryId) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("⚠️ Subkategori tidak sesuai dengan data barang.")),
        );
      }

      final success = await showTambahStokDialog(existingItem);
      if (success == true && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Berhasil mengajukan tambah stok")),
        );
        Navigator.pop(context, true);
      }
      return;
    }

    if (_selectedKategoriId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❗Pilih kategori terlebih dahulu untuk menambahkan barang baru!")),
      );
      return;
    }

    String? finalSKU = skipManualInput ? sku : await showSKUInputDialog();
    if (finalSKU == null || finalSKU.isEmpty) return;

    final success = await showInputBarangMasukDialog(finalSKU);
    if (success == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Barang baru berhasil disimpan")),
      );
      Navigator.pop(context, true);
    }
  }

  Future<String?> showSKUInputDialog() async {
    final TextEditingController _manualSKUController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Input Kode Barang Baru"),
        content: TextField(
          controller: _manualSKUController,
          decoration: const InputDecoration(
            labelText: "Masukkan Kode Barang",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () {
              final sku = _manualSKUController.text.trim();
              if (sku.isEmpty) return;
              Navigator.pop(context, sku);
            },
            child: const Text("Lanjut"),
          ),
        ],
      ),
    );
  }

  Future<bool?> showTambahStokDialog(Map<String, dynamic> item) async {
    _stokController.clear();
    _deskripsiController.clear();

    final unit = item['unit']?.toString().toLowerCase() ?? 'pcs';
    selectedSatuan = satuanList.contains(unit) ? unit : 'pcs';

    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
        actionsPadding: const EdgeInsets.only(right: 12, bottom: 8),
        title: Row(
          children: const [
            Icon(Icons.add_box_outlined, color: Colors.indigoAccent),
            SizedBox(width: 8),
            Text("Ajukan Tambah Stok", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              TextField(
                controller: _stokController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Tambahan',
                  prefixIcon: Icon(Icons.add_circle_outline),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: selectedSatuan,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Satuan',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.straighten),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _deskripsiController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi/Keterangan',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.note_alt),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.pop(context, false),
            icon: const Icon(Icons.cancel, color: Colors.redAccent),
            label: const Text("Batal"),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.send),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigoAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              final qty = int.tryParse(_stokController.text.trim());
              final keterangan = _deskripsiController.text.trim();

              if (qty == null || qty <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Jumlah tidak valid")));
                return;
              }

              final success = await ApiService.ajukanStockRequest(
                itemId: item['id'],
                quantity: qty,
                type: 'increase',
                description: keterangan,
                unit: selectedSatuan,
              );

              if (success) Navigator.pop(context, true);
            },
            label: const Text("Ajukan"),
          ),
        ],
      ),
    );
  }

  Future<bool?> showInputBarangMasukDialog(String sku) async {
    _namaController.clear();
    _lokasiController.clear();
    _stokController.clear();
    _deskripsiController.clear();

    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.inventory_2_outlined, color: Colors.indigoAccent),
            SizedBox(width: 8),
            Text("Input Barang Baru", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("📦 Kode Barang: $sku", style: const TextStyle(fontWeight: FontWeight.bold)),
              const Divider(height: 20),
              TextField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Barang',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.label_outline),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _lokasiController,
                decoration: const InputDecoration(
                  labelText: 'Lokasi',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _stokController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Stok',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.storage_rounded),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedSatuan,
                decoration: const InputDecoration(
                  labelText: 'Satuan',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.straighten),
                ),
                items: satuanList.map((satuan) => DropdownMenuItem(
                  value: satuan,
                  child: Text(satuan),
                )).toList(),
                onChanged: (val) => setState(() => selectedSatuan = val!),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _deskripsiController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi/Keterangan',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description_outlined),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.pop(context, false),
            icon: const Icon(Icons.cancel, color: Colors.redAccent),
            label: const Text("Batal"),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.save_rounded),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigoAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              final nama = _namaController.text.trim();
              final lokasi = _lokasiController.text.trim();
              final stok = int.tryParse(_stokController.text.trim());
              final deskripsi = _deskripsiController.text.trim();

              if (nama.isEmpty || lokasi.isEmpty || stok == null || selectedSatuan.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Semua data wajib diisi")),
                );
                return;
              }

              final success = await ApiService.simpanBarangMasuk({
                'sku': sku,
                'name': nama,
                'location': lokasi,
                'stock': stok,
                'unit': selectedSatuan,
                'description': deskripsi,
                'category_id': int.parse(_selectedKategoriId!),
                'sub_category_id': _selectedSubKategoriId != null ? int.parse(_selectedSubKategoriId!) : null,
              });

              if (success) Navigator.pop(context, true);
            },
            label: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  void _scanWithCamera() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BarcodeScannerPage(onDetect: (sku) => Navigator.pop(context, sku))),
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
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedKategoriId,
                  decoration: const InputDecoration(labelText: "Pilih Kategori", border: OutlineInputBorder()),
                  items: _kategoriList.map((item) => DropdownMenuItem(value: item['id'].toString(), child: Text(item['name']))).toList(),
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
                  items: _subKategoriList.map((item) => DropdownMenuItem(value: item['id'].toString(), child: Text(item['name']))).toList(),
                  onChanged: (val) => setState(() => _selectedSubKategoriId = val),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.navigate_next),
                  label: const Text("Lanjut Input / Scan Kode Barang"),
                  onPressed: () => _tabController.animateTo(1),
                )
              ],
            ),
          ),

          // Tab Scan/Input
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
                      setState(() {
                        _filteredItems.clear();
                      });
                    } else {
                      searchItem(value);
                    }
                  },
                ),
                const SizedBox(height: 10),
                if (_searchController.text.isNotEmpty && _filteredItems.isNotEmpty)
                  Expanded(
                    child: ListView.separated(
                      itemCount: _filteredItems.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        return Card(
                          color: Colors.indigo.shade50,
                          child: ListTile(
                            leading: const Icon(Icons.qr_code, color: Colors.indigo),
                            title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text("Kode: ${item['sku']} | Stok: ${item['stock']} ${item['unit'] ?? ''}"),
                            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.indigo),
                            onTap: () => cekSKU(item['sku']),
                          ),
                        );
                      },
                    ),
                  )
                else if (_searchController.text.isNotEmpty)
                  Column(
                    children: [
                      const Text("Barang tidak ditemukan.", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text("Input Barang Baru (Manual SKU)"),
                        onPressed: () async {
                          String? manualSKU = await showSKUInputDialog();
                          if (manualSKU != null && manualSKU.isNotEmpty) {
                            await cekSKU(manualSKU, skipManualInput: true);
                          }
                        },
                      ),
                    ],
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
                      const Text("Atau Input Kode Barang manual:"),
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
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text("OK"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        onPressed: () async {
                          final sku = _skuController.text.trim();
                          if (sku.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kode barang tidak boleh kosong")));
                            return;
                          }
                          await cekSKU(sku, skipManualInput: true);
                        },
                      ),
                    ],
                  )
              ],
            ),
          )
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
