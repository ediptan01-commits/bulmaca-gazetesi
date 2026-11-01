// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
part of 'main.dart';

// On yeni sayı için özgün, konuya göre hazırlanmış cevap ve ipucu havuzları.
class ExtraAnswer {
  final String word, clue;
  const ExtraAnswer(this.word, this.clue);
}

class ExtraPack {
  final String title, fact;
  final List<ExtraAnswer> words;
  const ExtraPack(this.title, this.fact, this.words);
}

const extraPacks = <ExtraPack>[
  ExtraPack('Doğa', 'Bambu, dünyanın en hızlı büyüyen bitkilerinden biridir.', [
    ExtraAnswer('ORMAN', 'Ağaçlarla kaplı geniş alan'),
    ExtraAnswer('YAPRAK', 'Ağacın yeşil bölümü'),
    ExtraAnswer('TOPRAK', 'Bitkilerin kök saldığı katman'),
    ExtraAnswer('NEHİR', 'Büyük akarsu'),
    ExtraAnswer('ÇİÇEK', 'Bitkinin renkli bölümü'),
    ExtraAnswer('YAĞMUR', 'Buluttan düşen su'),
    ExtraAnswer('BULUT', 'Gökteki su damlacıkları'),
    ExtraAnswer('GÜNEŞ', 'Dünyayı aydınlatan yıldız'),
    ExtraAnswer('RÜZGAR', 'Hareket eden hava'),
    ExtraAnswer('DENİZ', 'Büyük tuzlu su kütlesi'),
  ]),
  ExtraPack('Uzay', 'Venüs, Güneş Sistemi’ndeki en sıcak gezegendir.', [
    ExtraAnswer('GEZEGEN', 'Yıldız çevresinde dönen gök cismi'),
    ExtraAnswer('YILDIZ', 'Kendi ışığını üreten gök cismi'),
    ExtraAnswer('UYDU', 'Bir gezegenin çevresinde dolanır'),
    ExtraAnswer('ROKET', 'Uzaya gönderilen araç'),
    ExtraAnswer('EVREN', 'Bütün uzay ve içindekiler'),
    ExtraAnswer('DÜNYA', 'Üzerinde yaşadığımız gezegen'),
    ExtraAnswer('GÜNEŞ', 'Sistemimizin merkezindeki yıldız'),
    ExtraAnswer('AY', 'Dünya’nın doğal uydusu'),
    ExtraAnswer('MARS', 'Kızıl gezegen'),
    ExtraAnswer('VENÜS', 'Dünya’ya yakın parlak gezegen'),
  ]),
  ExtraPack('Hayvanlar', 'Ahtapotların üç kalbi vardır.', [
    ExtraAnswer('AHTAPOT', 'Sekiz kollu deniz canlısı'),
    ExtraAnswer('KARTAL', 'Keskin gözlü yırtıcı kuş'),
    ExtraAnswer('KAPLAN', 'Çizgili büyük kedi'),
    ExtraAnswer('BALİNA', 'Çok büyük deniz memelisi'),
    ExtraAnswer('PENGUEN', 'Uçamayan kutup kuşu'),
    ExtraAnswer('ZÜRAFA', 'Uzun boyunlu otçul'),
    ExtraAnswer('YUNUS', 'Zeki deniz memelisi'),
    ExtraAnswer('TAVŞAN', 'Uzun kulaklı hayvan'),
    ExtraAnswer('TİLKİ', 'Kurnazlığıyla anılan hayvan'),
    ExtraAnswer('ARI', 'Bal yapan böcek'),
  ]),
  ExtraPack('Coğrafya', 'Dünyanın en derin gölünün adı Baykal Gölü’dür.', [
    ExtraAnswer('HARİTA', 'Yeryüzünü çizimle gösterir'),
    ExtraAnswer('KITA', 'Büyük kara parçası'),
    ExtraAnswer('ADA', 'Dört yanı suyla çevrili kara'),
    ExtraAnswer('OVA', 'Geniş düz kara alanı'),
    ExtraAnswer('DAĞ', 'Yüksek yer şekli'),
    ExtraAnswer('VADİ', 'İki dağ arasındaki alçak alan'),
    ExtraAnswer('GÖL', 'Karalarla çevrili su'),
    ExtraAnswer('OKYANUS', 'Çok büyük tuzlu su kütlesi'),
    ExtraAnswer('KÖRFEZ', 'Denizin karaya sokulduğu yer'),
    ExtraAnswer('ŞELALE', 'Yüksekten dökülen akarsu'),
  ]),
  ExtraPack('Bilim', 'Ses, boşlukta yayılamaz; iletilmek için madde gerekir.', [
    ExtraAnswer('ATOM', 'Maddenin temel yapı taşı'),
    ExtraAnswer('ENERJİ', 'İş yapabilme yeteneği'),
    ExtraAnswer('DENEY', 'Bir görüşü sınayan işlem'),
    ExtraAnswer('IŞIK', 'Görmeyi sağlayan enerji'),
    ExtraAnswer('SES', 'Titreşimle oluşan dalga'),
    ExtraAnswer('MADDE', 'Kütlesi ve hacmi olan'),
    ExtraAnswer('KUVVET', 'Cismi hareket ettirebilen etki'),
    ExtraAnswer('MERCEK', 'Işığı kıran saydam araç'),
    ExtraAnswer('ISI', 'Sıcaklık farkıyla aktarılan enerji'),
    ExtraAnswer('MİKROP', 'Çıplak gözle görülmeyen canlı'),
  ]),
  ExtraPack('Sanat', 'Mona Lisa tablosu, Louvre Müzesi’nde sergilenir.', [
    ExtraAnswer('RESİM', 'Renk ve çizgilerle yapılan eser'),
    ExtraAnswer('MÜZİK', 'Sesleri düzenleme sanatı'),
    ExtraAnswer('HEYKEL', 'Üç boyutlu sanat eseri'),
    ExtraAnswer('ŞİİR', 'Dizelerden oluşan edebî eser'),
    ExtraAnswer('ROMAN', 'Uzun kurmaca anlatı'),
    ExtraAnswer('SAHNE', 'Oyunun sergilendiği yer'),
    ExtraAnswer('FIRÇA', 'Boya sürmeye yarayan araç'),
    ExtraAnswer('TUVAL', 'Resim yapılan bez yüzey'),
    ExtraAnswer('RENK', 'Kırmızı, mavi gibi özellik'),
    ExtraAnswer('NOTA', 'Müzik sesini gösteren işaret'),
  ]),
  ExtraPack(
    'Tarih',
    'Göbeklitepe, bilinen en eski anıtsal yapılardan biridir.',
    [
      ExtraAnswer('TARİH', 'Geçmiş olayları araştıran bilim'),
      ExtraAnswer('KALE', 'Savunma amacıyla yapılmış yapı'),
      ExtraAnswer('KRAL', 'Monarşide erkek hükümdar'),
      ExtraAnswer('SARAY', 'Hükümdarın yaşadığı yapı'),
      ExtraAnswer('YAZIT', 'Taşa kazınmış metin'),
      ExtraAnswer('MÜZE', 'Tarihî eserlerin sergilendiği yer'),
      ExtraAnswer('PARA', 'Alışverişte kullanılan ödeme aracı'),
      ExtraAnswer('FETİH', 'Bir yeri ele geçirme'),
      ExtraAnswer('ANIT', 'Bir olayı anmak için yapılan eser'),
      ExtraAnswer('ÇAĞ', 'Tarihin geniş bir dönemi'),
    ],
  ),
  ExtraPack('Spor', 'Olimpiyat bayrağında beş halka bulunur.', [
    ExtraAnswer('FUTBOL', 'Topa ayakla vurulan takım oyunu'),
    ExtraAnswer('TENİS', 'Raketle oynanan spor'),
    ExtraAnswer('YÜZME', 'Suda ilerleme sporu'),
    ExtraAnswer('KOŞU', 'Hızla ilerleme yarışı'),
    ExtraAnswer('GOL', 'Topun kaleye girmesi'),
    ExtraAnswer('KALE', 'Futbolda ağlı hedef'),
    ExtraAnswer('HAKEM', 'Oyunun kurallarını denetler'),
    ExtraAnswer('MADALYA', 'Başarı karşılığı verilen ödül'),
    ExtraAnswer('PİST', 'Yarış yapılan alan'),
    ExtraAnswer('TAKIM', 'Birlikte yarışan oyuncular'),
  ]),
  ExtraPack('Teknoloji', 'İlk bilgisayar faresi 1960’larda geliştirildi.', [
    ExtraAnswer('EKRAN', 'Görüntünün izlendiği yüzey'),
    ExtraAnswer('KOD', 'Yazılım komutları'),
    ExtraAnswer('ROBOT', 'Programla çalışan makine'),
    ExtraAnswer('KLAVYE', 'Yazı giriş aygıtı'),
    ExtraAnswer('FARE', 'Bilgisayar işaretleme aygıtı'),
    ExtraAnswer('AĞ', 'Bağlı bilgisayarlar bütünü'),
    ExtraAnswer('VERİ', 'İşlenebilen bilgi'),
    ExtraAnswer('DOSYA', 'Dijital belge'),
    ExtraAnswer('PİKSEL', 'Ekrandaki en küçük görüntü birimi'),
    ExtraAnswer('YAZILIM', 'Programların genel adı'),
  ]),
  ExtraPack(
    'Mutfak',
    'Safran, çiçeğin tepeciklerinden elde edilen bir baharattır.',
    [
      ExtraAnswer('EKMEK', 'Undan yapılan temel yiyecek'),
      ExtraAnswer('PEYNİR', 'Sütten yapılan yiyecek'),
      ExtraAnswer('ÇORBA', 'Kaşıkla içilen sulu yemek'),
      ExtraAnswer('SALATA', 'Sebzelerle yapılan soğuk yemek'),
      ExtraAnswer('PİLAV', 'Pirinç veya bulgurla yapılır'),
      ExtraAnswer('YOĞURT', 'Mayalanmış süt ürünü'),
      ExtraAnswer('TENCERE', 'Yemek pişirme kabı'),
      ExtraAnswer('KAŞIK', 'Yemek yeme aracı'),
      ExtraAnswer('FIRIN', 'Yiyecekleri pişirmeye yarar'),
      ExtraAnswer('BAHARAT', 'Yemeğe tat veren bitkisel ürün'),
    ],
  ),
];

