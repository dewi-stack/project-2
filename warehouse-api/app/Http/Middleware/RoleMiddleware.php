<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log; // ✅ Tambahkan ini
use Illuminate\Support\Facades\Auth; // ✅ Tambahkan ini
use Symfony\Component\HttpFoundation\Response;

class RoleMiddleware
{
    public function handle(Request $request, Closure $next, string $role): Response
    {
        Log::info('RoleMiddleware Triggered', [
            'Expected' => $role,
            'Actual' => $request->user()?->role,
            'User ID' => $request->user()?->id,
            'Auth Check' => Auth::check(), // ✅ Gunakan Auth::check()
        ]);

        if ($request->user()?->role !== $role) {
            return response()->json(['message' => 'Forbidden. You are not authorized.'], 403);
        }

        return $next($request);
    }
}
