<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Item;
use App\Models\StockRequest;
use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;
use PhpOffice\PhpSpreadsheet\Style\Border;
use PhpOffice\PhpSpreadsheet\Style\Fill;
use PhpOffice\PhpSpreadsheet\Style\Alignment;
use Illuminate\Support\Facades\Response;
use PhpOffice\PhpSpreadsheet\Worksheet\Worksheet;
use Illuminate\Support\Facades\Storage;
use Carbon\Carbon;
use PhpOffice\PhpSpreadsheet\Cell\Coordinate;
use Illuminate\Support\Facades\Auth; // Pastikan sudah ada


class ExportController extends Controller
{
    public function exportPosisi(Request $request)
    {
        if (!Auth::check()) {
            return redirect('/login');
        }

        $tanggal = $request->input('tanggal');
        if (!$tanggal) {
            return response()->json(['error' => 'Tanggal tidak valid'], 400);
        }

        $cutoff = Carbon::parse($tanggal)->endOfDay();

        $items = Item::with([
            'category', 'subCategory',
            'stockRequests.user',
            'stockRequests.approver'
        ])->get();

        // Grup berdasarkan kategori_id
        $grouped = $items->groupBy(fn ($item) => $item->category->id ?? 0)->sortKeys();

        $spreadsheet = new Spreadsheet();
        $spreadsheet->removeSheetByIndex(0); // Hapus default sheet

        $headers = ['No', 'Kode Barang', 'Kategori', 'Sub Kategori', 'Nama Barang', 'Jumlah Stok', 'Satuan', 'Lokasi', 'Keterangan', 'Status', 'User'];

        foreach ($grouped as $kategoriId => $itemsInKategori) {
            $firstItem = $itemsInKategori->first();
            $namaKategori = $firstItem->category->name ?? 'Tanpa Kategori';

            $sheet = $spreadsheet->createSheet();
            $sheet->setTitle(substr($namaKategori, 0, 31)); // Max 31 chars

            // Header style
            $headerStyle = [
                'font' => ['bold' => true, 'color' => ['rgb' => 'FFFFFF']],
                'alignment' => ['horizontal' => Alignment::HORIZONTAL_CENTER],
                'fill' => ['fillType' => Fill::FILL_SOLID, 'startColor' => ['rgb' => '6C63FF']],
                'borders' => ['allBorders' => ['borderStyle' => Border::BORDER_THIN]],
            ];

            // Set header row
            foreach ($headers as $i => $title) {
                $col = Coordinate::stringFromColumnIndex($i + 1);
                $cell = $col . '1';
                $sheet->setCellValue($cell, $title);
                $sheet->getStyle($cell)->applyFromArray($headerStyle);
            }

            $row = 2;
            $no = 1;

            foreach ($itemsInKategori as $item) {
                $approved = $item->stockRequests
                    ->where('status', 'approved')
                    ->filter(fn ($r) => Carbon::parse($r->created_at)->lte($cutoff));

                $stock = 0;
                foreach ($approved as $req) {
                    $qty = (int) $req->quantity;
                    $stock += $req->type === 'increase' ? $qty : -$qty;
                }

                // Tetap tampilkan meskipun stok = 0
                $latest = $approved->last();

                $user = $latest?->approver?->name
                        ? 'Approver: ' . $latest->approver->name
                        : ($latest?->user?->name
                            ? 'Submitter: ' . $latest->user->name
                            : '-');

                $description = $latest->description ?? '-';
                $status = $latest ? 'Disetujui' : '-';

                $data = [
                    $no++,
                    $item->sku,
                    $item->category->name ?? '-',
                    $item->subCategory->name ?? '-',
                    $item->name,
                    $stock,
                    $item->unit,
                    $item->location,
                    $description,
                    $status,
                    $user
                ];

                foreach ($data as $i => $val) {
                    $col = Coordinate::stringFromColumnIndex($i + 1);
                    $cell = $col . $row;
                    $sheet->setCellValue($cell, $val);
                    $sheet->getStyle($cell)->getBorders()->getAllBorders()->setBorderStyle(Border::BORDER_THIN);
                    $sheet->getStyle($cell)->getAlignment()->setVertical(Alignment::VERTICAL_TOP);
                }

                $row++;
            }

            // Auto width
            for ($i = 1; $i <= count($headers); $i++) {
                $sheet->getColumnDimension(Coordinate::stringFromColumnIndex($i))->setAutoSize(true);
            }
        }

        $filename = 'posisi_stok_' . now()->format('Ymd_His') . '.xlsx';
        $path = storage_path('app/public/' . $filename);
        $writer = new Xlsx($spreadsheet);
        $writer->save($path);

        return response()->download($path)->deleteFileAfterSend(true);
    }