String extraTheme(int level) =>
    extraPacks[level < 2 ? 0 : (level > 11 ? 9 : level - 2)].title;

class ExtraPlacedWord {
  final ExtraAnswer answer;
  final int row, col;
  final bool vertical;
  const ExtraPlacedWord(this.answer, this.row, this.col, this.vertical);
  List<(int, int)> get cells => List.generate(
    answer.word.length,
    (i) => (row + (vertical ? i : 0), col + (vertical ? 0 : i)),
  );
}

// Kesişen kelimeler yalnızca aynı harfte birleşebilir.
List<ExtraPlacedWord> makeCrosswords(ExtraPack pack, {required bool arrow}) {
  final chapter = extraPacks.indexOf(pack);
  if (arrow) {
    if (chapter >= 0) {
      return [
        for (final p in extraArrowLayouts[chapter])
          ExtraPlacedWord(
            ExtraAnswer(trUpper(pack.words[p.$1].word), pack.words[p.$1].clue),
            p.$2,
            p.$3,
            p.$4,
          ),
      ];
    }
  } else if (chapter >= 0 && chapter < extraKareLayouts.length) {
    return [
      for (final p in extraKareLayouts[chapter])
        ExtraPlacedWord(
          ExtraAnswer(trUpper(pack.words[p.$1].word), pack.words[p.$1].clue),
          p.$2,
          p.$3,
          p.$4,
        ),
    ];
  }
  const size = 12;
  final grid = <(int, int), String>{};
  final placed = <ExtraPlacedWord>[];
  final source =
      pack.words.map((e) => ExtraAnswer(trUpper(e.word), e.clue)).toList()
        ..sort((a, b) => b.word.length.compareTo(a.word.length));
  bool possible(ExtraAnswer answer, int r, int c, bool vertical, bool first) {
    final w = ExtraPlacedWord(answer, r, c, vertical);
    final clue = (r - (vertical ? 1 : 0), c - (vertical ? 0 : 1));
    if (r < 0 || c < 0 || w.cells.any((p) => p.$1 >= size || p.$2 >= size)) {
      return false;
    }
    if (arrow && (clue.$1 < 0 || clue.$2 < 0 || grid.containsKey(clue))) {
      return false;
    }
    if (arrow && placed.any((p) => p.cells.contains(clue))) {
      return false;
    }
    var crosses = 0;
    for (var i = 0; i < w.cells.length; i++) {
      final cell = w.cells[i];
      if (grid[cell] != null && grid[cell] != answer.word[i]) {
        return false;
      }
      if (grid[cell] != null) {
        crosses++;
      }
      if (arrow &&
          placed.any(
            (p) =>
                p.row - (p.vertical ? 1 : 0) == cell.$1 &&
                p.col - (p.vertical ? 0 : 1) == cell.$2,
          )) {
        return false;
      }
    }
    return first || crosses > 0;
  }

  for (final answer in source) {
    if (placed.isEmpty) {
      final start = ExtraPlacedWord(answer, 5, 2, false);
      if (possible(answer, start.row, start.col, false, true)) {
        placed.add(start);
        for (var i = 0; i < start.cells.length; i++) {
          grid[start.cells[i]] = answer.word[i];
        }
      }
      continue;
    }
    ExtraPlacedWord? candidate;
    outer:
    for (final vertical in [true, false]) {
      for (var i = 0; i < answer.word.length; i++) {
        for (final existing in grid.entries) {
          if (existing.value != answer.word[i]) {
            continue;
          }
          final r = existing.key.$1 - (vertical ? i : 0);
          final c = existing.key.$2 - (vertical ? 0 : i);
          if (possible(answer, r, c, vertical, false)) {
            candidate = ExtraPlacedWord(answer, r, c, vertical);
            break outer;
          }
        }
      }
    }
    if (candidate != null) {
      placed.add(candidate);
      for (var i = 0; i < candidate.cells.length; i++) {
        grid[candidate.cells[i]] = answer.word[i];
      }
    }
  }
  return placed;
}

