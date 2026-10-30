# Bulmaca Gazetesi — Sayı 003 / 1.2.0

Bağımsız bir Android bulmaca oyunu. **Gazete kapağı + modern kategori seçimi**, altı oynanabilir oyun türü:

- Çengel: 8×8 alanda 22 soru; 41 harf, 20 soru hücresi ve yalnızca 3 siyah kutu. Başlangıçta 62 piksel hücrelerle büyük görünür; sürükleme, büyütme/küçültme ve tümünü gösterme düğmeleri vardır.
- Kare: 7×7 bağlı ızgarada 22 soru; 41 harf ve 8 siyah kutu. Tüm harfler yatay ve dikey iki cevabın kesişimindedir.
- Sudoku: sayı girme, not alma ve çözüm kontrolü.
- Kelime avı: 12×12 alanda sekiz yöne saklanmış 12 sözcük; parmakla karalama sırasında canlı kalem izi, doğru cevapta kalıcı işaret. Karalamalar da cihazda saklanır.
- Dairesel sarmal: dıştan içe 24, 16, 8 ve 1 dilimli halkalarda 13 soruluk / 49 harflik zincir. Halka geçişleri oklarla gösterilir.
- Resimli: emoji ipuçlarına cevap ver.

İlerleme ve cevaplar cihazda `shared_preferences` ile kaydedilir. **Tek bir sabit gazete sayısı vardır; tarihe göre otomatik yeni içerik üretilmez.** Yeni içerikli dört bulmaca eski örneklerin kayıtlarını kullanmaz; sudoku ve resimli bulmaca kayıtları korunur. Reklam, IAP, sunucu ve hesap sistemi yoktur. Android APK, CI üzerinde debug/test anahtarıyla imzalanabilir; Google Play üretimi kendi kalıcı yükleme anahtarınızı gerektirir.

Kare, çengel ve sarmalda üç sıralı Türkçe Q klavye sabittir (QWERTYUIOPĞÜ / ASDFGHJKLŞİ / ZXCVBNMÖÇ). Seçili soru klavyenin üzerinde gösterilir. Karede kesişime tekrar dokunmak yönü değiştirir. Çengel/kare ızgarasını iki parmakla büyütüp kaydırabilirsiniz; çengelde soru hücresine dokunmak ipucunu tam boy gösterir. Yazarken görünür alan seçili harfi takip eder. Kontrol düğmesi hatalı harfleri işaretler, cevapları açıklamaz.

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

Bulmaca verileri `lib/newspaper.dart`, kare/çengel/sarmal ekranları `lib/newspaper_ui.dart`, dairesel ızgara/klavye/kalem çizimi `lib/newspaper_components.dart`, karalamalı kelime avı `lib/search_game.dart` ve ana sayfa/sudoku/resimli oyun `lib/main.dart` içindedir. Testler kesişimleri, azami siyah kutu oranını, dairesel dilimlerin seçimini, Türkçe Q sırasını, canlı/kalıcı karalamayı, kayıtları ve 320 piksel genişlikte altı ekranı denetler. Bu sayıda kare/çengel değiştiğinden yalnızca onların eski cevapları yeni içerikle karıştırılmaz; diğer dört oyunun ilerlemesi korunur. Resimli sorularda görseller emoji ile temsil edilir.

Google Play'e yüklemeden önce paket adı, imza, uygulama ikonu, gizlilik politikası ve cihaz testlerini tamamlayın.
