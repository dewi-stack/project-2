# 🏭 Warehouse Management System

> A full-stack warehouse management application built with Laravel and Flutter to manage inventory, stock movements, approval workflows, and operational reporting.

![Laravel](https://img.shields.io/badge/Laravel-FF2D20?logo=laravel\&logoColor=white)
![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter\&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-00758F?logo=mysql\&logoColor=white)
![Status](https://img.shields.io/badge/Project-Maintained-success)

---

## 📋 Overview

**Warehouse Management System** is a web and mobile-based application designed to help warehouse teams manage inventory and stock movements in a more structured and transparent workflow.

The system consists of:

* **Laravel Web Dashboard** for warehouse administration and monitoring
* **Laravel REST API** for mobile application communication
* **Flutter Mobile Application** for operational activities
* **MySQL / MariaDB** for data storage

The application supports stock management, inbound and outbound mutations, approval workflows, Excel reporting, and role-based access control.

---

## 🎯 Business Problem

Warehouse operations often involve repetitive data entry and manual approval processes.

Without a centralized system, several problems can occur:

* Stock data becomes difficult to track
* Manual data entry increases the possibility of errors
* Stock mutations require additional verification
* Approval status is difficult to monitor
* Reports need to be prepared manually
* Different users may have different responsibilities and access levels

This system was designed to provide a more structured digital workflow for warehouse operations.

---

## 💡 Solution

The application connects warehouse operations through a centralized web and mobile system.

```text
                    ┌──────────────────────┐
                    │   Warehouse Users    │
                    └──────────┬───────────┘
                               │
                 ┌─────────────┴─────────────┐
                 │                           │
                 ▼                           ▼
       ┌──────────────────┐        ┌──────────────────┐
       │ Flutter Mobile   │        │ Laravel Web      │
       │ Application      │        │ Dashboard        │
       └────────┬─────────┘        └────────┬─────────┘
                │                           │
                │        HTTP / JSON        │
                └────────────┬──────────────┘
                             ▼
                  ┌────────────────────┐
                  │ Laravel REST API   │
                  │                    │
                  │ Authentication     │
                  │ Business Logic     │
                  │ Validation         │
                  │ Approval Workflow  │
                  └─────────┬──────────┘
                            │
                            ▼
                  ┌────────────────────┐
                  │ MySQL / MariaDB    │
                  │                    │
                  │ Items              │
                  │ Users              │
                  │ Stock              │
                  │ Mutations          │
                  └────────────────────┘
```

---

# 🚀 Key Features

## 📱 Mobile Application

The Flutter mobile application is designed for warehouse employees who need to perform operational activities directly from their mobile devices.

### Stock Management

* Add and update stock items
* Search items using SKU
* Barcode scanning or manual SKU input
* View current stock information
* Record stock-related activities

### Stock Mutation

Supports warehouse stock movement such as:

* Inbound
* Outbound
* Stock mutation submission
* Mutation status monitoring

### Authentication

* User login
* Token-based authentication
* Role-based access
* Session management

### Excel Export

Users can export relevant stock information into Excel format for further processing and reporting.

---

# 💻 Web Dashboard

The Laravel web dashboard provides administrative and monitoring functionality.

## Master Data Management

Administrators can manage:

* Items
* Categories
* Subcategories
* Users

## 📦 Stock Management

The dashboard provides functionality to monitor warehouse stock and manage stock-related data.

## 🔄 Mutation Management

Warehouse stock mutations can be reviewed through an approval workflow.

Approvers can:

* View pending mutations
* Review mutation details
* Approve mutations
* Reject mutations
* Monitor mutation status

## 📊 Reporting

The system provides reporting functionality for:

* Current stock
* Stock mutations
* Inbound transactions
* Outbound transactions

Reports can be exported into Excel format.

## 🔐 Role-Based Access Control

The application separates user permissions based on their role.

| Role          | Responsibilities                                 |
| ------------- | ------------------------------------------------ |
| **Admin**     | Manage users, items, categories, and system data |
| **Submitter** | Input stock data and submit stock mutations      |
| **Approver**  | Review, approve, or reject submitted mutations   |

---

# 🔄 Application Workflow

The main workflow of the application is:

```text
Login
  │
  ▼
User Role
  │
  ├───────────────┐
  │               │
  ▼               ▼
Submitter       Approver
  │               │
  ▼               ▼
Stock Input     Pending Mutations
  │               │
  ▼               ▼
Submit Mutation  Review Mutation
  │               │
  │               ├──────► Reject
  │               │
  │               └──────► Approve
  │                         │
  └─────────────────────────┘
              │
              ▼
       Stock Status Updated
              │
              ▼
         Excel Reports
```

---

# 👤 User Roles

## 🟦 Submitter

The Submitter is responsible for entering operational data.

### Permissions

* Login
* Input stock data
* Search items
* Submit stock mutations
* View mutation status

### Workflow

```text
Login
  ↓
Select Stock / Mutation
  ↓
Scan Barcode or Enter SKU
  ↓
Enter Data
  ↓
Submit
  ↓
Waiting for Approval
```

---

## 🟩 Approver

The Approver is responsible for reviewing submitted stock mutations.

### Permissions

* Login
* View pending mutations
* Review mutation details
* Approve mutations
* Reject mutations
* View stock reports

### Workflow

```text
Login
  ↓
Open Pending Mutations
  ↓
Review Mutation
  ↓
Approve / Reject
  ↓
Mutation Status Updated
```

---

# 📊 Excel Reporting

Excel export is provided to support existing business reporting workflows.

The system supports exporting relevant operational data from both the mobile application and web dashboard.

### Mobile Application

```text
Current Stock
     ↓
Export
     ↓
Excel (.xlsx)
```

### Web Dashboard

```text
Stock / Mutation Data
        ↓
Export
        ↓
Excel (.xlsx)
        ↓
Management / Administration
```

Excel reports can be used for:

* Daily operational reports
* Stock monitoring
* Mutation records
* Administrative processing
* Data analysis

---

# 🧰 Tech Stack

| Component        | Technology                 |
| ---------------- | -------------------------- |
| Mobile Frontend  | Flutter / Dart             |
| Web Frontend     | Laravel Blade / Bootstrap  |
| Backend          | Laravel 12                 |
| API              | Laravel REST API           |
| Database         | MySQL / MariaDB            |
| Authentication   | Token-based Authentication |
| Excel Processing | `maatwebsite/excel`        |
| HTTP Client      | `http` / `dio`             |
| State Management | `provider`                 |
| Data Format      | JSON                       |
| Version Control  | Git / GitHub               |

---

# 🏗️ System Architecture

The system uses a client-server architecture.

```text
┌─────────────────────────────┐
│      Flutter Mobile App     │
│                             │
│  • Stock Input              │
│  • Barcode / SKU            │
│  • Mutation                  │
│  • Authentication           │
│  • Excel Export             │
└──────────────┬──────────────┘
               │
               │ REST API
               │ HTTP / JSON
               ▼
┌─────────────────────────────┐
│       Laravel Backend       │
│                             │
│  • REST API                 │
│  • Authentication           │
│  • Validation               │
│  • Business Logic           │
│  • Approval Workflow        │
│  • Web Dashboard            │
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
│       MySQL / MariaDB       │
│                             │
│  • Users                    │
│  • Items                    │
│  • Categories               │
│  • Stock                    │
│  • Mutations                │
└─────────────────────────────┘
```

---

# 📂 Project Structure

```text
project_3/
│
├── warehouse-api/
│   ├── app/
│   ├── routes/
│   ├── database/
│   ├── resources/
│   ├── public/
│   └── ...
│
├── frontend/
│   ├── lib/
│   ├── android/
│   ├── ios/
│   ├── web/
│   └── ...
│
└── README.md
```

> Update the structure above if the actual project folders differ.

---

# 📸 Application Preview

Add real screenshots here to demonstrate the application.

## Mobile Application

### Login

![Mobile Login](screenshots/mobile-login.png)

### Stock Management

![Stock Management](screenshots/mobile-stock.png)

### Stock Mutation

![Stock Mutation](screenshots/mobile-mutation.png)

### Barcode / SKU Input

![Barcode Scanner](screenshots/mobile-barcode.png)

---

## Web Dashboard

### Dashboard

![Dashboard](screenshots/dashboard.png)

### Item Management

![Item Management](screenshots/item-management.png)

### Mutation Approval

![Mutation Approval](screenshots/mutation-approval.png)

### Stock Report

![Stock Report](screenshots/stock-report.png)

---

# 🚀 Installation

## Requirements

Before running the project, make sure the following tools are installed:

* PHP
* Composer
* Laravel
* MySQL / MariaDB
* Flutter SDK
* Dart SDK
* Android Studio or another supported Flutter development environment

---

## 1. Clone the Repository

```bash
git clone https://github.com/dewi-stack/project-2.git
cd project-2
```

---

# 2. Backend Setup

Navigate to the Laravel backend:

```bash
cd warehouse-api
```

Install PHP dependencies:

```bash
composer install
```

Create the environment file:

```bash
cp .env.example .env
```

Generate the Laravel application key:

```bash
php artisan key:generate
```

---

## 3. Database Configuration

Configure the database in `.env`.

Example:

```env
DB_DATABASE=db_warehouse
DB_USERNAME=root
DB_PASSWORD=
```

Make sure the MySQL / MariaDB database has been created before running the migrations.

Then run:

```bash
php artisan migrate
```

If the project contains database seeders, run:

```bash
php artisan db:seed
```

> Only use the seeder command if seeders are actually included in the project.

---

## 4. Run Laravel

Start the development server:

```bash
php artisan serve
```

The backend will normally be available at:

```text
http://127.0.0.1:8000
```

---

# 5. Flutter Setup

Open another terminal and navigate to the Flutter application:

```bash
cd frontend
```

Install Flutter dependencies:

```bash
flutter pub get
```

Run on Chrome:

```bash
flutter run -d chrome
```

Run on Android:

```bash
flutter run
```

Make sure the API base URL in the Flutter application points to the correct Laravel server.

---

# 🔗 API Configuration

The Flutter application communicates with the Laravel backend through REST API.

The general flow is:

```text
Flutter
   ↓
HTTP Request
   ↓
Laravel REST API
   ↓
Validation & Business Logic
   ↓
Database
   ↓
JSON Response
   ↓
Flutter
```

API endpoint documentation should be added here based on the actual routes defined in:

```text
warehouse-api/routes/api.php
```

Example documentation format:

| Method | Endpoint   | Description        |
| ------ | ---------- | ------------------ |
| `POST` | `/api/...` | Authentication     |
| `GET`  | `/api/...` | Retrieve stock     |
| `POST` | `/api/...` | Submit mutation    |
| `GET`  | `/api/...` | Retrieve mutations |

> Replace the example endpoints above with the actual API routes from the project.

---

# 🔐 Demo Accounts

For demonstration purposes, test accounts can be provided if they are available in the project.

### Submitter

```text
Email: submitter@example.com
Password: password123
```

Permissions:

* Input stock data
* Submit stock mutations
* View mutation status

### Approver

```text
Email: approver@example.com
Password: password123
```

Permissions:

* View pending mutations
* Approve mutations
* Reject mutations
* View stock reports

> **Security:** Never use real production credentials in a public GitHub repository. Demo credentials should only be used if they are intentionally created for demonstration purposes.

---

# 🧪 Testing

The main application workflow can be tested using the following checklist:

### Authentication

* [ ] Login with valid credentials
* [ ] Reject invalid credentials
* [ ] Verify authentication token
* [ ] Verify role-based access

### Stock

* [ ] Add stock data
* [ ] Search stock by SKU
* [ ] Update stock information
* [ ] View current stock

### Mutation

* [ ] Create inbound mutation
* [ ] Create outbound mutation
* [ ] Submit mutation
* [ ] View mutation status
* [ ] Approve mutation
* [ ] Reject mutation

### Reporting

* [ ] Export stock data
* [ ] Export mutation data
* [ ] Verify generated Excel file

---

# 🔒 Security Considerations

The system implements authentication and role-based access to separate responsibilities between users.

For production deployment, additional security practices should include:

* HTTPS
* Secure API authentication
* Proper authorization checks
* Input validation
* Secure `.env` configuration
* Protection of production credentials
* Database access restrictions
* API rate limiting where appropriate
* Secure file upload/download handling

---

# 📈 Future Improvements

The system can be extended with additional warehouse and business features.

* [ ] Advanced dashboard
* [ ] Stock forecasting
* [ ] Low-stock notifications
* [ ] Push notifications
* [ ] Real-time stock updates
* [ ] Advanced search and filtering
* [ ] Pagination
* [ ] Audit logs
* [ ] More detailed analytics
* [ ] Multi-warehouse support
* [ ] Purchase order management
* [ ] Supplier management
* [ ] Inventory history
* [ ] Advanced reporting

---

# 🎯 Business Use Cases

The architecture of this system can be adapted for various business environments.

### Warehouse Management

Manage inventory, stock movements, and warehouse operations.

### Manufacturing

Track materials and stock movements within manufacturing workflows.

### Distribution

Monitor incoming and outgoing products.

### Retail

Extend the system into inventory and POS-related workflows.

### Internal Company Applications

The same architecture can be adapted for other internal operational systems that require:

* Mobile data collection
* Centralized backend
* Approval workflows
* Reporting
* Role-based access

---

# 💼 What This Project Demonstrates

This project demonstrates practical experience in developing a complete business application across multiple layers:

### Mobile Development

* Flutter
* Dart
* API integration
* Mobile forms
* Barcode / SKU workflows

### Backend Development

* Laravel
* REST API
* Authentication
* CRUD operations
* Validation
* Business logic

### Database

* MySQL / MariaDB
* Relational data management
* Stock and transaction data

### Business Logic

* Inbound / outbound workflow
* Stock mutation
* Approval process
* Role-based permissions

### Reporting

* Excel export
* Stock reports
* Mutation reports

The project demonstrates the ability to connect **mobile applications, backend APIs, databases, business workflows, and reporting** into a single system.

---

# 📌 Project Status

**Status: Maintained**

The system can be further customized based on specific warehouse and business requirements.

Potential customization includes:

* Warehouse management
* Inventory management
* POS integration
* Approval workflows
* Internal company applications
* Reporting dashboards
* Business-specific workflows

---

# 👩‍💻 Developer

**Dewi Laylaturrohmah**

Flutter & Laravel Developer

### Specialization

* Flutter Mobile Applications
* Laravel Backend Development
* REST API
* Business Applications
* Inventory & Warehouse Systems
* Internal Company Applications

For collaboration and custom application development, please contact me through my professional profile.

---

## ⭐ Portfolio Note

This project is part of my portfolio demonstrating full-stack application development using **Flutter + Laravel**.

The system was designed around a real-world warehouse workflow involving:

```text
Inventory
   ↓
Stock Movement
   ↓
Submission
   ↓
Approval
   ↓
Stock Update
   ↓
Reporting
```

---

<p align="center">
  Built with Flutter & Laravel 🚀
</p>
