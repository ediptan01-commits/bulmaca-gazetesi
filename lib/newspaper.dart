part of 'main.dart';

const crossSize = 7;
const arrowSize = 8;
const arrowRows = 11;

class WordEntry {
  final String text, clue;
  final int r, c;
  final bool vertical;
  const WordEntry(this.text, this.clue, this.r, this.c, this.vertical);
  List<(int, int)> get cells => List.generate(
    text.length,
    (i) => (r + (vertical ? i : 0), c + (vertical ? 0 : i)),
  );
  (int, int) get clueCell => (r - (vertical ? 1 : 0), c - (vertical ? 0 : 1));
}

const crossWords = [
  WordEntry('BAL', 'Arıların yaptığı tatlı besin', 0, 0, false),
  WordEntry('BEL', 'Gövdenin kalça üstündeki bölümü', 0, 0, true),
  WordEntry('ABİ', 'Büyük erkek kardeş', 0, 1, true),
  WordEntry('LEBALEP', 'Ağzına kadar dolu', 0, 2, true),
  WordEntry('KAT', 'Yapının her bir bölümü', 0, 4, false),
  WordEntry('KERAMET', 'Ermişlere atfedilen olağanüstü hâl', 0, 4, true),
  WordEntry('AĞA', 'Köyde sözü geçen, varlıklı kişi', 0, 5, true),
  WordEntry('TEL', 'İnce metal lif', 0, 6, true),
  WordEntry('EBE', 'Doğuma yardımcı sağlık görevlisi', 1, 0, false),
  WordEntry('EĞE', 'Metali yontmaya yarayan araç', 1, 4, false),
  WordEntry('LİBERAL', 'Özgürlükçü', 2, 0, false),
  WordEntry('EDA', 'Tavır, davranış', 2, 3, true),
  WordEntry('ADA', 'Dört yanı suyla çevrili kara', 3, 2, false),
  WordEntry('SELAMET', 'Esenlik, güven içinde olma', 4, 0, false),
  WordEntry('SİS', 'Görüşü azaltan su damlacıkları', 4, 0, true),
  WordEntry('ELA', 'Yeşile çalan göz rengi', 4, 1, true),
  WordEntry('EKO', 'Yankı', 4, 5, true),
  WordEntry('TİP', 'Tür, örnek', 4, 6, true),
  WordEntry('İLE', 'Birliktelik bildiren bağlaç', 5, 0, false),
  WordEntry('EKİ', 'Gazetenin yanında verilen ilave', 5, 4, false),
  WordEntry('SAP', 'Bitkinin gövde bölümü', 6, 0, false),
  WordEntry('TOP', 'Yuvarlak oyun aracı', 6, 4, false),
];

const arrowWords = [
  WordEntry('TUZ', 'Beyaz mineral', 1, 1, false),
  WordEntry('TEZ', 'Sav', 1, 1, true),
  WordEntry('ULU', 'Yüce', 1, 2, true),
  WordEntry('ZAMBİYA', 'Lusaka ülkesi', 1, 3, true),
  WordEntry('ANA', 'Anne', 1, 5, false),
  WordEntry('AZALMAK', 'Eksilmek', 1, 5, true),
  WordEntry('NAM', 'Ün', 1, 6, true),
  WordEntry('ATA', 'Soy büyüğü', 1, 7, true),
  WordEntry('ELA', 'Göz rengi', 2, 1, false),
  WordEntry('ZAT', 'Kişi', 2, 5, false),
  WordEntry('ZUMLAMA', 'Zum işlemi', 3, 1, false),
  WordEntry('LOŞ', 'Az ışıklı', 3, 4, true),
  WordEntry('BOL', 'Çok', 4, 3, false),
  WordEntry('İTİŞMEK', 'Karşılıklı itmek', 5, 1, false),
  WordEntry('İRİ', 'Kocaman', 5, 1, true),
  WordEntry('TAM', 'Eksiksiz', 5, 2, true),
  WordEntry('ECE', 'Kraliçe', 5, 6, true),
  WordEntry('KIL', 'İnce deri uzantısı', 5, 7, true),
  WordEntry('RAY', 'Trenin yolu', 6, 1, false),
  WordEntry('ACI', 'Tatlı karşıtı', 6, 5, false),
  WordEntry('İMA', 'Dolaylı anlatma', 7, 1, false),
  WordEntry('KEL', 'Saçsız', 7, 5, false),
  WordEntry('İL', 'Şehir', 9, 0, true),
  WordEntry('AR', 'Utanma duygusu', 9, 3, false),
  WordEntry('YE', 'Yemek emri', 10, 3, false),
  WordEntry('AY', 'Dünya uydusu', 9, 3, true),
  WordEntry('RE', 'İkinci nota', 9, 4, true),
  WordEntry('EK', 'İlave', 9, 6, false),
  WordEntry('Mİ', 'Soru eki', 10, 6, false),
  WordEntry('EM', 'Emmek emri', 9, 6, true),
  WordEntry('Kİ', 'İlgi bağlacı', 9, 7, true),
];


