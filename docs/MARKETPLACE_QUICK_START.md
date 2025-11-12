# 🚀 Marketplace Quick Start Guide

## ✅ Status Implementasi

| Fitur                | Status    | Keterangan                                    |
| -------------------- | --------- | --------------------------------------------- |
| Model & Data Service | ✅ Done   | Product model + API service dengan pagination |
| Halaman Upload       | ✅ Done   | Form upload dengan kamera/galeri              |
| Halaman Katalog      | ✅ Done   | Grid view dengan lazy loading                 |
| Halaman Edit         | ✅ Done   | Edit produk dengan ganti foto                 |
| Halaman Detail       | ✅ Done   | Detail produk lengkap                         |
| Sidebar Menu         | ✅ Done   | Menu Marketplace terintegrasi                 |
| Dropdown Navigation  | ✅ Done   | Switch antara Upload/Katalog                  |
| Fitur Kamera         | ✅ Done   | Image picker dari kamera/galeri               |
| Android Config       | ✅ Done   | Permissions sudah ditambahkan                 |
| iOS Config           | ⚠️ Manual | Perlu update Info.plist                       |
| REST API             | 🔄 Ready  | Siap integrasi, saat ini dummy data           |

## 📱 Cara Menggunakan

### 1. Akses Marketplace

**Via Sidebar:**

1. Buka sidebar (hamburger menu)
2. Klik **Marketplace**
3. Pilih:
   - **Unggah Produk** - Upload produk baru
   - **Katalog Produk** - Lihat semua produk

**Via Dropdown:**

1. Buka halaman Marketplace
2. Gunakan dropdown di pojok kanan atas
3. Switch antara mode Upload/Katalog

### 2. Upload Produk Baru

1. Pilih **Unggah Produk**
2. Tap area "Tap untuk ambil foto"
3. Pilih sumber:
   - 📷 Ambil Foto dari Kamera
   - 🖼️ Pilih dari Galeri
4. Isi form:
   - Nama Barang (required)
   - Harga Jual (required, angka)
   - Deskripsi Barang (required)
5. Tap **Unggah Produk**
6. Produk otomatis masuk ke katalog

### 3. Lihat Katalog

1. Pilih **Katalog Produk**
2. Scroll untuk load lebih banyak (lazy loading)
3. Pull-to-refresh untuk reload
4. Tap ikon ⋮ (titik tiga) untuk aksi:
   - 👁️ Lihat Detail
   - ✏️ Edit Data
   - 🗑️ Hapus Data

### 4. Edit Produk

1. Dari katalog, tap ⋮ → **Edit Data**
2. Form akan terisi dengan data existing
3. Tap foto untuk ganti gambar
4. Edit data yang diperlukan
5. Tap **Simpan Perubahan**

### 5. Hapus Produk

1. Dari katalog, tap ⋮ → **Hapus Data**
2. Konfirmasi penghapusan
3. Produk akan dihapus dari katalog

## 🔧 Setup untuk Development

### Android (Sudah Dikonfigurasi)

✅ Permissions sudah ditambahkan di `AndroidManifest.xml`
✅ Langsung bisa dijalankan:

```bash
flutter run -d <android-device-id>
```

### iOS (Perlu Konfigurasi Manual)

⚠️ Edit `ios/Runner/Info.plist`, tambahkan:

```xml
<key>NSCameraUsageDescription</key>
<string>Aplikasi memerlukan akses kamera untuk mengambil foto produk</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>Aplikasi memerlukan akses galeri untuk memilih foto produk</string>
```

Kemudian jalankan:

```bash
cd ios
pod install
cd ..
flutter run -d <ios-device-id>
```

## 🔌 Integrasi REST API

### 1. Update Base URL

Edit `lib/data/products.dart`:

```dart
static const String baseUrl = 'https://your-api-url.com/api';
```

### 2. Uncomment HTTP Calls

Di file yang sama, uncomment bagian:

- `fetchProducts()` - GET /products
- `createProduct()` - POST /products (multipart)
- `updateProduct()` - PUT /products/:id (multipart)
- `deleteProduct()` - DELETE /products/:id
- `getProductById()` - GET /products/:id

### 3. Tambahkan HTTP Package

```yaml
dependencies:
  http: ^1.1.0
```

### 4. API Endpoints Expected

```
GET    /api/products?page=1&limit=10
POST   /api/products (multipart/form-data)
GET    /api/products/:id
PUT    /api/products/:id (multipart/form-data)
DELETE /api/products/:id
```

### 5. Request Format (POST/PUT)

```
Content-Type: multipart/form-data

Fields:
- name: string
- price: number
- description: string
- image: file
- user_id: number
```

### 6. Response Format

```json
{
  "id": 1,
  "name": "Kursi Kayu",
  "price": 500000,
  "description": "Kursi kayu jati",
  "image_url": "https://...",
  "created_at": "2024-01-01T00:00:00Z",
  "user_id": 1
}
```

## 📊 Performa & Optimasi

### Lazy Loading

- Load 10 produk per request
- Auto-load saat scroll 80% dari bottom
- Mencegah memory overflow

### Image Optimization

- Max resolution: 1920x1080
- Quality: 85%
- Auto-compress saat upload

### Caching

- Gambar di-cache otomatis oleh Flutter
- Untuk production, gunakan `cached_network_image`

## 🐛 Troubleshooting

### Kamera tidak bisa dibuka

- ✅ Test di **real device** (bukan emulator)
- ✅ Check permissions di Settings > Apps
- ✅ Uninstall & reinstall app

### Gambar tidak muncul

- ✅ Check network connection (untuk URL)
- ✅ Check file path (untuk local file)
- ✅ Check error di console

### Form tidak bisa submit

- ✅ Pastikan semua field terisi
- ✅ Pastikan gambar sudah dipilih
- ✅ Check validation error message

## 📚 Dokumentasi Lengkap

- `MARKETPLACE_FEATURE.md` - Overview fitur lengkap
- `MARKETPLACE_CHANGELOG.md` - History perubahan
- `MARKETPLACE_CAMERA_SETUP.md` - Setup kamera detail

## 🎯 Next Steps

1. Test di real device Android
2. Konfigurasi iOS (jika diperlukan)
3. Integrasi dengan backend API
4. Tambah fitur search & filter
5. Implementasi image caching
6. Tambah kategori produk
7. Tambah fitur chat dengan penjual

## 💡 Tips

- Gunakan real device untuk test kamera
- Compress gambar sebelum upload ke server
- Implementasi pagination di backend
- Tambah loading indicator untuk UX lebih baik
- Validasi file size & format di backend
