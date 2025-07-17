<?php

namespace App\Http\Controllers;

use App\Models\SubCategory;
use App\Models\SubCategoryRequest;
use Illuminate\Http\Request;

class SubCategoryRequestController extends Controller
{
    public function store(Request $request)
    {
        $validated = $request->validate([
            'category_id' => 'required|exists:categories,id',
            'action' => 'required|in:add,delete',
            'name' => 'required_if:action,add',
            'sub_category_id' => 'required_if:action,delete|exists:sub_categories,id',
        ]);

        $user = auth()->user();

        if (!$user) {
            return response()->json(['message' => 'Unauthorized'], 401);
        }

        $requestData = [
            'category_id' => $validated['category_id'],
            'action' => $validated['action'],
            'status' => 'pending',
            'requested_by' => $user->id,
        ];

        if ($validated['action'] === 'add') {
            $requestData['name'] = $validated['name'];
        } elseif ($validated['action'] === 'delete') {
            $requestData['sub_category_id'] = $validated['sub_category_id'];

            // Ambil nama subkategori agar kolom 'name' tidak NULL
            $sub = SubCategory::find($validated['sub_category_id']);
            if (!$sub) {
                return response()->json(['message' => 'Subkategori tidak ditemukan'], 404);
            }
            $requestData['name'] = $sub->name; // <- ini mencegah error 1048
        }

        $subCategoryRequest = SubCategoryRequest::create($requestData);

        return response()->json($subCategoryRequest, 201);
    }

    public function index()
    {
        return SubCategoryRequest::with(['category', 'subCategory'])->get();
    }

    public function approve($id)
    {
        $request = SubCategoryRequest::findOrFail($id);

        if ($request->action === 'add') {
            $sub = SubCategory::create([
                'name' => $request->name,
                'category_id' => $request->category_id,
            ]);
        } elseif ($request->action === 'delete' && $request->sub_category_id) {
            $sub = SubCategory::find($request->sub_category_id);
            if ($sub) {
                $sub->delete();
            }
        }

        $request->status = 'approved';
        $request->save();

        return response()->json(['message' => 'Disetujui']);
    }

    public function reject($id)
    {
        $request = SubCategoryRequest::findOrFail($id);
        $request->status = 'rejected';
        $request->save();

        return response()->json(['message' => 'Ditolak']);
    }

    public function globalRequests()
    {
        $requests = \App\Models\SubCategoryRequest::with('category', 'user')
            ->orderByDesc('created_at')
            ->get();

        return response()->json($requests);
    }

}