// Gazete usulu, ipucu hucreleri olmayan birbirini kesen oyunlar.
const gazeteCengel1 = <WordEntry>[
  WordEntry('AZALMAK', 'Eksilmek', 7, 2, false),
  WordEntry('ZAMBİYA', 'Lusaka ülkesi', 6, 2, true),
  WordEntry('ZUMLAMA', 'Zum işlemi', 3, 4, true),
  WordEntry('İTİŞMEK', 'Karşılıklı itmek', 1, 8, true),
  WordEntry('RAY', 'Trenin yolu', 11, 0, false),
  WordEntry('ECE', 'Kraliçe', 6, 8, false),
  WordEntry('ZAT', 'Kişi', 3, 4, false),
  WordEntry('TEZ', 'Sav', 6, 0, false),
  WordEntry('ATA', 'Soy büyüğü', 7, 7, true),
  WordEntry('İMA', 'Dolaylı anlatma', 3, 8, false),
  WordEntry('NAM', 'Ün', 9, 6, false),
  WordEntry('TUZ', 'Beyaz mineral', 3, 6, true),
  WordEntry('ANA', 'Anne', 12, 2, false),
  WordEntry('ULU', 'Yüce', 4, 2, false),
  WordEntry('İRİ', 'Kocaman', 1, 6, false),
  WordEntry('TAM', 'Eksiksiz', 8, 0, false),
  WordEntry('ELA', 'Göz rengi', 6, 10, true),
  WordEntry('ACI', 'Tatlı karşıtı', 8, 10, false),
  WordEntry('AY', 'Dünya uydusu', 12, 4, true),
  WordEntry('Kİ', 'İlgi bağlacı', 0, 6, true),
  WordEntry('RE', 'İkinci nota', 5, 1, true),
  WordEntry('AR', 'Utanma duygusu', 10, 0, true),
  WordEntry('Mİ', 'Soru eki', 9, 8, true),
  WordEntry('EK', 'İlave', 0, 5, false),
  WordEntry('YE', 'Yemek emri', 13, 4, false),
  WordEntry('İL', 'Şehir', 10, 2, false),
  WordEntry('KIL', 'İnce deri uzantısı', 7, 12, true),
  WordEntry('LOŞ', 'Az ışıklı', 9, 12, false),
  WordEntry('EM', 'Emmek emri', 13, 5, true),
  WordEntry('KEL', 'Saçsız', 7, 12, false),
  WordEntry('BOL', 'Çok', 5, 14, true),
];
const gazeteCengel2 = <WordEntry>[
  WordEntry('SELAMET', 'Esenlik', 8, 2, false),
  WordEntry('LEBALEP', 'Ağzına dek dolu', 7, 3, true),
  WordEntry('LİBERAL', 'Özgürlükçü', 11, 3, false),
  WordEntry('KERAMET', 'Ermiş mucizesi', 10, 6, true),
  WordEntry('TİZ', 'İnce ses', 16, 6, false),
  WordEntry('TOZ', 'İnce zerreler', 14, 8, true),
  WordEntry('EBE', 'Doğum uzmanı', 6, 7, true),
  WordEntry('EKİ', 'Gazete ilavesi', 6, 7, false),
  WordEntry('TEL', 'Metal lif', 9, 9, true),
  WordEntry('EGE', 'Bir denizimiz', 10, 9, false),
  WordEntry('TOP', 'Oyun küresi', 13, 1, false),
  WordEntry('EKO', 'Yankı', 10, 11, true),
  WordEntry('SET', 'Engel', 11, 1, true),
  WordEntry('KAT', 'Yapı bölümü', 7, 5, true),
  WordEntry('SAL', 'Kütük taşıt', 13, 5, false),
  WordEntry('EĞE', 'Metal törpüsü', 15, 4, false),
  WordEntry('ET', 'Kas dokusundan besin', 15, 4, true),
  WordEntry('YA', 'Seçenek bağlacı', 10, 2, false),
  WordEntry('BE', 'Seslenme ünlemi', 12, 0, false),
  WordEntry('OY', 'Seçimde verilen tercih', 13, 2, true),
  WordEntry('ON', 'Dokuzdan sonra', 12, 11, false),
  WordEntry('TA', 'Uzaklığı vurgulayan söz', 14, 8, false),
  WordEntry('ABİ', 'Büyük kardeş', 4, 9, true),
  WordEntry('ADA', 'Suyla çevrili kara', 4, 9, false),
  WordEntry('EDA', 'Tavır', 2, 11, true),
  WordEntry('EL', 'Parmaklı organ', 2, 11, false),
  WordEntry('LA', 'Altıncı nota', 13, 9, true),
  WordEntry('NA', 'Sodyum simgesi', 12, 12, true),
  WordEntry('SEL', 'Su baskını', 0, 12, true),
  WordEntry('AĞA', 'Köy büyüğü', 13, 12, false),
  WordEntry('EGO', 'Benlik', 1, 12, false),
];
const gazeteKare1 = <WordEntry>[
  WordEntry('KERAMET', 'Ermişlere atfedilen olağanüstü hâl', 8, 5, false),
  WordEntry('LİBERAL', 'Özgürlükçü', 4, 7, true),
  WordEntry('LEBALEP', 'Ağzına kadar dolu', 3, 10, true),
  WordEntry('SELAMET', 'Esenlik, güven içinde olma', 4, 5, false),
  WordEntry('EKİ', 'Gazetenin yanında verilen ilave', 7, 5, true),
  WordEntry('SAP', 'Bitkinin gövde bölümü', 6, 9, false),
  WordEntry('ELA', 'Yeşile çalan göz rengi', 10, 6, false),
  WordEntry('ABİ', 'Büyük erkek kardeş', 10, 8, true),
  WordEntry('SİS', 'Görüşü azaltan su damlacıkları', 2, 5, true),
  WordEntry('BEL', 'Gövdenin kalça üstündeki bölümü', 11, 8, false),
  WordEntry('EBE', 'Doğuma yardımcı sağlık görevlisi', 10, 6, true),
  WordEntry('EĞE', 'Metali yontmaya yarayan araç', 7, 3, false),
  WordEntry('AĞA', 'Köyde sözü geçen, varlıklı kişi', 2, 8, true),
  WordEntry('İLE', 'Birliktelik bildiren bağlaç', 5, 3, true),
  WordEntry('BAL', 'Arıların yaptığı tatlı besin', 2, 7, false),
  WordEntry('TİP', 'Tür, örnek', 5, 2, false),
  WordEntry('KAT', 'Yapının her bir bölümü', 3, 2, true),
  WordEntry('TEL', 'İnce metal lif', 0, 9, true),
  WordEntry('EKO', 'Yankı', 1, 9, false),
  WordEntry('ADA', 'Dört yanı suyla çevrili kara', 4, 0, false),
  WordEntry('EDA', 'Tavır, davranış', 2, 0, true),
  WordEntry('TOP', 'Yuvarlak oyun aracı', 0, 11, true),
];
const gazeteKare2 = <WordEntry>[
  WordEntry('AÇINMAK', 'Derdini dökmek', 3, 2, false),
  WordEntry('RANTİYE', 'Gelirle geçinen', 1, 5, true),
  WordEntry('EŞİLMEK', 'Kazılmak', 7, 5, false),
  WordEntry('MANDIRA', 'Süt işleme yeri', 2, 2, true),
  WordEntry('KIL', 'Deri uzantısı', 5, 8, true),
  WordEntry('DAL', 'Ağaç kolu', 2, 7, true),
  WordEntry('KEL', 'Saçsız', 5, 8, false),
  WordEntry('ACI', 'Tatlı karşıtı', 6, 0, false),
  WordEntry('ZAM', 'Fiyat artışı', 2, 0, false),
  WordEntry('EFE', 'Zeybek', 7, 10, true),
  WordEntry('ABİ', 'Büyük kardeş', 8, 2, false),
  WordEntry('TAN', 'Şafak', 4, 0, false),
  WordEntry('ŞEF', 'Orkestra yönetir', 7, 6, true),
  WordEntry('EBE', 'Doğum uzmanı', 9, 8, false),
  WordEntry('ÇİM', 'Kısa yeşil örtü', 5, 4, false),
  WordEntry('İMA', 'Dolaylı anlatım', 8, 4, true),
  WordEntry('ADA', 'Suyla çevrili kara', 6, 0, true),
  WordEntry('BİR', 'İlk sayı', 1, 3, false),
  WordEntry('ECE', 'Kraliçe', 9, 8, true),
  WordEntry('ODA', 'Ev bölümü', 0, 1, true),
  WordEntry('ZOR', 'Güç, çetin', 0, 0, false),
  WordEntry('BEY', 'Erkek unvanı', 11, 7, false),
];

