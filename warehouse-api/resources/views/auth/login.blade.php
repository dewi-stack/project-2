<!DOCTYPE html>
<html lang="id">
<head>
  <meta charset="UTF-8">
  <title>SAJI</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">

  <!-- Anti-cache meta -->
  <meta http-equiv="Cache-Control" content="no-store, no-cache, must-revalidate">
  <meta http-equiv="Pragma" content="no-cache">
  <meta http-equiv="Expires" content="0">

  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container d-flex align-items-center justify-content-center vh-100 bg-light">
  <div class="col-md-5">
    <div class="text-center mb-4">
      <img src="{{ asset('assets/images/pt_agro_jaya.png') }}" alt="Logo SAJI" height="120" class="mb-3">
      <h3 class="text-primary fw-bold">Selamat Datang di SAJI</h3>
      <p class="text-muted">Silakan login untuk melanjutkan</p>
    </div>

    <div class="card shadow-sm rounded-4 border-0">
      <div class="card-body p-4">
        @if(session('error'))
          <div class="alert alert-danger alert-dismissible fade show" role="alert">
            {{ session('error') }}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
          </div>
        @endif

        <form method="POST" action="{{ route('login') }}">
          @csrf
          <div class="mb-3">
            <label for="email" class="form-label fw-semibold">Email</label>
            <input type="email" name="email" id="email" class="form-control form-control-lg" required autofocus value="{{ old('email') }}">
          </div>

          <div class="mb-3">
            <label for="password" class="form-label fw-semibold">Password</label>
            <input type="password" name="password" id="password" class="form-control form-control-lg" required>
          </div>

          <div class="d-grid">
            <button type="submit" class="btn btn-primary btn-lg">🔐 Login</button>
          </div>
        </form>
      </div>
    </div>

    <div class="text-center mt-4 text-muted" style="font-size: 14px">
      &copy; {{ date('Y') }} PT Agro Jaya Industri• SAJI System
    </div>
  </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

{{-- 🚀 Script Cegah Back Setelah Logout --}}
<script>
(function () {
  const navType = performance.getEntriesByType("navigation")[0]?.type;
  console.log('📦 Navigation type:', navType);

  window.addEventListener("pageshow", function (event) {
    console.log("🔁 pageshow triggered. persisted:", event.persisted);
    if (event.persisted || navType === "back_forward") {
      console.log("📡 Checking auth status...");
      fetch("{{ route('check.auth') }}", {
        credentials: "same-origin",
        cache: "no-store"
      })
        .then((res) => res.json())
        .then((data) => {
          console.log("✅ Auth status:", data);
          if (data.authenticated && data.redirect) {
            console.log("🔐 Still logged in. Redirecting...");
            window.location.href = data.redirect;
          }
        })
        .catch((err) => console.error("❌ Error checking auth:", err));
    }
  });

  // Perlindungan tambahan: reload saat user tekan tombol back
  window.addEventListener("popstate", function () {
    console.log("🧭 popstate detected, force reload");
    location.reload(true);
  });
})();
</script>

</body>
</html>
