<?php

namespace App\Http\Controllers;

use App\Models\StockRequest;
use App\Models\Item;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Auth;
use App\Models\Category;
use App\Models\SubCategory;
use Illuminate\Support\Str;
use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;
use Illuminate\Support\Facades\Response;

class StockRequestController extends Controller
{
    // Submitter: Ajukan permintaan tambah, kurangi, atau hapus stok
    public function store(Request $request)
    {
        $validated = $request->validate([
            'item_id'     => 'required|exists:items,id',
            'quantity'    => 'nullable|integer|min:1',
            'type'        => 'required|in:increase,decrease,delete',
            'description' => 'nullable|string',
        ]);

        // Ambil item untuk mendapatkan unit
        $item = Item::findOrFail($validated['item_id']);

        $quantity = $validated['type'] === 'delete'
            ? 1
            : ($validated['quantity'] ?? 1);

        $requestData = [
            'user_id'     => $request->user()->id,
            'item_id'     => $validated['item_id'],
            'quantity'    => $quantity,
            'type'        => $validated['type'],
            'description' => $validated['description'],
            'unit'        => $item->unit, // ✅ ambil unit dari tabel items
            'status'      => 'pending',
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

    // Approver: Lihat semua permintaan stok
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

    // Approver: Setujui atau tolak permintaan stok (termasuk hapus)
    public function approve(Request $request, $id)
{
    $validated = $request->validate([
        'status' => 'required|in:approved,rejected',
    ]);

    $stockRequest = StockRequest::with('item')->find($id);
    if (!$stockRequest) {
        $message = 'Stock request tidak ditemukan.';
        return $request->wantsJson()
            ? response()->json(['message' => $message], 404)
            : redirect()->back()->with('error', $message);
    }

    if ($stockRequest->status !== 'pending') {
        $message = 'Permintaan sudah diproses sebelumnya.';
        return $request->wantsJson()
            ? response()->json(['message' => $message], 400)
            : redirect()->back()->with('error', $message);
    }

    if ($validated['status'] === 'approved') {
        $item = $stockRequest->item;

        if ($stockRequest->type === 'decrease') {
            if ($item->stock < $stockRequest->quantity) {
                $message = 'Stok tidak mencukupi untuk dikurangi.';
                return $request->wantsJson()
                    ? response()->json(['message' => $message], 400)
                    : redirect()->back()->with('error', $message);
            }

            $item->stock -= $stockRequest->quantity;
            $item->save();
        } elseif ($stockRequest->type === 'increase') {
            $item->stock += $stockRequest->quantity;
            $item->save();
        } elseif ($stockRequest->type === 'delete') {
            $item->delete();
        }
    }

    $stockRequest->status = $validated['status'];
    $stockRequest->save();

    $message = 'Status permintaan berhasil diperbarui menjadi ' . $validated['status'];

    return $request->wantsJson()
        ? response()->json(['message' => $message, 'data' => $stockRequest])
        : redirect()->route('approver.stok')->with('success', $message);
}


    public function webStock(Request $request)
    {
        $items = Item::with(['category', 'subCategory', 'stockRequests'])
            ->when($request->category, fn($q) =>
                $q->where('category_id', $request->category))
            ->when($request->sub_category, fn($q) =>
                $q->where('sub_category_id', $request->sub_category))
            ->when($request->q, fn($q) =>
                $q->where(function ($query) use ($request) {
                    $query->where('name', 'like', '%' . $request->q . '%')
                        ->orWhere('sku', 'like', '%' . $request->q . '%');
                }))
            ->get();

        // Hitung summary
        $totalItems = $items->count();
        $stokHabis = $items->where('stock', 0)->count();
        $stokMenipis = $items->where('stock', '>', 0)->where('stock', '<=', 10)->count();
        $stokAman = $items->where('stock', '>', 10)->count();

        // Ambil semua kategori untuk dropdown
        $categories = \App\Models\Category::orderBy('name')->get();

        // Jika kategori dipilih, ambil sub kategori untuk dropdown
        $subCategories = collect();
        if ($request->category) {
            $subCategories = \App\Models\SubCategory::where('category_id', $request->category)
                ->orderBy('name')
                ->get();
        }

        return view('approver.stok-barang', compact(
            'items',
            'totalItems',
            'stokHabis',
            'stokMenipis',
            'stokAman',
            'categories',
            'subCategories' // kirim ke view
        ));
    }

    // Menampilkan mutasi masuk saja
    public function webMutasiMasuk(Request $request)
    {
        $query = StockRequest::with(['item.category', 'item.subCategory'])
            ->where('type', 'increase');

        if ($request->sort) {
            $order = $request->order === 'desc' ? 'desc' : 'asc';

            switch ($request->sort) {
                case 'item_name':
                    $query->leftJoin('items', 'stock_requests.item_id', '=', 'items.id')
                        ->orderBy('items.name', $order);
                    break;

                case 'category':
                    $query->leftJoin('items', 'stock_requests.item_id', '=', 'items.id')
                        ->leftJoin('categories', 'items.category_id', '=', 'categories.id')
                        ->orderBy('categories.name', $order);
                    break;

                case 'sub_category':
                    $query->leftJoin('items', 'stock_requests.item_id', '=', 'items.id')
                        ->leftJoin('sub_categories', 'items.sub_category_id', '=', 'sub_categories.id')
                        ->orderBy('sub_categories.name', $order);
                    break;

                case 'location':
                    $query->leftJoin('items as i2', 'stock_requests.item_id', '=', 'i2.id')
                        ->orderBy('i2.location', $order);
                    break;

                case 'quantity':
                case 'unit':
                case 'status':
                    $query->orderBy($request->sort, $order);
                    break;

                case 'created_at':
                    $query->orderBy('stock_requests.created_at', $order);
                    break;
            }

            // Tambahkan select stock_requests.* agar with() bisa tetap digunakan
            $query->select('stock_requests.*');
        } else {
            $query->orderBy('stock_requests.created_at', 'desc');
        }

        $mutasi = $query->paginate(10)->appends($request->all());

        return view('approver.mutasi-masuk', compact('mutasi'));
    }

    public function downloadTemplate()
    {
        $spreadsheet = new Spreadsheet();

        // Sheet 1: Template dengan kategori
        $sheet1 = $spreadsheet->getActiveSheet();
        $sheet1->setTitle('Template');
        $sheet1->fromArray(['sku,name,category,sub_category,location,stock,unit,description'], NULL, 'A1');
        $sheet1->fromArray(['SKU001,Barang A,Kategori A,SubKategori A,Jakarta,10,Pcs,Deskripsi barang'], NULL, 'A2');

        // Sheet 2: BACA DULU !!
        $sheet2 = $spreadsheet->createSheet();
        $sheet2->setTitle('BACA DULU !!');
        $sheet2->fromArray(['Contoh Format DENGAN Sub Kategori'], NULL, 'A1');
        $sheet2->fromArray(['sku,name,category,sub_category,location,stock,unit,description'], NULL, 'A2');
        $sheet2->fromArray(['SKU001,Barang A,Kategori A,SubKategori A,Jakarta,10,Pcs,Deskripsi barang'], NULL, 'A3');
        $sheet2->fromArray([''], NULL, 'A4');
        $sheet2->fromArray(['Contoh Format TANPA Sub Kategori'], NULL, 'A5');
        $sheet2->fromArray(['sku,name,category,location,stock,unit,description'], NULL, 'A6');
        $sheet2->fromArray(['SKU002,Barang B,Kategori B,Surabaya,5,Pcs,Deskripsi barang'], NULL, 'A7');
        $sheet2->fromArray([''], NULL, 'A8');
        $sheet2->fromArray(['JANGAN LUPA SAVE FORMAT DALAM BENTUK CSV TERLEBIH DAHULU SEBELUM IMPORT DATA, KARENA WEB HANYA MENERIMA FILE DALAM FORMAT CSV SAJA !!'], NULL, 'A9');

        $writer = new Xlsx($spreadsheet);
        $fileName = 'template_mutasi_masuk.xlsx';

        // Simpan ke temporary file
        $tempFile = tempnam(sys_get_temp_dir(), $fileName);
        $writer->save($tempFile);

        return response()->download($tempFile, $fileName)->deleteFileAfterSend(true);
    }

    public function importCsvMutasiMasuk(Request $request)
    {
        $request->validate([
            'file' => 'required|file|mimes:csv,txt|max:2048',
        ]);

        $file = fopen($request->file('file')->getRealPath(), 'r');
        $header = fgetcsv($file);

        $userId = Auth::id();
        $success = 0;
        $error = 0;

        while (($row = fgetcsv($file)) !== false) {
            try {
                // Deteksi jumlah kolom: dengan atau tanpa sub kategori
                if (count($row) == 8) {
                    // Format: SKU, Name, Category, SubCategory, Location, Stock, Unit, Description
                    [$sku, $name, $categoryName, $subCategoryName, $location, $stock, $unit, $description] = $row;
                } elseif (count($row) == 7) {
                    // Format tanpa sub kategori: SKU, Name, Category, Location, Stock, Unit, Description
                    [$sku, $name, $categoryName, $location, $stock, $unit, $description] = $row;
                    $subCategoryName = null;
                } else {
                    $error++;
                    continue;
                }

                // Validasi kolom wajib
                if (!$sku || !$name || !$categoryName || !$stock) {
                    $error++;
                    continue;
                }

                // Ambil/buat kategori
                $category = Category::firstOrCreate(['name' => $categoryName]);

                // Ambil/buat sub kategori jika diisi, jika tidak set null
                $subCategoryId = null;
                if ($subCategoryName) {
                    $subCategory = SubCategory::firstOrCreate([
                        'name' => $subCategoryName,
                        'category_id' => $category->id,
                    ]);
                    $subCategoryId = $subCategory->id;
                }

                // Buat item jika belum ada
                $item = Item::firstOrCreate(
                    ['sku' => $sku],
                    [
                        'name' => $name,
                        'category_id' => $category->id,
                        'sub_category_id' => $subCategoryId,
                        'location' => $location,
                        'stock' => 0,
                        'unit' => $unit,
                        'description' => $description,
                        'user_id' => $userId,
                    ]
                );

                $item->increment('stock', (int) $stock);

                StockRequest::create([
                    'user_id' => $userId,
                    'item_id' => $item->id,
                    'quantity' => (int) $stock,
                    'type' => 'increase',
                    'unit' => $unit,
                    'status' => 'approved',
                    'description' => $description,
                ]);

                $success++;
            } catch (\Throwable $e) {
                \Log::error("Import CSV Error: {$e->getMessage()}");
                $error++;
            }
        }

        fclose($file);

        return redirect()->route('approver.mutasi-masuk')->with('success', "Import selesai. Berhasil: $success, Gagal: $error.");
    }
}