List<WordEntry> gazeteWordsForLevel(String kind, int level) {
  if (kind == 'cengel') return level == 1 ? gazeteCengel1 : gazeteCengel2;
  return level == 1 ? gazeteKare1 : gazeteKare2;
}

const searchGrid = [
  'GAZETEKHĞT',
  'KÜTŞLTAİMA',
  'ĞİİATULRCB',
  'ĞİTFNPEAAİ',
  'RBAALAMTRL',
  'TIÖDPLSCİİ',
  'UKODUSZEOM',
  'YZABİLGİGD',
  'SAIGALHZBE',
  'CIZASÖERAÜ',
  'TUÇAJIFMKL',
  'INKYRĞEIÖÇ',
];
const searchEntries = <(String, int, int, int, int)>[
  ('GAZETE', 0, 0, 0, 1),
  ('KALEM', 0, 6, 1, 0),
  ('KİTAP', 1, 0, 1, 1),
  ('BULMACA', 7, 3, -1, 1),
  ('SUDOKU', 6, 5, 0, -1),
  ('TARİH', 4, 7, -1, 0),
  ('SANAT', 5, 6, -1, -1),
  ('ŞİİR', 1, 3, 1, -1),
  ('BİLGİ', 7, 3, 0, 1),
  ('BİLİM', 2, 9, 1, 0),
  ('YAZAR', 7, 0, 1, 1),
];
final searchWords = searchEntries.map((e) => e.$1).toList();
const spiralWords = [
  ('KREM', 'Cilde sürülen yumuşak bakım ürünü'),
  ('MASA', 'Üzerinde yemek yenilen mobilya'),
  ('ARABA', 'Dört tekerlekli kara taşıtı'),
  ('ANAHTAR', 'Kilidi açan küçük araç'),
  ('RENK', 'Kırmızı, mavi ve yeşilin ortak adı'),
  ('KİTAP', 'Okumak için sayfalarını çeviririz'),
  ('PENCERE', 'Odaya gün ışığı alan açıklık'),
  ('ELMA', 'Amasya ile anılan meyve'),
  ('AĞAÇ', 'Gövdesi, dalları ve yaprakları olan bitki'),
  ('ÇİÇEK', 'Bitkinin renkli üreme organı'),
  ('KAPI', 'Bir yere girip çıkmayı sağlar'),
  ('IRMAK', 'Büyük akarsu'),
  ('KUŞ', 'Tüyleri ve kanatları olan hayvan'),
];

