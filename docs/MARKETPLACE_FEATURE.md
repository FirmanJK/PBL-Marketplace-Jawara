# Fitur Marketplace

## Deskripsi

Fitur marketplace memfasilitasi warga dalam menjual barang secara cepat dan terintegrasi dengan katalog produk.

## Struktur File

### Models

- `lib/models/product.dart` - Model data produk dengan JSON serialization

### Data Services

- `lib/data/products.dart` - Service untuk API calls (create, read, update, delete produk)
  - Mendukung pagination untuk performa optimal
  - Saat ini menggunakan dummy data, siap untuk integrasi REST API

### Pages

- `lib/pages/marketplace_page.dart` - Halaman utama dengan TabBar (Unggah & Katalog)
- `lib/pages/marketplace_upload_page.dart` - Form unggah produk baru dengan kamera
- `lib/pages/marketplace_catalog_page.dart` - Grid view katalog dengan lazy loading
- `lib/pages/marketplace_edit_page.dart` - Form edit produk existing
- `lib/pages/marketplace_detail_page.dart` - Halaman detail produk lengkap

## Fitur Utama

### 1. Unggah Produk

- Ambil foto dari kamera atau galeri
- Input: Nama Barang, Harga Jual, Deskripsi
- Upload async ke backend via REST API
- Validasi form lengkap

### 2. Katalog Produk

- Grid view responsif (2 kolom)
- Lazy loading / pagination (10 produk per load)
- Pull-to-refresh
- Mencegah stack overflow dengan loading bertahap
- Menu aksi per produk (Edit, Detail, Hapus)

### 3. Manajemen Produk

- **Edit**: Update data produk dengan form pre-filled
- **Detail**: Tampilan lengkap informasi produk
- **Hapus**: Konfirmasi sebelum delete

## Cara Penggunaan

### Navigasi ke Marketplace

#### Dari Sidebar

Menu Marketplace sudah terintegrasi di sidebar dengan 2 submenu:

- **Unggah Produk** - Langsung ke halaman upload
- **Katalog Produk** - Langsung ke halaman katalog

#### Programmatically

```dart
// Ke halaman marketplace (default: upload)
Navigator.pushNamed(context, '/marketplace');

// Langsung ke halaman upload
Navigator.pushNamed(context, '/marketplace/upload');

// Langsung ke halaman katalog
Navigator.pushNamed(context, '/marketplace/catalog');
```

#### Dropdown Navigation

Di halaman marketplace, pengguna dapat beralih antara mode Unggah dan Katalog menggunakan dropdown di AppBar (pojok kanan atas).

### Integrasi API Backend

Edit `lib/data/products.dart` dan uncomment bagian HTTP calls:

1. Ganti `baseUrl` dengan URL backend Anda
2. Uncomment kode `http.get`, `http.post`, dll
3. Tambahkan package `http` di `pubspec.yaml`

### Implementasi Kamera

Tambahkan di `pubspec.yaml`:

```yaml
dependencies:
  image_picker: ^1.0.0
```

Uncomment kode image picker di:

- `marketplace_upload_page.dart` (method `_pickImage`)
- `marketplace_edit_page.dart` (method `_pickImage`)

## Optimasi Performa

### Pagination

- Load 10 produk per request
- Trigger load saat scroll mencapai 80% dari bottom
- Flag `_hasMore` untuk stop loading jika data habis

### Lazy Loading

- Menggunakan `ScrollController` untuk detect scroll position
- Mencegah multiple simultaneous requests dengan flag `_isLoading`

### Memory Management

- Dispose controllers dan listeners di `dispose()`
- Clear list saat refresh untuk free memory

## TODO / Pengembangan Selanjutnya

1. **Image Picker**: Implementasi `image_picker` package
2. **HTTP Client**: Implementasi real REST API calls
3. **Authentication**: Ambil userId dari session login
4. **Image Caching**: Gunakan `cached_network_image` untuk performa
5. **Search & Filter**: Tambah fitur pencarian dan filter kategori
6. **User Profile**: Tampilkan info penjual di detail produk
7. **Error Handling**: Improve error messages dan retry mechanism

## Dependencies yang Dibutuhkan

Tambahkan di `pubspec.yaml`:

```yaml
dependencies:
  image_picker: ^1.0.0 # Untuk kamera/galeri
  http: ^1.1.0 # Untuk REST API calls
  cached_network_image: ^3.3.0 # Optional: untuk cache gambar
```

## Catatan Penting

- Semua file ditempatkan sesuai struktur folder existing (tidak membuat folder baru)
- Menggunakan shared components yang sudah ada (`CustomInput`, `CustomButton`)
- Konsisten dengan pattern yang digunakan di file lain (seperti `residents.dart`)
- Ready untuk production setelah integrasi API backend
