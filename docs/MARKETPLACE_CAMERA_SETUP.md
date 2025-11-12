# Setup Kamera untuk Marketplace

## ✅ Package Installed

Package `image_picker: ^1.0.7` sudah ditambahkan dan diinstall.

## 📱 Konfigurasi Platform

### Android Configuration

#### 1. Update `android/app/src/main/AndroidManifest.xml`

Tambahkan permission berikut di dalam tag `<manifest>`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Permission untuk kamera -->
    <uses-permission android:name="android.permission.CAMERA" />

    <!-- Permission untuk akses storage (Android 12 ke bawah) -->
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
                     android:maxSdkVersion="32" />

    <!-- Permission untuk akses media (Android 13+) -->
    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />

    <!-- Deklarasi fitur kamera (optional) -->
    <uses-feature android:name="android.hardware.camera" android:required="false" />
    <uses-feature android:name="android.hardware.camera.autofocus" android:required="false" />

    <application>
        <!-- ... existing code ... -->
    </application>
</manifest>
```

#### 2. Update `android/app/build.gradle`

Pastikan minSdkVersion minimal 21:

```gradle
android {
    defaultConfig {
        minSdkVersion 21  // Minimal SDK 21
        targetSdkVersion flutter.targetSdkVersion
    }
}
```

### iOS Configuration

#### 1. Update `ios/Runner/Info.plist`

Tambahkan permission description:

```xml
<dict>
    <!-- ... existing keys ... -->

    <!-- Permission untuk kamera -->
    <key>NSCameraUsageDescription</key>
    <string>Aplikasi memerlukan akses kamera untuk mengambil foto produk</string>

    <!-- Permission untuk photo library -->
    <key>NSPhotoLibraryUsageDescription</key>
    <string>Aplikasi memerlukan akses galeri untuk memilih foto produk</string>

    <!-- Permission untuk save photo (optional) -->
    <key>NSPhotoLibraryAddUsageDescription</key>
    <string>Aplikasi memerlukan akses untuk menyimpan foto</string>
</dict>
```

#### 2. Update `ios/Podfile`

Pastikan platform minimal iOS 12:

```ruby
platform :ios, '12.0'
```

## 🎯 Fitur yang Sudah Diimplementasikan

### 1. Upload Page (`marketplace_upload_page.dart`)

✅ Bottom sheet untuk memilih sumber gambar (Kamera/Galeri)
✅ Image picker dengan konfigurasi optimal:

- Max width: 1920px
- Max height: 1080px
- Image quality: 85%
  ✅ Preview gambar yang dipilih
  ✅ Error handling

### 2. Edit Page (`marketplace_edit_page.dart`)

✅ Bottom sheet untuk memilih sumber gambar
✅ Image picker dengan konfigurasi yang sama
✅ Preview gambar baru atau gambar existing
✅ Error handling

## 🚀 Cara Menggunakan

### Untuk User

1. Buka halaman Unggah Produk
2. Tap pada area "Tap untuk ambil foto"
3. Pilih sumber:
   - **Ambil Foto dari Kamera** - Buka kamera langsung
   - **Pilih dari Galeri** - Buka galeri foto
   - **Batal** - Tutup dialog
4. Ambil/pilih foto
5. Foto akan muncul di preview
6. Isi form dan submit

### Untuk Developer

```dart
// Image picker sudah terintegrasi
// Tidak perlu konfigurasi tambahan di code

// Contoh penggunaan manual (jika diperlukan):
final ImagePicker picker = ImagePicker();
final XFile? image = await picker.pickImage(
  source: ImageSource.camera,  // atau ImageSource.gallery
  maxWidth: 1920,
  maxHeight: 1080,
  imageQuality: 85,
);
```

## 🔧 Testing

### Test di Android

```bash
flutter run -d <android-device-id>
```

### Test di iOS

```bash
flutter run -d <ios-device-id>
```

### Test Permission

1. Buka app
2. Tap area kamera
3. Pilih "Ambil Foto dari Kamera"
4. Sistem akan meminta permission
5. Allow permission
6. Kamera akan terbuka

## ⚠️ Troubleshooting

### Android

**Error: Permission Denied**

- Pastikan permission sudah ditambahkan di AndroidManifest.xml
- Uninstall app dan install ulang
- Check Settings > Apps > [App Name] > Permissions

**Error: Camera not available**

- Test di real device (bukan emulator)
- Pastikan device memiliki kamera

### iOS

**Error: This app has crashed because it attempted to access privacy-sensitive data**

- Pastikan NSCameraUsageDescription sudah ditambahkan di Info.plist
- Clean build: `flutter clean && flutter pub get`
- Rebuild app

**Error: Photo library permission denied**

- Check Info.plist untuk NSPhotoLibraryUsageDescription
- Reset permissions: Settings > General > Reset > Reset Location & Privacy

## 📝 Notes

- Image picker akan otomatis compress gambar sesuai konfigurasi
- Gambar disimpan temporary di cache device
- Untuk production, upload ke server/cloud storage
- Pertimbangkan menambahkan image cropping library jika diperlukan

## 🔗 Resources

- [image_picker package](https://pub.dev/packages/image_picker)
- [Android Permissions Guide](https://developer.android.com/training/permissions/requesting)
- [iOS Privacy Permissions](https://developer.apple.com/documentation/uikit/protecting_the_user_s_privacy)
