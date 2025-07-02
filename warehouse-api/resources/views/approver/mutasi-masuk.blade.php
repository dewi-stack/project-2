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
  <h5>📥 Mutasi Masuk</h5>
  <div>
    <a href="{{ route('approver.mutasi-masuk.template') }}" class="btn btn-outline-primary me-2">
      <i class="bi bi-file-earmark-arrow-down"></i> Contoh CSV
    </a>
    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#importModal">
      <i class="bi bi-upload"></i> Import CSV
    </button>
  </div>
</div>

{{-- Tabel Mutasi --}}
<div class="table-responsive">
  <table class="table table-bordered table-hover">
    <thead class="table-light">
      <tr>
        <th>
          <a href="{{ route('approver.mutasi-masuk', array_merge(request()->except('page'), [
            'sort' => 'item_name',
            'order' => (request('sort') === 'item_name' && request('order') === 'asc') ? 'desc' : 'asc'
          ])) }}" class="text-decoration-none text-dark">
            Nama Barang {!! sortIcon('item_name') !!}
          </a>
        </th>
        <th>
          <a href="{{ route('approver.mutasi-masuk', array_merge(request()->except('page'), [
            'sort' => 'category',
            'order' => (request('sort') === 'category' && request('order') === 'asc') ? 'desc' : 'asc'
          ])) }}" class="text-decoration-none text-dark">
            Kategori {!! sortIcon('category') !!}
          </a>
        </th>
        <th>
          <a href="{{ route('approver.mutasi-masuk', array_merge(request()->except('page'), [
            'sort' => 'sub_category',
            'order' => (request('sort') === 'sub_category' && request('order') === 'asc') ? 'desc' : 'asc'
          ])) }}" class="text-decoration-none text-dark">
            Sub Kategori {!! sortIcon('sub_category') !!}
          </a>
        </th>
        <th>
          <a href="{{ route('approver.mutasi-masuk', array_merge(request()->except('page'), [
            'sort' => 'quantity',
            'order' => (request('sort') === 'quantity' && request('order') === 'asc') ? 'desc' : 'asc'
          ])) }}" class="text-decoration-none text-dark">
            Stok {!! sortIcon('quantity') !!}
          </a>
        </th>
        <th>
          <a href="{{ route('approver.mutasi-masuk', array_merge(request()->except('page'), [
            'sort' => 'unit',
            'order' => (request('sort') === 'unit' && request('order') === 'asc') ? 'desc' : 'asc'
          ])) }}" class="text-decoration-none text-dark">
            Satuan {!! sortIcon('unit') !!}
          </a>
        </th>
        <th>
          <a href="{{ route('approver.mutasi-masuk', array_merge(request()->except('page'), [
            'sort' => 'location',
            'order' => (request('sort') === 'location' && request('order') === 'asc') ? 'desc' : 'asc'
          ])) }}" class="text-decoration-none text-dark">
            Lokasi {!! sortIcon('location') !!}
          </a>
        </th>
        <th>
          <a href="{{ route('approver.mutasi-masuk', array_merge(request()->except('page'), [
            'sort' => 'status',
            'order' => (request('sort') === 'status' && request('order') === 'asc') ? 'desc' : 'asc'
          ])) }}" class="text-decoration-none text-dark">
            Status {!! sortIcon('status') !!}
          </a>
        </th>
        <th>
          <a href="{{ route('approver.mutasi-masuk', array_merge(request()->except('page'), [
            'sort' => 'created_at',
            'order' => (request('sort') === 'created_at' && request('order') === 'asc') ? 'desc' : 'asc'
          ])) }}" class="text-decoration-none text-dark">
            Tanggal {!! sortIcon('created_at') !!}
          </a>
        </th>
      </tr>
    </thead>
    <tbody>
      @forelse ($mutasi as $request)
        <tr>
          <td>{{ $request->item->name ?? '-' }}</td>
          <td>{{ $request->item->category->name ?? '-' }}</td>
          <td>{{ $request->item->subCategory->name ?? '-' }}</td>
          <td>{{ $request->quantity }}</td>
          <td>{{ $request->unit }}</td>
          <td>{{ $request->item->location ?? '-' }}</td>
          <td>
            @if ($request->status === 'approved')
              <span class="badge bg-success">✅ Disetujui</span>
            @elseif ($request->status === 'pending')
              <span class="badge bg-warning text-dark">⏳ Menunggu</span>
            @else
              <span class="badge bg-secondary">❌ Ditolak</span>
            @endif
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
<div class="d-flex justify-content-end mt-3">
  {{ $mutasi->links() }}
</div>

{{-- Modal Upload --}}
<div class="modal fade" id="importModal" tabindex="-1" aria-labelledby="importModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <form method="POST" action="{{ route('approver.mutasi-masuk.import') }}" enctype="multipart/form-data" class="modal-content">
      @csrf
      <div class="modal-header">
        <h5 class="modal-title" id="importModalLabel">📤 Import Mutasi Masuk dari CSV</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Tutup"></button>
      </div>
      <div class="modal-body">
        <div class="mb-3">
          <label for="file" class="form-label">Pilih file CSV</label>
          <input type="file" class="form-control" id="file" name="file" accept=".csv" required>
          <small class="text-muted">Pastikan format kolom sesuai template.</small>
        </div>
      </div>
      <div class="modal-footer">
        <button type="submit" class="btn btn-primary">Import Sekarang</button>
      </div>
    </form>
  </div>
</div>

@endsection