final spiralAnswer = spiralWords
    .map((e) => e.$1)
    .reduce((a, b) => a + b.substring(1));
List<int> get spiralStarts {
  final starts = <int>[];
  var offset = 0;
  for (final word in spiralWords) {
    starts.add(offset);
    offset += word.$1.length - 1;
  }
  return starts;
}

const defaultSearchGrid = searchGrid;
const defaultSearchEntries = searchEntries;

const arrowLevel2 = [
  WordEntry('SAL', 'Kütük taşıt', 1, 1, false),
  WordEntry('SEL', 'Su baskını', 1, 1, true),
  WordEntry('ABİ', 'Büyük kardeş', 1, 2, true),
  WordEntry('LEBALEP', 'Ağzına dek dolu', 1, 3, true),
  WordEntry('KAT', 'Yapı bölümü', 1, 5, false),
  WordEntry('KERAMET', 'Ermiş mucizesi', 1, 5, true),
  WordEntry('AĞA', 'Köy büyüğü', 1, 6, true),
  WordEntry('TEL', 'Metal lif', 1, 7, true),
  WordEntry('EBE', 'Doğum uzmanı', 2, 1, false),
  WordEntry('EĞE', 'Metal törpüsü', 2, 5, false),
  WordEntry('LİBERAL', 'Özgürlükçü', 3, 1, false),
  WordEntry('EDA', 'Tavır', 3, 4, true),
  WordEntry('ADA', 'Suyla çevrili kara', 4, 3, false),
  WordEntry('SELAMET', 'Esenlik', 5, 1, false),
  WordEntry('SET', 'Engel', 5, 1, true),
  WordEntry('EGO', 'Benlik', 5, 2, true),
  WordEntry('EKİ', 'Gazete ilavesi', 5, 6, true),
  WordEntry('TOZ', 'İnce zerreler', 5, 7, true),
  WordEntry('EGE', 'Bir denizimiz', 6, 1, false),
  WordEntry('EKO', 'Yankı', 6, 5, false),
  WordEntry('TOP', 'Oyun küresi', 7, 1, false),
  WordEntry('TİZ', 'İnce ses', 7, 5, false),
];

