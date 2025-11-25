# Konfigurasi API untuk Flutter

## Mengubah Base URL API

Edit file: `lib/services/api_service.dart`

### Untuk Android Emulator

```dart
static const String baseUrl = 'http://10.0.2.2:3000/api';
```

### Untuk iOS Simulator

```dart
static const String baseUrl = 'http://localhost:3000/api';
```

### Untuk Physical Device (Android/iOS)

1. **Cari IP Address komputer Anda:**

**Windows:**

```bash
ipconfig
# Cari "IPv4 Address", contoh: 192.168.1.100
```

**Mac/Linux:**

```bash
ifconfig
# Atau
ip addr show
```

2. **Update baseUrl:**

```dart
static const String baseUrl = 'http://192.168.1.100:3000/api';
```

**PENTING:** Ganti `192.168.1.100` dengan IP address komputer Anda!

### Untuk Production

```dart
static const String baseUrl = 'https://your-domain.com/api';
```

## Testing Koneksi

Setelah mengubah baseUrl, test dengan:

1. Jalankan backend: `cd jawara-backend && npm start`
2. Buka browser di HP/Emulator
3. Akses: `http://YOUR_IP:3000/health`
4. Jika berhasil, akan muncul: `{"status":"OK",...}`

## Troubleshooting

### Error: Connection refused

- Pastikan backend sudah running
- Pastikan HP dan komputer dalam jaringan yang sama (WiFi)
- Cek firewall Windows (allow port 3000)

### Error: Timeout

- Cek IP address sudah benar
- Ping IP dari HP untuk test koneksi
- Pastikan tidak ada VPN yang aktif

### Error: SSL/Certificate

- Untuk development, gunakan HTTP (bukan HTTPS)
- Untuk production, gunakan HTTPS dengan SSL certificate
