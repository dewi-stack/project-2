import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final TextEditingController _satuanController = TextEditingController();
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
    final existingItem = await ApiService.fetchItemBySKU(sku);

    if (existingItem != null) {
      final success = await showTambahStokDialog(existingItem);
      if (success == true && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Berhasil mengajukan tambah stok")),
        );
        Navigator.pop(context, true);
      }
      return; // ✅ Stop di sini jika item sudah ada
    }

    if (_selectedKategoriId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih kategori terlebih dahulu!")),
      );
      return;
    }

    final success = await showInputBarangMasukDialog(sku);
    if (success == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Barang baru berhasil disimpan")),
      );
      Navigator.pop(context, true);
    }
  }

  Future<bool?> showTambahStokDialog(Map<String, dynamic> item) async {
  _stokController.clear();
  _deskripsiController.clear(); // pastikan deskripsi kosong setiap buka dialog baru

  return showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text("Ajukan Tambah Stok"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("SKU: ${item['sku']}", style: const TextStyle(fontWeight: FontWeight.bold)),
            Text("Nama: ${item['name']}"),
            Text("Stok Saat Ini: ${item['stock']}", style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 10),
            TextField(
              controller: _stokController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Jumlah Tambahan', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _deskripsiController,
              decoration: const InputDecoration(labelText: 'Deskripsi/Keterangan', border: OutlineInputBorder()),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text("Batal"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigoAccent, // warna latar
            foregroundColor: Colors.white,
          ),
          onPressed: () async {
            final qty = int.tryParse(_stokController.text);
            final keterangan = _deskripsiController.text.trim();

            if (qty == null || qty <= 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Jumlah tidak valid")),
              );
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
          child: const Text("Ajukan"),
        ),
      ]

        ),
    );
}


  Future<bool?> showInputBarangMasukDialog(String sku) async {
    _namaController.clear();
    _lokasiController.clear();
    _stokController.clear();
    _satuanController.clear();
    _deskripsiController.clear();

    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Input Barang Baru"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Text("SKU: $sku"),
              const SizedBox(height: 8),
              TextField(controller: _namaController, decoration: const InputDecoration(labelText: 'Nama Barang', border: OutlineInputBorder())),
              const SizedBox(height: 8),
              TextField(controller: _lokasiController, decoration: const InputDecoration(labelText: 'Lokasi', border: OutlineInputBorder())),
              const SizedBox(height: 8),
              TextField(controller: _stokController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Stok', border: OutlineInputBorder())),
              const SizedBox(height: 8),
              TextField(controller: _satuanController, decoration: const InputDecoration(labelText: 'Satuan', border: OutlineInputBorder())),
              const SizedBox(height: 8),
              TextField(controller: _deskripsiController, decoration: const InputDecoration(labelText: 'Deskripsi/Keterangan', border: OutlineInputBorder())),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigoAccent,
              foregroundColor: Colors.white, // ⬅️ ini bikin teks "Simpan" jadi putih
            ),
            onPressed: () async {
              final nama = _namaController.text;
              final lokasi = _lokasiController.text;
              final stok = int.tryParse(_stokController.text);
              final satuan = _satuanController.text;
              final deskripsi = _deskripsiController.text;

              if (nama.isEmpty || lokasi.isEmpty || stok == null || satuan.isEmpty) {
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
                'unit': satuan,
                'description': deskripsi,
                'category_id': int.parse(_selectedKategoriId!),
                'sub_category_id': _selectedSubKategoriId != null ? int.parse(_selectedSubKategoriId!) : null,
              });

              if (success) Navigator.pop(context, true);
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  void _scanWithCamera() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BarcodeScannerPage(onDetect: (sku) => Navigator.pop(context, sku)),
      ),
    );
    if (result != null) cekSKU(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan / Input SKU"),
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
                            subtitle: Text('SKU: ${item['sku']}'),
                            trailing: const Icon(Icons.check_circle, color: Colors.green),
                            onTap: () => cekSKU(item['sku']),
                          ),
                        );
                      },
                    ),
                  )
                else if (_searchController.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        const Text("Barang tidak ditemukan."),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text("Tambah Barang Baru"),
                          onPressed: () => cekSKU(_searchController.text),
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