import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryApproverPage extends StatefulWidget {
  @override
  State<CategoryApproverPage> createState() => _CategoryApproverPageState();
}

class _CategoryApproverPageState extends State<CategoryApproverPage> {
  List subcategoryRequests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSubcategoryRequests();
  }

  Future<void> fetchSubcategoryRequests() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('https://green-dog-346335.hostingersite.com/api/subcategory-requests'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (!mounted) return;

    if (response.statusCode == 200) {
      setState(() {
        subcategoryRequests = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengambil data pengajuan subkategori')),
      );
    }
  }

  Future<void> updateRequestStatus(int requestId, String status) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // Sesuaikan URL berdasarkan status
    final url = status == 'approved'
        ? 'https://green-dog-346335.hostingersite.com/api/subcategory-requests/$requestId/approve'
        : 'https://green-dog-346335.hostingersite.com/api/subcategory-requests/$requestId/reject';

    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Berhasil ${status == 'approved' ? 'menyetujui' : 'menolak'} pengajuan')),
      );
      fetchSubcategoryRequests();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memperbarui status pengajuan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : subcategoryRequests.isEmpty
              ? const Center(child: Text('Tidak ada pengajuan subkategori.'))
              : ListView.builder(
                  itemCount: subcategoryRequests.length,
                  itemBuilder: (context, index) {
                    final req = subcategoryRequests[index];
                    final categoryName = req['category']?['name'] ?? '-';
                    final subcategoryName = req['name'] ?? '-';
                    final status = req['status'] ?? '-';

                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Kategori: $categoryName', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('Nama Subkategori: $subcategoryName'),
                            const SizedBox(height: 8),
                            Text('Status: $status',
                                style: TextStyle(
                                  color: status == 'pending'
                                      ? Colors.orange
                                      : status == 'approved'
                                          ? Colors.green
                                          : Colors.red,
                                )),
                            const SizedBox(height: 8),
                            if (status == 'pending')
                              Row(
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () => updateRequestStatus(req['id'], 'approved'),
                                    icon: const Icon(Icons.check),
                                    label: const Text('Setujui'),
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton.icon(
                                    onPressed: () => updateRequestStatus(req['id'], 'rejected'),
                                    icon: const Icon(Icons.close),
                                    label: const Text('Tolak'),
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
