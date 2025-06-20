import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project_3/approver/category_approver_page.dart';
import 'package:project_3/approver/export_approver_page.dart';
import 'package:project_3/approver/riwayat_keluar_approver_page.dart';
import 'package:project_3/approver/riwayat_masuk_approver_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../screens/login_page.dart';

class DashboardApproverPage extends StatefulWidget {
  const DashboardApproverPage({super.key});

  @override
  State<DashboardApproverPage> createState() => _DashboardApproverPageState();
}

class _DashboardApproverPageState extends State<DashboardApproverPage> with WidgetsBindingObserver {
  int _selectedIndex = 0;
  List items = [];
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    checkRole();
    fetchItems();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _selectedIndex == 1) {
      fetchItems();
    }
  }

  void checkRole() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role');

    if (role != 'Approver') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  Future<void> fetchItems() async {
    setState(() {
      isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('http://192.168.1.6:8000/api/items'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List allItems = json.decode(response.body);

      // Filter hanya item yang punya minimal 1 stockRequest yang approved
      List approvedItems = allItems.where((item) {
        final stockRequests = item['stock_requests'] as List<dynamic>? ?? [];
        return stockRequests.any((req) => req['status'] == 'approved');
      }).toList();

      setState(() {
        items = approvedItems;
        isLoading = false;
      });
    } else {
      print('Gagal memuat data: ${response.statusCode}');
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Widget> getPages() {
    return [
      ExportPage(),
      buildStokPage(),
      const RiwayatMasukApproverPage(),
      const RiwayatKeluarApproverPage(),
      CategoryPage(),
    ];
  }

  ListTile buildDrawerItem(IconData icon, String title, int index) {
    return ListTile(
      dense: true, // <--- Memperpendek tinggi
      leading: Icon(icon),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
          color: _selectedIndex == index ? Colors.indigo : null,
        ),
      ),
      selected: _selectedIndex == index,
      onTap: () {
        setState(() {
          _selectedIndex = index;
          Navigator.pop(context);
        });
      },
    );
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '📦 Warehouse Management',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo,
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
            child: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('token');
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        elevation: 10,
        child: Column(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                ),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  '📋 Menu Gudang',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListTileTheme(
                selectedColor: Colors.indigo,
                selectedTileColor: Colors.indigo[50],
                child: ListView.separated(
                  itemCount: 5,
                  separatorBuilder: (context, index) => const Divider(
                    height: 1,
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
                  itemBuilder: (context, index) {
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
                      'Riwayat Masuk',
                      'Riwayat Keluar',
                      'Kategori',
                    ];
                    return buildDrawerItem(icons[index], titles[index], index);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      body: getPages()[_selectedIndex],
    );
  }

  Widget buildStokPage() {
    return RefreshIndicator(
      onRefresh: fetchItems,
      child: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple[50],
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📊 Data Stok Barang',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigoAccent),
                  ),
                  const SizedBox(height: 8),
                  Text("Total ${items.length} item • Update realtime", style: const TextStyle(color: Colors.grey))
                ],
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : items.isEmpty
                    ? const Center(child: Text("Tidak ada data stok yang disetujui."))
                    : ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          var item = items[index];
                          bool isOutOfStock = (item['stock'] ?? 0) == 0;
                          final stockRequests = item['stock_requests'] as List<dynamic>? ?? [];
                          final approvedRequest = stockRequests.firstWhere(
                            (req) => req['status'] == 'approved',
                            orElse: () => null,
                          );

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${item['name']}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    Text("SKU: ${item['sku']}"),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.inventory_2, color: Colors.brown),
                                        const SizedBox(width: 5),
                                        Text("Jumlah: ${item['stock']} unit",
                                            style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    if (isOutOfStock)
                                      Row(
                                        children: const [
                                          Icon(Icons.block, color: Colors.red),
                                          SizedBox(width: 5),
                                          Text("❌ Stok Habis!", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16)),
                                        ],
                                      )
                                    else if ((item['stock'] ?? 0) < 10)
                                      Row(
                                        children: const [
                                          Icon(Icons.warning, color: Colors.red),
                                          SizedBox(width: 5),
                                          Text("⚠️ Stok hampir habis!", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    Row(
                                      children: [
                                        const Icon(Icons.label, color: Colors.yellow),
                                        const SizedBox(width: 5),
                                        Text("Status: ${approvedRequest?['status'] ?? '-'}",
                                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.category, color: Colors.blue),
                                        const SizedBox(width: 5),
                                        Text("Kategori: ${item['category']?['name'] ?? '-'}"),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on, color: Colors.red),
                                        const SizedBox(width: 5),
                                        Text("Lokasi: ${item['location']}"),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.more_horiz),
                                        const SizedBox(width: 5),
                                        Text("Keterangan: ${item['description'] ?? '-'}"),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
