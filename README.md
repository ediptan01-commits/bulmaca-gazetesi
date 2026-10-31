# Bulmaca Dünyası — 1.4.1

**Her Bulmacada Yeni Bir Macera!**

Krem ve koyu yeşil tasarımlı Türkçe mobil bulmaca oyunu. Çengel, Kare, Sudoku,
Kelime Avı, Sarmal ve Resimli Bulmaca: her türde 3 bölüm, toplam 18 bölüm.
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
