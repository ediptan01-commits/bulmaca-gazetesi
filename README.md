# Bulmaca Dünyası — 1.7.0

**Her Bulmacada Yeni Bir Macera!**

Mavi-altın ana ekranı ve krem oyun yüzeyleri olan Türkçe mobil bulmaca oyunu. Çengel, Kare, Sudoku,
Kelime Avı, Sarmal, Resimli ve Numaralı Çapraz Bulmaca: her türde 2 bölüm, toplam 14 bölüm.
Bölümler sırayla açılır ve ilerleme cihazda kaydedilir. Gelecek sürümler için
hazırlanmış diğer tema verileri kaynakta korunur, ilk sürümde gösterilmez.

Teknik paket adı ve GitHub deposu korunmuştur. Android üretim akışı görünen adı
ve uygulama simgesini `tool/brand_android.py` ile uygular.

## Kontrol

```
flutter pub get
flutter analyze
flutter test
```

GitHub Actions analiz ve testlerden sonra APK ve AAB üretir. Mevcut akış test
imzasını kullanır. Google Play yayını için kalıcı yükleme anahtarı, mağaza bilgileri,
gizlilik politikası ve gerçek Android cihaz kontrolü tamamlanmalıdır.

Bu sürüm bölüm kayıtlarında Set serileştirme hatasını, uzun sarmallarda erken
bitme sorununu ve ek kelime avında sürükleme desteğini düzeltir.

## 1.4.1 düzeltmeleri

Çengelin üç bölümü 8×8 sabit ve doğrulanmış ızgaralar kullanır. Her kesintisiz
harf dizisinin sorusu vardır; ipucu kutuları harfleri kapatmaz. Izgara klavyenin
üzerindeki kullanılabilir yüksekliğe göre sığar. İlk bölümdeki ayrık alt satırlar kaldırıldı.

Resimli bölümlerin tamamı nesne seçme, harf kutuları ve gizli şifre sistemi kullanır:
park (GAZETE), bahçe (BAHÇEM), oda (BİLGİN). Her bölümün kaydı ayrıdır.

Sarmal üç bölümde de merkezden dışa uzanan tek bir spiral şerittir. Her kutu
sırayla numaralanır; ipuçları cevapların kutu aralığını gösterir. Bölümün cevap
uzunluğuna göre kutu sayısı değişir; tüm kutular dokunarak seçilebilir.

## İki bölümlük sürüm
Altı türde yalnızca 1. ve 2. bölümler gösterilir. Kare 2 otomatik yerleşim yerine doğrulanmış sabit 7×7 ızgarayı ve birinci bölümün giriş sistemini kullanır. Sudoku notları aynı sayıya tekrar dokunarak kaldırılabilir.

## 1.5.0 — yeni görsel kimlik

Ana ekran verilen tasarımın özgün çizimleriyle mavi-altın düzene geçti. Altı kart,
alt menü, profil, başarılar, ayarlar ve günlük görev gerçek uygulama kontrolleridir.
Günlük görev üç farklı tür tamamlandığında cihazda bir günlük yıldız kaydeder.
Telefonun durum çubuğu görsele gömülmez; sistemin kendi durum çubuğu kullanılır.

Çengel her iki bölümde 8 sütun ve 11 satırdır. Alt satırlar mevcut dikey
cevaplarla birleşir. Kelime Avı iki bölümde de 10 sütun × 12 satırdır.
Her türde yalnızca iki bölüm vardır: toplam 14 bölüm.

## 1.6.0 — Numaralı Çapraz Bulmaca

Koleksiyona siyah dolgu olmadan, numaralı başlangıçlarla birbirine geçen sözcüklerden oluşan yeni tür eklendi. Doğa ve Okul/Kültür temalarında 18 soruluk iki bölüm bulunur. Türkçe Q klavye, yatay/dikey ipuçları, çözüm kontrolü ve ayrı bölüm kayıtları desteklenir. Mevcut altı türün ikişer bölümü korunur. Çengel her iki bölümde 11 satırdır.

## 1.7.0 — Gazete düzeni ve karalama düzeltmeleri

Kelime Avı 2 artık aynı düz karalama motorunu kullanır; eski bulunan kelimeler de çizgiye dönüştürülür. Çengel iki bölümde 11 satırdır; kullanılmayan alanlar geniş soru panellerine katılır, dolgu karesi gösterilmez. Her bölümde ve bölümler arasında tekrar eden cevap bulunmaz. Numaralı çaprazın iki 18 soruluk düzeni 17×16 ve 18×17 boyutlarına toplandı; ipuçları sayı sırasındadır. Yeni Çengel ve çapraz düzenleri ayrı kayıtlarla açılır; diğer türlerin ilerlemesi korunur.
