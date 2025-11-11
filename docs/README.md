# 📁 Dokumentasi PBL Jawara

Folder ini berisi dokumentasi dan media untuk project PBL Jawara.

## 📂 Struktur Folder

```
docs/
├── MEDIA_GUIDE.md           # Panduan upload video & screenshots
├── screenshots/             # Folder untuk screenshots aplikasi
│   └── .gitkeep
└── videos/                  # Folder untuk video demo
    └── .gitkeep
```

## 📸 Screenshots

Simpan screenshot aplikasi Anda di folder `screenshots/`:
- `dashboard-keuangan.png` - Screenshot dashboard keuangan
- `data-warga.png` - Screenshot halaman data warga
- `laporan.png` - Screenshot laporan
- Dan lainnya...

**Format yang disarankan:**
- Format: PNG atau JPG
- Ukuran: Max 1MB per file
- Resolusi: 1920x1080 atau 1280x720

## 📹 Videos

Simpan video demo di folder `videos/`:
- `demo.mp4` - Video demo aplikasi
- `tutorial.mp4` - Video tutorial (optional)

**Format yang disarankan:**
- Format: MP4 (H.264 codec)
- Durasi: 30-90 detik untuk demo pendek
- Resolusi: 1280x720 (HD) atau 1920x1080 (Full HD)
- Ukuran: < 10MB untuk GitHub, > 10MB gunakan Git LFS

## 📖 Panduan Lengkap

Baca [MEDIA_GUIDE.md](MEDIA_GUIDE.md) untuk panduan lengkap tentang:
- Cara upload video lokal ke GitHub
- Convert video ke GIF
- Setup Git LFS untuk file besar
- Best practices untuk screenshots & video
- Troubleshooting

## 🚀 Quick Start

### Menambahkan Screenshot:

1. Ambil screenshot aplikasi
2. Simpan ke `docs/screenshots/nama-file.png`
3. Update README.md dengan path file
4. Commit & push:
   ```bash
   git add docs/screenshots/
   git commit -m "📸 Add: screenshots"
   git push
   ```

### Menambahkan Video (< 10MB):

**Cara 1: Drag & Drop di GitHub (Termudah)**
1. Buka README.md di GitHub
2. Klik Edit
3. Drag video ke editor
4. GitHub auto-generate link
5. Save

**Cara 2: Simpan di Repo**
1. Copy video ke `docs/videos/demo.mp4`
2. Commit & push:
   ```bash
   git add docs/videos/demo.mp4
   git commit -m "📹 Add: demo video"
   git push
   ```

### Menambahkan Video (> 10MB):

1. Install Git LFS:
   ```bash
   git lfs install
   ```

2. Track & commit:
   ```bash
   git add docs/videos/demo.mp4
   git commit -m "📹 Add: demo video with LFS"
   git push
   ```

## 💡 Tips

- **Untuk README:** Gunakan GIF (auto-play) + link ke full video
- **File Size:** Compress jika terlalu besar
- **Quality:** Balance antara quality & file size
- **Content:** Tunjukkan fitur utama aplikasi

## 🔗 Resources

- [MEDIA_GUIDE.md](MEDIA_GUIDE.md) - Panduan lengkap
- [Git LFS](https://git-lfs.github.com/) - Large File Storage
- [ezgif.com](https://ezgif.com/) - Convert video to GIF
- [HandBrake](https://handbrake.fr/) - Video compression

---

**Need help?** Baca [MEDIA_GUIDE.md](MEDIA_GUIDE.md) atau buat issue di GitHub.
