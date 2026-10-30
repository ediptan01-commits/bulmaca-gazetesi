part of 'main.dart';

const crossSize = 11;

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
  WordEntry('DEMİR', 'Mıknatısın çektiği metal', 0, 0, false),
  WordEntry('DÜĞME', 'Giysiyi iliklemeye yarayan parça', 0, 0, true),
  WordEntry('İP', 'Liflerden yapılan ince bağ', 0, 3, true),
  WordEntry('ADA', 'Dört yanı suyla çevrili kara', 0, 6, false),
  WordEntry('ARI', 'Bal yapan böcek', 0, 6, true),
  WordEntry('AT', 'Binilen, yeleli hayvan', 0, 8, true),
  WordEntry('TAÇ', 'Kralların başlığı', 1, 8, false),
  WordEntry('ÇÖL', 'Yağışı çok az, kurak bölge', 1, 10, true),
  WordEntry('AK', 'Beyazın eş anlamlısı', 2, 2, true),
  WordEntry('SU', 'Yaşam için gerekli renksiz sıvı', 2, 4, true),
  WordEntry('MEKTUP', 'Uzağa gönderilen yazılı haber', 3, 0, false),
  WordEntry('PORTAKAL', 'C vitaminiyle bilinen turunçgil', 3, 5, true),
  WordEntry('PUL', 'Posta ücretini gösteren küçük kâğıt', 3, 8, false),
  WordEntry('PENCERE', 'Odaya gün ışığı alan açıklık', 3, 8, true),
  WordEntry('GÜVERCİN', 'Barışı simgeleyen kuş', 5, 1, false),
  WordEntry('KAPI', 'Bir yere girip çıkmayı sağlar', 6, 0, true),
  WordEntry('ANAHTAR', 'Kilidi açan küçük araç', 7, 0, false),
  WordEntry('AYNA', 'Görüntümüzü yansıtır', 7, 2, true),
  WordEntry('İNEK', 'Sütünden yararlanılan büyükbaş hayvan', 7, 10, true),
  WordEntry('TREN', 'Raylar üzerinde giden taşıt', 8, 7, false),
  WordEntry('MADALYA', 'Başarı karşılığında verilen nişan', 10, 1, false),
  WordEntry('OK', 'Yayla atılan sivri uçlu çubuk', 10, 9, false),
];

const arrowWords = [
  WordEntry('İP', 'İnce bağ', 1, 1, false),
  WordEntry('PORTAKAL', 'Bir turunçgil', 1, 2, true),
  WordEntry('GÜL', 'Dikenli çiçek', 1, 8, false),
  WordEntry('GÜVERCİN', 'Barışı simgeleyen kuş', 1, 8, true),
  WordEntry('PAPATYA', 'Beyaz taçlı çiçek', 2, 4, true),
  WordEntry('KARTAL', 'Yırtıcı kuş', 2, 6, true),
  WordEntry('ADA', 'Suyla çevrili kara', 3, 4, false),
  WordEntry('AT', 'Binek hayvanı', 4, 1, false),
  WordEntry('ANAHTAR', 'Kilidi açar', 5, 2, false),
  WordEntry('GECE', 'Gündüz karşıtı', 5, 10, true),
  WordEntry('OK', 'Yayla atılır', 6, 1, false),
  WordEntry('YOL', 'Ulaşım şeridi', 7, 4, false),
  WordEntry('ELMA', 'Amasya meyvesi', 8, 1, false),
  WordEntry('EL', 'Beş parmaklı organ', 8, 1, true),
  WordEntry('MOR', 'Kırmızı + mavi', 8, 3, true),
  WordEntry('ANNE', 'Ana, valide', 8, 7, false),
  WordEntry('NAR', 'Taneli meyve', 8, 9, true),
  WordEntry('AK', 'Beyaz', 9, 5, false),
  WordEntry('AY', 'Doğal uydumuz', 9, 5, true),
  WordEntry('RAY', 'Trenin yolu', 10, 3, false),
  WordEntry('KAR', 'Beyaz yağış', 10, 7, false),
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
  ('ROMAN', 1, 1, 0, 1),
  ('YAZAR', 0, 4, 1, 0),
  ('OKUR', 3, 0, 1, 1),
  ('HABER', 4, 5, -1, 1),
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
