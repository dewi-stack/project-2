@extends('layouts.approver')

@section('content')

  <h5 class="mb-4">📊 Data Stok Barang</h5>

  {{-- Ringkasan Kartu --}}
  <div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-3 mb-4">
    <div class="col">
      <div class="card shadow-sm border-0 text-white bg-primary h-100">
        <div class="card-body d-flex flex-column justify-content-center align-items-center">
          <h6 class="card-title mb-2">Total Barang</h6>
          <h2 class="fw-bold">{{ $totalItems }}</h2>
        </div>
      </div>
    </div>
    <div class="col">
      <div class="card shadow-sm border-0 text-white bg-success h-100">
        <div class="card-body d-flex flex-column justify-content-center align-items-center">
          <h6 class="card-title mb-2">Stok Aman (>10)</h6>
          <h2 class="fw-bold">{{ $stokAman }}</h2>
        </div>
      </div>
    </div>
    <div class="col">
      <div class="card shadow-sm border-0 text-dark bg-warning h-100">
        <div class="card-body d-flex flex-column justify-content-center align-items-center">
          <h6 class="card-title mb-2">Stok Menipis (&lt;10)</h6>
          <h2 class="fw-bold">{{ $stokMenipis }}</h2>
        </div>
      </div>
    </div>
    <div class="col">
      <div class="card shadow-sm border-0 text-white bg-danger h-100">
        <div class="card-body d-flex flex-column justify-content-center align-items-center">
          <h6 class="card-title mb-2">Stok Habis</h6>
          <h2 class="fw-bold">{{ $stokHabis }}</h2>
        </div>
      </div>
    </div>
  </div>

  {{-- Form Filter --}}
  <form method="GET" action="{{ route('approver.stok') }}" class="row g-2 align-items-end mb-4">
    <div class="col-md-3">
    <label for="category" class="form-label">Kategori</label>
    <select name="category" id="category" class="form-select" onchange="this.form.submit()">
      <option value="">- Semua Kategori -</option>
      @foreach($categories as $cat)
        <option value="{{ $cat->id }}" {{ request('category') == $cat->id ? 'selected' : '' }}>
          {{ $cat->name }}
        </option>
      @endforeach
    </select>
  </div>

  <div class="col-md-3">
    <label for="sub_category" class="form-label">Sub Kategori</label>
    <select name="sub_category" id="sub_category" class="form-select">
      <option value="">- Semua Sub Kategori -</option>
      @if($subCategories->count())
        @foreach($subCategories as $subCat)
          <option value="{{ $subCat->id }}" {{ request('sub_category') == $subCat->id ? 'selected' : '' }}>
            {{ $subCat->name }}
          </option>
        @endforeach
      @endif
    </select>
  </div>

    <div class="col-md-4">
      <label for="q" class="form-label">Cari Nama/SKU</label>
      <input type="text" name="q" id="q" class="form-control" placeholder="Nama barang atau SKU" value="{{ request('q') }}">
    </div>

    <div class="col-md-2 d-grid">
      <button type="submit" class="btn btn-primary"><i class="bi bi-funnel"></i> Filter</button>
    </div>
  </form>

  {{-- Data Barang --}}
  <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
    @forelse ($items as $item)
      @php
          $latestIncrease = $item->stockRequests
              ->where('type', 'increase')
              ->sortByDesc('created_at')
              ->first();

          $pendingDelete = $item->stockRequests
              ->where('type', 'delete')
              ->where('status', 'pending')
              ->sortByDesc('created_at')
              ->first();
      @endphp

      <div class="col">
        <div class="card shadow-sm h-100 border-0 d-flex flex-column justify-content-between">
          <div class="card-body">
            <h5 class="card-title text-primary">{{ $item->name }}</h5>

            <p class="mb-1">
              <strong>Kode Barang:</strong> {{ $item->sku }}<br>
              <strong>Stok:</strong> {{ $item->stock }}<br>

              {{-- Mutasi Masuk --}}
              @if ($latestIncrease)
                <strong>Mutasi:</strong>
                @if ($latestIncrease->status === 'pending')
                  <span class="badge bg-warning text-dark">
                    ⏳ Masuk {{ $latestIncrease->quantity }} Unit (Menunggu Persetujuan)
                  </span><br>
                @elseif ($latestIncrease->status === 'approved')
                  <span class="badge bg-success">
                    ✅ Masuk {{ $latestIncrease->quantity }} Unit (Telah Disetujui)
                  </span><br>
                @else
                  <span class="badge bg-secondary">
                    ❌ Mutasi Ditolak ({{ $latestIncrease->quantity }})
                  </span><br>
                @endif
              @endif

              {{-- Status Penghapusan --}}
              @if ($pendingDelete)
                <strong>Status:</strong>
                <span class="badge bg-danger text-light">🗑️ Permintaan Penghapusan (Menunggu Persetujuan)</span><br>
              @endif

              <strong>Kategori:</strong> {{ $item->category->name ?? '-' }}<br>
              <strong>Lokasi:</strong> {{ $item->location }}<br>
              <strong>Keterangan:</strong> {{ $item->description ?? '-' }}
            </p>
          </div>

          <div class="card-footer bg-transparent border-top-0 d-flex justify-content-between align-items-center px-3 pb-3">
            <div>
              @if ($item->stock == 0)
                <span class="badge bg-danger">❌ Stok Habis</span>
              @elseif ($item->stock <= 10)
                <span class="badge bg-warning text-dark">⚠️ Stok Menipis</span>
              @else
                <span class="badge bg-success">✅ Stok Aman</span>
              @endif
            </div>

            @if ($pendingDelete)
              <div>
                <form method="POST" action="{{ route('approver.approve', $pendingDelete->id) }}" class="d-inline">
                  @csrf
                  @method('PUT')
                  <input type="hidden" name="status" value="approved">
                  <button type="submit" class="btn btn-sm btn-success" title="Setujui" onclick="return confirm('Setujui penghapusan item ini?')">
                    <i class="bi bi-check-circle"></i>
                  </button>
                </form>
                <form method="POST" action="{{ route('approver.approve', $pendingDelete->id) }}" class="d-inline">
                  @csrf
                  @method('PUT')
                  <input type="hidden" name="status" value="rejected">
                  <button type="submit" class="btn btn-sm btn-danger" title="Tolak" onclick="return confirm('Tolak penghapusan item ini?')">
                    <i class="bi bi-x-circle"></i>
                  </button>
                </form>
              </div>
            @endif
          </div>
        </div>
      </div>
    @empty
      <div class="col">
        <div class="alert alert-warning">Tidak ada data barang.</div>
      </div>
    @endforelse
  </div>
