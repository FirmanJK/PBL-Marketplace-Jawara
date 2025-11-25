# Changelog

## [Unreleased] - 2025-01-XX

### Changed - UI/UX Improvements

- **Mengubah semua tabel menjadi Grid View / List View** untuk pengalaman pengguna yang lebih baik dan responsif

#### Fitur yang Diubah:

1. **Data Warga dan Rumah**

   - ✅ Daftar Warga (`residents_list.dart`) - Diubah dari Grid View ke List View (lebih menarik)
   - ✅ Daftar Rumah (`houses_list.dart`) - Diubah dari tabel ke Grid View
   - ✅ Data Keluarga (`families_page.dart`) - Sudah menggunakan Grid View

2. **Pemasukan**

   - ✅ Tagihan (`income_bills.dart`) - Diubah dari tabel ke List View
   - ✅ Kategori Iuran (`income_categories.dart`) - Diubah dari tabel ke List View
   - ✅ Pemasukan Lain (`income_other_list.dart`) - Diubah dari tabel ke List View

3. **Pengeluaran**

   - ✅ Daftar Pengeluaran (`spending_list.dart`) - Diubah dari tabel ke List View

4. **Laporan Keuangan**

   - ✅ Laporan Pemasukan (`reports_income.dart`) - Diubah dari tabel ke List View
   - ✅ Laporan Pengeluaran (`reports_spending.dart`) - Diubah dari tabel ke List View

5. **Kegiatan & Broadcast**

   - ✅ Daftar Kegiatan (`activities_list.dart`) - Diubah dari tabel ke List View
   - ✅ Daftar Broadcast (`broadcast_list.dart`) - Diubah dari tabel ke List View

6. **Pesan Warga**

   - ✅ Semua Pesan (`resident_messages.dart`) - Diubah dari tabel ke List View
   - ✅ Aspirasi - Terintegrasi dalam pesan warga

7. **Penerimaan Warga**

   - ✅ Daftar Permohonan (`resident_approvals.dart`) - Diubah dari tabel ke List View

8. **Mutasi Keluarga**

   - ✅ Daftar Mutasi (`family_mutations_list.dart`) - Diubah dari tabel ke List View

9. **Log Aktivitas**

   - ✅ Daftar Log (`activity_logs_page.dart`) - Diubah dari tabel ke List View

10. **Manajemen Pengguna**

    - ✅ Daftar Pengguna (`user_management.dart`) - Diubah dari tabel ke List View

11. **Channel Transfer**
    - ✅ Daftar Channel (`channels_list.dart`) - Diubah dari tabel ke List View

### Keuntungan Perubahan:

- ✨ Tampilan lebih modern dan menarik
- 📱 Lebih responsif di berbagai ukuran layar
- 🎨 Konsistensi desain di seluruh aplikasi
- 🔍 Fitur pencarian terintegrasi di setiap halaman
- ➕ Floating Action Button untuk aksi tambah data
- 🎯 Interaksi yang lebih intuitif dengan card-based design
- 🏷️ Status chip yang lebih jelas dan mudah dibaca
- 🔄 Pull-to-refresh untuk memuat ulang data

### Technical Details:

- Menggunakan `StandardAppBar` untuk konsistensi header
- Menggunakan `ResponsiveGridView` untuk daftar warga dan rumah
- Menggunakan `ListView.builder` dengan Card untuk data list
- Menghapus dependency pada `CustomDataTable`
- Menambahkan search bar di setiap halaman list
- Menambahkan floating action button untuk aksi tambah