// Her yeni çengel bölümü için önceden denetlenmiş yerleşimler.
// Kelime indeksi, satır, sütun, dikey.
const extraArrowLayouts = <List<(int, int, int, bool)>>[
  // Bölüm 2: Çengel ekranını aşağı doğru dolduran daha uzun düzen.
  [
    (0, 1, 1, false),
    (1, 2, 1, false),
    (6, 3, 1, false),
    (3, 4, 1, false),
    (9, 5, 1, false),
    (7, 6, 1, false),
    (4, 7, 1, false),
    (5, 8, 1, false),
    (2, 9, 1, false),
    (8, 10, 1, false),
  ],
  [
    (0, 3, 4, true),
    (5, 9, 2, false),
    (4, 6, 4, false),
    (3, 3, 7, true),
    (6, 4, 1, false),
    (9, 1, 2, true),
    (2, 7, 2, true),
    (8, 8, 6, true),
    (7, 8, 1, false),
  ],
  [
    (0, 3, 4, true),
    (4, 7, 4, false),
    (5, 3, 1, false),
    (2, 2, 6, true),
    (7, 9, 4, false),
    (3, 3, 10, true),
    (1, 5, 1, false),
    (9, 5, 2, true),
  ],
  [
    (0, 4, 11, true),
    (2, 5, 9, false),
    (3, 9, 9, false),
    (9, 2, 9, true),
    (8, 3, 5, false),
    (6, 6, 7, false),
    (1, 3, 5, true),
  ],
  [
    (6, 6, 6, true),
    (9, 6, 4, false),
    (7, 10, 5, false),
    (1, 1, 5, true),
    (5, 1, 1, false),
    (2, 3, 4, false),
    (3, 7, 10, true),
    (0, 1, 2, true),
    (4, 2, 7, true),
  ],
  [
    (8, 4, 4, true),
    (6, 4, 2, false),
    (4, 1, 6, true),
    (2, 7, 1, false),
    (9, 5, 6, false),
    (5, 5, 1, true),
    (0, 1, 6, false),
    (7, 5, 8, true),
    (1, 3, 6, false),
  ],
  [
    (4, 10, 2, false),
    (8, 8, 5, true),
    (6, 8, 4, false),
    (2, 6, 7, true),
    (1, 6, 7, false),
    (7, 5, 10, true),
    (3, 6, 2, true),
    (9, 7, 1, false),
  ],
  [
    (7, 2, 8, true),
    (9, 8, 7, false),
    (0, 6, 3, false),
    (2, 2, 5, false),
    (3, 3, 4, true),
    (5, 8, 9, true),
    (1, 6, 5, true),
    (4, 4, 3, false),
    (8, 10, 3, false),
    (6, 4, 11, true),
  ],
  [
    (9, 3, 6, true),
    (3, 4, 4, false),
    (8, 2, 4, true),
    (7, 1, 8, true),
    (2, 2, 7, false),
    (4, 6, 1, false),
    (6, 3, 1, false),
    (1, 1, 10, true),
    (5, 6, 2, true),
  ],
  [
    (6, 7, 5, false),
    (9, 1, 5, true),
    (3, 4, 2, false),
    (1, 6, 9, true),
    (5, 11, 5, false),
    (7, 2, 4, false),
    (0, 4, 11, true),
    (2, 6, 1, false),
    (8, 9, 5, false),
  ],
];

