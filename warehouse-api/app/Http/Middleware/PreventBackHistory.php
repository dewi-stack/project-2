<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class PreventBackHistory
{
    public function handle($request, Closure $next)
    {
        $response = $next($request);

        // Hanya tambahkan headers jika bukan BinaryFileResponse
        if (!($response instanceof \Symfony\Component\HttpFoundation\BinaryFileResponse)) {
            $response->headers->set('Cache-Control','no-store, no-cache, must-revalidate, max-age=0');
            $response->headers->set('Pragma','no-cache');
            $response->headers->set('Expires','Sat, 01 Jan 1990 00:00:00 GMT');
        }

        return $response;
    }
}

