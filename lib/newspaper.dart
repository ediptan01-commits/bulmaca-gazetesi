part of 'main.dart';

const crossSize = 7;
const arrowSize = 8;
const arrowRows = 12;

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
  WordEntry('ZAMBİYA', 'Başkenti Lusaka', 1, 3, true),
  WordEntry('ANA', 'Anne', 1, 5, false),
  WordEntry('AZALMAK', 'Eksilmek', 1, 5, true),
  WordEntry('NAM', 'Ün', 1, 6, true),
  WordEntry('ATA', 'Soy büyüğü', 1, 7, true),
  WordEntry('ELA', 'Göz rengi', 2, 1, false),
  WordEntry('ZAT', 'Kişi', 2, 5, false),
  WordEntry('ZUMLAMA', 'Görüntüyü büyütme', 3, 1, false),
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
  // Gazete sayfasının alt kısmındaki ek kısa çengel soruları.
  WordEntry('GÜL', 'Dikenli çiçek', 8, 1, false),
  WordEntry('SES', 'Kulağın algıladığı titreşim', 8, 5, false),
  WordEntry('ARI', 'Bal yapan böcek', 9, 2, false),
  WordEntry('SU', 'İçilen berrak sıvı', 9, 6, false),
  WordEntry('KAR', 'Kış yağışı', 10, 1, false),
  WordEntry('AYI', 'İri bir orman hayvanı', 10, 5, false),
  WordEntry('TAŞ', 'Sert kaya parçası', 11, 1, false),
  WordEntry('YOL', 'Ulaşım için kullanılan geçit', 11, 5, false),
];

const searchGrid = [
  'DLRTYJKCMRAÖ',
  'BROMANPMECSF',
  'EBYAZNVBANFK',
  'OHMŞADAMSİIA',
  'VKİARHLSŞJUL',
  'ÖİUDSUYIRİOE',
  'ROHRBUKODUSM',
  'FLİKGAZETEDC',
  'ÖFRÖİYŞEZJBĞ',
  'PBATHTMIKĞNŞ',
  'IHTSSİADZDKA',
  'FJÖIDDHPHIBB',
  'BİLGİABCDEĞÖ',
  'ÖÇĞABİLİMXYZ',
  'KLMNOPQYAZAR',
];
const searchEntries = <(String, int, int, int, int)>[
  ('GAZETE', 7, 4, 0, 1),
  ('KALEM', 2, 11, 1, 0),
  ('KİTAP', 7, 3, 1, 1),
  ('BULMACA', 6, 4, -1, 1),
  ('SUDOKU', 6, 10, 0, -1),
  ('TARİH', 10, 2, -1, 0),
  ('SANAT', 4, 7, -1, -1),
  ('ŞİİR', 3, 3, 1, -1),
  ('BİLGİ', 12, 0, 0, 1),
  ('BİLİM', 13, 4, 0, 1),
  ('YAZAR', 14, 7, 0, 1),
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