// Kare Bulmaca için özellikle 2. ve 3. bölümler daha dolu, numaralandırılmış ve
// referans görsele yakın bir düzende hazırlanır.
const extraKareLayouts = <List<(int, int, int, bool)>>[
  [
    (4, 0, 6, true),
    (3, 1, 3, false),
    (6, 2, 0, true),
    (0, 3, 4, true),
    (1, 4, 1, false),
    (5, 5, 1, false),
    (2, 6, 0, false),
    (7, 7, 2, false),
    (8, 1, 7, true),
  ],
  [
    (9, 0, 4, false),
    (8, 1, 0, false),
    (3, 1, 2, true),
    (4, 1, 4, true),
    (6, 1, 6, true),
    (7, 6, 7, true),
    (5, 2, 7, true),
    (0, 4, 1, false),
  ],
];

class ExtraSearchBoard {
  final List<String> grid;
  final List<(String, int, int, int, int)> entries;
  const ExtraSearchBoard(this.grid, this.entries);
}

const extraSearchColumns = 10;
const extraSearchRows = 12;

ExtraSearchBoard makeExtraSearch(ExtraPack pack, int level) {
  const rows = extraSearchRows;
  const columns = extraSearchColumns;
  const alphabet = 'ABCÇDEFGĞHIİJKLMNOÖPRSŞTUÜVYZ';
  final matrix = List.generate(rows, (r) => List.generate(columns, (c) => ''));
  final entries = <(String, int, int, int, int)>[];
  const directions = [
    (0, 1),
    (1, 0),
    (1, 1),
    (-1, 1),
    (0, -1),
    (-1, 0),
    (-1, -1),
    (1, -1),
  ];
  for (final item in pack.words) {
    final word = trUpper(item.word);
    if (word.length > math.max(rows, columns)) {
      continue;
    }
    bool fitted = false;
    for (var tries = 0; tries < rows * columns * 8 && !fitted; tries++) {
      final index =
          (tries * 37 + level * 13 + entries.length * 29) %
          (rows * columns * 8);
      final dir = directions[index % 8];
      final r = (index ~/ 8) % rows, c = (index ~/ (8 * rows)) % columns;
      var ok = true;
      for (var i = 0; i < word.length; i++) {
        final y = r + i * dir.$1, x = c + i * dir.$2;
        if (y < 0 ||
            y >= rows ||
            x < 0 ||
            x >= columns ||
            (matrix[y][x].isNotEmpty && matrix[y][x] != word[i])) {
          ok = false;
          break;
        }
      }
      if (ok) {
        for (var i = 0; i < word.length; i++) {
          matrix[r + i * dir.$1][c + i * dir.$2] = word[i];
        }
        entries.add((word, r, c, dir.$1, dir.$2));
        fitted = true;
      }
    }
  }
  for (var r = 0; r < rows; r++) {
    for (var c = 0; c < columns; c++) {
      if (matrix[r][c].isEmpty) {
        matrix[r][c] =
            alphabet[(r * 17 + c * 19 + level * 23) % alphabet.length];
      }
    }
  }
  return ExtraSearchBoard(matrix.map((r) => r.join()).toList(), entries);
}

