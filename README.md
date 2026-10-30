# Bulmaca Gazetesi — Sayı 003 / 1.3.0

Bağımsız bir Android bulmaca oyunu. **Gazete kapağı + modern kategori seçimi**, altı oynanabilir oyun türü:

- Çengel: 8×8 alanda 22 soru; 41 harf, 20 soru hücresi ve yalnızca 3 siyah kutu. Üst başlık ve açıklamalar kaldırıldı. Izgara ekran genişliğine oturur; yazarken, silerken veya soru değiştirirken görünüm kendiliğinden büyümez ya da kaymaz. Büyütme yalnızca kullanıcının kontrolündedir.
- Kare: 7×7 bağlı ızgarada 22 soru; 41 harf ve 8 siyah kutu. Tüm harfler yatay ve dikey iki cevabın kesişimindedir.
- Sudoku: sayı girme, not alma ve çözüm kontrolü.
- Kelime avı: 12×12 alanda sekiz yöne saklanmış 8 sözcük. Canlı ve kalıcı çizgiler harf merkezlerine ve en yakın yatay/dikey/çapraz yöne oturur; eski eğri kayıtlar da düz gösterilir.
- Dairesel sarmal: dıştan içe 24, 16, 8 ve 1 dilimli halkalarda 13 soruluk / 49 harflik zincir. Halka geçişleri oklarla gösterilir.
- Resimli Şifre: özgün çizimli park sahnesinde altı numaralı nesneyi çöz, çerçeveli harflerden GAZETE şifresini aç. Cevap kutuları, ipuçları, Q klavye ve kayıt desteği vardır; eski emoji soruları kaldırıldı.

İlerleme ve cevaplar cihazda `shared_preferences` ile kaydedilir. **Tek bir sabit gazete sayısı vardır; tarihe göre otomatik yeni içerik üretilmez.** Yeni içerikli dört bulmaca eski örneklerin kayıtlarını kullanmaz; sudoku ve resimli bulmaca kayıtları korunur. Reklam, IAP, sunucu ve hesap sistemi yoktur. Android APK, CI üzerinde debug/test anahtarıyla imzalanabilir; Google Play üretimi kendi kalıcı yükleme anahtarınızı gerektirir.

Kare, çengel, sarmal ve resimli oyunda üç sıralı Türkçe Q klavye sabittir (QWERTYUIOPĞÜ / ASDFGHJKLŞİ / ZXCVBNMÖÇ). Karede gazete düzenine uygun numaralı ızgara, altında iki sütunda soldan sağa/yukarıdan aşağıya ipuçları ve klavye üzerinde etkin soru vardır. Kesişime tekrar dokunmak yönü değiştirir. Çengel/kare ızgarasını kullanıcı isteğiyle büyütüp kaydırabilirsiniz; soru ya da harf değişimi görüntüyü değiştirmez.

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

Bulmaca verileri `lib/newspaper.dart`, kare/çengel/sarmal ekranları `lib/newspaper_ui.dart`, ortak çizimler/klavye `lib/newspaper_components.dart`, kelime avı `lib/search_game.dart`, resimli şifre `lib/picture_game.dart` ve ana sayfa/sudoku `lib/main.dart` içindedir. Testler kesişimleri, 8 yönü, yakınlaştırmanın sabitliğini, düz karalamayı, altı nesneden şifre çözümünü, kayıtları ve 320 piksel genişlikte altı ekranı denetler. Yeni resimli içerik eski emoji sorularının kayıtlarından ayrıdır; diğer oyunların ilerlemesi korunur.

Google Play'e yüklemeden önce paket adı, imza, uygulama ikonu, gizlilik politikası ve cihaz testlerini tamamlayın.
