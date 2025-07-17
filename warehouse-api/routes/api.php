<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\CategoryController;
use App\Http\Controllers\CategoryRequestController;
use App\Http\Controllers\ItemController;
use App\Http\Controllers\StockRequestController;
use App\Http\Controllers\SubCategoryController;
use App\Http\Controllers\SubCategoryRequestController;

Route::post('/login', [AuthController::class, 'login']);

Route::middleware(['auth:sanctum'])->group(function () {
    // ✅ Informasi login & logout
    Route::get('/me', [AuthController::class, 'me']);
    Route::post('/logout', [AuthController::class, 'logout']);

    // ✅ Kelola sesi (multi-login support)
    Route::get('/sessions', [AuthController::class, 'activeSessions']);
    Route::delete('/sessions/{id}', [AuthController::class, 'revokeSession']);
    Route::post('/sessions/revoke-all', [AuthController::class, 'revokeAllSessionsExceptCurrent']);

    // ✅ Route umum (boleh semua login)
    Route::get('/items', [ItemController::class, 'index']);
    Route::get('/items/search', [ItemController::class, 'search']);
    Route::get('/items/sku/{sku}', [ItemController::class, 'findBySku']);
    Route::get('/items/{item}', [ItemController::class, 'show']);

    Route::get('/categories', [CategoryController::class, 'index']);
    Route::get('/categories/{category}', [CategoryController::class, 'show']);

    // 📚 Sub Kategori
    Route::get('/sub-categories', [SubCategoryController::class, 'index']);
    Route::get('/sub-categories/by-category/{id}', [SubCategoryController::class, 'byCategory']);

    // ✅ Role: Submitter
    Route::middleware('role:Submitter')->group(function () {
        Route::post('/items', [ItemController::class, 'store']);
        Route::post('/stock-requests', [StockRequestController::class, 'store']);
        Route::get('/stock-requests/submitter', [StockRequestController::class, 'submitterGlobalRequests']);
        Route::get('/my-stock-requests', [StockRequestController::class, 'myRequests']);
        Route::post('/subcategory-requests', [SubCategoryRequestController::class, 'store']);
        Route::post('/category-requests', [CategoryRequestController::class, 'store']);
    });

    // ✅ Role: Approver
    Route::middleware('role:Approver')->group(function () {
        Route::get('/stock-requests', [StockRequestController::class, 'index']);
        Route::put('/stock-requests/{id}/approve', [StockRequestController::class, 'approve']);
        
        Route::get('/stock-requests/global', [StockRequestController::class, 'globalRequests']); // ✅ ⬅ Tambahkan di sini

        Route::get('/subcategory-requests', [SubCategoryRequestController::class, 'index']);
        Route::put('/subcategory-requests/{id}/approve', [SubCategoryRequestController::class, 'approve']);
        Route::put('/subcategory-requests/{id}/reject', [SubCategoryRequestController::class, 'reject']);

        Route::get('/category-requests', [CategoryRequestController::class, 'index']);
        Route::post('/category-requests/{id}/approve', [CategoryRequestController::class, 'approve']);
        Route::post('/category-requests/{id}/reject', [CategoryRequestController::class, 'reject']);

        Route::post('/categories', [CategoryController::class, 'store']);
        Route::put('/categories/{category}', [CategoryController::class, 'update']);
        Route::delete('/categories/{category}', [CategoryController::class, 'destroy']);

        Route::get('/category-requests/global', [CategoryRequestController::class, 'globalRequests']);
        Route::get('/subcategory-requests/global', [SubCategoryRequestController::class, 'globalRequests']);
    });
});