@endsection

@push('scripts')
<script>
document.addEventListener('DOMContentLoaded', function () {
  const categorySelect = document.getElementById('category');
  const subCategorySelect = document.getElementById('sub_category');

  function loadSubCategories(categoryId, selectedSubCategory = null) {
    // Reset dropdown sub kategori ke default
    subCategorySelect.innerHTML = '<option value="">- Semua Sub Kategori -</option>';

    if (categoryId) {
      console.log("🔎 Memuat sub kategori untuk categoryId:", categoryId);

      fetch(`/api/sub-categories/by-category/${categoryId}`)
        .then(response => {
          console.log("✅ Status response:", response.status);
          if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
          }
          return response.json();
        })
        .then(data => {
          console.log("📥 Data sub kategori diterima:", data);

          data.forEach(subCat => {
            const option = document.createElement('option');
            option.value = subCat.id;
            option.textContent = subCat.name;

            // Pilih sub kategori jika sesuai request sebelumnya
            if (selectedSubCategory && selectedSubCategory == subCat.id) {
              option.selected = true;
            }
            subCategorySelect.appendChild(option);
          });
        })
        .catch(error => console.error('❌ Gagal mengambil sub kategori:', error));
    }
  }

  // Load sub kategori pertama kali jika ada category terpilih di query string
  const initialCategoryId = categorySelect.value;
  const initialSubCategoryId = "{{ request('sub_category') }}";

  if (initialCategoryId) {
    console.log("🚀 Inisialisasi dengan kategori ID:", initialCategoryId, "dan sub kategori ID:", initialSubCategoryId);
    loadSubCategories(initialCategoryId, initialSubCategoryId);
  }

  // Event listener saat dropdown kategori berubah
  categorySelect.addEventListener('change', function () {
    console.log("🔄 Kategori berubah, ID baru:", this.value);
    loadSubCategories(this.value);
  });
});
</script>
@endpush

