<?php

namespace App\Http\Controllers;

use App\Models\SubCategory;
use Illuminate\Http\Request;

class SubCategoryController extends Controller
{
    // ✅ Ambil semua sub kategori
    public function index(Request $request)
    {
        $query = SubCategory::with('category');

        // Jika ada parameter category_id, filter berdasarkan itu
        if ($request->has('category_id')) {
            $query->where('category_id', $request->category_id);
        }

        return response()->json($query->get(), 200);
    }


    // ✅ Ambil sub kategori berdasarkan ID
    public function show($id)
    {
        $subCategory = SubCategory::with('category')->find($id);

        if (!$subCategory) {
            return response()->json(['message' => 'Sub category not found'], 404);
        }

        return response()->json($subCategory, 200);
    }

    // ✅ Tambah sub kategori baru
    public function store(Request $request)
    {
        $validated = $request->validate([
            'name'        => 'required|string|unique:sub_categories,name',
            'category_id' => 'required|exists:categories,id',
        ]);

        $subCategory = SubCategory::create($validated);

        return response()->json($subCategory, 201);
    }

    // ✅ Update sub kategori
    public function update(Request $request, $id)
    {
        $subCategory = SubCategory::find($id);

        if (!$subCategory) {
            return response()->json(['message' => 'Sub category not found'], 404);
        }

        $validated = $request->validate([
            'name'        => 'required|string|unique:sub_categories,name,' . $id,
            'category_id' => 'required|exists:categories,id',
        ]);

        $subCategory->update($validated);

        return response()->json($subCategory, 200);
    }

    // ✅ Hapus sub kategori
    public function destroy($id)
    {
        $subCategory = SubCategory::find($id);

        if (!$subCategory) {
            return response()->json(['message' => 'Sub category not found'], 404);
        }

        $subCategory->delete();

        return response()->json(['message' => 'Sub category deleted successfully'], 200);
    }

    public function byCategory($id)
    {
        try {
            $subs = SubCategory::where('category_id', $id)->get();
            return response()->json($subs);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Error: ' . $e->getMessage()], 500);
        }
    }
}
