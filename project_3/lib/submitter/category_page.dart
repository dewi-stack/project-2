import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class CategoryPage extends StatefulWidget {
  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List categories = [];
  int? selectedCategoryId;
  String? selectedCategoryName;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        await handleLogout();
        return;
      }

      fetchCategories();
    });
  }

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      await handleLogout();
      return {};
    }

    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }

  Future<void> handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sesi Berakhir'),
        content: const Text('Silakan login kembali.'),
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

  Future<void> fetchCategories() async {
    final headers = await _getHeaders();
    if (headers.isEmpty) return;

    final response = await http.get(
      Uri.parse('https://saji.my.id/api/categories'),
      headers: headers,
    );

    if (response.statusCode == 401) {
      await handleLogout();
    } else if (response.statusCode == 200) {
      setState(() {
        categories = json.decode(response.body);
      });
    } else {
      print('Gagal memuat kategori: ${response.statusCode}');
    }
  }

  Future<void> ajukanKategori({required String type, String? name, int? categoryId}) async {
    final headers = await _getHeaders();
    if (headers.isEmpty) return;

    final body = {
      'action': type,
      if (name != null) 'name': name,
      if (categoryId != null) 'category_id': categoryId,
    };

    final response = await http.post(
      Uri.parse('https://saji.my.id/api/category-requests'),
      headers: headers,
      body: json.encode(body),
    );

    if (response.statusCode == 401) {
      await handleLogout();
    } else if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pengajuan berhasil dikirim')),
      );
      fetchCategories();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengirim pengajuan')),
      );
    }
  }

  Future<void> ajukanSubkategori(int categoryId, String name) async {
    final headers = await _getHeaders();
    if (headers.isEmpty) return;

    final response = await http.post(
      Uri.parse('https://saji.my.id/api/subcategory-requests'),
      headers: headers,
      body: json.encode({
        'category_id': categoryId,
        'name': name,
        'action': 'add',
      }),
    );

    if (response.statusCode == 401) {
      await handleLogout();
    } else if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Subkategori berhasil diajukan')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengajukan subkategori')),
      );
    }
  }

  Future<void> ajukanHapusSubkategori(int subCategoryId, int categoryId) async {
    final headers = await _getHeaders();
    if (headers.isEmpty) return;

    final response = await http.post(
      Uri.parse('https://saji.my.id/api/subcategory-requests'),
      headers: headers,
      body: json.encode({
        'category_id': categoryId,
        'sub_category_id': subCategoryId,
        'action': 'delete',
      }),
    );

    if (response.statusCode == 401) {
      await handleLogout();
    } else if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Penghapusan subkategori diajukan')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus subkategori')),
      );
    }
  }

  void showAddCategoryDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Tambah Kategori Baru"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Nama Kategori'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                Navigator.pop(context);
                ajukanKategori(type: 'add', name: name);
              }
            },
            child: const Text("Ajukan"),
          ),
        ],
      ),
    );
  }

  void showEditDialog(int id, String currentName) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Kategori"),
        content: TextField(controller: controller, decoration: const InputDecoration(labelText: 'Nama Kategori')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () {
              final newName = controller.text.trim();
              Navigator.pop(context);
              if (newName != currentName && newName.isNotEmpty) {
                ajukanKategori(type: 'edit', name: newName, categoryId: id);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nama tidak berubah atau kosong')),
                );
              }
            },
            child: const Text("Ajukan"),
          ),
        ],
      ),
    );
  }

  void showDeleteDialog(int id, String name) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Hapus Kategori"),
        content: Text("Yakin ingin menghapus kategori \"$name\"?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              ajukanKategori(type: 'delete', categoryId: id);
            },
            child: const Text("Ajukan"),
          ),
        ],
      ),
    );
  }

  void showAddSubcategoryDialog(int categoryId, String categoryName) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Ajukan Subkategori untuk "$categoryName"'),
        content: TextField(controller: controller, decoration: const InputDecoration(labelText: 'Nama Subkategori')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                Navigator.pop(context);
                ajukanSubkategori(categoryId, name);
              }
            },
            child: const Text('Ajukan'),
          ),
        ],
      ),
    );
  }

  void showDeleteSubcategoryDialog(int subCategoryId, int categoryId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Ajukan Penghapusan Subkategori'),
        content: const Text('Yakin ingin menghapus subkategori ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              ajukanHapusSubkategori(subCategoryId, categoryId);
            },
            child: const Text('Ajukan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: categories.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: categories.length,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              itemBuilder: (_, index) {
                final kategori = categories[index];
                final subCategories = kategori['sub_categories'] ?? [];

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    childrenPadding: const EdgeInsets.only(bottom: 8),
                    title: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategoryId = kategori['id'];
                          selectedCategoryName = kategori['name'];
                        });
                      },
                      child: Text(
                        kategori['name'] ?? '-',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    iconColor: Colors.indigo,
                    collapsedIconColor: Colors.grey[700],
                    children: [
                      if (subCategories.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Belum ada subkategori',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ...subCategories.map<Widget>((sub) => ListTile(
                            leading: const Icon(Icons.subdirectory_arrow_right, color: Colors.indigo),
                            title: Text(sub['name']),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  showDeleteSubcategoryDialog(sub['id'], kategori['id']),
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(right: 16, top: 8),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            icon: const Icon(Icons.add, color: Colors.indigo),
                            label: const Text("Ajukan Subkategori"),
                            onPressed: () =>
                                showAddSubcategoryDialog(kategori['id'], kategori['name']),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: SpeedDial(
        icon: Icons.menu,
        activeIcon: Icons.close,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        overlayOpacity: 0.3,
        spacing: 12,
        spaceBetweenChildren: 8,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.add),
            backgroundColor: Colors.green,
            label: 'Tambah Kategori',
            labelStyle: const TextStyle(fontSize: 14),
            onTap: showAddCategoryDialog,
          ),
          SpeedDialChild(
            child: const Icon(Icons.edit),
            backgroundColor: Colors.orange,
            label: 'Edit Kategori',
            labelStyle: const TextStyle(fontSize: 14),
            onTap: () {
              if (selectedCategoryId != null) {
                showEditDialog(selectedCategoryId!, selectedCategoryName!);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pilih kategori terlebih dahulu.'),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.delete),
            backgroundColor: Colors.red,
            label: 'Hapus Kategori',
            labelStyle: const TextStyle(fontSize: 14),
            onTap: () {
              if (selectedCategoryId != null) {
                showDeleteDialog(selectedCategoryId!, selectedCategoryName!);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pilih kategori terlebih dahulu.'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
