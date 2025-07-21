@extends('layouts.approver')

@section('content')
<h5 class="mb-4">📊 Data Stok Barang</h5>

{{-- Ringkasan --}}
<div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-3 mb-4">
  @foreach ([
    ['label' => 'Total Barang', 'count' => $totalItems, 'color' => 'primary'],
    ['label' => 'Stok Aman (>10)', 'count' => $stokAman, 'color' => 'success'],
    ['label' => 'Stok Menipis (<10)', 'count' => $stokMenipis, 'color' => 'warning', 'text' => 'text-dark'],
    ['label' => 'Stok Habis', 'count' => $stokHabis, 'color' => 'danger']
  ] as $card)
    <div class="col">
      <div class="card shadow-sm border-0 text-white bg-{{ $card['color'] }} h-100 {{ $card['text'] ?? '' }}">
        <div class="card-body text-center d-flex flex-column justify-content-center">
          <h6 class="card-title mb-2">{{ $card['label'] }}</h6>
          <h2 class="fw-bold">{{ $card['count'] }}</h2>
        </div>
      </div>
    </div>
  @endforeach
</div>

{{-- Filter --}}
<form method="GET" action="{{ route('approver.stok') }}" class="row g-2 align-items-end mb-4">
  <div class="col-md-3">
    <label for="category" class="form-label">Kategori</label>
    <select name="category" id="category" class="form-select">
      <option value="">- Semua Kategori -</option>
      @foreach($categories as $cat)
        <option value="{{ $cat->id }}" {{ request('category') == $cat->id ? 'selected' : '' }}>{{ $cat->name }}</option>
      @endforeach
    </select>
  </div>

  <div class="col-md-3">
    <label for="sub_category" class="form-label">Sub Kategori</label>
    <select name="sub_category" id="sub_category" class="form-select">
      <option value="">- Semua Sub Kategori -</option>
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

{{-- List Barang --}}
<div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
  @forelse ($items as $item)
    @php
      $latestIncrease = $item->stockRequests->where('type', 'increase')->sortByDesc('created_at')->first();
      $latestDecrease = $item->stockRequests->where('type', 'decrease')->sortByDesc('created_at')->first();
      $pendingDelete = $item->stockRequests->where('type', 'delete')->where('status', 'pending')->first();

      $latestMutation = $latestIncrease && $latestDecrease
        ? ($latestIncrease->created_at > $latestDecrease->created_at ? $latestIncrease : $latestDecrease)
        : ($latestIncrease ?? $latestDecrease);
    @endphp

    <div class="col">
      <div class="card shadow-sm border-0 h-100 d-flex flex-column justify-content-between">
        <div class="card-body">
          <h5 class="card-title text-primary">{{ $item->name }}</h5>
          <p class="mb-1">
            <strong>Kode Barang:</strong> {{ $item->sku }}<br>
            <strong>Stok:</strong> {{ $item->stock }} {{ $item->unit ?? 'Unit' }}<br>

            {{-- Mutasi Terakhir --}}
            @if ($latestMutation)
              @php
                $icon = $latestMutation->type === 'increase' ? 'Masuk' : 'Keluar';
                $badge = match(true) {
                  $latestMutation->type === 'decrease' => 'bg-warning text-dark',
                  $latestMutation->status === 'pending' => 'bg-warning text-dark',
                  $latestMutation->status === 'approved' => 'bg-success',
                  $latestMutation->status === 'rejected' => 'bg-secondary',
                  default => 'bg-light text-dark'
                };
                $statusLabel = match($latestMutation->status) {
                  'pending' => '⏳',
                  'approved' => '✅',
                  'rejected' => '❌',
                  default => ''
                };
              @endphp
              <strong>Mutasi:</strong>
              <span class="badge {{ $badge }}">
                {{ $statusLabel }} {{ $icon }} {{ $latestMutation->quantity }} {{ $item->unit ?? 'Unit' }}
                ({{ ucfirst($latestMutation->status === 'approved' ? 'Disetujui' : ($latestMutation->status === 'pending' ? 'Menunggu' : 'Ditolak')) }})
              </span><br>
            @endif

            {{-- Permintaan Hapus --}}
            @if ($pendingDelete)
              <strong>Status:</strong>
              <span class="badge bg-danger">🗑️ Permintaan Penghapusan</span><br>
            @endif

            <strong>Kategori:</strong> {{ $item->category->name ?? '-' }}<br>
            <strong>Lokasi:</strong> {{ $item->location }}<br>
            <strong>Keterangan:</strong> {{ $latestMutation->description ?? $item->description ?? '-' }}
          </p>
        </div>

        <div class="card-footer bg-transparent border-top-0 d-flex justify-content-between align-items-center px-3 pb-3">
          {{-- Status Stok --}}
          <div>
            @if ($item->stock == 0)
              <span class="badge bg-danger">❌ Stok Habis</span>
            @elseif ($item->stock <= 10)
              <span class="badge bg-warning text-dark">⚠️ Stok Menipis</span>
            @else
              <span class="badge bg-success">✅ Stok Aman</span>
            @endif
          </div>

          {{-- Aksi Approve/Hapus --}}
          @if ($pendingDelete)
            <div>
              <form method="POST" action="{{ route('approver.approve', $pendingDelete->id) }}" class="d-inline">
                @csrf @method('PUT')
                <input type="hidden" name="status" value="approved">
                <button type="submit" class="btn btn-sm btn-success" title="Setujui" onclick="return confirm('Setujui penghapusan item ini?')">
                  <i class="bi bi-check-circle"></i>
                </button>
              </form>
              <form method="POST" action="{{ route('approver.approve', $pendingDelete->id) }}" class="d-inline">
                @csrf @method('PUT')
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
      <div class="alert alert-warning w-100 text-center">Tidak ada data barang.</div>
    </div>
  @endforelse
</div>

{{-- Pagination --}}
@if ($items->hasPages())
  <div class="mt-4 d-flex justify-content-center">
    {{ $items->withQueryString()->links('pagination::bootstrap-5') }}
  </div>
@endif
@endsection

@push('scripts')
<script>
document.addEventListener('DOMContentLoaded', function () {
  const categorySelect = document.getElementById('category');
  const subCategorySelect = document.getElementById('sub_category');

  function loadSubCategories(categoryId, selectedId = "{{ request('sub_category') }}") {
    subCategorySelect.innerHTML = '<option value="">- Semua Sub Kategori -</option>';
    if (!categoryId) return;

    fetch(`/api/sub-categories/by-category/${categoryId}`)
      .then(res => res.json())
      .then(data => {
        data.forEach(sub => {
          const option = new Option(sub.name, sub.id);
          if (selectedId == sub.id) option.selected = true;
          subCategorySelect.appendChild(option);
        });
      })
      .catch(err => console.error('Gagal memuat sub kategori:', err));
  }

  if (categorySelect.value) {
    loadSubCategories(categorySelect.value);
  }

  categorySelect.addEventListener('change', () => {
    loadSubCategories(categorySelect.value);
  });
});
</script>
@endpush
