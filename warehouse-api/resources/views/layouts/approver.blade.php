<!DOCTYPE html>
<html lang="id">
<head>
  <meta charset="UTF-8">
  <title>Dashboard Approver</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">

  <!-- No Cache -->
  <meta http-equiv="Cache-Control" content="no-store, no-cache, must-revalidate">
  <meta http-equiv="Pragma" content="no-cache">
  <meta http-equiv="Expires" content="0">

  <!-- Bootstrap -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

  <style>
    body { background-color: #f8f9fa; }
    .sidebar {
      width: 260px;
      background-color: #fff;
      box-shadow: 2px 0 8px rgba(0, 0, 0, 0.05);
    }
    .sidebar .nav-link {
      padding: 12px 20px;
      color: #495057;
      transition: all 0.2s;
      border-radius: 6px;
    }
    .sidebar .nav-link.active {
      background-color: #e3f2fd;
      font-weight: 600;
      color: #0d6efd;
    }
    .sidebar .nav-link:hover {
      background-color: #f1f1f1;
    }
    .sidebar-header {
      background: linear-gradient(to right, #3f51b5, #5c6bc0);
      color: white;
      padding: 24px 20px;
      border-bottom-right-radius: 16px;
    }
    .main-content {
      flex-grow: 1;
      padding: 32px;
    }
  </style>
</head>
<body>

@auth
<div class="d-flex">
  <!-- Sidebar -->
  <aside class="sidebar d-flex flex-column vh-100">
    <div class="sidebar-header">
      <h5><i class="bi bi-clipboard-data"></i> Menu Gudang</h5>
      <div class="mt-2">
        <small><i class="bi bi-person-circle"></i> User: Approver</small><br>
        <small><i class="bi bi-check2-square"></i> Fungsi: Approval Data</small>
      </div>
    </div>
    <nav class="nav flex-column mt-3 px-3">
      <a class="nav-link {{ request()->is('approver/export') ? 'active' : '' }}" href="{{ route('approver.export') }}">
        <i class="bi bi-file-earmark-arrow-down me-2"></i> Export Data
      </a>
      <a class="nav-link {{ request()->is('approver/stok-barang') ? 'active' : '' }}" href="{{ route('approver.stok') }}">
        <i class="bi bi-box me-2"></i> Stok Barang
      </a>
      <a class="nav-link {{ request()->is('approver/mutasi-masuk') ? 'active' : '' }}" href="{{ route('approver.mutasi-masuk') }}">
        <i class="bi bi-download me-2"></i> Mutasi Masuk
      </a>

      <!-- Logout Form -->
      <form id="logoutForm" method="POST" action="{{ route('logout') }}" class="mt-4 px-2">
        @csrf
        <button class="btn btn-outline-danger w-100" type="submit" onclick="return confirm('Yakin ingin logout?')">
          <i class="bi bi-box-arrow-right me-2"></i> Logout
        </button>
      </form>
    </nav>
  </aside>

  <!-- Main Content -->
  <main class="main-content">
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h4 class="d-flex align-items-center">
        <img src="{{ asset('assets/images/pt_agro_jaya.png') }}" height="36" class="me-2" alt="Logo">
        SAJI - Dashboard Approver
      </h4>
    </div>

    {{-- Flash Messages --}}
    @if (session('success'))
      <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="bi bi-check-circle-fill me-1"></i> {{ session('success') }}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
      </div>
    @endif

    @if (session('error'))
      <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="bi bi-exclamation-triangle-fill me-1"></i> {{ session('error') }}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
      </div>
    @endif

    @yield('content')
  </main>
</div>
<!-- Modal Konfirmasi Keluar -->
<div class="modal fade" id="exitConfirmModal" tabindex="-1" aria-labelledby="exitConfirmLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header bg-warning text-dark">
        <h5 class="modal-title" id="exitConfirmLabel"><i class="bi bi-exclamation-triangle"></i> Konfirmasi</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Tutup"></button>
      </div>
      <div class="modal-body">
        Apakah Anda yakin ingin meninggalkan halaman ini?
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
        <button type="button" class="btn btn-danger" id="confirmExitBtn">Logout & Keluar</button>
      </div>
    </div>
  </div>
</div>
@endauth

@guest
  <script>window.location.href = "{{ route('login') }}";</script>
@endguest

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
  // Fungsi tampilkan modal keluar
  function showExitModal() {
    const modalEl = document.getElementById("exitConfirmModal");
    const modal = new bootstrap.Modal(modalEl, {
      backdrop: "static",
      keyboard: false
    });
    modal.show();
  }

  // Push state dummy saat halaman dimuat pertama kali
  window.addEventListener("load", () => {
    if (history.state === null) {
      history.replaceState({ stay: true }, "");
      history.pushState({ exit: true }, "");
    }
  });

  // Deteksi saat tombol back ditekan
  window.addEventListener("popstate", (event) => {
    if (event.state && event.state.stay) {
      console.log("⬅️ Tombol BACK ditekan");

      // Tampilkan modal
      showExitModal();

      // Push ulang agar tidak benar-benar keluar
      setTimeout(() => {
        history.pushState({ exit: true }, "");
      }, 100);
    }
  });

  // Logout via form POST
  document.getElementById("logoutForm")?.addEventListener("submit", function(e) {
  e.preventDefault();
  const modalEl = document.getElementById("exitConfirmModal");
  if (modalEl) {
    const modal = new bootstrap.Modal(modalEl, {
      backdrop: "static",
      keyboard: false
    });
    modal.show();
  }
});

document.getElementById("confirmExitBtn")?.addEventListener("click", () => {
  document.getElementById("logoutForm")?.submit();
});
</script>

@stack('scripts')
</body>
</html>