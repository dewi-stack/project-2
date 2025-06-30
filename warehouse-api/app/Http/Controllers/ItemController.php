<?php

namespace App\Http\Controllers;

use App\Models\Item;
use App\Models\StockRequest;
use Illuminate\Http\Request;

class ItemController extends Controller
{
    // ✅ Menampilkan daftar item sesuai role
    public function index(Request $request)
    {
        // Ambil user login (masih bisa digunakan kalau perlu filtering lain)
        $user = $request->user();

        // Ambil semua item dengan relasi
        $query = Item::with(['category', 'subCategory', 'user', 'stockRequests']);

        // Jika kamu ingin menampilkan semua item ke semua role (baik Submitter maupun Approver), cukup kembalikan semua data:
        return response()->json($query->get(), 200);
    }

    // ✅ Menambahkan item baru (dengan sub_category_id & unit)
    public function store(Request $request)
    {
        $validated = $request->validate([
            'sku'             => 'required|unique:items',
            'name'            => 'required|string',
            'category_id'     => 'required|exists:categories,id',
            'sub_category_id' => 'nullable|exists:sub_categories,id',
            'location'        => 'required|string',
            'stock'           => 'required|integer|min:1',
            'unit'            => 'nullable|string|max:50',
            'description'     => 'nullable|string',
        ]);

        $user = $request->user();

        $item = Item::create([
            'sku'             => $validated['sku'],
            'name'            => $validated['name'],
            'category_id'     => $validated['category_id'],
            'sub_category_id' => $validated['sub_category_id'] ?? null,
            'location'        => $validated['location'],
            'stock'           => 0, // stok awal tetap 0
            'unit'            => $validated['unit'] ?? null,
            'description'     => $validated['description'] ?? null,
            'user_id'         => $user->id,
        ]);

        // Buat permintaan stok awal
        StockRequest::create([
            'item_id'    => $item->id,
            'user_id'    => $user->id,
            'quantity'   => $validated['stock'],
            'type'       => 'increase',
            'status'     => 'pending',
            'unit'       => $validated['unit'] ?? null,
            'description'=> $validated['description'] ?? 'Stok awal saat input barang',
        ]);

        return response()->json([
            'message' => 'Item berhasil dibuat dan menunggu persetujuan stok awal.',
            'item'    => $item
        ], 201);
    }

    // ✅ Mengupdate item
    public function update(Request $request, $id)
    {
        $item = Item::find($id);
        if (!$item) {
            return response()->json(['message' => 'Item not found'], 404);
        }

        $validated = $request->validate([
            'sku'             => 'required|unique:items,sku,' . $item->id,
            'name'            => 'required|string',
            'category_id'     => 'required|exists:categories,id',
            'sub_category_id' => 'nullable|exists:sub_categories,id',
            'location'        => 'required|string',
            'stock'           => 'required|integer|min:0',
            'unit'            => 'nullable|string|max:50',
            'description'     => 'nullable|string',
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

    // ✅ Mencari item berdasarkan SKU
    public function findBySku($sku)
    {
        $item = Item::with(['category', 'subCategory', 'user'])
            ->where('sku', $sku)
            ->first();

        if (!$item) {
            return response()->json(['message' => 'Item not found'], 404);
        }

        return response()->json($item, 200);
    }

    // ❌ Tidak digunakan lagi
    public function addStock(Request $request, $id)
    {
        return response()->json([
            'message' => 'Permintaan stok harus diajukan melalui Stock Request dan disetujui oleh Approver.'
        ], 403);
    }

    // ❌ Tidak digunakan lagi
    public function approve(Request $request, $id)
    {
        return response()->json([
            'message' => 'Proses approval sekarang dilakukan melalui permintaan stok (stock_requests).'
        ], 403);
    }

    // ✅ Tambahkan ke bawah method findBySku()
    public function search(Request $request)
    {
        $keyword = $request->get('q'); // sesuai dengan ?q= di Flutter

        $items = Item::with(['category', 'subCategory'])
            ->where('sku', 'like', "%$keyword%")
            ->orWhere('name', 'like', "%$keyword%")
            ->get();

        return response()->json($items);
    }

}