    public function exportMutasi(Request $request)
    {
        if (!Auth::check()) {
            return redirect('/login');
        }
        
        $start = $request->input('start_date');
        $end = $request->input('end_date');

        if (!$start || !$end) {
            return response()->json(['error' => 'Tanggal tidak valid'], 400);
        }

        $startDate = Carbon::parse($start)->startOfDay();
        $endDate = Carbon::parse($end)->endOfDay();

        // Gunakan 'date' untuk filter, bukan created_at
        $requests = StockRequest::with(['item.category', 'item.subCategory', 'user', 'approver'])
            ->where('status', 'approved')
            ->whereBetween('created_at', [$startDate, $endDate])

    ->orderBy('created_at')
            ->get();

        if ($requests->isEmpty()) {
            return response()->json(['error' => 'Tidak ada data mutasi stok yang disetujui.'], 400);
        }

        $kategoriMap = [];

        foreach ($requests as $req) {
            $item = $req->item;
            if (!$item) continue;

            $kategori = $item->category->name ?? 'Tanpa Kategori';
            $kategoriMap[$kategori][] = [
                'item' => $item,
                'request' => $req
            ];
        }

        $spreadsheet = new Spreadsheet();
        $spreadsheet->removeSheetByIndex(0);

        $headers = [
            'No', 'Kode Barang', 'Kategori', 'Sub Kategori', 'Nama Barang',
            'Tanggal Mutasi', 'Mutasi Masuk', 'Mutasi Keluar', 'Satuan',
            'Lokasi', 'Keterangan', 'Status', 'User'
        ];

        $headerStyle = [
            'font' => ['bold' => true, 'color' => ['rgb' => 'FFFFFF']],
            'alignment' => ['horizontal' => Alignment::HORIZONTAL_CENTER],
            'fill' => ['fillType' => Fill::FILL_SOLID, 'startColor' => ['rgb' => '6C63FF']],
            'borders' => ['allBorders' => ['borderStyle' => Border::BORDER_THIN]],
        ];

        foreach ($kategoriMap as $kategori => $records) {
            $sheet = $spreadsheet->createSheet();
            $sheet->setTitle(substr($kategori, 0, 31));

            foreach ($headers as $i => $header) {
                $col = Coordinate::stringFromColumnIndex($i + 1);
                $cell = $col . '1';
                $sheet->setCellValue($cell, $header);
                $sheet->getStyle($cell)->applyFromArray($headerStyle);
            }

            $row = 2;
            $no = 1;

            foreach ($records as $rec) {
                $item = $rec['item'];
                $req = $rec['request'];

                $date = Carbon::parse($req->date ?? $req->created_at);

                $isIncrease = $req->type === 'increase';
                $isDecrease = $req->type === 'decrease';
                $qty = $req->quantity ?? 0;

                $userLabel = $req->user?->name ?? '-';

                $data = [
                    $no++,
                    $item->sku,
                    $item->category->name ?? '-',
                    $item->subCategory->name ?? '-',
                    $item->name,
                    $date->format('d-m-Y'),
                    $isIncrease ? $qty : 0,
                    $isDecrease ? $qty : 0,
                    $item->unit,
                    $req->location ?? $item->location ?? '-',
                    $req->description ?? '-',
                    'Disetujui',
                    $userLabel
                ];

                foreach ($data as $i => $val) {
                    $col = Coordinate::stringFromColumnIndex($i + 1);
                    $cell = $col . $row;
                    $sheet->setCellValue($cell, $val);
                    $sheet->getStyle($cell)->getBorders()->getAllBorders()->setBorderStyle(Border::BORDER_THIN);
                    $sheet->getStyle($cell)->getAlignment()->setVertical(Alignment::VERTICAL_TOP);
                }

                $row++;
            }

            for ($i = 1; $i <= count($headers); $i++) {
                $sheet->getColumnDimension(Coordinate::stringFromColumnIndex($i))->setAutoSize(true);
            }
        }

        $filename = 'mutasi_stok_' . now()->format('Ymd_His') . '.xlsx';
        $path = storage_path('app/public/' . $filename);
        $writer = new Xlsx($spreadsheet);
        $writer->save($path);

        return response()->download($path)->deleteFileAfterSend(true);
    }
}
