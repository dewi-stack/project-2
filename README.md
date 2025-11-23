<!-- Banner -->
<p align="center">
  <img src="https://capsule-render.vercel.app/api?type=waving&color=0:11998e,100:38ef7d&height=160&section=header&text=Aplikasi%20Warehouse%20🏭&fontSize=30&fontColor=fff&animation=fadeIn&fontAlignY=35"/>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Laravel-FF2D20?logo=laravel&logoColor=white"/>
  <img src="https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white"/>
  <img src="https://img.shields.io/badge/MySQL-00758F?logo=mysql&logoColor=white"/>
  <img src="https://img.shields.io/badge/Status-Maintained-success"/>
</p>

---

# 🏭 Aplikasi Warehouse – PT Agro Jaya Industri

**Aplikasi Warehouse** adalah sistem manajemen gudang berbasis **Laravel (Web Dashboard)** dan **Flutter (Aplikasi Mobile)**.  
Sistem ini digunakan untuk mempermudah pengelolaan stok barang, mutasi barang, dan proses approval.

---

# 📦 Fitur Utama

## 📱 Aplikasi Mobile (Flutter)
- Scan barcode atau input SKU manual  
- Input & update stok barang  
- Mutasi barang (Masuk/Keluar)  
- Export Excel langsung dari aplikasi  
- Sistem login & autentikasi  
- Tampilan modern, ringan, dan mobile-friendly  

## 💻 Dashboard Web (Laravel)
- Manajemen barang, kategori, subkategori, dan user  
- Import & Export Excel (stok & mutasi)  
- Role-based access (Admin, Approver, Submitter)  
- Approval mutasi barang  
- Grafik dan laporan  

---

# 🧰 Teknologi yang Digunakan

| Komponen | Teknologi |
|---------|-----------|
| **Frontend Mobile** | Flutter |
| **Frontend Web** | Laravel Blade + Bootstrap |
| **Backend API** | Laravel 12 |
| **Database** | MySQL / MariaDB |
| **Library Pendukung** | maatwebsite/excel, http, dio, provider |

---

# 📂 Struktur Project

project_3/
│── warehouse-api/ # Laravel API + Dashboard Web
│── frontend/ # Flutter Mobile App
└── README.md

---

# 🚀 Instalasi Proyek

## 1️⃣ Instalasi Backend (Laravel)

Masuk ke folder backend:
```bash
cd warehouse-api
composer install
cp .env.example .env
Atur database di file .env:

makefile
Salin kode
DB_DATABASE=db_warehouse
DB_USERNAME=root
DB_PASSWORD=
Generate key & jalankan server:

bash
Salin kode
php artisan key:generate
php artisan serve
```


## 2️⃣ Instalasi Frontend (Flutter)
Masuk ke folder aplikasi mobile:

```bash
cd frontend
flutter pub get
Jalankan aplikasi:

Untuk Web:
flutter run -d chrome

Untuk Android:
flutter run

🔐 Akun Demo
🟦 Submitter
Email: submitter@example.com

Password: password123
Digunakan untuk:

Input data stok

Input mutasi

Melihat status mutasi

🟩 Approver
Email: approver@example.com

Password: password123
Digunakan untuk:

Melihat mutasi pending

Menerima/menolak mutasi

Melihat laporan stok

📘 Cara Menggunakan Aplikasi
1️⃣ Login
Submitter → input barang / mutasi

Approver → persetujuan mutasi

2️⃣ Alur Submitter
Login

Pilih menu Input Barang / Mutasi Barang

Scan barcode atau input SKU manual

Submit data

Tunggu persetujuan Approver

3️⃣ Alur Approver
Login

Buka menu Mutasi Pending

Lihat detail mutasi

Klik Accept atau Decline

Status otomatis diperbarui

4️⃣ Export Excel
Dari mobile → Export Posisi Stok

Dari web → Export Stok & Mutasi Barang
```

<p align="center"> Terima kasih telah menggunakan Aplikasi Warehouse! 🙌 </p>
