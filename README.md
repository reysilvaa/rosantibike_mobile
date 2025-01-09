# 🏍️ RosantiBike Mobile App

RosantiBike adalah aplikasi mobile yang dikembangkan menggunakan Flutter untuk pengalaman pengelolaan yang lebih mudah dan dapat diakses dimana saja. Proyek ini dirancang untuk membantu dalam hal kemudahan akses kelola, mencatat aktivitas.

---

## 📋 Persyaratan
Sebelum memulai, pastikan Anda telah menginstal:

- [Android Studio](https://developer.android.com/studio) (termasuk SDK Android)
- [Flutter](https://flutter.dev/docs/get-started/install)
- Editor teks favorit Anda (contoh: Visual Studio Code)
- Git untuk mengelola kontrol versi

---

## 🚀 Langkah Instalasi

Ikuti langkah-langkah di bawah ini untuk menjalankan aplikasi:

1. Clone repository ini:
   ```bash
   git clone https://github.com/reysilvaa/rosantibike_mobile.git
   ```

2. Masuk ke folder proyek:
   ```bash
   cd rosantibike_mobile
   ```

3. Jalankan perintah berikut untuk mengunduh dependensi:
   ```bash
   flutter pub get
   ```

4. Jalankan aplikasi:
   ```bash
   flutter run
   ```

   Pastikan emulator atau perangkat Anda sudah terhubung dan diatur dengan benar.

---

## 📂 Struktur Proyek

```
rosantibike_mobile/
├── lib/
│   ├── main.dart                     # File utama untuk aplikasi
│   ├── bottom_navigation_widget.dart # File untuk bottom navigation
│   ├── screens/                      # Semua layar aplikasi
│   ├── pages/                        # Semua halaman aplikasi
│   ├── api/                          # Integrasi API
│   ├── blocs/                        # State Management
│   ├── constant/                     # Transisi halaman dan UI yang tidak akan berubah
│   ├── services/                     # Layanan notifidkasi dengan Firebase
│   ├── widgets/                      # Komponen UI yang dapat digunakan kembali
│   ├── models/                       # Model data
│   ├── theme/                        # Provider tema dark dan light mode
│   └── services/                     # Layanan dan logika bisnis
├── pubspec.yaml                      # File konfigurasi dependensi
└── README.md                         # Dokumentasi proyek
```

---

## 🛠️ Teknologi yang Digunakan

- **Flutter**: Framework untuk pengembangan aplikasi lintas platform
- **Dart**: Bahasa pemrograman untuk Flutter
- **Firebase**: Backend untuk notifikasi dan pengiriman notifikasi 
- **Laravel API**: API untuk mengambil data dan penyimpanan data 

---

## 💡 Fitur Utama

- Pencatatan data rental
- Real-Time notifikasi
- Intregrasi API menggunakan Laravel
- UI yang friendly

---

## 📸 Tangkapan Layar

**Beranda:**
_(Tambahkan tangkapan layar aplikasi di sini)_

---

## 🤝 Kontribusi
Kami menyambut kontribusi untuk meningkatkan aplikasi ini! Berikut langkah-langkah untuk berkontribusi:

1. Fork repository ini.
2. Buat branch untuk fitur baru:
   ```bash
   git checkout -b fitur-baru
   ```
3. Commit perubahan Anda:
   ```bash
   git commit -m "Menambahkan fitur baru"
   ```
4. Push ke branch Anda:
   ```bash
   git push origin fitur-baru
   ```
5. Ajukan pull request.

---

## 📧 Kontak

Jika Anda memiliki pertanyaan atau saran, silakan hubungi:
- **Nama**: Reynald Silva
- **Email**: reynaldsilva123@gmail.com
- **GitHub**: [reysilvaa](https://github.com/reysilvaa)

---

## 📜 Lisensi
Proyek ini dilisensikan di bawah [MIT License](LICENSE).

---

### Selamat Mencoba 🏍️!

