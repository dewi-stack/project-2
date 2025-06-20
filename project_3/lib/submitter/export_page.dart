import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:universal_html/html.dart' as html;
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';

class ExportPage extends StatefulWidget {
  const ExportPage({Key? key}) : super(key: key);

  @override
  State<ExportPage> createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage> {
  bool isLoading = true;
  List items = [];
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
      Uri.parse('http://192.168.1.6:8000/api/items'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List allItems = json.decode(response.body);
      setState(() {
        items = allItems;
        isLoading = false;
      });
    } else {
      print('Failed to load items');
      setState(() => isLoading = false);
    }
  }

  Future<void> exportToExcel() async {
    final filteredItems = filterByDateRange();

    final workbook = xlsio.Workbook();
    final sheet = workbook.worksheets[0];
    sheet.name = 'Data Stok';

    sheet.getRangeByName('A1').setText('SKU');
    sheet.getRangeByName('B1').setText('Nama');
    sheet.getRangeByName('C1').setText('Kategori');
    sheet.getRangeByName('D1').setText('Lokasi');
    sheet.getRangeByName('E1').setText('Stok');
    sheet.getRangeByName('F1').setText('Status');

    for (int i = 0; i < filteredItems.length; i++) {
      final item = filteredItems[i];
      final stockRequests = item['stock_requests'] as List<dynamic>? ?? [];
      final latestApproved = stockRequests.lastWhere(
        (req) => req['status'] == 'approved',
        orElse: () => null,
      );
      final statusText = latestApproved != null
          ? 'Disetujui (${latestApproved['status']})'
          : 'Belum disetujui';

      sheet.getRangeByIndex(i + 2, 1).setText(item['sku'] ?? '');
      sheet.getRangeByIndex(i + 2, 2).setText(item['name'] ?? '');
      sheet.getRangeByIndex(i + 2, 3).setText(item['category']?['name'] ?? 'Tidak diketahui');
      sheet.getRangeByIndex(i + 2, 4).setText(item['location'] ?? '');
      sheet.getRangeByIndex(i + 2, 5).setNumber((item['stock'] ?? 0).toDouble());
      sheet.getRangeByIndex(i + 2, 6).setText(statusText);
    }

    final bytes = workbook.saveAsStream();
    workbook.dispose();

    final date = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final filename = 'data_stok_$date.xlsx';

    await saveExcel(bytes, filename);
  }

  Future<void> saveExcel(List<int> bytes, String filename) async {
    if (kIsWeb) {
      final uint8list = Uint8List.fromList(bytes);
      final blob = html.Blob([uint8list]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", filename)
        ..click();
      html.Url.revokeObjectUrl(url);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File berhasil diunduh')),
      );
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/$filename';
      final file = io.File(path);
      await file.writeAsBytes(bytes, flush: true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File berhasil disimpan: $path')),
      );
    }
  }

  List filterByDateRange() {
    if (startDate == null || endDate == null) return items;

    return items.where((item) {
      if (item['created_at'] == null) return false;
      final createdAt = DateTime.tryParse(item['created_at']);
      if (createdAt == null) return false;
      return createdAt.isAfter(startDate!.subtract(const Duration(days: 1))) &&
          createdAt.isBefore(endDate!.add(const Duration(days: 1)));
    }).toList();
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

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd-MM-yyyy');

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FC),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Card(
                margin: const EdgeInsets.all(20),
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Pilih Rentang Tanggal',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: pickDateRange,
                        icon: const Icon(Icons.date_range),
                        label: const Text('Pilih Rentang Tanggal'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigoAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (startDate != null && endDate != null)
                        Text(
                          'Filter: ${dateFormat.format(startDate!)} - ${dateFormat.format(endDate!)}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      const SizedBox(height: 28),
                      ElevatedButton.icon(
                        onPressed: exportToExcel,
                        icon: const Icon(Icons.download),
                        label: const Text('Export ke Excel'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          textStyle: const TextStyle(fontSize: 18),
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
}
