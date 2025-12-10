# Changelog

All notable changes to the JAWARA project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-12-02

### Added

- ✨ Implementasi lengkap manajemen data warga
- ✨ Sistem manajemen keluarga dan rumah
- ✨ Fitur mutasi warga (masuk/keluar)
- ✨ Sistem persetujuan warga baru
- ✨ Manajemen keuangan (pemasukan & pengeluaran)
- ✨ Marketplace warga dengan fitur lengkap
- ✨ Keranjang belanja untuk multiple items
- ✨ Multiple metode pengiriman (Reguler & Instan)
- ✨ Multiple metode pembayaran (Transfer Bank & QRIS)
- ✨ Halaman pembayaran dengan instruksi lengkap
- ✨ Dashboard aktivitas, keuangan, dan populasi
- ✨ Grafik dan visualisasi data dengan fl_chart
- ✨ Laporan PDF untuk pemasukan dan pengeluaran
- ✨ Fitur cetak laporan
- ✨ Saluran komunikasi untuk broadcast informasi
- ✨ Sistem notifikasi push
- ✨ Autentikasi biometric (fingerprint/face ID)
- ✨ Multi-role system (Admin, Ketua RT, Bendahara, Warga)
- ✨ Manajemen user dan role

### Fixed

- 🐛 Stack overflow pada edit pemasukan (dropdown)
- 🐛 RenderFlex overflow pada jenis pemasukan
- 🐛 Error pada cart service method getQuantity()
- 🐛 Unused imports di marketplace pages
- 🐛 Dialog edit pemasukan tidak konsisten

### Changed

- 🔄 Edit pemasukan menggunakan dialog (bukan halaman baru)
- 🔄 Nama jenis pemasukan disingkat untuk menghindari overflow
- 🔄 Katalog produk: klik langsung ke detail (tanpa dropdown)
- 🔄 Detail produk: menu edit/hapus di dropdown
- 🔄 Halaman pembayaran dengan tampilan lebih informatif

### Improved

- ⚡ Performa cart service dengan try-catch
- ⚡ Layout dialog edit dengan constraints yang tepat
- ⚡ Dropdown dengan isExpanded untuk menghindari overflow
- ⚡ Navigasi marketplace lebih intuitif

## [0.9.0] - 2025-11-30

### Added

- Initial project setup
- Basic authentication system
- Dashboard skeleton
- Data models

### In Progress

- Marketplace features
- Report generation
- Notification system

---

## Upcoming Features

### [1.1.0] - Planned

- [ ] Chat antar warga
- [ ] Voting online untuk keputusan RT
- [ ] Jadwal kegiatan RT/RW
- [ ] Absensi kegiatan
- [ ] Integrasi payment gateway
- [ ] Dark mode
- [ ] Multi-language support

### [1.2.0] - Planned

- [ ] Backup & restore data
- [ ] Export data ke Excel
- [ ] Statistik lanjutan
- [ ] Mobile app optimization
- [ ] Offline mode

---

## Bug Fixes History

### Critical Fixes

- **Stack Overflow**: Fixed dropdown overflow dengan menyingkat text dan menggunakan isExpanded
- **Cart Service**: Fixed getQuantity() error dengan try-catch
- **Navigation**: Fixed marketplace navigation flow

### Minor Fixes

- Removed unused imports
- Fixed deprecated warnings
- Improved error handling

---

## Contributors

- Ahmad Dzul Fadhli Hannan (2341720123)
- Gilang Purnomo (2341720042)
- Mochammad Firmandika Jati Kusuma (2341720229)
- Raffi Abiyyu Airlangga (2341720115)

---

For more details, see the [README.md](README.md)
