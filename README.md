# Bulmaca Gazetesi — Sayı 002

Bağımsız bir Android bulmaca oyunu. **Gazete kapağı + modern kategori seçimi**, altı oynanabilir oyun türü:

- Çengel: 11×11 ızgarada, soru hücreleri ve yön oklarıyla 21 ipucu.
- Kare: 11×11 bağlı ızgarada, numaralandırılmış yatay/dikey 22 ipucu.
- Sudoku: sayı girme, not alma ve çözüm kontrolü.
- Kelime avı: 12×12 alanda sekiz yöne saklanmış 12 sözcük; uçlara dokunma veya sürükleyerek seçim.
- Sarmal: 13 soruluk doğru kelime zinciriyle dolan 7×7 / 49 kutuluk sayfa.
- Resimli: emoji ipuçlarına cevap ver.

İlerleme ve cevaplar cihazda `shared_preferences` ile kaydedilir. **Tek bir sabit gazete sayısı vardır; tarihe göre otomatik yeni içerik üretilmez.** Yeni içerikli dört bulmaca eski örneklerin kayıtlarını kullanmaz; sudoku ve resimli bulmaca kayıtları korunur. Reklam, IAP, sunucu ve hesap sistemi yoktur. Android APK, CI üzerinde debug/test anahtarıyla imzalanabilir; Google Play üretimi kendi kalıcı yükleme anahtarınızı gerektirir.

Kare ve sarmal ekranlarında klavye sabittir. Seçili soru klavyenin üzerinde gösterilir. Karede kesişime tekrar dokunmak yönü değiştirir. Çengel/kare ızgarasını iki parmakla büyütüp kaydırabilirsiniz; çengelde soru hücresine dokunmak ipucunu tam boy gösterir. Kontrol düğmesi hatalı harfleri işaretler, cevapları açıklamaz.

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

Repo'ya yüklediğinizde `.github/workflows/android.yaml` otomatik analiz, test ve Android APK/AAB üretimini çalıştırır. GitHub Actions → Android APK ve AAB → Artifacts.

## İçerik ve geliştirme notları

Bulmaca verileri `lib/newspaper.dart`, gazete oyun ekranları `lib/newspaper_ui.dart`, ana sayfa/sudoku/resimli oyun `lib/main.dart` içindedir. Yerleşim testleri her kesişmenin tutarlılığını, ipucusuz harf dizisi olmadığını, çengel sorularının harflerle çakışmadığını, kelime avının sekiz yönünü ve sarmalın 49 kutusunu doğrular. Etkileşim testleri kayıtları, seçimleri, tamamlanmayı ve 320 piksel genişlikte büyük metinle altı ekranı denetler. Resimli sorularda görseller emoji ile temsil edilir.

Google Play'e yüklemeden önce paket adı, imza, uygulama ikonu, gizlilik politikası ve cihaz testlerini tamamlayın.
