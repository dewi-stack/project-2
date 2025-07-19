<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Category;
use App\Models\CategoryRequest;
use Illuminate\Support\Facades\Auth;

class CategoryRequestController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'action' => 'required|in:add,edit,delete',
            'name' => 'required_if:action,add,edit',
            'category_id' => 'required_if:action,edit,delete|exists:categories,id',
        ]);

        $data = [
            'action' => $request->action,
            'status' => 'pending',
            'requested_by' => Auth::id(),
        ];

        if (in_array($request->action, ['add', 'edit'])) {
            $data['name'] = $request->name;
            $data['category_id'] = $request->category_id ?? null;
        }

        if ($request->action === 'delete') {
            $category = Category::find($request->category_id);
            if (!$category) {
                return response()->json(['message' => 'Kategori tidak ditemukan.'], 404);
            }

            $data['name'] = $category->name; // ← isi name dari kategori yang akan dihapus
            $data['category_id'] = $category->id;
        }

        $categoryRequest = CategoryRequest::create($data);

        return response()->json(['message' => 'Permintaan kategori berhasil diajukan.', 'data' => $categoryRequest], 201);
    }

    public function approve($id)
    {
        $request = CategoryRequest::find($id);
        if (!$request || $request->status !== 'pending') {
            return response()->json(['message' => 'Permintaan tidak ditemukan atau sudah diproses.'], 404);
        }

        if ($request->action === 'add') {
            $category = Category::create(['name' => $request->name]);
            $request->update(['status' => 'approved', 'category_id' => $category->id]);
        } elseif ($request->action === 'edit') {
            $category = Category::find($request->category_id);
            if ($category) {
                $category->update(['name' => $request->name]);
                $request->update(['status' => 'approved']);
            }
        } elseif ($request->action === 'delete') {
            $category = Category::find($request->category_id);
            if ($category) {
                // ✅ Tambahan: Cek jika kategori sedang digunakan
                if ($category->items()->exists()) {
                    return response()->json([
                        'message' => 'Kategori tidak dapat dihapus karena masih digunakan oleh barang.'
                    ], 422);
                }

                $category->delete();
                $request->update(['status' => 'approved']);
            }
        }

        return response()->json(['message' => 'Permintaan berhasil disetujui.']);
    }

    public function reject($id)
    {
        $request = CategoryRequest::find($id);
        if (!$request || $request->status !== 'pending') {
            return response()->json(['message' => 'Permintaan tidak ditemukan atau sudah diproses.'], 404);
        }

        $request->update(['status' => 'rejected']);

        return response()->json(['message' => 'Permintaan berhasil ditolak.']);
    }

    public function index()
    {
        return CategoryRequest::with('category', 'user')->orderByDesc('created_at')->get();
    }

    public function globalRequests()
    {
        $requests = \App\Models\CategoryRequest::with('user')
            ->orderByDesc('created_at')
            ->get();

        return response()->json($requests);
    }

}

