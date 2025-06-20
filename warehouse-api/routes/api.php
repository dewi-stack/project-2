<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\CategoryController;
use App\Http\Controllers\ItemController;
use App\Http\Controllers\ItemOutController;
use App\Http\Controllers\StockRequestController;

Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {

    // ✅ Info login
    Route::get('/me', [AuthController::class, 'me']);
    Route::post('/logout', [AuthController::class, 'logout']);

    // ✅ Route yang boleh diakses semua yang login
    Route::get('/items', [ItemController::class, 'index']);         // Include stock_requests di controller
    Route::get('/items/{item}', [ItemController::class, 'show']);
    Route::get('/categories', [CategoryController::class, 'index']);
    Route::get('/categories/{category}', [CategoryController::class, 'show']);
    Route::post('/item-keluar', [ItemOutController::class, 'store']);
    Route::get('/item-outs', [ItemOutController::class, 'itemOuts']);
    Route::get('/riwayat-keluar', [ItemOutController::class, 'riwayat']);

    // ✅ Submitter-only
    Route::middleware('role:Submitter')->group(function () {
        // kategori
        Route::post('/categories', [CategoryController::class, 'store']);
        Route::put('/categories/{category}', [CategoryController::class, 'update']);
        Route::delete('/categories/{category}', [CategoryController::class, 'destroy']);

        // item
        Route::apiResource('items', ItemController::class)->except(['index', 'show']);
        Route::get('/items/sku/{sku}', [ItemController::class, 'findBySku']);
        Route::put('/items/{id}/add-stock', [ItemController::class, 'addStock']); // hanya untuk testing / tidak digunakan lagi

        // stock request
        Route::post('/stock-requests', [StockRequestController::class, 'store']);
        Route::get('/my-stock-requests', [StockRequestController::class, 'myRequests']);
    });

    // ✅ Approver-only
    Route::middleware('role:Approver')->group(function () {
        Route::put('/items/{id}/approve', [ItemController::class, 'approve']); // masih digunakan?
        Route::get('/stock-requests', [StockRequestController::class, 'index']);
        Route::put('/stock-requests/{id}/approve', [StockRequestController::class, 'approve']);
    });
});