// Her ek Sudoku için geçerli ve birbirinden farklı bir çözüm üretir.
// Satır bantları, sütun yığınları ve rakam isimleri Sudoku kurallarını korur.
const extraSudokuBase = <String>[
  '534678912',
  '672195348',
  '198342567',
  '859761423',
  '426853791',
  '713924856',
  '961537284',
  '287419635',
  '345286179',
];
const extraSudokuMask = <String>[
  '530070000',
  '600195000',
  '098000060',
  '800060003',
  '400803001',
  '700020006',
  '060000280',
  '000419005',
  '000080079',
];

int extraSudokuRow(int level, int row) => (row + 3 * (level % 3)) % 9;
int extraSudokuColumn(int level, int column) {
  final offset = (level - 2) ~/ 9 == 1 ? 2 - column % 3 : column % 3;
  return column ~/ 3 * 3 + offset;
}

List<List<int>> extraSudokuSolution(int level) {
  final shift = (level - 2) % 9;
  return List.generate(
    9,
    (r) => List.generate(9, (c) {
      final value = int.parse(
        extraSudokuBase[extraSudokuRow(level, r)][extraSudokuColumn(level, c)],
      );
      return (value + shift - 1) % 9 + 1;
    }),
  );
}

List<List<bool>> extraSudokuFixed(int level) => List.generate(
  9,
  (r) => List.generate(
    9,
    (c) =>
        extraSudokuMask[extraSudokuRow(level, r)][extraSudokuColumn(
          level,
          c,
        )] !=
        '0',
  ),
);

class ExtraLevelScreen extends StatefulWidget {
  final Puzzle puzzle;
  final int level;
  const ExtraLevelScreen({
    super.key,
    required this.puzzle,
    required this.level,
  });
  @override
  State<ExtraLevelScreen> createState() => _ExtraLevelScreenState();
}

class _ExtraLevelScreenState extends State<ExtraLevelScreen> {
  late final pack = extraPacks[widget.level - 2];
  late final cross = makeCrosswords(pack, arrow: widget.puzzle.id == 'cengel');
  late final search = makeExtraSearch(pack, widget.level);
  final entered = <String, String>{};
  final discovered = <String>{};
  int active = 0, selected = 0;
  (int, int)? searchStart;
  bool done = false, ready = false;
  String get saveKey => 'extra_${widget.puzzle.id}_${widget.level}';
  String get type => widget.puzzle.id;
  int get size => 12;

  @override
  void initState() {
    super.initState();
    restore();
  }

  Future<void> restore() async {
    final raw = await Store.read(saveKey);
    if (raw != null) {
      try {
        final json = jsonDecode(raw) as Map<String, dynamic>;
        final values = json['entered'];
        if (values is Map) {
          for (final e in values.entries) {
            entered['${e.key}'] = '${e.value}';
          }
        }
        final words = json['found'];
        if (words is List) {
          discovered.addAll(words.map((e) => '$e'));
        }
      } catch (_) {}
    }
    done = await Store.read('chapter_${type}_${widget.level}') == '1';
    if (mounted) {
      setState(() => ready = true);
    }
  }

  void save() => Store.write(
    saveKey,
    jsonEncode({'entered': entered, 'found': discovered.toList()}),
  );
  Future<void> complete() async {
    if (done) {
      return;
    }
    await Store.write('chapter_${type}_${widget.level}', '1');
    if (!mounted) {
      return;
    }
    setState(() => done = true);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Tebrikler! Bölüm tamamlandı.')));
  }

