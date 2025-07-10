<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\WebLoginController;
use App\Http\Controllers\StockRequestController;
use App\Http\Controllers\SubCategoryController;

// Login Routes
Route::get('/login', [WebLoginController::class, 'showLoginForm'])->name('login');
Route::post('/login', [WebLoginController::class, 'login']);
Route::post('/logout', [WebLoginController::class, 'logout'])->name('logout');

// Grup Approver (butuh login)
Route::middleware(['auth'])->prefix('approver')->group(function () {

    // Halaman stok barang
    Route::get('/stok-barang', [StockRequestController::class, 'webStock'])
        ->name('approver.stok');

    Route::get('/riwayat-masuk', [StockRequestController::class, 'webMutasiMasuk'])
        ->name('approver.mutasi-masuk');

    Route::get('/mutasi-template', [StockRequestController::class, 'downloadTemplate'])
        ->name('approver.mutasi-masuk.template');

    Route::post('/mutasi/import', [StockRequestController::class, 'importExcelMutasiMasuk'])
    ->name('approver.mutasi-masuk.import');

    // Approve/Reject permintaan
    Route::put('/approve/{id}', [StockRequestController::class, 'approve'])
        ->name('approver.approve');

    
    Route::get('/api/sub-categories/by-category/{id}', [SubCategoryController::class, 'byCategory'])
        ->name('api.subcategories.byCategory');
});

Route::get('/test-time', function () {
    return now()->toDateTimeString();
});


