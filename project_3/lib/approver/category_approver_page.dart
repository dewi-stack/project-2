import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryApproverPage extends StatefulWidget {
  @override
  _CategoryApproverPageState createState() => _CategoryApproverPageState();
}

class _CategoryApproverPageState extends State<CategoryApproverPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List categoryRequests = [];
  List subcategoryRequests = [];
  bool isLoadingCategory = true;
  bool isLoadingSubcategory = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() {
      fetchCategoryRequests();
      fetchSubcategoryRequests();
    });
  }

  Future<Map<String, String>> _getHeaders() async {
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

  bool _isForcedLogout(http.Response res) {
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
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Login Tidak Sah'),
        content: const Text('Akun Anda digunakan di perangkat lain. Silakan login kembali.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> fetchCategoryRequests() async {
    setState(() => isLoadingCategory = true);
    final headers = await _getHeaders();
    if (headers.isEmpty) return;

    try {
      final res = await http.get(
        Uri.parse('http://192.168.1.6:8000/api/category-requests/global'),
        headers: headers,
      );

      if (!mounted) return;

      if (res.statusCode == 401 || res.statusCode == 403 || _isForcedLogout(res)) {
        await handleForcedLogout();
        return;
      }

      final data = json.decode(res.body);
      setState(() {
        categoryRequests = data;
        isLoadingCategory = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() => isLoadingCategory = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengambil data pengajuan kategori')),
        );
      }
    }
  }

  Future<void> fetchSubcategoryRequests() async {
    setState(() => isLoadingSubcategory = true);
    final headers = await _getHeaders();
    if (headers.isEmpty) return;

    try {
      final res = await http.get(
        Uri.parse('http://192.168.1.6:8000/api/subcategory-requests/global'),
        headers: headers,
      );

      if (!mounted) return;

      if (res.statusCode == 401 || res.statusCode == 403 || _isForcedLogout(res)) {
        await handleForcedLogout();
        return;
      }

      final data = json.decode(res.body);
      setState(() {
        subcategoryRequests = data;
        isLoadingSubcategory = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() => isLoadingSubcategory = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengambil data pengajuan subkategori')),
        );
      }
    }
  }

  Future<void> updateStatus({
    required String endpoint,
    required int id,
    required String status,
    required VoidCallback onSuccess,
  }) async {
    final headers = await _getHeaders();
    if (headers.isEmpty) return;

    final url = 'http://192.168.1.6:8000/api/$endpoint/$id/$status';

    try {
      http.Response res;

      if (endpoint == 'category-requests/global') {
        res = await http.post(Uri.parse(url), headers: headers);
      } else {
        res = await http.put(Uri.parse(url), headers: headers);
      }

      if (!mounted) return;

      if (res.statusCode == 401 || res.statusCode == 403 || _isForcedLogout(res)) {
        await handleForcedLogout();
        return;
      }

      if (res.statusCode == 200) {
        onSuccess();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Status pengajuan berhasil di${status == 'approve' ? 'setujui' : 'tolak'}.',
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memperbarui status pengajuan')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memperbarui status pengajuan')),
        );
      }
    }
  }

  Widget buildRequestCard({
    required String title,
    required String subtitle,
    required String status,
    required VoidCallback onApprove,
    required VoidCallback onReject,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text(subtitle),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Status: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: status == 'pending'
                        ? Colors.orange
                        : status == 'approved'
                            ? Colors.green
                            : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (status == 'pending')
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: onApprove,
                    icon: const Icon(Icons.check),
                    label: const Text('Setujui'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: onReject,
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.indigo,
            child: SafeArea(
              child: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    labelColor: Colors.amberAccent,
                    unselectedLabelColor: Colors.white70,
                    indicatorColor: Colors.amberAccent,
                    tabs: const [
                      Tab(text: "Kategori"),
                      Tab(text: "Subkategori"),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                isLoadingCategory
                    ? const Center(child: CircularProgressIndicator())
                    : categoryRequests.isEmpty
                        ? const Center(child: Text("Tidak ada pengajuan kategori."))
                        : ListView.builder(
                            itemCount: categoryRequests.length,
                            itemBuilder: (context, index) {
                              final req = categoryRequests[index];
                              final action = req['action'];
                              final name = req['name'] ?? '-';
                              final status = req['status'] ?? '-';
                              final categoryName = req['category']?['name'] ?? '-';

                              String title;
                              if (action == 'add') {
                                title = 'Pengajuan Tambah Kategori';
                              } else if (action == 'edit') {
                                title = 'Pengajuan Edit Kategori "$categoryName"';
                              } else {
                                title = 'Pengajuan Hapus Kategori "$categoryName"';
                              }

                              return buildRequestCard(
                                title: title,
                                subtitle: 'Nama: $name',
                                status: status,
                                onApprove: () => updateStatus(
                                  endpoint: 'category-requests',
                                  id: req['id'],
                                  status: 'approve',
                                  onSuccess: fetchCategoryRequests,
                                ),
                                onReject: () => updateStatus(
                                  endpoint: 'category-requests',
                                  id: req['id'],
                                  status: 'reject',
                                  onSuccess: fetchCategoryRequests,
                                ),
                              );
                            },
                          ),
                isLoadingSubcategory
                    ? const Center(child: CircularProgressIndicator())
                    : subcategoryRequests.isEmpty
                        ? const Center(child: Text("Tidak ada pengajuan subkategori."))
                        : ListView.builder(
                            itemCount: subcategoryRequests.length,
                            itemBuilder: (context, index) {
                              final req = subcategoryRequests[index];
                              final categoryName = req['category']?['name'] ?? '-';
                              final subName = req['name'] ?? '-';
                              final status = req['status'] ?? '-';

                              return buildRequestCard(
                                title: 'Kategori: $categoryName',
                                subtitle: 'Nama Subkategori: $subName',
                                status: status,
                                onApprove: () => updateStatus(
                                  endpoint: 'subcategory-requests',
                                  id: req['id'],
                                  status: 'approve',
                                  onSuccess: fetchSubcategoryRequests,
                                ),
                                onReject: () => updateStatus(
                                  endpoint: 'subcategory-requests',
                                  id: req['id'],
                                  status: 'reject',
                                  onSuccess: fetchSubcategoryRequests,
                                ),
                              );
                            },
                          ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
