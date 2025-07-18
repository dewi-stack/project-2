@extends('layouts.approver')

@section('content')
<div class="container py-4">
  <h5 class="mb-4">📤 Export Data Stok</h5>

  {{-- 📦 Export Posisi Stok --}}
  <div class="card mb-5 shadow-sm">
    <div class="card-body">
      <h5 class="card-title text-primary"><i class="bi bi-box"></i> Posisi Stok</h5>
      <div class="row align-items-end">
        <div class="col-md-6">
          <label for="tanggal_posisi" class="form-label">Pilih Tanggal Posisi Stok</label>
          <input type="date" class="form-control" id="tanggal_posisi" required>
        </div>
        <div class="col-md-6 mt-3 mt-md-0">
          <button onclick="downloadPosisi()" class="btn btn-success w-100">
            <i class="bi bi-download"></i> Export Posisi
          </button>
        </div>
      </div>
    </div>
  </div>

  {{-- 🔁 Export Mutasi Stok --}}
  <div class="card mb-4 shadow-sm">
    <div class="card-body">
      <h5 class="card-title text-primary"><i class="bi bi-arrow-repeat"></i> Mutasi Stok</h5>
      <div class="row">
        <div class="col-md-5">
          <label for="start_date" class="form-label">Dari Tanggal</label>
          <input type="date" class="form-control" id="start_date" required>
        </div>
        <div class="col-md-5">
          <label for="end_date" class="form-label">Sampai Tanggal</label>
          <input type="date" class="form-control" id="end_date" required>
        </div>
        <div class="col-md-2 d-flex align-items-end">
          <button onclick="downloadMutasi()" class="btn btn-success w-100">
            <i class="bi bi-download"></i> Export Mutasi
          </button>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
function downloadPosisi() {
  const tanggal = document.getElementById('tanggal_posisi').value;
  if (!tanggal) {
    alert("Silakan pilih tanggal terlebih dahulu");
    return;
  }
  window.location.href = `/approver/export/posisi?tanggal=${encodeURIComponent(tanggal)}`;
}

function downloadMutasi() {
  const start = document.getElementById('start_date').value;
  const end = document.getElementById('end_date').value;

  if (!start || !end) {
    alert("Silakan isi tanggal mulai dan tanggal akhir");
    return;
  }

  window.location.href = `/approver/export/mutasi?start_date=${encodeURIComponent(start)}&end_date=${encodeURIComponent(end)}`;
}
</script>
@endsection
