import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:universal_html/html.dart' as html;
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class ExportApproverPage extends StatefulWidget {
  const ExportApproverPage({Key? key}) : super(key: key);

  @override
  State<ExportApproverPage> createState() => _ExportApproverPageState();
}

class _ExportApproverPageState extends State<ExportApproverPage> {
  bool isLoading = true;
  List items = [];
  DateTime? posisiDate;
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
    setState(() => isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('http://192.168.1.3:8000/api/items'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      setState(() {
        items = json.decode(response.body);
        isLoading = false;
      });
    } else {
      print('Failed to load items');
      setState(() => isLoading = false);
    }
  }

  List filterPosisiByDate() {
    if (posisiDate == null) return [];

    return items.where((item) {
      final createdAt = DateTime.tryParse(item['created_at'] ?? '');
      if (createdAt == null) return false;

      // Hanya item yang punya stock request disetujui
      final stockRequests = item['stock_requests'] as List<dynamic>? ?? [];
      final hasApproved = stockRequests.any((req) => req['status'] == 'approved');

      return hasApproved &&
          createdAt.year == posisiDate!.year &&
          createdAt.month == posisiDate!.month &&
          createdAt.day == posisiDate!.day;
    }).toList();
  }

  List filterMutasiByDateRange() {
    if (startDate == null || endDate == null) return [];

    return items.where((item) {
      final createdAt = DateTime.tryParse(item['created_at'] ?? '');
      if (createdAt == null) return false;

      final stockRequests = item['stock_requests'] as List<dynamic>? ?? [];
      final hasApproved = stockRequests.any((req) => req['status'] == 'approved');

      return hasApproved &&
          createdAt.isAfter(startDate!.subtract(const Duration(days: 1))) &&
          createdAt.isBefore(endDate!.add(const Duration(days: 1)));
    }).toList();
  }

