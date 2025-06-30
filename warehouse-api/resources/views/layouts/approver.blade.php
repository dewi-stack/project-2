<!DOCTYPE html>
<html lang="id">
<head>
  <meta charset="UTF-8">
  <title>Dashboard Approver</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Bootstrap Icons CDN -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
  <style>
    body {
      background-color: #f8f9fa;
    }
    .sidebar {
      width: 250px;
      background-color: #ffffff;
      box-shadow: 2px 0 6px rgba(0,0,0,0.05);
    }
    .sidebar .nav-link.active {
      background-color: #e8eaf6;
      font-weight: bold;
      color: #3f51b5;
    }
    .sidebar .nav-link:hover {
      background-color: #f1f1f1;
    }
    .sidebar-header {
      background: linear-gradient(to right, #3f51b5, #5c6bc0);
      color: white;
      padding: 24px;
      border-bottom-right-radius: 16px;
    }
  </style>
</head>
<body>
  <div class="d-flex">
    <!-- Sidebar -->
    <div class="sidebar d-flex flex-column vh-100">
      <div class="sidebar-header">
        <h5>📋 Menu Gudang</h5>
        <div class="mt-2">
          <small>User: Approver</small><br>
          <small>Fungsi: Approval Data</small>
        </div>
      </div>
      <nav class="nav flex-column mt-3 px-2">
        <a class="nav-link {{ request()->is('approver/stok-barang') ? 'active' : '' }}" href="{{ route('approver.stok') }}">
          <i class="bi bi-box"></i> Stok Barang
        </a>
        <a class="nav-link {{ request()->is('approver/mutasi-masuk') ? 'active' : '' }}" href="{{ route('approver.mutasi-masuk') }}">
          <i class="bi bi-download"></i> Mutasi Masuk
        </a>
        <form method="POST" action="{{ route('logout') }}" onsubmit="return confirm('Yakin ingin logout?')">
          @csrf
          <button class="btn btn-outline-danger w-100 mt-4" type="submit">
            <i class="bi bi-box-arrow-right"></i> Logout
          </button>
        </form>
      </nav>
    </div>

    <!-- Main content -->
    <div class="flex-grow-1 p-4">
      <div class="d-flex justify-content-between align-items-center mb-4">
        <h4>📦 SAJI - Dashboard Approver</h4>
      </div>

      {{-- Flash Message --}}
@if (session('success'))
  <div class="alert alert-success alert-dismissible fade show" role="alert">
    <i class="bi bi-check-circle-fill"></i> {{ session('success') }}
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
  </div>
  @endif

  @if (session('error'))
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
      <i class="bi bi-exclamation-triangle-fill"></i> {{ session('error') }}
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
  @endif
      @yield('content')
    </div>
  </div>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
