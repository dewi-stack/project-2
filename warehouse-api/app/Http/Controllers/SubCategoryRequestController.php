<?php

namespace App\Http\Controllers;

use App\Models\SubCategory;
use App\Models\SubCategoryRequest;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class SubCategoryRequestController extends Controller
{
public function store(Request $request)
{
    $validated = $request->validate([
        'category_id' => 'required|exists:categories,id',
        'action' => 'required|in:add,delete',
        'name' => 'required_if:action,add|string|nullable',
        'sub_category_id' => 'required_if:action,delete|exists:sub_categories,id|nullable',
    ]);

    $user = auth()->user();

    $requestModel = new SubCategoryRequest();
    $requestModel->category_id = $validated['category_id'];
    $requestModel->action = $validated['action'];
    $requestModel->name = $validated['name'] ?? null;
    $requestModel->sub_category_id = $validated['sub_category_id'] ?? null;
    $requestModel->status = 'pending';
    $requestModel->requested_by = $user->id;
    $requestModel->save();

    return response()->json(['message' => 'Permintaan berhasil diajukan'], 201);
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

        // ✅ Simpan ID hasil create ke dalam request
        $request->sub_category_id = $sub->id;

    } elseif ($request->action === 'delete' && $request->sub_category_id) {
        $sub = SubCategory::find($request->sub_category_id);
        if ($sub) {
            $sub->delete();
        }
    }

    $request->status = 'approved';
    $request->save();

    return response()->json(['message' => 'Disetujui', 'sub_category_id' => $request->sub_category_id]);
}


    public function reject($id)
{
    $requestModel = SubCategoryRequest::findOrFail($id);

    if ($requestModel->status !== 'pending') {
        return response()->json(['message' => 'Permintaan sudah diproses sebelumnya'], 400);
    }

    $requestModel->status = 'rejected';
    $requestModel->save();

    return response()->json(['message' => 'Permintaan berhasil ditolak']);
}

public function destroy($id)
{
    $requestModel = SubCategoryRequest::findOrFail($id);

    if ($requestModel->status === 'approved') {
        return response()->json(['message' => 'Permintaan yang sudah disetujui tidak dapat dihapus'], 403);
    }

    $requestModel->delete();

    return response()->json(['message' => 'Permintaan berhasil dihapus']);
}

    public function globalRequests()
    {
        $requests = \App\Models\SubCategoryRequest::with('category', 'user')
            ->orderByDesc('created_at')
            ->get();

        return response()->json($requests);
    }

}