  Future<void> pickPosisiDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDate: posisiDate ?? DateTime.now(),
    );
    if (picked != null) {
      setState(() => posisiDate = picked);
    }
  }

  Future<void> pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: (startDate != null && endDate != null)
          ? DateTimeRange(start: startDate!, end: endDate!)
          : null,
    );

    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
    }
  }

  Future<void> exportPosisiStok(String filename) async {
    final filtered = filterPosisiByDate();
    final workbook = xlsio.Workbook();

    final kategoriMap = <String, List<Map<String, dynamic>>>{};

    // Kelompokkan item berdasarkan kategori
    for (final item in filtered) {
      final stockRequests = item['stock_requests'] as List<dynamic>? ?? [];
      final latestApproved = stockRequests.lastWhere(
        (req) => req['status'] == 'approved',
        orElse: () => null,
      );
      if (latestApproved == null) continue; // hanya yang approved

      final category = item['category']?['name'] ?? 'Tanpa Kategori';
      kategoriMap.putIfAbsent(category, () => []).add({
        'item': item,
        'request': latestApproved,
      });
    }

    if (kategoriMap.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak ada data posisi stok yang disetujui.')),
        );
      }
      workbook.dispose();
      return;
    }

    // Buat style sekali saja!
    final headerStyle = workbook.styles.add('headerStylePosisi')
      ..bold = true
      ..fontSize = 12
      ..fontColor = '#FFFFFF'
      ..hAlign = xlsio.HAlignType.center
      ..backColor = '#6C63FF';

    bool isFirstSheet = true;
    int sheetIndex = 0;

    kategoriMap.forEach((kategori, records) {
      final sheet = isFirstSheet
          ? workbook.worksheets[sheetIndex]
          : workbook.worksheets.add();

      sheet.name = kategori;
      isFirstSheet = false;

      final headers = [
        'No', 'Kode Barang', 'Kategori', 'Sub Kategori', 'Nama Barang',
        'Jumlah Stok', 'Satuan', 'Lokasi', 'Keterangan', 'Status'
      ];

      for (int i = 0; i < headers.length; i++) {
        final cell = sheet.getRangeByIndex(1, i + 1);
        cell.setText(headers[i]);
        cell.cellStyle = headerStyle; // pakai style yang sudah dibuat
      }

      int row = 2;
      for (final rec in records) {
        final item = rec['item'];
        final latestApproved = rec['request'];

        final statusText = 'Disetujui (${latestApproved['status']})';
        final description = latestApproved['description'] ?? '-';

        sheet.getRangeByIndex(row, 1).setNumber(row - 1);
        sheet.getRangeByIndex(row, 2).setText(item['sku'] ?? '');
        sheet.getRangeByIndex(row, 3).setText(item['category']?['name'] ?? '-');
        sheet.getRangeByIndex(row, 4).setText(item['sub_category']?['name'] ?? '-');
        sheet.getRangeByIndex(row, 5).setText(item['name'] ?? '');
        sheet.getRangeByIndex(row, 6).setNumber((item['stock'] ?? 0).toDouble());
        sheet.getRangeByIndex(row, 7).setText(item['unit'] ?? '');
        sheet.getRangeByIndex(row, 8).setText(item['location'] ?? '');
        sheet.getRangeByIndex(row, 9).setText(description);
        sheet.getRangeByIndex(row, 10).setText(statusText);
        row++;
      }

      for (int i = 1; i <= headers.length; i++) {
        sheet.autoFitColumn(i);
      }
    });

    final bytes = workbook.saveAsStream();
    workbook.dispose();
    await saveExcel(bytes, filename);
  }

  Future<void> exportMutasiStok(String filename) async {
    final filtered = filterMutasiByDateRange();
    final workbook = xlsio.Workbook();

    final kategoriMap = <String, List<Map<String, dynamic>>>{};

    for (final item in filtered) {
      final stockRequests = item['stock_requests'] as List<dynamic>? ?? [];
      final category = item['category']?['name'] ?? 'Tanpa Kategori';

      for (final req in stockRequests) {
        if (req['status'] != 'approved') continue;
        kategoriMap.putIfAbsent(category, () => []).add({'item': item, 'request': req});
      }
    }

    if (kategoriMap.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak ada data mutasi stok yang disetujui.')),
        );
      }
      workbook.dispose();
      return;
    }

    // Buat style hanya sekali!
    final headerStyle = workbook.styles.add('headerStyle')
      ..bold = true
      ..fontSize = 12
      ..fontColor = '#FFFFFF'
      ..hAlign = xlsio.HAlignType.center
      ..backColor = '#6C63FF';

    bool isFirstSheet = true;
    int sheetIndex = 0;

    kategoriMap.forEach((kategori, records) {
      final sheet = isFirstSheet
          ? workbook.worksheets[sheetIndex]
          : workbook.worksheets.add();

      sheet.name = kategori;
      isFirstSheet = false;

      final headers = [
        'No', 'Kode Barang', 'Kategori', 'Sub Kategori', 'Nama Barang',
        'Tanggal Mutasi', 'Mutasi Masuk', 'Mutasi Keluar', 'Satuan',
        'Lokasi', 'Keterangan', 'Status'
      ];

      for (int i = 0; i < headers.length; i++) {
        final cell = sheet.getRangeByIndex(1, i + 1);
        cell.setText(headers[i]);
        cell.cellStyle = headerStyle; // pakai style yang sudah dibuat
      }

      int row = 2;
      for (final rec in records) {
        final item = rec['item'];
        final req = rec['request'];

        final statusText = 'Disetujui (${req['status']})';
        final rawDate = req['date'] ?? item['created_at'];
        final parsedDate = DateTime.tryParse(rawDate);
        final formattedDate = parsedDate != null
            ? DateFormat('dd-MM-yyyy').format(parsedDate)
            : '-';
        final description = req['description'] ?? '-';

        final isIncrease = req['type'] == 'increase';
        final isDecrease = req['type'] == 'decrease';
        final stockValue = (req['quantity'] ?? 0).toDouble();

        sheet.getRangeByIndex(row, 1).setNumber(row - 1);
        sheet.getRangeByIndex(row, 2).setText(item['sku'] ?? '');
        sheet.getRangeByIndex(row, 3).setText(item['category']?['name'] ?? '-');
        sheet.getRangeByIndex(row, 4).setText(item['sub_category']?['name'] ?? '-');
        sheet.getRangeByIndex(row, 5).setText(item['name'] ?? '');
        sheet.getRangeByIndex(row, 6).setText(formattedDate);
        sheet.getRangeByIndex(row, 7).setNumber(isIncrease ? stockValue : 0);
        sheet.getRangeByIndex(row, 8).setNumber(isDecrease ? stockValue : 0);
        sheet.getRangeByIndex(row, 9).setText(item['unit'] ?? '');
        sheet.getRangeByIndex(row, 10).setText(item['location'] ?? '');
        sheet.getRangeByIndex(row, 11).setText(description);
        sheet.getRangeByIndex(row, 12).setText(statusText);
        row++;
      }

      for (int i = 1; i <= headers.length; i++) {
        sheet.autoFitColumn(i);
      }
    });

    final bytes = workbook.saveAsStream();
    workbook.dispose();
    await saveExcel(bytes, filename);
  }

  Future<void> saveExcel(List<int> bytes, String filename) async {
    if (kIsWeb) {
      final blob = html.Blob([Uint8List.fromList(bytes)]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", filename)
        ..click();
      html.Url.revokeObjectUrl(url);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Berhasil diekspor dan diunduh.')),
        );
      }
    } else {
      bool permissionGranted = false;
      if (Platform.isAndroid) {
        var status = await Permission.manageExternalStorage.status;
        if (!status.isGranted) {
          status = await Permission.manageExternalStorage.request();
        }
        permissionGranted = status.isGranted;
      } else {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
        }
        permissionGranted = status.isGranted;
      }

      if (!permissionGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Izin penyimpanan tidak diberikan')),
          );
        }
        return;
      }

      try {
        final dir = Directory('/storage/emulated/0/Download');
        if (!(await dir.exists())) {
          await dir.create(recursive: true);
        }
        final file = File('${dir.path}/$filename');
        await file.writeAsBytes(bytes, flush: true);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Berhasil diekspor ke: ${file.path}')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menyimpan file: $e')),
          );
        }
      }
    }
  }

  Widget buildPosisiStokTab() {
    final dateFormat = DateFormat('dd-MM-yyyy');

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Export Posisi Stok pada Tanggal Tertentu',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: pickPosisiDate,
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Pilih Tanggal'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,     // Warna latar tombol
                    foregroundColor: Colors.white,      // Warna teks dan ikon
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                if (posisiDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      'Tanggal: ${dateFormat.format(posisiDate!)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                const SizedBox(height: 28),
                ElevatedButton.icon(
                  onPressed: () {
                    final filename =
                        'posisi_stok_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.xlsx';
                    exportPosisiStok(filename);
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Export Posisi Stok'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

    Widget buildMutasiStokTab() {
    final dateFormat = DateFormat('dd-MM-yyyy');

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Export Mutasi Stok Berdasarkan Rentang Tanggal',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: pickDateRange,
                  icon: const Icon(Icons.date_range),
                  label: const Text('Pilih Rentang Tanggal'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,         // Warna tombol
                    foregroundColor: Colors.white,        // Warna teks & ikon
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),

                if (startDate != null && endDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      'Rentang: ${dateFormat.format(startDate!)} - ${dateFormat.format(endDate!)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                const SizedBox(height: 28),
                ElevatedButton.icon(
                  onPressed: () {
                    final filename =
                        'mutasi_stok_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.xlsx';
                    exportMutasiStok(filename);
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Export Mutasi Stok'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          // TabBar manual di body, bukan di AppBar
          Container(
            color: Colors.indigo,
            child: const TabBar(
              labelColor: Colors.white,
              indicatorColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: [
                Tab(text: 'Posisi Stok'),
                Tab(text: 'Mutasi Stok'),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    children: [
                      buildPosisiStokTab(),
                      buildMutasiStokTab(),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
