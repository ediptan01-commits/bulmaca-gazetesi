part of 'main.dart';

// İki bağımsız, kesişimleri ve boşlukları doğrulanmış çapraz bulmaca.

const freeCrossLevel1 = <WordEntry>[
  WordEntry("KELEBEK", "Renkli kanatları olan böcek", 5, 6, false),
  WordEntry("GÖL", "Karalarla çevrili su kütlesi", 3, 8, true),
  WordEntry("GÜNEŞ", "Dünyamızı aydınlatan yıldız", 3, 8, false),
  WordEntry("ÇİÇEK", "Bitkinin renkli üreme organı", 1, 6, true),
  WordEntry("KARINCA", "Koloniler hâlinde yaşayan çalışkan böcek", 5, 12, true),
  WordEntry("DENİZ", "Büyük tuzlu su kütlesi", 9, 10, false),
  WordEntry("MEŞE", "Palamut veren ağaç", 2, 11, true),
  WordEntry("PAPATYA", "Sarı göbekli, beyaz yapraklı çiçek", 11, 6, false),
  WordEntry("TOHUM", "Yeni bir bitkiyi oluşturacak tane", 11, 10, true),
  WordEntry("NEHİR", "Büyük akarsu", 13, 8, false),
  WordEntry("YAĞMUR", "Buluttan düşen su", 7, 7, false),
  WordEntry("ÇAM", "İğne yapraklı ağaç", 1, 6, false),
  WordEntry("RÜZGAR", "Hareket eden hava", 7, 14, true),
  WordEntry("TOPRAK", "Bitkilerin kök saldığı katman", 9, 6, true),
  WordEntry("YAPRAK", "Ağacın yeşil bölümü", 14, 1, false),
  WordEntry("ORMAN", "Ağaçlarla kaplı geniş alan", 15, 8, false),
  WordEntry("FİDAN", "Yeni yetişen ağaç", 11, 2, true),
  WordEntry("BULUT", "Gökyüzündeki su damlacıkları topluluğu", 9, 2, false),
];

const freeCrossLevel2 = <WordEntry>[
  WordEntry("BİLGİSAYAR", "Verileri işleyen elektronik aygıt", 9, 2, false),
  WordEntry(
    "GAZETE",
    "Günlük haberlerin yayımlandığı basılı yayın",
    8,
    10,
    true,
  ),
  WordEntry("SINIF", "Öğrencilerin ders gördüğü oda", 9, 7, true),
  WordEntry("ŞİİR", "Dizelerle yazılan edebî tür", 8, 3, true),
  WordEntry("KEMAN", "Yayla çalınan dört telli çalgı", 13, 9, false),
  WordEntry("ÇANTA", "Eşya taşımaya yarayan aksesuar", 11, 13, true),
  WordEntry("ÖĞRENCİ", "Bir eğitim kurumunda öğrenim gören kişi", 3, 6, true),
  WordEntry("ROMAN", "Uzun kurmaca anlatı", 11, 3, false),
  WordEntry("TİYATRO", "Sahnede oynanan gösteri sanatı", 5, 1, false),
  WordEntry("KİTAP", "Okumak için sayfalarını çevirdiğimiz eser", 3, 1, true),
  WordEntry("OKUL", "Eğitim verilen kurum", 11, 4, true),
  WordEntry("ÖĞRETMEN", "Ders veren eğitimci", 3, 6, false),
  WordEntry("KALEM", "Yazı yazmaya yarayan araç", 14, 2, false),
  WordEntry("MÜZİK", "Seslerle yapılan sanat", 3, 11, true),
  WordEntry("SANAT", "Duygu ve düşüncelerin estetik anlatımı", 7, 4, false),
  WordEntry("KÜTÜPHANE", "Kitapların toplandığı ve okunduğu yer", 15, 7, false),
  WordEntry("DEFTER", "Yazı yazılan boş sayfalı araç", 11, 15, true),
  WordEntry("TAHTA", "Sınıfta üzerine yazı yazılan yüzey", 1, 4, true),
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
