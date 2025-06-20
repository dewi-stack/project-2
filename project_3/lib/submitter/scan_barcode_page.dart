import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/api_service.dart';
import 'dashboard_page.dart';

class ScanBarcodePage extends StatefulWidget {
  const ScanBarcodePage({super.key});

  @override
  State<ScanBarcodePage> createState() => _ScanBarcodePageState();
}

class _ScanBarcodePageState extends State<ScanBarcodePage> {
  final TextEditingController _skuController = TextEditingController();
  List<dynamic> _kategoriList = [];
  String? _selectedKategoriId;

  @override
  void initState() {
    super.initState();
    fetchKategori();
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

  Future<void> cekSKU(String sku) async {
    final existingItem = await ApiService.fetchItemBySKU(sku);

    if (existingItem != null) {
      final success = await showTambahStokDialog(existingItem);
      if (success == true && mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => DashboardPage(role: 'submitter', initialIndex: 1)),
          (route) => false,
        );
      }
    } else {
      final success = await showInputBarangMasukDialog(sku);
      if (success == true && mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => DashboardPage(role: 'submitter', initialIndex: 1)),
          (route) => false,
        );
      }
    }
  }

  Future<bool?> showInputBarangMasukDialog(String sku) async {
    final namaController = TextEditingController();
    final lokasiController = TextEditingController();
    final stokController = TextEditingController();
    final deskripsiController = TextEditingController();

    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Input Barang Masuk"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Text("SKU: $sku"),
              DropdownButtonFormField<String>(
                value: _selectedKategoriId,
                items: _kategoriList.map((item) {
                  return DropdownMenuItem(
                    value: item['id'].toString(),
                    child: Text(item['name'] ?? 'Tanpa Nama'),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedKategoriId = val),
                decoration: const InputDecoration(labelText: 'Kategori'),
              ),
              TextField(controller: namaController, decoration: const InputDecoration(labelText: 'Nama Barang')),
              TextField(controller: lokasiController, decoration: const InputDecoration(labelText: 'Lokasi')),
              TextField(controller: stokController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Stok / Jumlah')),
              TextField(controller: deskripsiController, decoration: const InputDecoration(labelText: 'Deskripsi')),
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
              final nama = namaController.text;
              final lokasi = lokasiController.text;
              final stok = int.tryParse(stokController.text);
              final deskripsi = deskripsiController.text;

              if (nama.isEmpty || lokasi.isEmpty || stok == null || _selectedKategoriId == null) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Semua data wajib diisi")));
                return;
              }

              try {
                final success = await ApiService.simpanBarangMasuk({
                  'sku': sku,
                  'name': nama,
                  'location': lokasi,
                  'stock': stok,
                  'description': deskripsi,
                  'category_id': int.parse(_selectedKategoriId!),
                });

                if (success) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => DashboardPage(role: 'submitter', initialIndex: 2)), // ke Riwayat Masuk
                    (route) => false,
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))));
              }
            },
            child: const Text("Simpan"),
          )
        ],
      ),
    );
  }

  Future<bool?> showTambahStokDialog(Map<String, dynamic> existingItem) async {
    final stokController = TextEditingController();

    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Ajukan Tambah Stok"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("SKU: ${existingItem['sku']}", style: const TextStyle(fontWeight: FontWeight.bold)),
            Text("Nama: ${existingItem['name']}"),
            Text("Stok Saat Ini: ${existingItem['stock']}", style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 10),
            TextField(
              controller: stokController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Jumlah Tambahan'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigoAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              final qty = int.tryParse(stokController.text);

              if (qty == null || qty <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Jumlah stok harus lebih dari 0")),
                );
                return;
              }

              try {
                final success = await ApiService.ajukanStockRequest(
                  itemId: existingItem['id'],
                  quantity: qty,
                  type: 'increase',
                );

                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Barang berhasil ditambahkan dan menunggu persetujuan")),
                  );

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => DashboardPage(role: 'submitter', initialIndex: 2)), // ke Riwayat Masuk
                    (route) => false,
                  );

                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
                );
              }
            },
            child: const Text("Ajukan"),
          )
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

  void _submitSKU() => cekSKU(_skuController.text);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan / Input SKU"), 
        backgroundColor: Colors.indigoAccent,
        foregroundColor: Colors.white,
        ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
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
              decoration: const InputDecoration(hintText: "Masukkan kode SKU", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _submitSKU, child: const Text("OK")),
          ],
        ),
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
