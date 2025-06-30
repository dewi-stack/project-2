<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\CategoryController;
use App\Http\Controllers\ItemController;
use App\Http\Controllers\StockRequestController;
use App\Http\Controllers\SubCategoryController;
use App\Http\Controllers\SubCategoryRequestController;

Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {

    // ✅ Informasi login & logout
    Route::get('/me', [AuthController::class, 'me']);
    Route::post('/logout', [AuthController::class, 'logout']);

    // ✅ Route yang boleh diakses semua role yang login
    Route::get('/items', [ItemController::class, 'index']);
    Route::get('/items/search', [ItemController::class, 'search']); // 🟢 PENTING: harus di atas /items/{item}
    Route::get('/items/{item}', [ItemController::class, 'show']);

    Route::get('/categories', [CategoryController::class, 'index']);
    Route::get('/categories/{category}', [CategoryController::class, 'show']);

    // ✅ Role: Submitter
    Route::middleware('role:Submitter')->group(function () {

        // 🗂️ Kategori
        Route::post('/categories', [CategoryController::class, 'store']);
        Route::put('/categories/{category}', [CategoryController::class, 'update']);
        Route::delete('/categories/{category}', [CategoryController::class, 'destroy']);

        // 📦 Item
        Route::apiResource('items', ItemController::class)->except(['index', 'show']);
        Route::get('/items/sku/{sku}', [ItemController::class, 'findBySku']);

        // 📝 Stock Request
        Route::post('/stock-requests', [StockRequestController::class, 'store']);
        Route::get('/my-stock-requests', [StockRequestController::class, 'myRequests']);

        // 📚 Sub Kategori
        Route::get('/sub-categories', [SubCategoryController::class, 'index']);
        Route::get('/sub-categories/by-category/{id}', [SubCategoryController::class, 'byCategory']);
        Route::post('/subcategory-requests', [SubCategoryRequestController::class, 'store']);
    });

    // ✅ Role: Approver
    Route::middleware('role:Approver')->group(function () {
        Route::get('/stock-requests', [StockRequestController::class, 'index']);
        Route::put('/stock-requests/{id}/approve', [StockRequestController::class, 'approve']);
        Route::get('/subcategory-requests', [SubCategoryRequestController::class, 'index']);
        Route::put('/subcategory-requests/{id}/approve', [SubCategoryRequestController::class, 'approve']);
        Route::put('/subcategory-requests/{id}/reject', [SubCategoryRequestController::class, 'reject']);
        });
});
