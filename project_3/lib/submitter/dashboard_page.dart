import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_3/submitter/stock_barang_page.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'category_page.dart';
import 'export_page.dart';
import 'riwayat_masuk_page.dart';
import 'riwayat_keluar_page.dart';
import '../screens/login_page.dart';

class DashboardPage extends StatefulWidget {
  final String role;
  final int initialIndex;

  const DashboardPage({Key? key, required this.role, this.initialIndex = 0}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  List items = [];
  bool isLoading = true;

  String? selectedCategory;
  String? selectedSubCategoryName;
  String? selectedJenis;
  String searchQuery = '';

  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> subCategories = [];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    fetchItems();
    fetchCategories();
    checkRole();
  }

  void checkRole() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role');
    if (role != 'Submitter') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
    }
  }

  Future<void> fetchItems() async {
    setState(() => isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('http://192.168.1.3:8000/api/items'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List allItems = json.decode(response.body);

      setState(() {
        items = allItems; // ❗ gunakan semua item, bukan hanya yang pending
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('http://192.168.1.3:8000/api/categories'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        categories = data.cast<Map<String, dynamic>>();
      });
    }
  }

  Future<void> fetchSubCategoriesByCategory(String categoryName) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final selected = categories.firstWhere(
      (cat) => cat['name'] == categoryName,
      orElse: () => {},
    );
    final categoryId = selected['id'];
    if (categoryId == null) return;

    final response = await http.get(
      Uri.parse('http://192.168.1.3:8000/api/sub-categories?category_id=$categoryId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        subCategories = data.cast<Map<String, dynamic>>();
      });
    }
  }

  Future<void> logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar dari akun?'),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          ElevatedButton(
            child: const Text('Ya, Logout'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  List<Widget> getPages() {
    return [
      ExportPage(),
      StokBarangPage(
        items: items,
        isLoading: isLoading,
        selectedCategory: selectedCategory,
        selectedSubCategoryName: selectedSubCategoryName,
        selectedJenis: selectedJenis,
        searchQuery: searchQuery,
        categories: categories,
        subCategories: subCategories,
        onRefresh: fetchItems,
        onFilterChanged: (category, subCategory, jenis, query) {
          setState(() {
            selectedCategory = category;
            selectedSubCategoryName = subCategory;
            selectedJenis = jenis;
            searchQuery = query;
          });
        },
        onDeleteItem: hapusBarang,
        onFetchSubCategories: fetchSubCategoriesByCategory,
      ),
      RiwayatMasukPage(key: UniqueKey()),
      RiwayatKeluarPage(key: UniqueKey()),
      CategoryPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📦 SAJI', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigoAccent,
        foregroundColor: Colors.white,
        elevation: 4,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          Tooltip(
            message: "Logout",
            child: IconButton(icon: const Icon(Icons.logout), onPressed: logout),
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
        borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      child: Column(
        children: [
          FutureBuilder(
            future: SharedPreferences.getInstance(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.indigo, Colors.indigoAccent],
                    ),
                    borderRadius: BorderRadius.only(topRight: Radius.circular(20)),
                  ),
                  child: Center(child: CircularProgressIndicator(color: Colors.white)),
                );
              }

              final prefs = snapshot.data!;
              final role = prefs.getString('role') ?? 'Unknown';
              final tugas = role == 'Submitter' ? 'Maker' : 'Tugas tidak tersedia';

              return DrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.indigo, Colors.indigoAccent],
                  ),
                  borderRadius: BorderRadius.only(topRight: Radius.circular(20)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📋 Menu Gudang',
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'User: $role',
                      style: const TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    Text(
                      'Fungsi: $tugas',
                      style: const TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: Container(
              color: Colors.grey[50],
              child: ListTileTheme(
                selectedColor: Colors.indigoAccent,
                selectedTileColor: Colors.indigo.withOpacity(0.1),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: icons.length,
                  separatorBuilder: (context, index) => const Divider(
                    height: 1,
                    thickness: 0.8,
                    indent: 16,
                    endIndent: 16,
                    color: Colors.grey,
                  ),
                  itemBuilder: (context, index) => ListTile(
                    dense: true,
                    leading: Icon(
                      icons[index],
                      color: _selectedIndex == index ? Colors.indigo : Colors.grey[700],
                    ),
                    title: Text(
                      titles[index],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: _selectedIndex == index ? FontWeight.w600 : FontWeight.normal,
                        color: _selectedIndex == index ? Colors.indigo : Colors.grey[800],
                      ),
                    ),
                    selected: _selectedIndex == index,
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
          ),
        ],
      ),
    );
  }

  ListTile buildDrawerItem(IconData icon, String title, int index) {
    return ListTile(
      dense: true,
      leading: Icon(icon),
      title: Text(title, style: TextStyle(fontWeight: _selectedIndex == index ? FontWeight.bold : FontWeight.normal, color: _selectedIndex == index ? Colors.indigo : null)),
      selected: _selectedIndex == index,
      onTap: () {
        setState(() {
          _selectedIndex = index;
          Navigator.pop(context);
          if (index == 1) fetchItems();
        });
      },
    );
  }

  Future<void> hapusBarang(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.delete(
      Uri.parse('http://192.168.1.3:8000/api/items/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Barang berhasil dihapus')),
      );
      fetchItems();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus barang')),
      );
    }
  }
}
