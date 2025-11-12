# Profile Menu di Marketplace

## ✅ Fitur yang Diimplementasikan

### 1. Profile Icon di AppBar

- Icon profil berbentuk lingkaran dengan background biru
- Posisi di pojok kanan atas AppBar
- Icon person berwarna putih

### 2. Bottom Sheet Menu

Ketika icon profil diklik, muncul bottom sheet dengan 3 opsi:

#### 👤 Profil

- Icon: person_outline
- Warna: Biru (#0891B2)
- Aksi: Navigate ke halaman `/profile`

#### ⚙️ Pengaturan

- Icon: settings_outlined
- Warna: Biru (#0891B2)
- Aksi: Navigate ke halaman `/settings`

#### 🚪 Keluar

- Icon: logout_rounded
- Warna: Merah
- Aksi: Tampilkan dialog konfirmasi logout

### 3. Logout Confirmation Dialog

- Title: "Konfirmasi Keluar"
- Message: "Apakah Anda yakin ingin keluar dari aplikasi?"
- Actions:
  - **Batal** - Tutup dialog
  - **Keluar** - Logout dan kembali ke halaman login

## 🎨 Design Specifications

### Profile Icon Button

```dart
Container(
  padding: EdgeInsets.all(8),
  decoration: BoxDecoration(
    color: Color(0xFF0891B2),  // Biru
    shape: BoxShape.circle,
  ),
  child: Icon(
    Icons.person,
    color: Colors.white,
    size: 20,
  ),
)
```

### Menu Item Style

```dart
ListTile(
  leading: Container(
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Color(0xFF0891B2).withOpacity(0.1),  // Background transparan
      borderRadius: BorderRadius.circular(12),
    ),
    child: Icon(
      Icons.person_outline,
      color: Color(0xFF0891B2),
      size: 24,
    ),
  ),
  title: Text(
    'Profil',
    style: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
    ),
  ),
)
```

### Logout Item Style (Red)

```dart
ListTile(
  leading: Container(
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.red.withOpacity(0.1),  // Background merah transparan
      borderRadius: BorderRadius.circular(12),
    ),
    child: Icon(
      Icons.logout_rounded,
      color: Colors.red,
      size: 24,
    ),
  ),
  title: Text(
    'Keluar',
    style: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: Colors.red,
    ),
  ),
)
```

## 📱 User Flow

### Flow 1: Akses Profil

```
1. User tap icon profil di AppBar
2. Bottom sheet muncul dari bawah
3. User tap "Profil"
4. Navigate ke halaman profil
5. Bottom sheet tertutup otomatis
```

### Flow 2: Akses Pengaturan

```
1. User tap icon profil di AppBar
2. Bottom sheet muncul dari bawah
3. User tap "Pengaturan"
4. Navigate ke halaman pengaturan
5. Bottom sheet tertutup otomatis
```

### Flow 3: Logout

```
1. User tap icon profil di AppBar
2. Bottom sheet muncul dari bawah
3. User tap "Keluar"
4. Bottom sheet tertutup
5. Dialog konfirmasi muncul
6. User tap "Keluar" di dialog
7. Navigate ke halaman login
8. Clear navigation stack (tidak bisa back)
```

### Flow 4: Batal Logout

```
1. User tap icon profil di AppBar
2. Bottom sheet muncul dari bawah
3. User tap "Keluar"
4. Bottom sheet tertutup
5. Dialog konfirmasi muncul
6. User tap "Batal"
7. Dialog tertutup
8. User tetap di halaman marketplace
```

## 🔧 Konfigurasi

### Routes yang Diperlukan

Pastikan routes berikut sudah terdaftar di `main.dart`:

```dart
routes: {
  '/profile': (context) => const ProfilePage(),
  '/settings': (context) => const SettingsPage(),
  '/login': (context) => const LoginPage(),
  // ... other routes
}
```

### Navigation Stack Management

Saat logout, menggunakan `pushNamedAndRemoveUntil` untuk:

- Navigate ke login page
- Clear semua navigation stack
- User tidak bisa back ke halaman sebelumnya

```dart
Navigator.pushNamedAndRemoveUntil(
  context,
  '/login',
  (route) => false,  // Remove all routes
);
```

## 🎯 Customization

### Mengubah Warna Icon

Edit di `marketplace_page.dart`:

```dart
// Ubah warna background icon
decoration: BoxDecoration(
  color: const Color(0xFF0891B2),  // Ganti warna ini
  shape: BoxShape.circle,
),

// Ubah warna icon
child: const Icon(
  Icons.person,
  color: Colors.white,  // Ganti warna ini
  size: 20,
),
```

### Menambah Menu Item

Tambahkan ListTile baru di bottom sheet:

```dart
ListTile(
  leading: Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: const Color(0xFF0891B2).withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
    ),
    child: const Icon(
      Icons.help_outline,  // Icon baru
      color: Color(0xFF0891B2),
      size: 24,
    ),
  ),
  title: const Text(
    'Bantuan',  // Label baru
    style: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
    ),
  ),
  onTap: () {
    Navigator.pop(context);
    Navigator.pushNamed(context, '/help');  // Route baru
  },
),
```

### Mengubah Logout Confirmation

Edit di method `_showLogoutConfirmation`:

```dart
AlertDialog(
  title: const Text('Konfirmasi Keluar'),  // Ubah title
  content: const Text('Apakah Anda yakin?'),  // Ubah message
  // ... actions
)
```

## 🧪 Testing

### Test Profile Menu

1. ✅ Tap icon profil → Bottom sheet muncul
2. ✅ Tap "Profil" → Navigate ke profile page
3. ✅ Back dari profile → Kembali ke marketplace
4. ✅ Tap icon profil lagi → Bottom sheet muncul lagi

### Test Settings Menu

1. ✅ Tap icon profil → Bottom sheet muncul
2. ✅ Tap "Pengaturan" → Navigate ke settings page
3. ✅ Back dari settings → Kembali ke marketplace

### Test Logout Flow

1. ✅ Tap icon profil → Bottom sheet muncul
2. ✅ Tap "Keluar" → Dialog konfirmasi muncul
3. ✅ Tap "Batal" → Dialog tertutup, tetap di marketplace
4. ✅ Tap icon profil → Tap "Keluar" lagi
5. ✅ Tap "Keluar" di dialog → Navigate ke login
6. ✅ Coba back button → Tidak bisa kembali (stack cleared)

### Test UI/UX

1. ✅ Icon profil terlihat jelas di AppBar
2. ✅ Bottom sheet muncul smooth dari bawah
3. ✅ Menu items memiliki spacing yang baik
4. ✅ Icons dan text aligned dengan baik
5. ✅ Warna konsisten dengan theme app
6. ✅ Logout item berwarna merah (destructive action)

## 💡 Best Practices

### 1. Confirmation untuk Destructive Actions

Selalu tampilkan konfirmasi untuk aksi yang tidak bisa di-undo seperti logout.

### 2. Clear Navigation Stack

Saat logout, clear navigation stack agar user tidak bisa back ke halaman yang memerlukan authentication.

### 3. Visual Hierarchy

- Menu normal: Warna biru (primary color)
- Menu destructive: Warna merah (danger color)

### 4. Accessibility

- Gunakan tooltip untuk icon button
- Text yang jelas dan deskriptif
- Icon yang mudah dipahami

### 5. Consistent Design

- Ikuti design system yang sama dengan halaman lain
- Gunakan warna dan spacing yang konsisten
- Border radius dan padding yang seragam

## 📊 Analytics (Optional)

Untuk tracking user behavior, tambahkan analytics:

```dart
// Saat profile menu dibuka
Analytics.logEvent('profile_menu_opened');

// Saat menu item diklik
Analytics.logEvent('profile_menu_item_clicked', {
  'item': 'profile',  // atau 'settings', 'logout'
});

// Saat logout confirmed
Analytics.logEvent('user_logged_out');
```

## 🔐 Security Notes

### Session Management

Saat logout, pastikan untuk:

1. Clear user session/token
2. Clear cached data (jika ada)
3. Reset app state
4. Navigate ke login page

```dart
// Contoh logout logic
Future<void> _performLogout() async {
  // Clear session
  await SessionManager.clearSession();

  // Clear cache
  await CacheManager.clearCache();

  // Navigate to login
  Navigator.pushNamedAndRemoveUntil(
    context,
    '/login',
    (route) => false,
  );
}
```

## 🎨 Screenshots

### AppBar dengan Profile Icon

```
┌─────────────────────────────────────┐
│ ☰  Marketplace Warga    [📷▼] [👤] │
└─────────────────────────────────────┘
```

### Bottom Sheet Menu

```
┌─────────────────────────────────────┐
│                                     │
│  👤  Profil                         │
│  ─────────────────────────────────  │
│  ⚙️  Pengaturan                     │
│  ─────────────────────────────────  │
│  🚪  Keluar                         │
│                                     │
└─────────────────────────────────────┘
```

### Logout Confirmation Dialog

```
┌─────────────────────────────────────┐
│  Konfirmasi Keluar                  │
│                                     │
│  Apakah Anda yakin ingin keluar     │
│  dari aplikasi?                     │
│                                     │
│              [Batal]  [Keluar]      │
└─────────────────────────────────────┘
```
