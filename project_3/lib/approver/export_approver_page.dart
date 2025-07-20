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
      const SnackBar(content: Text('Sesi Anda telah berakhir. Silakan login kembali.')),
    );
  }

  Future<void> redirectToLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> validateTokenAndFetch() async {
    final headers = await getHeaders();
    if (headers.isEmpty) return;

    await fetchItems();
  }

    Future<void> fetchItems() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('https://saji.my.id/api/items'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (!mounted) return;

    if (response.statusCode == 200) {
      setState(() {
        items = json.decode(response.body);
        isLoading = false;
      });
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login tidak valid. Silakan login ulang.')),
        );
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  List filterPosisiByDate() {
    if (posisiDate == null) return [];

    final tanggalCutoff = DateTime(
      posisiDate!.year,
      posisiDate!.month,
      posisiDate!.day,
      23, 59, 59,
    );

    List result = [];

    for (var item in items) {
      final stockRequests = item['stock_requests'] as List<dynamic>? ?? [];

      // Filter hanya yang approved dan sebelum/sama dengan tanggal posisi
      final approvedRequests = stockRequests.where((req) {
        final createdAt = DateTime.tryParse(req['created_at'] ?? '');
        return req['status'] == 'approved' &&
            createdAt != null &&
            createdAt.isBefore(tanggalCutoff.add(const Duration(seconds: 1)));
      }).toList();

      if (approvedRequests.isEmpty) {
        // Tidak ada mutasi sama sekali sampai tanggal posisi
        // Tapi jika kamu tetap ingin menampilkan semua item (dengan stock awal = 0), aktifkan baris berikut:
        result.add({
          'item': item,
          'stock': 0,
          'latestApproved': null,
        });
        continue;
      }

      // Hitung total stok berdasarkan semua mutasi sampai tanggal posisi
      int totalStock = 0;
      for (var req in approvedRequests) {
        final int qty = int.tryParse(req['quantity'].toString()) ?? 0;
        if (req['type'] == 'increase') {
          totalStock += qty;
        } else if (req['type'] == 'decrease') {
          totalStock -= qty;
        }
      }

      // Tetap tampilkan meskipun stok akhir = 0
      result.add({
        'item': item,
        'stock': totalStock,
        'latestApproved': approvedRequests.last,
      });
    }

    return result;
  }

  List filterMutasiByDateRange() {
    if (startDate == null || endDate == null) return [];

    final List result = [];

    for (final item in items) {
      final stockRequests = item['stock_requests'] as List<dynamic>? ?? [];

      for (final req in stockRequests) {
        if (req['status'] != 'approved') continue;

        final dateStr = req['created_at'] ?? '';
        final parsedDate = DateTime.tryParse(dateStr);
        if (parsedDate == null) continue;

        final inRange = !parsedDate.isBefore(startDate!) && !parsedDate.isAfter(endDate!);


        if (inRange) {
          result.add({'item': item, 'request': req});
        }
      }
    }

    return result;
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
        // Perhatikan perubahan di sini:
        endDate = DateTime(
          picked.end.year,
          picked.end.month,
          picked.end.day,
          23, 59, 59,
        );
      });
    }
  }

  Future<void> exportPosisiStok(String filename) async {
    final filtered = filterPosisiByDate();
    final workbook = xlsio.Workbook();

    final kategoriMap = <String, List<Map<String, dynamic>>>{};

    for (final rec in filtered) {
      final item = rec['item'];
      final latestApproved = rec['latestApproved'];
      final totalStock = rec['stock'] ?? 0;

      final category = item['category']?['name'] ?? 'Tanpa Kategori';
      kategoriMap.putIfAbsent(category, () => []).add({
        'item': item,
        'request': latestApproved,
        'stock': totalStock,
      });
    }

    if (kategoriMap.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('⚠️ Tidak ada data posisi stok yang disetujui.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      workbook.dispose();
      return;
    }

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
        'Jumlah Stok', 'Satuan', 'Lokasi', 'Keterangan', 'Status', 'User'
      ];

      for (int i = 0; i < headers.length; i++) {
        final cell = sheet.getRangeByIndex(1, i + 1);
        cell.setText(headers[i]);
        cell.cellStyle = headerStyle;
      }

      int row = 2;
      for (final rec in records) {
        final item = rec['item'];
        final latestApproved = rec['request'];
        final totalStock = rec['stock'] ?? 0;

        final statusText = latestApproved != null
            ? 'Disetujui (${latestApproved['status']})'
            : '-';

        final description = latestApproved?['description'] ?? '-';

        // Tentukan user
        final user = latestApproved?['user'];
        final approver = latestApproved?['approver'];

        String userLabel = '-';
        if (approver != null && approver['name'] != null) {
          userLabel = 'Approver: ${approver['name']}';
        } else if (user != null && user['name'] != null) {
          userLabel = 'Submitter: ${user['name']}';
        }

        sheet.getRangeByIndex(row, 1).setNumber(row - 1);
        sheet.getRangeByIndex(row, 2).setText(item['sku'] ?? '');
        sheet.getRangeByIndex(row, 3).setText(item['category']?['name'] ?? '-');
        sheet.getRangeByIndex(row, 4).setText(item['sub_category']?['name'] ?? '-');
        sheet.getRangeByIndex(row, 5).setText(item['name'] ?? '');
        sheet.getRangeByIndex(row, 6).setNumber(totalStock.toDouble());
        sheet.getRangeByIndex(row, 7).setText(item['unit'] ?? '');
        sheet.getRangeByIndex(row, 8).setText(item['location'] ?? '');
        sheet.getRangeByIndex(row, 9).setText(description);
        sheet.getRangeByIndex(row, 10).setText(statusText);
        sheet.getRangeByIndex(row, 11).setText(userLabel);
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

    for (final rec in filtered) {
      final item = rec['item'];
      final req = rec['request'];
      final category = item['category']?['name'] ?? 'Tanpa Kategori';

      kategoriMap.putIfAbsent(category, () => []).add({'item': item, 'request': req});
    }

    if (kategoriMap.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('⚠️ Tidak ada data mutasi stok yang disetujui.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      workbook.dispose();
      return;
    }

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
        'Lokasi', 'Keterangan', 'Status', 'User'
      ];

      for (int i = 0; i < headers.length; i++) {
        final cell = sheet.getRangeByIndex(1, i + 1);
        cell.setText(headers[i]);
        cell.cellStyle = headerStyle;
      }

      int row = 2;
      for (final rec in records) {
        final item = rec['item'];
        final req = rec['request'];

        final statusText = 'Disetujui (${req['status']})';
        final rawDate = req['created_at'];
        final parsedDate = DateTime.tryParse(rawDate);
        final formattedDate = parsedDate != null
            ? DateFormat('dd-MM-yyyy').format(parsedDate)
            : '-';

        final description = req['description'] ?? '-';
        final isIncrease = req['type'] == 'increase';
        final isDecrease = req['type'] == 'decrease';
        final stockValue = double.tryParse(req['quantity'].toString()) ?? 0.0;

        // Tentukan user
        final user = req?['user'];
        final approver = req?['approver'];

        String userLabel = '-';
        if (approver != null && approver['name'] != null) {
          userLabel = 'Approver: ${approver['name']}';
        } else if (user != null && user['name'] != null) {
          userLabel = 'Submitter: ${user['name']}';
        }

        sheet.getRangeByIndex(row, 1).setNumber(row - 1);
        sheet.getRangeByIndex(row, 2).setText(item['sku'] ?? '');
        sheet.getRangeByIndex(row, 3).setText(item['category']?['name'] ?? '-');
        sheet.getRangeByIndex(row, 4).setText(item['sub_category']?['name'] ?? '-');
        sheet.getRangeByIndex(row, 5).setText(item['name'] ?? '');
        sheet.getRangeByIndex(row, 6).setText(formattedDate);
        sheet.getRangeByIndex(row, 7).setNumber(isIncrease ? stockValue : 0);
        sheet.getRangeByIndex(row, 8).setNumber(isDecrease ? stockValue : 0);
        sheet.getRangeByIndex(row, 9).setText(item['unit'] ?? '');
        sheet.getRangeByIndex(row, 10).setText(req['location'] ?? item['location'] ?? '-');
        sheet.getRangeByIndex(row, 11).setText(description);
        sheet.getRangeByIndex(row, 12).setText(statusText);
        sheet.getRangeByIndex(row, 13).setText(userLabel);
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
          const SnackBar(content: Text('✅ Berhasil diekspor dan diunduh.'),
            backgroundColor: Colors.green,
          ),
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
            const SnackBar(content: Text('⚠️ Izin penyimpanan tidak diberikan'),
              backgroundColor: Colors.red,
            ),
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
            SnackBar(content: Text('✅ Berhasil diekspor ke: ${file.path}'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('⚠️ Gagal menyimpan file: $e'),
              backgroundColor: Colors.red,
            ),
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
          elevation: 6,
          margin: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.inventory_2_rounded, size: 50, color: Colors.indigo),
                const SizedBox(height: 16),
                const Text(
                  'Export Posisi Stok',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Pilih tanggal untuk mengekspor posisi stok barang.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: pickPosisiDate,
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Pilih Tanggal'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigoAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                if (posisiDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      'Tanggal: ${dateFormat.format(posisiDate!)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                const SizedBox(height: 28),
                const Divider(),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    final filename =
                        'posisi_stok_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.xlsx';
                    exportPosisiStok(filename);
                  },
                  icon: const Icon(Icons.download_rounded),
                  label: const Text('Export Posisi Stok'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
          elevation: 6,
          margin: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.swap_vert_circle_rounded, size: 50, color: Colors.indigo),
                const SizedBox(height: 16),
                const Text(
                  'Export Mutasi Stok',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Pilih rentang tanggal untuk mengekspor mutasi stok.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: pickDateRange,
                  icon: const Icon(Icons.date_range),
                  label: const Text('Pilih Rentang Tanggal'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                if (startDate != null && endDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      'Rentang: ${dateFormat.format(startDate!)} - ${dateFormat.format(endDate!)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                const SizedBox(height: 28),
                const Divider(),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    final filename =
                        'mutasi_stok_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.xlsx';
                    exportMutasiStok(filename);
                  },
                  icon: const Icon(Icons.download_rounded),
                  label: const Text('Export Mutasi Stok'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
    return WillPopScope(
      onWillPop: () async {
        // Tampilkan dialog konfirmasi
        final result = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Konfirmasi Keluar'),
            content: const Text('Apakah Anda yakin ingin keluar dari halaman ini?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // Tutup dialog
                  Navigator.of(context).pushReplacementNamed('/login'); // Arahkan ke login
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Keluar'),
              ),
            ],
          ),
        );

        // Jika user pilih keluar (true), maka izinkan pop
        return result ?? false;
      },
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              color: Colors.indigo,
              child: const TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.amberAccent,
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
      ),
    );
  }
}

