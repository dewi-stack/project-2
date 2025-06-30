import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('http://192.168.1.3:8000/api/categories'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      setState(() {
        categories = json.decode(response.body);
      });
    } else {
      print('Failed to load categories');
    }
  }

  Future<void> tambahKategori(String namaKategori) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('http://192.168.1.3:8000/api/categories'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode({'name': namaKategori}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kategori berhasil ditambahkan')),
      );
      fetchCategories();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menambahkan kategori')),
      );
    }
  }

  Future<void> editKategori(int id, String newName) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.put(
      Uri.parse('http://192.168.1.3:8000/api/categories/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode({'name': newName}),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kategori berhasil diperbarui')),
      );
      fetchCategories();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memperbarui kategori')),
      );
    }
  }

  Future<void> hapusKategori(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.delete(
      Uri.parse('http://192.168.1.3:8000/api/categories/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kategori berhasil dihapus')),
      );
      fetchCategories();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus kategori')),
      );
    }
  }

  Future<void> ajukanSubkategori(int categoryId, String name) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('http://192.168.1.3:8000/api/subcategory-requests'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'category_id': categoryId,
        'name': name,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pengajuan subkategori berhasil dikirim. Menunggu persetujuan Approver.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengajukan subkategori.')),
      );
    }
  }

  void showAddSubcategoryDialog(int categoryId, String categoryName) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ajukan Subkategori untuk "$categoryName"'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Nama Subkategori'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                Navigator.pop(context);
                ajukanSubkategori(categoryId, name);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nama subkategori tidak boleh kosong')),
                );
              }
            },
            child: const Text('Ajukan'),
          ),
        ],
      ),
    );
  }

  void showAddCategoryDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Tambah Kategori Baru"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Nama Kategori'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                Navigator.pop(context);
                tambahKategori(name);
              }
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  void showEditDialog(int id, String currentName) {
    final controller = TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Kategori"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Nama Kategori'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                Navigator.pop(context);
                editKategori(id, name);
              }
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  void showDeleteDialog(int id, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Kategori'),
        content: Text('Apakah Anda yakin ingin menghapus kategori "$name"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              hapusKategori(id);
            },
            child: const Text('Hapus'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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
              itemBuilder: (context, index) {
                final kategori = categories[index];
                final subCategories = kategori['sub_categories'] ?? [];

                return Card(
                  margin: const EdgeInsets.all(8),
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ExpansionTile(
                    key: Key('${kategori['id']}'),
                    title: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategoryId = kategori['id'];
                          selectedCategoryName = kategori['name'];
                        });
                      },
                      child: Text(kategori['name'] ?? '-', style: const TextStyle(fontSize: 16)),
                    ),
                    children: [
                      if (subCategories.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Belum ada subkategori yang disetujui.', style: TextStyle(color: Colors.grey)),
                        ),
                      ...subCategories.map<Widget>((sub) => ListTile(
                            leading: const Icon(Icons.subdirectory_arrow_right),
                            title: Text(sub['name'] ?? '-'),
                          )),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () => showAddSubcategoryDialog(kategori['id'], kategori['name']),
                          icon: const Icon(Icons.add, color: Colors.indigo),
                          label: const Text("Ajukan Subkategori"),
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
        backgroundColor: Colors.indigoAccent,
        overlayOpacity: 0.4,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.add, color: Colors.white),
            backgroundColor: Colors.green,
            label: 'Tambah Kategori',
            onTap: showAddCategoryDialog,
          ),
          SpeedDialChild(
            child: const Icon(Icons.edit, color: Colors.white),
            backgroundColor: Colors.orange,
            label: 'Edit Kategori',
            onTap: () {
              if (selectedCategoryId != null) {
                showEditDialog(selectedCategoryId!, selectedCategoryName!);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pilih kategori terlebih dahulu.')),
                );
              }
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.delete, color: Colors.white),
            backgroundColor: Colors.red,
            label: 'Hapus Kategori',
            onTap: () {
              if (selectedCategoryId != null) {
                showDeleteDialog(selectedCategoryId!, selectedCategoryName!);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pilih kategori terlebih dahulu.')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
