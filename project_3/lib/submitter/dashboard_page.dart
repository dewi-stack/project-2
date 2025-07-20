import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import 'category_page.dart';
import 'export_page.dart';
import 'riwayat_masuk_page.dart';
import 'riwayat_keluar_page.dart';
import 'stock_barang_page.dart';
import '../screens/login_page.dart';

class DashboardPage extends StatefulWidget {
  final int initialIndex;

  const DashboardPage({super.key, this.initialIndex = 0});

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

  String? _userRole;

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
      await prefs.clear();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } else {
      setState(() {
        _userRole = role;
      });
    }
  }

  Future<void> handleForbidden() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Login Tidak Sah'),
        content: const Text('Sesi login Anda telah berakhir. Silakan login kembali.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  Future<void> fetchItems() async {
    setState(() => isLoading = true);
    try {
      final response = await ApiService.get('items');
      if (response.statusCode == 200) {
        final List allItems = json.decode(response.body);
        setState(() {
          items = allItems;
          isLoading = false;
        });
      } else if (response.statusCode == 403 || response.statusCode == 401) {
        await handleForbidden();
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Error fetchItems: $e");
    }
  }

  Future<void> fetchCategories() async {
    try {
      final response = await ApiService.get('categories');
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          categories = data.cast<Map<String, dynamic>>();
        });
      } else if (response.statusCode == 403 || response.statusCode == 401) {
        await handleForbidden();
      }
    } catch (e) {
      debugPrint("Error fetchCategories: $e");
    }
  }

  Future<void> fetchSubCategoriesByCategory(String categoryName) async {
    try {
      final selected = categories.firstWhere(
        (cat) => cat['name'] == categoryName,
        orElse: () => {},
      );

      final categoryId = selected['id'];
      if (categoryId == null) return;

      final response = await ApiService.get('sub-categories?category_id=$categoryId');
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          subCategories = data.cast<Map<String, dynamic>>();
        });
      } else if (response.statusCode == 403 || response.statusCode == 401) {
        await handleForbidden();
      }
    } catch (e) {
      debugPrint("Error fetchSubCategoriesByCategory: $e");
    }
  }

  Future<void> hapusBarang(int id) async {
    try {
      final response = await ApiService.delete('items/$id');
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Barang berhasil dihapus')),
        );
        fetchItems();
      } else if (response.statusCode == 403 || response.statusCode == 401) {
        await handleForbidden();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menghapus barang')),
        );
      }
    } catch (e) {
      debugPrint("Error hapusBarang: $e");
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
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text(
              'Ya, Logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
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
    final scaffold = Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.indigoAccent,
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

    // 💡 Hanya pasang WillPopScope jika bukan di Web
    return kIsWeb
        ? scaffold
        : WillPopScope(
            onWillPop: _onWillPop,
            child: scaffold,
          );
  }

  Future<bool> _onWillPop() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar Aplikasi'),
        content: const Text('Apakah Anda yakin ingin keluar dan kembali ke halaman login?'),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Ya, Kembali ke Login',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      if (!mounted) return false;
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
      return false; // Jangan keluar dari app langsung, cukup arahkan ke login
    }

    return false;
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
          FutureBuilder(
            future: SharedPreferences.getInstance(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.indigo, Colors.indigoAccent],
                    ),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
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
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                  ),
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
