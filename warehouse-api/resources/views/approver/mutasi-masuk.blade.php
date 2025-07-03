@extends('layouts.approver')

@section('content')

@php
    function sortIcon($field) {
        $currentSort = request('sort');
        $currentOrder = request('order', 'asc');

        if ($currentSort === $field) {
            return $currentOrder === 'asc'
                ? '<i class="bi bi-caret-up-fill ms-1"></i>'
                : '<i class="bi bi-caret-down-fill ms-1"></i>';
        }

        return '';
    }
@endphp

<div class="d-flex justify-content-between align-items-center mb-4">
  <h5 class="mb-0">📥 Mutasi Masuk</h5>
  <div>
    <a href="{{ route('approver.mutasi-masuk.template') }}" class="btn btn-outline-primary me-2">
      <i class="bi bi-file-earmark-arrow-down"></i> Template Excel
    </a>
    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#importModal">
      <i class="bi bi-upload"></i> Import Excel
    </button>
  </div>
</div>

{{-- Tabel Mutasi --}}
<div class="table-responsive">
  <table class="table table-bordered table-hover align-middle">
    <thead class="table-light text-center">
      <tr>
        @foreach ([
          'item_name' => 'Nama Barang',
          'category' => 'Kategori',
          'sub_category' => 'Sub Kategori',
          'quantity' => 'Stok',
          'unit' => 'Satuan',
          'location' => 'Lokasi',
          'status' => 'Status',
          'created_at' => 'Tanggal'
        ] as $field => $label)
          <th>
            <a href="{{ route('approver.mutasi-masuk', array_merge(request()->except('page'), [
              'sort' => $field,
              'order' => (request('sort') === $field && request('order') === 'asc') ? 'desc' : 'asc'
            ])) }}" class="text-decoration-none text-dark">
              {{ $label }} {!! sortIcon($field) !!}
            </a>
          </th>
        @endforeach
      </tr>
    </thead>
    <tbody>
      @forelse ($mutasi as $request)
        <tr>
          <td>{{ $request->item->name ?? '-' }}</td>
          <td>{{ $request->item->category->name ?? '-' }}</td>
          <td>{{ $request->item->subCategory->name ?? '-' }}</td>
          <td class="text-center">{{ $request->quantity }}</td>
          <td class="text-center">{{ $request->unit }}</td>
          <td>{{ $request->item->location ?? '-' }}</td>
          <td class="text-center">
            @switch($request->status)
              @case('approved')
                <span class="badge bg-success">✅ Disetujui</span>
                @break
              @case('pending')
                <span class="badge bg-warning text-dark">⏳ Menunggu</span>
                @break
              @default
                <span class="badge bg-secondary">❌ Ditolak</span>
            @endswitch
          </td>
          <td>{{ $request->created_at->format('d/m/Y H:i') }}</td>
        </tr>
      @empty
        <tr>
          <td colspan="8" class="text-center">Tidak ada data mutasi masuk.</td>
        </tr>
      @endforelse
    </tbody>
  </table>
</div>

{{-- Pagination --}}
@if ($mutasi->hasPages())
  <div class="d-flex justify-content-center mt-4">
    {{ $mutasi->onEachSide(1)->links('pagination::bootstrap-5') }}
  </div>
@endif

{{-- Modal Upload --}}
<div class="modal fade" id="importModal" tabindex="-1" aria-labelledby="importModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <form method="POST" action="{{ route('approver.mutasi-masuk.import') }}" enctype="multipart/form-data" class="modal-content">
      @csrf
      <div class="modal-header">
        <h5 class="modal-title" id="importModalLabel">📤 Import Mutasi Masuk dari Excel</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Tutup"></button>
      </div>
      <div class="modal-body">
        <div class="mb-3">
          <label for="file" class="form-label">Pilih file Excel (.xlsx / .xls)</label>
          <input type="file" class="form-control" id="file" name="file" accept=".xlsx,.xls" required>
          <small class="text-muted">Pastikan format kolom sesuai dengan template.</small>
        </div>
      </div>
      <div class="modal-footer">
        <button type="submit" class="btn btn-primary">Import Sekarang</button>
      </div>
    </form>
  </div>
</div>

@endsection