  void feedback(bool correct) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          correct
              ? 'Tebrikler, bütün cevaplar doğru!'
              : 'Bazı cevaplar eksik veya yanlış.',
        ),
      ),
    );
    if (correct) {
      complete();
    }
  }

  void put(String letter, String key) {
    setState(() => entered[key] = letter);
    save();
  }

  Widget keyboard(void Function(String) onLetter, VoidCallback onDelete) =>
      LetterKeyboard(onLetter: onLetter, onDelete: onDelete);

  @override
  Widget build(BuildContext context) {
    if (type == 'cengel' || type == 'kare' || type == 'resim') {
      return Scaffold(
        appBar: AppBar(title: Text('${widget.puzzle.name} • ${widget.level}')),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: type != 'resim'
                    ? CrossGame(
                        arrow: type == 'cengel',
                        level: widget.level,
                        onSolved: complete,
                      )
                    : PictureGame(level: widget.level, onSolved: complete),
              ),
              if (done)
                const Padding(
                  padding: EdgeInsets.all(4),
                  child: Text(
                    'Bölüm tamamlandı!',
                    style: TextStyle(color: green, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ),
      );
    }
    final isCross = type == 'kare';
    return Scaffold(
      appBar: AppBar(title: Text('${widget.puzzle.name} • ${widget.level}')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: EditionHeading(
                label:
                    'SAYI ${widget.level.toString().padLeft(3, '0')} • ${pack.title.toUpperCase()}',
              ),
            ),
            if (!ready)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (type == 'cengel')
              Expanded(
                child: CrossGame(
                  arrow: true,
                  level: widget.level,
                  onSolved: complete,
                ),
              )
            else if (type == 'resim')
              Expanded(
                child: PictureGame(level: widget.level, onSolved: complete),
              )
            else
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(10),
                  child: type == 'sudoku'
                      ? sudokuView()
                      : type == 'av'
                      ? searchView()
                      : type == 'sarmal'
                      ? spiralView()
                      : crossView(),
                ),
              ),
            if (done)
              Container(
                color: const Color(0xFFDDEADB),
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: green),
                    const SizedBox(width: 8),
                    const Expanded(child: Text('Bölüm tamamlandı!')),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Bölümlere dön'),
                    ),
                  ],
                ),
              ),
            if (ready && (isCross || type == 'sarmal'))
              keyboard(
                (letter) {
                  if (isCross) {
                    if (cross.isEmpty) {
                      return;
                    }
                    final w = cross[active];
                    final p = w.cells[selected];
                    put(letter, '${p.$1},${p.$2}');
                    if (selected < w.cells.length - 1) {
                      setState(() => selected++);
                    }
                  } else {
                    final answerLength = pack.words.fold<int>(
                      0,
                      (total, word) => total + trUpper(word.word).length,
                    );
                    put(letter, '$selected');
                    if (selected < answerLength - 1) {
                      setState(() => selected++);
                    }
                  }
                },
                () {
                  if (isCross) {
                    if (cross.isEmpty) {
                      return;
                    }
                    final p = cross[active].cells[selected];
                    setState(() => entered.remove('${p.$1},${p.$2}'));
                  } else {
                    setState(() => entered.remove('$selected'));
                  }
                  save();
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget crossView() {
    if (cross.isEmpty) {
      return const Center(child: Text('Bu bölümün ızgarası oluşturulamadı.'));
    }
    final letters = <(int, int), String>{};
    for (final w in cross) {
      for (var i = 0; i < w.cells.length; i++) {
        letters[w.cells[i]] = w.answer.word[i];
      }
    }
    final hintCells = <(int, int), String>{};
    if (type == 'cengel') {
      for (final w in cross) {
        final p = (w.row - (w.vertical ? 1 : 0), w.col - (w.vertical ? 0 : 1));
        final previous = hintCells[p];
        final next = '${w.answer.clue} ${w.vertical ? '↓' : '→'}';
        hintCells[p] = previous == null ? next : '$previous\n$next';
      }
    }
    final clueNumbers = <ExtraPlacedWord, int>{};
    if (type == 'kare') {
      final ordered = [...cross]
        ..sort((a, b) {
          final byRow = a.row.compareTo(b.row);
          return byRow != 0 ? byRow : a.col.compareTo(b.col);
        });
      for (var i = 0; i < ordered.length; i++) {
        clueNumbers[ordered[i]] = i + 1;
      }
    }
    void check() {
      feedback(
        letters.entries.every(
          (e) => entered['${e.key.$1},${e.key.$2}'] == e.value,
        ),
      );
    }

    late final int firstRow;
    late final int lastRow;
    late final int firstCol;
    late final int lastCol;
    if (type == 'kare') {
      firstRow = 0;
      firstCol = 0;
      if (widget.level == 2) {
        lastRow = 8;
        lastCol = 8;
      } else if (widget.level == 3) {
        lastRow = 8;
        lastCol = 8;
      } else {
        final rows = letters.keys.map((p) => p.$1);
        final cols = letters.keys.map((p) => p.$2);
        lastRow = rows.reduce(math.max);
        lastCol = cols.reduce(math.max);
      }
    } else {
      final allPositions = <(int, int)>{...letters.keys, ...hintCells.keys};
      firstRow = allPositions.map((p) => p.$1).reduce(math.min);
      lastRow = allPositions.map((p) => p.$1).reduce(math.max);
      firstCol = allPositions.map((p) => p.$2).reduce(math.min);
      lastCol = allPositions.map((p) => p.$2).reduce(math.max);
    }
    final rowCount = lastRow - firstRow + 1;
    final colCount = lastCol - firstCol + 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${cross.length} ipucu • Harfe dokun, kelimeyi doldur.',
          style: const TextStyle(fontSize: 13),
        ),
        const SizedBox(height: 8),
        AspectRatio(
          aspectRatio: colCount / rowCount,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: rowCount * colCount,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: colCount,
            ),
            itemBuilder: (context, i) {
              final r = firstRow + i ~/ colCount,
                  c = firstCol + i % colCount,
                  p = (r, c),
                  letter = letters[p],
                  hint = hintCells[p];
              final activeCells = cross[active].cells;
              final highlighted = activeCells.contains(p);
              if (type == 'kare') {
                final hasLetter = letter != null;
                final wordIndex = cross.indexWhere(
                  (w) => w.row == r && w.col == c,
                );
                final word = wordIndex >= 0 ? cross[wordIndex] : null;
                final number = word == null ? null : clueNumbers[word];
                return InkWell(
                  key: ValueKey('extra_cross_cell_$r,$c'),
                  onTap: !hasLetter
                      ? null
                      : () {
                          final index = cross.indexWhere(
                            (w) => w.cells.contains(p),
                          );
                          if (index >= 0) {
                            setState(() {
                              active = index;
                              selected = cross[index].cells.indexOf(p);
                            });
                          }
                        },
                  child: Container(
                    decoration: BoxDecoration(
                      color: hasLetter
                          ? (highlighted ? selectedPaper : Colors.white)
                          : ink,
                      border: Border.all(color: rule, width: .55),
                    ),
                    child: Stack(
                      children: [
                        if (number != null)
                          Positioned(
                            top: 2,
                            left: 3,
                            child: Text(
                              '$number',
                              style: const TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        Center(
                          child: Text(
                            hasLetter ? (entered['$r,$c'] ?? '') : '',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return InkWell(
                key: hint != null
                    ? ValueKey(
                        'arrow_clue_${cross.indexWhere((w) => (w.row - (w.vertical ? 1 : 0), w.col - (w.vertical ? 0 : 1)) == p)}',
                      )
                    : ValueKey('extra_cross_cell_$r,$c'),
                onTap: letter == null && hint == null
                    ? null
                    : () {
                        if (hint != null) {
                          final indices = <int>[
                            for (var j = 0; j < cross.length; j++)
                              if ((
                                    cross[j].row - (cross[j].vertical ? 1 : 0),
                                    cross[j].col - (cross[j].vertical ? 0 : 1),
                                  ) ==
                                  p)
                                j,
                          ];
                          if (indices.isNotEmpty) {
                            setState(() {
                              active = indices.contains(active)
                                  ? indices[(indices.indexOf(active) + 1) %
                                        indices.length]
                                  : indices.first;
                              selected = 0;
                            });
                          }
                        } else {
                          final index = cross.indexWhere(
                            (w) => w.cells.contains(p),
                          );
                          if (index >= 0) {
                            setState(() {
                              active = index;
                              selected = cross[index].cells.indexOf(p);
                            });
                          }
                        }
                      },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: hint != null
                        ? const Color(0xFFE8E3D7)
                        : letter == null
                        ? ink
                        : highlighted
                        ? selectedPaper
                        : Colors.white,
                    border: Border.all(color: rule, width: .35),
                  ),
                  child: hint != null
                      ? FittedBox(
                          fit: BoxFit.scaleDown,
                          child: SizedBox(
                            width: 45,
                            child: Text(
                              hint,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      : letter == null
                      ? null
                      : Text(
                          entered['$r,$c'] ?? '',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'SEÇİLEN SORU: ${cross[active].answer.clue}',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 5),
        Text(
          '${cross[active].answer.word.length} harf • ${cross[active].vertical ? 'Dikey' : 'Yatay'}',
        ),
        const Divider(),
        ...List.generate(
          cross.length,
          (i) => InkWell(
            key: ValueKey('extra_cross_clue_$i'),
            onTap: () => setState(() {
              active = i;
              selected = 0;
            }),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(
                '${(type == 'kare' ? '${clueNumbers[cross[i]]}. ' : '${i + 1}. ')}${cross[i].answer.clue} (${cross[i].answer.word.length})',
                style: TextStyle(
                  fontWeight: i == active ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        FilledButton(
          onPressed: check,
          child: const Text('Cevapları kontrol et'),
        ),
      ],
    );
  }

  Widget sudokuView() {
    final solved = extraSudokuSolution(widget.level);
    final fixed = extraSudokuFixed(widget.level);
    final key = '$active,$selected';
    final chosen = (active, selected);
    void setNumber(int n) {
      if (fixed[chosen.$1][chosen.$2]) {
        return;
      }
      if (n == 0) {
        setState(() => entered.remove(key));
        save();
      } else {
        put('$n', key);
      }
    }

    void check() {
      feedback(
        List.generate(
          9,
          (r) => List.generate(
            9,
            (c) =>
                fixed[r][c] ||
                int.tryParse(entered['$r,$c'] ?? '') == solved[r][c],
          ).every((ok) => ok),
        ).every((ok) => ok),
      );
    }

    return Column(
      children: [
        const Text(
          'Her satır, sütun ve 3×3 alanda 1–9 yalnız bir kez kullanılır.',
        ),
        const SizedBox(height: 12),
        AspectRatio(
          aspectRatio: 1,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 81,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 9,
            ),
            itemBuilder: (context, i) {
              final r = i ~/ 9, c = i % 9, isFixed = fixed[r][c];
              return InkWell(
                key: ValueKey('extra_sudoku_$r,$c'),
                onTap: () => setState(() {
                  active = r;
                  selected = c;
                }),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: active == r && selected == c
                        ? selectedPaper
                        : Colors.white,
                    border: Border(
                      left: BorderSide(color: ink, width: c % 3 == 0 ? 2 : .3),
                      top: BorderSide(color: ink, width: r % 3 == 0 ? 2 : .3),
                      right: BorderSide(color: ink, width: c == 8 ? 2 : .3),
                      bottom: BorderSide(color: ink, width: r == 8 ? 2 : .3),
                    ),
                  ),
                  child: Text(
                    isFixed ? '${solved[r][c]}' : (entered['$r,$c'] ?? ''),
                    style: TextStyle(
                      fontWeight: isFixed ? FontWeight.bold : FontWeight.normal,
                      fontSize: 18,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 5,
          children: List.generate(
            9,
            (i) => OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(38, 42),
                padding: EdgeInsets.zero,
              ),
              onPressed: () => setNumber(i + 1),
              child: Text('${i + 1}', key: ValueKey('extra_number_${i + 1}')),
            ),
          ),
        ),
        TextButton.icon(
          onPressed: () => setNumber(0),
          icon: const Icon(Icons.backspace),
          label: const Text('Sil'),
        ),
        FilledButton(onPressed: check, child: const Text('Sudoku kontrol et')),
      ],
    );
  }

  Widget searchView() {
    final entries = search.entries;
    final used = <String>{};
    for (final entry in entries) {
      if (!discovered.contains(entry.$1)) {
        continue;
      }
      for (var i = 0; i < entry.$1.length; i++) {
        used.add('${entry.$2 + i * entry.$4},${entry.$3 + i * entry.$5}');
      }
    }
    final rows = search.grid.length;
    final cols = search.grid.first.length;
    void selectCell(int r, int c) {
      if (searchStart == null) {
        setState(() => searchStart = (r, c));
        return;
      }
      final start = searchStart!;
      String? foundWord;
      for (final e in entries) {
        final end = (
          e.$2 + (e.$1.length - 1) * e.$4,
          e.$3 + (e.$1.length - 1) * e.$5,
        );
        if ((start == (e.$2, e.$3) && (r, c) == end) ||
            (start == end && (r, c) == (e.$2, e.$3))) {
          foundWord = e.$1;
          break;
        }
      }
      setState(() {
        searchStart = null;
        if (foundWord != null) {
          discovered.add(foundWord);
        }
      });
      if (foundWord != null) {
        save();
        if (discovered.length == entries.length) {
          complete();
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Kelimenin ilk ve son harfine dokun. Yatay, dikey ve çapraz kelimeleri bul.',
        ),
        const SizedBox(height: 12),
        AspectRatio(
          aspectRatio: cols / rows,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: rows * cols,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
            ),
            itemBuilder: (context, i) {
              final r = i ~/ cols, c = i % cols;
              return InkWell(
                key: ValueKey('search_$r,$c'),
                onTap: () => selectCell(r, c),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: searchStart == (r, c)
                        ? selectedPaper
                        : used.contains('$r,$c')
                        ? const Color(0xFFD1E2C7)
                        : Colors.white,
                    border: Border.all(color: rule, width: .25),
                  ),
                  child: FittedBox(
                    child: Text(
                      search.grid[r][c],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 14,
          runSpacing: 12,
          children: [
            for (final e in entries)
              Text(
                e.$1,
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: discovered.contains(e.$1) ? green : ink,
                  decoration: discovered.contains(e.$1)
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          '${discovered.length} / ${entries.length} kelime bulundu',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget spiralView() {
    final words = pack.words
        .map((e) => ExtraAnswer(trUpper(e.word), e.clue))
        .toList();
    final answer = words.map((e) => e.word).join();
    final cells = spiralPositions(12);
    final shown = math.min(answer.length, cells.length);
    final path = <(int, int), int>{for (var i = 0; i < shown; i++) cells[i]: i};
    void check() => feedback(
      answer.length <= cells.length &&
          List.generate(
            answer.length,
            (i) => entered['$i'] == answer[i],
          ).every((v) => v),
    );
    return Column(
      children: [
        const Text(
          'Dıştan merkeze doğru ilerle. İpuçlarının cevapları peş peşe yazılır.',
        ),
        const SizedBox(height: 12),
        AspectRatio(
          aspectRatio: 1,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 144,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 12,
            ),
            itemBuilder: (context, i) {
              final r = i ~/ 12, c = i % 12, index = path[(r, c)];
              return InkWell(
                onTap: index == null
                    ? null
                    : () => setState(() => selected = index),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: index == null
                        ? ink
                        : index == selected
                        ? selectedPaper
                        : Colors.white,
                    border: Border.all(color: rule, width: .4),
                  ),
                  child: index == null
                      ? null
                      : Text(
                          entered['$index'] ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        ...words.map(
          (w) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Text(
              '• ${w.clue} (${w.word.length})',
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ),
        const SizedBox(height: 12),
        FilledButton(onPressed: check, child: const Text('Sarmalı kontrol et')),
      ],
    );
  }

  Widget pictureView() {
    const icons = [
      '🌳',
      '🌍',
      '🐙',
      '🗺️',
      '🔬',
      '🎨',
      '🏛️',
      '🏆',
      '💻',
      '🍞',
    ];
    final list = pack.words.take(5).toList();
    void check() => feedback(
      List.generate(
        list.length,
        (i) =>
            trUpper((entered['answer_$i'] ?? '').trim()) ==
            trUpper(list[i].word),
      ).every((x) => x),
    );
    return Column(
      children: [
        Text(icons[widget.level - 2], style: const TextStyle(fontSize: 82)),
        Text(
          '${pack.title} temalı resimli kelime oyunu',
          style: const TextStyle(
            fontFamily: 'serif',
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...List.generate(
          list.length,
          (i) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: TextFormField(
              key: ValueKey('picture_answer_$i'),
              initialValue: entered['answer_$i'] ?? '',
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: '${i + 1}. ${list[i].clue} (${list[i].word.length})',
              ),
              onChanged: (v) {
                entered['answer_$i'] = v;
                save();
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: check,
          child: const Text('Cevapları kontrol et'),
        ),
        if (done)
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              pack.fact,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: green,
              ),
            ),
          ),
      ],
    );
  }
}
