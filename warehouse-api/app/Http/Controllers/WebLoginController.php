<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class WebLoginController extends Controller
{
    public function showLoginForm()
    {
        return view('auth.login'); // File: resources/views/auth/login.blade.php
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
                return redirect()->route('approver.stok'); // <-- redirect ke stok barang
            }

            // Kalau ada dashboard lain untuk role lain, sesuaikan di sini
            return redirect('/dashboard'); // default
        }

        return back()->with('error', 'Email atau password salah');
    }

    public function logout(Request $request)
    {
        Auth::logout();
        $request->session()->invalidate();
        $request->session()->regenerateToken();

        return redirect('/login');
    }
}
