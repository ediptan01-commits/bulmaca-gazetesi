part of 'main.dart';

// İki bağımsız, kesişimleri ve boşlukları doğrulanmış çapraz bulmaca.

const freeCrossLevel1 = <WordEntry>[
  WordEntry("KELEBEK", "Renkli kanatları olan böcek", 14, 8, false),
  WordEntry("DENİZ", "Büyük tuzlu su kütlesi", 13, 13, true),
  WordEntry("FİDAN", "Yeni yetişen ağaç", 16, 12, false),
  WordEntry("MEŞE", "Palamut veren ağaç", 13, 9, true),
  WordEntry("YAPRAK", "Ağacın yeşil bölümü", 15, 15, true),
  WordEntry("ÇİÇEK", "Bitkinin renkli üreme organı", 20, 11, false),
  WordEntry("GÜNEŞ", "Dünyamızı aydınlatan yıldız", 11, 11, true),
  WordEntry("ORMAN", "Ağaçlarla kaplı geniş alan", 18, 14, false),
  WordEntry("ÇAM", "İğne yapraklı ağaç", 17, 17, true),
  WordEntry("RÜZGAR", "Hareket eden hava", 11, 8, false),
  WordEntry("NEHİR", "Büyük akarsu", 7, 13, true),
  WordEntry("TOHUM", "Yeni bir bitkiyi oluşturacak tane", 9, 11, false),
  WordEntry("YAĞMUR", "Buluttan düşen su", 6, 8, true),
  WordEntry("PAPATYA", "Sarı göbekli, beyaz yapraklı çiçek", 7, 5, false),
  WordEntry("TOPRAK", "Bitkilerin kök saldığı katman", 5, 5, true),
  WordEntry("KARINCA", "Koloniler hâlinde yaşayan çalışkan böcek", 1, 11, true),
  WordEntry("BULUT", "Gökyüzündeki su damlacıkları topluluğu", 5, 1, false),
  WordEntry("GÖL", "Karalarla çevrili su kütlesi", 3, 3, true),
];

const freeCrossLevel2 = <WordEntry>[
  WordEntry("BİLGİSAYAR", "Verileri işleyen elektronik aygıt", 15, 1, false),
  WordEntry("TİYATRO", "Sahnede oynanan gösteri sanatı", 12, 7, true),
  WordEntry("KALEM", "Yazı yazmaya yarayan araç", 13, 3, true),
  WordEntry("OKUL", "Eğitim verilen kurum", 18, 7, false),
  WordEntry("MÜZİK", "Seslerle yapılan sanat", 12, 5, true),
  WordEntry("SANAT", "Duygu ve düşüncelerin estetik anlatımı", 12, 9, true),
  WordEntry("KEMAN", "Yayla çalınan dört telli çalgı", 18, 8, true),
  WordEntry("ÇANTA", "Eşya taşımaya yarayan aksesuar", 21, 4, false),
  WordEntry("KİTAP", "Okumak için sayfalarını çevirdiğimiz eser", 18, 5, true),
  WordEntry("ŞİİR", "Dizelerle yazılan edebî tür", 19, 3, false),
  WordEntry("SINIF", "Öğrencilerin ders gördüğü oda", 12, 9, false),
  WordEntry("ROMAN", "Uzun kurmaca anlatı", 8, 11, true),
  WordEntry("ÖĞRENCİ", "Bir eğitim kurumunda öğrenim gören kişi", 8, 9, false),
  WordEntry("DEFTER", "Yazı yazılan boş sayfalı araç", 10, 13, true),
  WordEntry("TAHTA", "Sınıfta üzerine yazı yazılan yüzey", 13, 13, false),
  WordEntry(
    "GAZETE",
    "Günlük haberlerin yayımlandığı basılı yayın",
    9,
    16,
    true,
  ),
  WordEntry("ÖĞRETMEN", "Ders veren eğitimci", 1, 13, true),
  WordEntry("KÜTÜPHANE", "Kitapların toplandığı ve okunduğu yer", 4, 5, false),
];

List<WordEntry> freeCrossWordsForLevel(int level) =>
    level == 1 ? freeCrossLevel1 : freeCrossLevel2;

int freeCrossRows(List<WordEntry> words) =>
    words.fold<int>(
      0,
      (n, w) => math.max(n, w.r + (w.vertical ? w.text.length : 1)),
    ) +
    1;
int freeCrossColumns(List<WordEntry> words) =>
    words.fold<int>(
      0,
      (n, w) => math.max(n, w.c + (w.vertical ? 1 : w.text.length)),
    ) +
    1;

class FreeCrossCollectionCard extends StatelessWidget {
  const FreeCrossCollectionCard({super.key});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFFF4C6), Color(0xFFFFCE69)],
      ),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: Colors.white, width: 3),
      boxShadow: const [
        BoxShadow(
          color: Color(0x66001964),
          blurRadius: 6,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      children: [
        const Expanded(
          child: CustomPaint(
            painter: _FreeCrossThumbnail(),
            child: SizedBox.expand(),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Çapraz Bulmaca',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: dashboardNavy,
            fontSize: 21,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Numaraları izle, kelimeleri birleştir!',
          textAlign: TextAlign.center,
          style: TextStyle(color: dashboardNavy, fontSize: 13),
        ),
        const SizedBox(height: 8),
        const Text(
          '2 bölüm',
          style: TextStyle(color: dashboardNavy, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}

class _FreeCrossThumbnail extends CustomPainter {
  const _FreeCrossThumbnail();
  @override
  void paint(Canvas canvas, Size size) {
    final words = freeCrossLevel1;
    final unit = math.min(
      size.width / freeCrossColumns(words),
      size.height / freeCrossRows(words),
    );
    final offset = Offset(
      (size.width - unit * freeCrossColumns(words)) / 2,
      (size.height - unit * freeCrossRows(words)) / 2,
    );
    final cells = words.expand((w) => w.cells).toSet();
    for (final p in cells) {
      final rect = Rect.fromLTWH(
        offset.dx + p.$2 * unit,
        offset.dy + p.$1 * unit,
        unit,
        unit,
      );
      canvas.drawRect(rect, Paint()..color = Colors.white);
      canvas.drawRect(
        rect,
        Paint()
          ..color = dashboardBlue
          ..style = PaintingStyle.stroke
          ..strokeWidth = .6,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _FreeCrossThumbnail oldDelegate) => false;
}
