<?php

namespace App\Http\Controllers;

use App\Models\StockRequest;
use App\Models\Item;
use Illuminate\Http\Request;

class ItemController extends Controller
{
    // ✅ Menampilkan daftar item sesuai role
    public function index(Request $request)
    {
        $user = $request->user();

        $query = Item::with(['category', 'user', 'stockRequests']);

        if ($user->role === 'Submitter') {
            $query->where('user_id', $user->id);
        }

        return response()->json($query->get(), 200);
    }

    // ✅ Menampilkan detail item
    public function show($id)
    {
        $item = Item::with('category', 'user')->find($id);

        if (!$item) {
            return response()->json(['message' => 'Item not found'], 404);
        }

        return response()->json($item, 200);
    }

    // ✅ Menambahkan item baru (tanpa kolom status)
    public function store(Request $request)
    {
        $validated = $request->validate([
            'sku' => 'required|unique:items',
            'name' => 'required|string',
            'category_id' => 'required|exists:categories,id',
            'location' => 'required|string',
            'stock' => 'required|integer|min:1', // wajib diisi
            'description' => 'nullable|string',
        ]);

        $user = $request->user();

        // Buat item dengan stok = 0
        $item = Item::create([
            'sku' => $validated['sku'],
            'name' => $validated['name'],
            'category_id' => $validated['category_id'],
            'location' => $validated['location'],
            'stock' => 0,
            'description' => $validated['description'] ?? null,
            'user_id' => $user->id,
        ]);

        // Buat permintaan stok awal (status pending)
        StockRequest::create([
            'item_id' => $item->id,
            'user_id' => $user->id,
            'quantity' => $validated['stock'],
            'type' => 'increase',
            'status' => 'pending',
        ]);

        return response()->json(['message' => 'Item berhasil dibuat dan menunggu persetujuan stok awal.', 'item' => $item], 201);
    }

    // ✅ Mengupdate item (hanya info, bukan stok)
    public function update(Request $request, $id)
    {
        $item = Item::find($id);
        if (!$item) {
            return response()->json(['message' => 'Item not found'], 404);
        }

        $validated = $request->validate([
            'sku' => 'required|unique:items,sku,' . $item->id,
            'name' => 'required|string',
            'category_id' => 'required|exists:categories,id',
            'location' => 'required|string',
            'stock' => 'required|integer|min:0',
            'description' => 'nullable|string',
        ]);

        $item->update($validated);
        return response()->json($item, 200);
    }

    // ✅ Menghapus item
    public function destroy($id)
    {
        $item = Item::find($id);
        if (!$item) {
            return response()->json(['message' => 'Item not found'], 404);
        }

        $item->delete();
        return response()->json(['message' => 'Item deleted successfully'], 200);
    }

    // 🚫 Tidak digunakan lagi
    public function approve(Request $request, $id)
    {
        return response()->json([
            'message' => 'Proses approval sekarang dilakukan melalui permintaan stok (stock_requests).'
        ], 403);
    }

    // ✅ Mencari item berdasarkan SKU
    public function findBySku($sku)
    {
        $item = Item::with('category', 'user')->where('sku', $sku)->first();

        if (!$item) {
            return response()->json(['message' => 'Item not found'], 404);
        }

        return response()->json($item, 200);
    }

    // 🚫 Dialihkan ke StockRequestController
    public function addStock(Request $request, $id)
    {
        return response()->json([
            'message' => 'Permintaan stok harus diajukan melalui Stock Request dan disetujui oleh Approver.'
        ], 403);
    }
}
