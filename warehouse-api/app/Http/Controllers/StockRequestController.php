<?php

namespace App\Http\Controllers;

use App\Models\StockRequest;
use App\Models\Item;
use Illuminate\Http\Request;

class StockRequestController extends Controller
{
    // Submitter: Ajukan permintaan tambah atau kurangi stok
    public function store(Request $request)
    {
        $validated = $request->validate([
            'item_id'  => 'required|exists:items,id',
            'quantity' => 'required|integer|min:1',
            'type'     => 'required|in:increase,decrease', // ✅ validasi tipe permintaan
        ]);

        $requestData = [
            'user_id'   => $request->user()->id,
            'item_id'   => $validated['item_id'],
            'quantity'  => $validated['quantity'],
            'type'      => $validated['type'],
            'status'    => 'pending',
        ];

        $stockRequest = StockRequest::create($requestData);

        return response()->json($stockRequest, 201);
    }

    // Submitter: Lihat riwayat permintaan miliknya
    public function myRequests(Request $request)
    {
        $requests = StockRequest::with('item')
            ->where('user_id', $request->user()->id)
            ->orderByDesc('created_at')
            ->get();

        return response()->json($requests);
    }

    // Approver: Lihat semua permintaan stok (dengan filter opsional)
    public function index(Request $request)
    {
        $query = StockRequest::with('item.category', 'user')->orderByDesc('created_at');

        if ($request->has('type')) {
            $query->where('type', $request->type);
        }

        if ($request->has('status')) {
            $query->where('status', $request->status);
        }

        return response()->json($query->get());
    }

    // Approver: Setujui atau tolak permintaan stok
    public function approve(Request $request, $id)
    {
        $validated = $request->validate([
            'status' => 'required|in:approved,rejected',
        ]);

        $stockRequest = StockRequest::with('item')->find($id);
        if (!$stockRequest) {
            return response()->json(['message' => 'Stock request tidak ditemukan.'], 404);
        }

        if ($stockRequest->status !== 'pending') {
            return response()->json(['message' => 'Permintaan sudah diproses sebelumnya.'], 400);
        }

        // Jika disetujui
        if ($validated['status'] === 'approved') {
            $item = $stockRequest->item;

            // 🔍 Cek dan kurangi stok hanya jika type = decrease
            if ($stockRequest->type === 'decrease') {
                if ($item->stock < $stockRequest->quantity) {
                    return response()->json(['message' => 'Stok tidak mencukupi untuk dikurangi.'], 400);
                }

                $item->stock -= $stockRequest->quantity;
            }

            // ➕ Tambahkan stok jika type = increase
            elseif ($stockRequest->type === 'increase') {
                $item->stock += $stockRequest->quantity;
            }

            $item->save();
        }

        // Update status setelah proses
        $stockRequest->status = $validated['status'];
        $stockRequest->save();

        return response()->json([
            'message' => 'Status berhasil diperbarui.',
            'request' => $stockRequest
        ]);
    }
}
