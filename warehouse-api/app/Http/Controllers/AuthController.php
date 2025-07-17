<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use App\Models\User;
use Laravel\Sanctum\PersonalAccessToken;

class AuthController extends Controller
{
    // ✅ Login & generate token
    public function login(Request $request)
    {
        $request->validate([
            'email'    => 'required|email',
            'password' => 'required',
        ]);

        $user = User::where('email', $request->email)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json(['message' => 'Email atau password salah'], 401);
        }

        // Generate token Sanctum
        $token = $user->createToken('api-token')->plainTextToken;

        return response()->json([
            'access_token' => $token,
            'user' => [
                'id'    => $user->id,
                'name'  => $user->name,
                'email' => $user->email,
                'role'  => $user->role,
            ],
        ]);
    }

    // ✅ Logout token saat ini
    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()?->delete();

        return response()->json(['message' => 'Berhasil logout']);
    }

    // ✅ Logout semua token (opsional)
    public function logoutAll(Request $request)
    {
        $request->user()->tokens()->delete();

        return response()->json(['message' => 'Berhasil logout dari semua perangkat']);
    }

    // ✅ Ambil data user yang sedang login
    public function me(Request $request)
    {
        return response()->json($request->user());
    }

    // ✅ Lihat semua sesi aktif (opsional)
    public function sessions(Request $request)
    {
        $sessions = $request->user()->tokens->map(function ($token) {
            return [
                'id'            => $token->id,
                'name'          => $token->name,
                'created_at'    => $token->created_at,
                'last_used_at'  => $token->last_used_at,
            ];
        });

        return response()->json($sessions);
    }

    public function activeSessions(Request $request)
    {
        $user = $request->user();

        $tokens = $user->tokens->map(function ($token) {
            return [
                'id' => $token->id,
                'name' => $token->name,
                'last_used_at' => $token->last_used_at,
                'created_at' => $token->created_at,
                'current' => $token->id === $token->accessToken->id,
            ];
        });

        return response()->json($tokens);
    }

    public function revokeSession(Request $request, $tokenId)
    {
        $user = $request->user();

        $token = $user->tokens()->findOrFail($tokenId);

        // Tidak bisa hapus sesi sekarang
        if ($token->id === $user->currentAccessToken()->id) {
            return response()->json(['message' => 'Tidak bisa logout dari sesi saat ini.'], 403);
        }

        $token->delete();

        return response()->json(['message' => 'Sesi berhasil dihapus.']);
    }

    public function revokeAllSessionsExceptCurrent(Request $request)
    {
        $user = $request->user();
        $currentTokenId = $user->currentAccessToken()->id;

        $user->tokens()->where('id', '!=', $currentTokenId)->delete();

        return response()->json(['message' => 'Semua sesi lainnya telah dihapus.']);
    }
}
