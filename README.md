# 🏘️ JAWARA - Aplikasi Manajemen RT/RW

<div align="center">
  <img src="assets/logo.png" alt="JAWARA Logo" width="200"/>
  
  **Sistem Informasi Manajemen RT/RW Berbasis Mobile**
  
  [![Flutter](https://img.shields.io/badge/Flutter-3.35.4-02569B?logo=flutter)](https://flutter.dev)
  [![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart)](https://dart.dev)
  [![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
</div>

---

## 📋 Deskripsi

**JAWARA** (Jaringan Warga) adalah aplikasi mobile yang dirancang untuk memudahkan pengelolaan administrasi dan keuangan RT/RW. Aplikasi ini menyediakan fitur lengkap untuk manajemen data warga, keuangan, kegiatan, dan marketplace warga.

### ✨ Fitur Utama

#### 👥 Manajemen Warga

- **Data Warga**: Pencatatan lengkap data penduduk RT/RW
- **Data Keluarga**: Manajemen data keluarga dan anggota keluarga
- **Data Rumah**: Pencatatan informasi rumah dan kepemilikan
- **Mutasi Warga**: Tracking perpindahan warga (masuk/keluar)
- **Persetujuan Warga**: Sistem approval untuk pendaftaran warga baru

#### 💰 Manajemen Keuangan

- **Pemasukan**:
  - Iuran Bulanan
  - Kategori Pemasukan
  - Pemasukan Lainnya
- **Pengeluaran**:
  - Pencatatan pengeluaran RT/RW
  - Kategorisasi pengeluaran
- **Laporan Keuangan**:
  - Laporan pemasukan
  - Laporan pengeluaran
  - Export ke PDF
  - Cetak laporan

#### 🛍️ Marketplace Warga

- **Katalog Produk**: Jual beli antar warga
- **Unggah Produk**: Warga dapat menjual produk
- **Keranjang Belanja**: Sistem keranjang untuk multiple items
- **Checkout**: Proses pembelian yang mudah
- **Metode Pengiriman**:
  - Reguler (diantar penjual)
  - Instan (ambil di tempat)
- **Metode Pembayaran**:
  - Transfer Bank (BCA, Mandiri, BNI, BRI)
  - QRIS
- **Transaksi**: Tracking status pesanan

#### 📊 Dashboard & Laporan

- **Dashboard Aktivitas**: Ringkasan kegiatan RT/RW
- **Dashboard Keuangan**: Visualisasi pemasukan & pengeluaran
- **Dashboard Populasi**: Statistik data warga
- **Grafik & Chart**: Visualisasi data dengan fl_chart

#### 📢 Komunikasi

- **Saluran Komunikasi**: Broadcast informasi ke warga
- **Notifikasi**: Push notification untuk update penting
- **Pesan Warga**: Sistem pesan antar warga

#### 👤 Manajemen User

- **Multi-Role**: Admin, Ketua RT, Bendahara, Warga
- **Autentikasi**: Login dengan email/password
- **Biometric**: Login dengan fingerprint/face ID
- **Manajemen User**: CRUD user dan role

---

## 👨‍💻 Tim Pengembang

**Kelompok 07 - Politeknik Negeri Malang**

| NIM        | Nama                             | Role      |
| ---------- | -------------------------------- | --------- |
| 2341720123 | Ahmad Dzul Fadhli Hannan         | Developer |
| 2341720042 | Gilang Purnomo                   | Developer |
| 2341720229 | Mochammad Firmandika Jati Kusuma | Developer |
| 2341720115 | Raffi Abiyyu Airlangga           | Developer |

---

## 🛠️ Teknologi

### Framework & Language

- **Flutter** 3.35.4 - UI Framework
- **Dart** 3.0+ - Programming Language

### Dependencies Utama

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management & Navigation
  provider: ^6.1.2

  # UI Components
  fl_chart: ^0.69.2
  intl: ^0.19.0

  # Image & Media
  image_picker: ^1.2.0

  # Authentication & Security
  local_auth: ^2.3.0
  shared_preferences: ^2.3.4

  # PDF Generation
  pdf: ^3.11.1
  printing: ^5.13.4

  # Notifications
  flutter_local_notifications: ^18.0.1
```

---

## 📱 Screenshots

<div align="center">
  <img src="docs/screenshots/dashboard.png" width="200" alt="Dashboard"/>
  <img src="docs/screenshots/warga.png" width="200" alt="Data Warga"/>
  <img src="docs/screenshots/keuangan.png" width="200" alt="Keuangan"/>
  <img src="docs/screenshots/marketplace.png" width="200" alt="Marketplace"/>
</div>

---

## 🚀 Instalasi & Setup

### Prerequisites

- Flutter SDK 3.35.4 atau lebih baru
- Dart SDK 3.0+
- Android Studio / VS Code
- Android SDK (untuk Android)
- Xcode (untuk iOS)

### Langkah Instalasi

1. **Clone Repository**

   ```bash
   git clone https://github.com/your-repo/jawara.git
   cd jawara
   ```

2. **Install Dependencies**

   ```bash
   flutter pub get
   ```

3. **Setup Environment**

   - Pastikan Flutter sudah terinstall dengan benar

   ```bash
   flutter doctor
   ```

4. **Run Application**

   ```bash
   # Debug mode
   flutter run

   # Release mode
   flutter run --release
   ```

5. **Build APK (Android)**

   ```bash
   flutter build apk --release
   ```

6. **Build iOS**
   ```bash
   flutter build ios --release
   ```

---

## 📁 Struktur Proyek

```
jawara/
├── lib/
│   ├── main.dart                 # Entry point aplikasi
│   ├── models/                   # Data models
│   │   ├── product.dart
│   │   ├── transaction.dart
│   │   ├── cart_item.dart
│   │   └── user_role.dart
│   ├── pages/                    # UI Pages
│   │   ├── dashboard/           # Dashboard pages
│   │   ├── residents/           # Manajemen warga
│   │   ├── income/              # Pemasukan
│   │   ├── spending/            # Pengeluaran
│   │   ├── marketplace/         # Marketplace
│   │   ├── reports/             # Laporan
│   │   ├── channels/            # Saluran komunikasi
│   │   ├── mutations/           # Mutasi warga
│   │   └── users/               # Manajemen user
│   ├── services/                # Business logic
│   │   ├── auth_service.dart
│   │   ├── cart_service.dart
│   │   ├── notification_service.dart
│   │   └── report_service.dart
│   ├── shared/                  # Shared widgets
│   │   ├── sidebar.dart
│   │   ├── standard_app_bar.dart
│   │   └── role_guard.dart
│   └── data/                    # Data sources
│       └── products.dart
├── assets/                      # Assets (images, fonts)
├── docs/                        # Documentation
└── test/                        # Unit tests
```

---

## 🔐 Autentikasi & Role

### User Roles

1. **Admin**: Akses penuh ke semua fitur
2. **Ketua RT**: Manajemen warga dan persetujuan
3. **Bendahara**: Fokus pada keuangan
4. **Warga**: Akses terbatas (marketplace, info)

### Login Credentials (Demo)

```
Admin:
Email: admin@jawara.com
Password: admin123

Ketua RT:
Email: ketua@jawara.com
Password: ketua123

Bendahara:
Email: bendahara@jawara.com
Password: bendahara123
```

---

## 📊 Fitur Marketplace

### Alur Pembelian

1. **Browse Katalog** → Lihat produk yang tersedia
2. **Detail Produk** → Lihat informasi lengkap
3. **Tambah ke Keranjang** → Kumpulkan beberapa produk
4. **Checkout** → Pilih metode pengiriman & pembayaran
5. **Pembayaran** → Transfer/QRIS
6. **Konfirmasi** → Pesanan diproses

### Metode Pengiriman

- **Reguler**: Produk diantar oleh penjual ke alamat pembeli
- **Instan**: Pembeli mengambil langsung di lokasi penjual

### Metode Pembayaran

- **Transfer Bank**: BCA, Mandiri, BNI, BRI
- **QRIS**: Scan QR Code untuk pembayaran

---

## 📈 Fitur Laporan

### Jenis Laporan

1. **Laporan Pemasukan**

   - Filter berdasarkan periode
   - Detail per kategori
   - Export PDF

2. **Laporan Pengeluaran**

   - Tracking pengeluaran RT/RW
   - Kategorisasi
   - Export PDF

3. **Laporan Warga**
   - Statistik populasi
   - Data demografi
   - Mutasi warga

### Export & Print

- Export ke PDF dengan format profesional
- Print langsung dari aplikasi
- Share laporan via email/WhatsApp

---

## 🔧 Konfigurasi

### Notification Setup

Edit `lib/services/notification_service.dart` untuk konfigurasi notifikasi.

### Biometric Authentication

Pastikan permission sudah ditambahkan:

**Android** (`android/app/src/main/AndroidManifest.xml`):

```xml
<uses-permission android:name="android.permission.USE_BIOMETRIC"/>
```

**iOS** (`ios/Runner/Info.plist`):

```xml
<key>NSFaceIDUsageDescription</key>
<string>Gunakan Face ID untuk login</string>
```

---

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run specific test
flutter test test/widget_test.dart

# Run with coverage
flutter test --coverage
```

---

## 🐛 Troubleshooting

### Stack Overflow pada Edit Pemasukan

**Solusi**: Sudah diperbaiki dengan menyingkat nama dropdown dan menggunakan `isExpanded: true`

### Error Cart Service

**Solusi**: Sudah diperbaiki dengan try-catch pada method `getQuantity()`

### Hot Reload Tidak Update

**Solusi**:

```bash
flutter clean
flutter run
```

---

## 📝 Changelog

### Version 1.0.0 (2025-12-02)

- ✅ Implementasi manajemen warga lengkap
- ✅ Sistem keuangan (pemasukan & pengeluaran)
- ✅ Marketplace dengan keranjang belanja
- ✅ Multiple metode pembayaran
- ✅ Laporan PDF
- ✅ Dashboard dengan grafik
- ✅ Notifikasi push
- ✅ Biometric authentication
- ✅ Multi-role system

---

## 🤝 Kontribusi

Kami menerima kontribusi! Silakan:

1. Fork repository
2. Buat branch baru (`git checkout -b feature/AmazingFeature`)
3. Commit perubahan (`git commit -m 'Add some AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Buat Pull Request

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

---

## 📞 Kontak

**Politeknik Negeri Malang**

- Website: [https://polinema.ac.id](https://polinema.ac.id)
- Email: info@polinema.ac.id

**Project Link**: [https://github.com/your-repo/jawara](https://github.com/your-repo/jawara)

---

## 🙏 Acknowledgments

- [Flutter](https://flutter.dev) - UI Framework
- [Dart](https://dart.dev) - Programming Language
- [FL Chart](https://pub.dev/packages/fl_chart) - Chart Library
- [Intl](https://pub.dev/packages/intl) - Internationalization
- Politeknik Negeri Malang - Institusi Pendidikan

---

<div align="center">
  <p>Made with ❤️ by Kelompok 07</p>
  <p>© 2025 JAWARA - Politeknik Negeri Malang</p>
</div>
