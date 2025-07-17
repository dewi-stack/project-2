<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\WebLoginController;
use App\Http\Controllers\StockRequestController;
use App\Http\Controllers\SubCategoryController;
use App\Http\Controllers\ExportController;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;

Route::get('/', function () {
    return Auth::check()
        ? redirect()->route('approver.export')
        : view('auth.splash');
});

Route::get('/check-auth', function () {
    \Log::info('🔍 Auth::check = ' . (Auth::check() ? 'true' : 'false'));
    return response()->json([
        'authenticated' => Auth::check(),
        'redirect' => route('login'),
    ]);
})->name('check.auth');

Route::middleware(['guest', 'nocache'])->group(function () {
    Route::get('/login', [WebLoginController::class, 'showLoginForm'])->name('login');
    Route::post('/login', [WebLoginController::class, 'login']);
});

Route::post('/logout', [WebLoginController::class, 'logout'])
    ->middleware(['web'])
    ->name('logout');

Route::middleware(['auth', 'prevent-back-history'])->prefix('approver')->group(function () {
    Route::get('/export', fn() =>
        response()->view('approver.export')
            ->header('Cache-Control', 'no-store, no-cache, must-revalidate, max-age=0')
            ->header('Pragma', 'no-cache')
            ->header('Expires', 'Sat, 01 Jan 1990 00:00:00 GMT')
        )->name('approver.export');


    Route::get('/stok-barang', [StockRequestController::class, 'webStock'])->name('approver.stok');
    Route::get('/riwayat-masuk', [StockRequestController::class, 'webMutasiMasuk'])->name('approver.mutasi-masuk');
    Route::get('/mutasi-template', [StockRequestController::class, 'downloadTemplate'])->name('approver.mutasi-masuk.template');
    Route::post('/mutasi/import', [StockRequestController::class, 'importExcelMutasiMasuk'])->name('approver.mutasi-masuk.import');
    Route::put('/approve/{id}', [StockRequestController::class, 'approve'])->name('approver.approve');
    Route::get('/export/posisi', [ExportController::class, 'exportPosisi'])->name('approver.export.posisi');
    Route::get('/export/mutasi', [ExportController::class, 'exportMutasi'])->name('approver.export.mutasi');
});

Route::get('/api/sub-categories/by-category/{id}', [SubCategoryController::class, 'byCategory'])->name('api.subcategories.byCategory');

Route::get('/test-time', function () {
    return now()->toDateTimeString();
});