const arrowLevel3 = [
  WordEntry('ZAM', 'Fiyat artışı', 1, 1, false),
  WordEntry('ZOR', 'Güç, çetin', 1, 1, true),
  WordEntry('ADA', 'Suyla çevrili kara', 1, 2, true),
  WordEntry('MANDIRA', 'Süt işleme yeri', 1, 3, true),
  WordEntry('EBE', 'Doğum uzmanı', 1, 5, false),
  WordEntry('EŞİLMEK', 'Kazılmak', 1, 5, true),
  WordEntry('BEY', 'Erkek unvanı', 1, 6, true),
  WordEntry('EFE', 'Zeybek', 1, 7, true),
  WordEntry('ODA', 'Ev bölümü', 2, 1, false),
  WordEntry('ŞEF', 'Orkestra yönetir', 2, 5, false),
  WordEntry('RANTİYE', 'Gelirle geçinen', 3, 1, false),
  WordEntry('TAN', 'Şafak', 3, 4, true),
  WordEntry('DAL', 'Ağaç kolu', 4, 3, false),
  WordEntry('AÇINMAK', 'Derdini dökmek', 5, 1, false),
  WordEntry('ABİ', 'Büyük kardeş', 5, 1, true),
  WordEntry('ÇİM', 'Kısa yeşil örtü', 5, 2, true),
  WordEntry('ACI', 'Tatlı karşıtı', 5, 6, true),
  WordEntry('KEL', 'Saçsız', 5, 7, true),
  WordEntry('BİR', 'İlk sayı', 6, 1, false),
  WordEntry('ECE', 'Kraliçe', 6, 5, false),
  WordEntry('İMA', 'Dolaylı anlatım', 7, 1, false),
  WordEntry('KIL', 'Deri uzantısı', 7, 5, false),
];

List<WordEntry> arrowWordsForLevel(int level) => switch (level) {
  2 => [...arrowLevel2, ...arrowExtension2],
  3 => arrowLevel3,
  _ => arrowWords,
};

List<WordEntry> crossWordsForLevel(int level) => level == 1
    ? crossWords
    : arrowLevel2
          .map((w) => WordEntry(w.text, w.clue, w.r - 1, w.c - 1, w.vertical))
          .toList();

const arrowExtension2 = [
  WordEntry('BE', 'Seslenme ünlemi', 9, 0, true),
  WordEntry('ON', 'Dokuzdan sonra', 9, 3, false),
  WordEntry('YA', 'Seçenek bağlacı', 10, 3, false),
  WordEntry('OY', 'Seçimde verilen tercih', 9, 3, true),
  WordEntry('NA', 'Sodyum simgesi', 9, 4, true),
  WordEntry('EL', 'Parmaklı organ', 9, 6, false),
  WordEntry('TA', 'Uzaklığı vurgulayan söz', 10, 6, false),
  WordEntry('ET', 'Kas dokusundan besin', 9, 6, true),
  WordEntry('LA', 'Altıncı nota', 9, 7, true),
];
