import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({super.key});

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  List items = [];
  List categories = [];
  final nameController = TextEditingController();
  final skuController = TextEditingController();
  final lokasiController = TextEditingController();
  final stokController = TextEditingController();
  final keteranganController = TextEditingController();
  int? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    loadItems();
    loadCategories();
  }

  void loadItems() async {
    final response = await ApiService.get('items');
    if (response.statusCode == 200) {
      setState(() {
        items = json.decode(response.body);
      });
    }
  }

  void loadCategories() async {
    final response = await ApiService.get('categories');
    if (response.statusCode == 200) {
      setState(() {
        categories = json.decode(response.body);
      });
    }
  }

  void addItem() async {
    final response = await ApiService.post('items', {
      'sku': skuController.text,
      'name': nameController.text,
      'lokasi': lokasiController.text,
      'stok': stokController.text,
      'keterangan': keteranganController.text,
      'category_id': selectedCategoryId.toString(),
    });

    if (response.statusCode == 201) {
      skuController.clear();
      nameController.clear();
      lokasiController.clear();
      stokController.clear();
      keteranganController.clear();
      loadItems();
    }
  }

  void deleteItem(int id) async {
    await ApiService.delete('items/$id');
    loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Items")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField(
              items: categories.map((c) {
                return DropdownMenuItem(
                  value: c['id'],
                  child: Text(c['name']),
                );
              }).toList(),
              onChanged: (value) {
                selectedCategoryId = value as int;
              },
              decoration: const InputDecoration(labelText: "Category"),
            ),
            TextField(controller: skuController, decoration: const InputDecoration(labelText: 'SKU')),
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Item Name')),
            TextField(controller: lokasiController, decoration: const InputDecoration(labelText: 'Lokasi')),
            TextField(controller: stokController, decoration: const InputDecoration(labelText: 'Stok')),
            TextField(controller: keteranganController, decoration: const InputDecoration(labelText: 'Keterangan')),
            ElevatedButton(onPressed: addItem, child: const Text("Add Item")),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    title: Text(item['name']),
                    subtitle: Text('Status: ${item['status']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => deleteItem(item['id']),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
