<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class EnsureSingleLogin
{
    public function handle(Request $request, Closure $next)
    {
        $user = $request->user();

        // Ambil token dari header 'X-Login-Token'
        $clientLoginToken = $request->header('X-Login-Token');

        // Jika user login, tapi token tidak cocok, berarti login dari perangkat lain
        if ($user && $user->login_token !== $clientLoginToken) {
            return response()->json([
                'message' => 'Akun ini sedang digunakan di perangkat lain.',
                'forced_logout' => true
            ], 403); // ⚠️ Gunakan 403 agar dibedakan dari login gagal (401)
        }

        return $next($request);
    }
}
