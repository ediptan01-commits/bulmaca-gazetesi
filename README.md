# Bulmaca Gazetesi — Flutter MVP

Bağımsız bir Android bulmaca oyunu. **Gazete kapağı + modern kategori seçimi**, altı oynanabilir oyun türü:

- Çengel tarzı ızgara: ipucunu seç, harfleri yerleştir, cevapları kontrol et.
- Kare bulmaca: kesişen kelimeleri doldur.
- Sudoku: sayı girme, not alma ve çözüm kontrolü.
- Kelime avı: ilk/son harfe dokunarak yatay, dikey veya çapraz kelime seç.
- Sarmal: merkez yönüne doğru ortak harfli kelimeleri doldur.
- Resimli: emoji ipuçlarına cevap ver.

İlerleme ve bazı cevaplar cihazda `shared_preferences` ile kaydedilir. **İlk sürümde tek sabit örnek gazete sayısı vardır; tarihe göre otomatik yeni gazete üretilmez.** Reklam, IAP, sunucu ve hesap sistemi yoktur. İlk Android APK, CI üzerinde debug/test anahtarıyla imzalanmış olabilir: Google Play üretimi için kendi kalıcı yükleme anahtarınızla yeniden imzalama gerekir.

## Kurulum

Flutter 3.41+ / Dart 3.11+ ve Android SDK kurulu olmalı.

```bash
flutter create --platforms=android --project-name bulmaca_gazetesi --org com.teknolojix .
flutter pub get
flutter analyze
flutter test
flutter run
flutter build apk --release
```

Repo'ya yüklediğinizde `.github/workflows/android.yml` otomatik Android APK/AAB üretir. GitHub Actions → Android APK ve AAB → Run workflow → Artifacts.

## İçerik ve geliştirme notları

Oyun soruları ve örnek ızgaralar `lib/main.dart` içinde tanımlıdır. Günlük gerçek bulmaca sayıları, daha büyük sözlük, otomatik çapraz/çengel yerleştirme algoritması ve benzersiz sudoku üretimi sonraki aşamadır. Çengel ilk sürümde ok yönlü klasik yerleşimden esinlenen bir ızgaradır; gazete standardında ipucu hücreleri ızgara içinde değildir. Emoji bulmacalarda görseller emoji ile temsil edilir.

Google Play'e yüklemeden önce paket adı, imza, uygulama ikonu, gizlilik politikası ve cihaz testlerini tamamlayın.
