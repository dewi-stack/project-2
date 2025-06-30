<?php

namespace App\Http\Controllers;

use App\Models\SubCategoryRequest;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class SubCategoryRequestController extends Controller
{
    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string',
            'category_id' => 'required|exists:categories,id',
        ]);

        $user = auth()->user(); // Atau Auth::user();

        if (!$user) {
            return response()->json(['message' => 'Unauthorized'], 401);
        }

        $requestData = SubCategoryRequest::create([
            'name' => $validated['name'],
            'category_id' => $validated['category_id'],
            'status' => 'pending',
            'requested_by' => $user->id,
        ]);

        return response()->json($requestData, 201);
    }

    public function index()
    {
        return SubCategoryRequest::with('category')->get();
    }

    public function approve($id)
    {
        $request = SubCategoryRequest::findOrFail($id);

        // Simpan ke tabel sub_categories
        $sub = \App\Models\SubCategory::create([
            'name' => $request->name,
            'category_id' => $request->category_id,
        ]);

        $request->status = 'approved';
        $request->save();

        return response()->json(['message' => 'Disetujui', 'data' => $sub]);
    }

    public function reject($id)
    {
        $request = SubCategoryRequest::findOrFail($id);
        $request->status = 'rejected';
        $request->save();

        return response()->json(['message' => 'Ditolak']);
    }
}

