<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Response;

class WebLoginController extends Controller
{
    public function showLoginForm()
{
    if (Auth::check()) {
        $user = Auth::user();
        return $user->role === 'Approver'
            ? redirect()->route('approver.export')
            : redirect('/dashboard');
    }

    // Gunakan response dengan no-cache agar browser tidak menyimpan halaman login
    $response = response()->view('auth.login');
    $response->headers->set('Cache-Control', 'no-store, no-cache, must-revalidate, max-age=0');
    $response->headers->set('Pragma', 'no-cache');
    $response->headers->set('Expires', 'Sat, 01 Jan 1990 00:00:00 GMT');
    return $response;
}

    public function login(Request $request)
    {
        $credentials = $request->validate([
            'email' => ['required', 'email'],
            'password' => ['required'],
        ]);

        if (Auth::attempt($credentials)) {
            $request->session()->regenerate();

            $user = Auth::user();

            // ✅ Redirect sesuai role
            if ($user->role === 'Approver') {
                return redirect()->route('approver.export'); // <-- redirect ke stok barang
            }

            // Kalau ada dashboard lain untuk role lain, sesuaikan di sini
            return redirect('/dashboard'); // default
        }

        return back()->with('error', 'Email atau password salah');
    }

    public function logout(Request $request)
    {
        Auth::logout();
        $request->session()->invalidate(); // ⛔ Session invalid
        $request->session()->regenerateToken();

        return redirect('/login')->withHeaders([
            'Cache-Control' => 'no-store, no-cache, must-revalidate',
            'Pragma' => 'no-cache',
            'Expires' => '0',
        ]);
    }
}
