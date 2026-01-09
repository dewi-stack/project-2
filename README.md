<!-- Banner -->
<p align="center">
  <img src="https://capsule-render.vercel.app/api?type=waving&color=0:11998e,100:38ef7d&height=160&section=header&text=Warehouse%20Management%20System%20🏭&fontSize=30&fontColor=fff&animation=fadeIn&fontAlignY=35"/>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Laravel-FF2D20?logo=laravel&logoColor=white"/>
  <img src="https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white"/>
  <img src="https://img.shields.io/badge/MySQL-00758F?logo=mysql&logoColor=white"/>
  <img src="https://img.shields.io/badge/Project-Maintained-success"/>
</p>

---

# 🏭 Warehouse Management System  
### PT Agro Jaya Industri

The **Warehouse Management System** is a web and mobile-based application built with  
**Laravel (Web Dashboard & REST API)** and **Flutter (Mobile App)**.

This system is designed to manage **stock items, inbound/outbound mutations, and approval workflows** efficiently, helping warehouse operations become more structured, accurate, and transparent.

---

## 📦 Key Features

### 📱 Mobile Application (Flutter)
- Barcode scanning or manual SKU input
- Stock item input and updates
- Stock mutation (Inbound / Outbound)
- Export stock data to Excel
- User authentication & login
- Lightweight, modern, and mobile-friendly UI

### 💻 Web Dashboard (Laravel)
- Item, category, subcategory, and user management
- Import & export stock and mutation data to Excel
- Role-based access control:
  - Admin
  - Approver
  - Submitter
- Stock mutation approval process
- Stock reports and charts

---

## 🧰 Tech Stack

| Component | Technology |
|---------|------------|
| **Mobile Frontend** | Flutter |
| **Web Frontend** | Laravel Blade + Bootstrap |
| **Backend API** | Laravel 12 (REST API) |
| **Database** | MySQL / MariaDB |
| **Supporting Libraries** | maatwebsite/excel, http, dio, provider |

---

## 📂 Project Structure

project_3/
│── warehouse-api/ # Laravel REST API & Web Dashboard
│── frontend/ # Flutter Mobile Application
└── README.md


---

## 🚀 Installation Guide

### 1️⃣ Backend Setup (Laravel)

```bash
cd warehouse-api
composer install
cp .env.example .env

Configure database in .env:
DB_DATABASE=db_warehouse
DB_USERNAME=root
DB_PASSWORD=

Run the application:
php artisan key:generate
php artisan serve
```


2️⃣ Frontend Setup (Flutter)

```bash
cd frontend
flutter pub get
Run the application:

Web:
flutter run -d chrome

Android:
flutter run

🔐 Demo Accounts
🟦 Submitter

Email: submitter@example.com

Password: password123

Permissions:

Input stock data

Submit stock mutations

View mutation status

🟩 Approver

Email: approver@example.com

Password: password123

Permissions:

View pending mutations

Approve or reject mutations

View stock reports

📘 Application Workflow
1️⃣ Login

Submitter → stock input & mutation submission

Approver → mutation approval

2️⃣ Submitter Flow

Login

Select stock input or mutation menu

Scan barcode or enter SKU manually

Submit data

Wait for approver confirmation

3️⃣ Approver Flow

Login

Open pending mutation list

Review mutation details

Click Accept or Decline

Status updates automatically

4️⃣ Excel Export

Mobile App → Export current stock position

Web Dashboard → Export stock & mutation reports
```

<p align="center"> Thank you for using the Warehouse Management System 🙌 </p> ```
