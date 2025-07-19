import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'category_approver_page.dart';
import 'export_approver_page.dart';
import 'riwayat_masuk_approver_page.dart';
import 'riwayat_keluar_approver_page.dart';
import 'stock_barang_approver_page.dart';
import '../screens/login_page.dart';

class DashboardApproverPage extends StatefulWidget {
  final int initialIndex;

  const DashboardApproverPage({super.key, this.initialIndex = 0});

  @override
  State<DashboardApproverPage> createState() => _DashboardApproverPageState();
}

class _DashboardApproverPageState extends State<DashboardApproverPage> {
  int _selectedIndex = 0;

  // Untuk tabel stok dll.
  List items = [];
  bool isLoading = false;
  String? selectedCategory;
  String? selectedSubCategoryName;
  String? selectedJenis;
  String searchQuery = '';
  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> subCategories = [];

  // Baru: untuk pengajuan kategori/subkategori
  List categoryRequests = [];
  List subcategoryRequests = [];
  bool isLoadingCategoryReq = false;
  bool isLoadingSubcategoryReq = false;

  final String baseUrl = 'http://192.168.1.6:8000/api';

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    Future.microtask(() async {
      await checkRole();
      await fetchInitialData();
    });
  }

  Future<void> fetchInitialData() async {
    await Future.wait([
      fetchItems(),
      fetchCategories(),
      fetchCategoryRequests(),
      fetchSubcategoryRequests(),
    ]);
  }

  /// Generic header
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
        final d = json.decode(res.body);
        return d['forced_logout'] == true || d['message'] == 'Unauthenticated.';
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
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  Future<void> checkRole() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role');
    if (role != 'Approver') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
    }
  }

  Future<void> fetchItems() async {
    setState(() => isLoading = true);
    final headers = await getHeaders();
    if (headers.isEmpty) return;

    final res = await http.get(
      Uri.parse('http://192.168.1.6:8000/api/items'),
      headers: headers,
    );
    if (!mounted) return;

    if (isForcedLogout(res)) {
      await handleForcedLogout();
    } else if (res.statusCode == 200) {
      setState(() {
        items = json.decode(res.body);
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchCategories() async {
    final headers = await getHeaders();
    if (headers.isEmpty) return;

    final res = await http.get(
      Uri.parse('http://192.168.1.6:8000/api/categories'),
      headers: headers,
    );
    if (!mounted) return;

    if (isForcedLogout(res)) {
      await handleForcedLogout();
    } else if (res.statusCode == 200) {
      setState(() {
        categories = (json.decode(res.body) as List).cast<Map<String, dynamic>>();
      });
    }
  }

  Future<void> fetchSubCategoriesByCategory(String categoryName) async {
    final headers = await getHeaders();
    if (headers.isEmpty) return;

    final selected = categories.firstWhere(
      (cat) => cat['name'] == categoryName,
      orElse: () => {},
    );
    final categoryId = selected['id'];
    if (categoryId == null) return;

    final res = await http.get(
      Uri.parse('http://192.168.1.6:8000/api/sub-categories?category_id=$categoryId'),
      headers: headers,
    );
    if (!mounted) return;

    if (isForcedLogout(res)) {
      await handleForcedLogout();
    } else if (res.statusCode == 200) {
      setState(() {
        subCategories = (json.decode(res.body) as List).cast<Map<String, dynamic>>();
      });
    }
  }

  Future<void> logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar dari akun?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Ya, Logout'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

   Future<void> fetchCategoryRequests() async {
    setState(() => isLoadingCategoryReq = true);
    final h = await getHeaders();
    if (h.isEmpty) return;
    final res = await http.get(Uri.parse('$baseUrl/category-requests'), headers: h);
    if (!mounted) return;
    if (isForcedLogout(res)) return;
    if (res.statusCode == 200) {
      setState(() {
        categoryRequests = json.decode(res.body);
      });
    }
    setState(() => isLoadingCategoryReq = false);
  }

  Future<void> fetchSubcategoryRequests() async {
    setState(() => isLoadingSubcategoryReq = true);
    final h = await getHeaders();
    if (h.isEmpty) return;
    final res = await http.get(Uri.parse('$baseUrl/subcategory-requests'), headers: h);
    if (!mounted) return;
    if (isForcedLogout(res)) return;
    if (res.statusCode == 200) {
      setState(() {
        subcategoryRequests = json.decode(res.body);
      });
    }
    setState(() => isLoadingSubcategoryReq = false);
  }

  Future<void> fetchData() async {
    await Future.wait([
      fetchCategoryRequests(),
      fetchSubcategoryRequests(),
    ]);
  }

  List<Widget> getPages() {
    return [
      ExportApproverPage(),
      StokBarangApproverPage(
        items: items,
        isLoading: isLoading,
        selectedCategory: selectedCategory,
        selectedSubCategoryName: selectedSubCategoryName,
        selectedJenis: selectedJenis,
        searchQuery: searchQuery,
        categories: categories,
        subCategories: subCategories,
        onRefresh: fetchItems,
        onFilterChanged: (cat, sub, jenis, q) {
          setState(() {
            selectedCategory = cat;
            selectedSubCategoryName = sub;
            selectedJenis = jenis;
            searchQuery = q;
          });
        },
        onFetchSubCategories: fetchSubCategoriesByCategory,
      ),
      RiwayatMasukApproverPage(key: UniqueKey()),
      RiwayatKeluarApproverPage(key: UniqueKey()),
      CategoryApproverPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 4,
        title: Row(
          children: [
            const SizedBox(width: 8),
            Image.asset(
              'assets/images/pt_agro_jaya.png',
              height: 32,
            ),
            const SizedBox(width: 8),
            const Text(
              'SAJI',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          Tooltip(
            message: "Logout",
            child: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: logout,
            ),
          ),
        ],
      ),
      drawer: buildDrawer(),
      body: getPages()[_selectedIndex],
    );
  }

  Widget buildDrawer() {
    final icons = [
      Icons.dashboard_outlined,
      Icons.inventory_2_outlined,
      Icons.download_rounded,
      Icons.upload_rounded,
      Icons.category_outlined,
    ];

    final titles = [
      'Dashboard',
      'Stok Barang',
      'Mutasi Masuk',
      'Mutasi Keluar',
      'Kategori',
    ];

    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          FutureBuilder<SharedPreferences>(
            future: SharedPreferences.getInstance(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.indigo, Colors.indigoAccent]),
                    borderRadius: BorderRadius.only(topRight: Radius.circular(20)),
                  ),
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                );
              }

              final prefs = snapshot.data!;
              final role = prefs.getString('role') ?? 'Unknown';
              final tugas = role == 'Approver' ? 'Approval Data' : 'Tugas tidak tersedia';

              return DrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.indigo, Colors.indigoAccent],
                  ),
                  borderRadius: BorderRadius.only(topRight: Radius.circular(20)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      '📋 Menu Gudang',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'User: $role',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'Fungsi: $tugas',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: Container(
              color: Colors.grey[50],
              child: ListView.separated(
                itemCount: icons.length,
                separatorBuilder: (_, __) => const Divider(
                  height: 1,
                  thickness: 0.8,
                  indent: 16,
                  endIndent: 16,
                  color: Colors.grey,
                ),
                itemBuilder: (context, index) => ListTile(
                  leading: Icon(
                    icons[index],
                    color: _selectedIndex == index
                        ? Colors.indigo
                        : Colors.grey[700],
                  ),
                  title: Text(
                    titles[index],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: _selectedIndex == index
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: _selectedIndex == index
                          ? Colors.indigo
                          : Colors.grey[800],
                    ),
                  ),
                  selected: _selectedIndex == index,
                  selectedTileColor: Colors.indigo.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                      Navigator.pop(context);
                      if (index == 1) fetchItems();
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
