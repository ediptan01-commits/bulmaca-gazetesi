part of 'main.dart';

class PictureClue {
  final String answer, hint;
  final int secretIndex;
  final Rect area;
  const PictureClue(this.answer, this.hint, this.secretIndex, this.area);
}

const pictureClues = [
  PictureClue(
    'GÜNEŞ',
    'Dünyamızı aydınlatan yıldız',
    0,
    Rect.fromLTWH(.04, .03, .24, .30),
  ),
  PictureClue(
    'AĞAÇ',
    'Gövdesi, dalları ve yaprakları var',
    0,
    Rect.fromLTWH(.02, .33, .32, .54),
  ),
  PictureClue(
    'ZARF',
    'Mektubun kâğıt kılıfı',
    0,
    Rect.fromLTWH(.39, .67, .25, .25),
  ),
  PictureClue(
    'EV',
    'İçinde yaşadığımız yapı',
    0,
    Rect.fromLTWH(.57, .23, .39, .44),
  ),
  PictureClue(
    'TOP',
    'Yuvarlak bir oyun aracı',
    0,
    Rect.fromLTWH(.76, .73, .20, .24),
  ),
  PictureClue(
    'KEDİ',
    'Miyavlayan evcil hayvan',
    1,
    Rect.fromLTWH(.30, .45, .24, .25),
  ),
];
String get pictureSecret =>
    pictureClues.map((c) => c.answer[c.secretIndex]).join();

class PictureGame extends StatefulWidget {
  final VoidCallback onSolved;
  final int level;
  const PictureGame({super.key, this.level = 1, required this.onSolved});
  @override
  State<PictureGame> createState() => _PictureGameState();
}

class _PictureGameState extends State<PictureGame> {
  List<PictureClue> get clues => pictureCluesForLevel(widget.level);
  String get saveKey =>
      widget.level == 1 ? 'picture_cipher' : 'picture_scene_${widget.level}';
  final answers = <int, String>{};
  final solved = <int>{};
  int active = 0, selected = 0;
  bool ready = false, hint = false;
  @override
  void initState() {
    super.initState();
    restore();
  }

  Future<void> restore() async {
    final raw = await Store.read(saveKey);
    if (!mounted) return;
    if (raw != null) {
      try {
        final data = jsonDecode(raw) as Map<String, dynamic>;
        for (var i = 0; i < clues.length; i++) {
          final value = data['$i'];
          if (value is String && value.length <= clues[i].answer.length) {
            answers[i] = value;
            if (value == clues[i].answer) solved.add(i);
          }
        }
      } catch (_) {
        /* Bozuk kayıt resmi ve soruları etkilemez. */
      }
    }
    setState(() {
      active = clues.indexWhere((c) => !solved.contains(clues.indexOf(c)));
      if (active < 0) active = 0;
      ready = true;
    });
  }

  void save() => Store.write(
    saveKey,
    jsonEncode({for (final e in answers.entries) '${e.key}': e.value}),
  );
  void choose(int index) => setState(() {
    active = index;
    selected = 0;
    hint = false;
  });
  void type(String value) {
    if (!ready || solved.contains(active)) return;
    setState(() {
      final chars = (answers[active] ?? '')
          .padRight(clues[active].answer.length, '_')
          .split('');
      chars[selected] = value;
      answers[active] = chars.join();
      if (selected < chars.length - 1) selected++;
    });
    save();
  }

  void erase() {
    if (!ready || solved.contains(active)) return;
    setState(() {
      final chars = (answers[active] ?? '')
          .padRight(clues[active].answer.length, '_')
          .split('');
      if (chars[selected] == '_' && selected > 0) selected--;
      chars[selected] = '_';
      answers[active] = chars.join();
    });
    save();
  }

  void check() {
    if (answers[active] != clues[active].answer) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Resimdeki nesnenin adını kutulara yaz.')),
      );
      return;
    }
    setState(() {
      solved.add(active);
      hint = false;
    });
    save();
    if (solved.length == clues.length) {
      widget.onSolved();
    } else {
      final next = List.generate(
        clues.length,
        (i) => i,
      ).firstWhere((i) => !solved.contains(i));
      choose(next);
    }
  }

  @override
  Widget build(BuildContext context) {
    final clue = clues[active],
        value = (answers[active] ?? '').padRight(clue.answer.length, '_');
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 10),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'RESİMLİ ŞİFRE',
                            style: TextStyle(
                              fontFamily: 'serif',
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Text('${solved.length} / ${clues.length}'),
                      ],
                    ),
                    const SizedBox(height: 6),
                    PictureScene(
                      level: widget.level,
                      active: active,
                      solved: solved,
                      onSelect: choose,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < clues.length; i++)
                          SizedBox(
                            width: 44,
                            height: 38,
                            child: TextButton(
                              key: ValueKey('picture_select_$i'),
                              onPressed: () => choose(i),
                              child: Text(
                                solved.contains(i) ? '✓' : '${i + 1}',
                                style: TextStyle(
                                  color: active == i ? rust : ink,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    Text(
                      '${active + 1}. resimdeki nesne • ${clue.answer.length} harf',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 5,
                      children: [
                        for (var i = 0; i < clue.answer.length; i++)
                          GestureDetector(
                            onTap: () => setState(() => selected = i),
                            child: Container(
                              key: ValueKey('picture_letter_$i'),
                              width: 40,
                              height: 44,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: solved.contains(active)
                                    ? const Color(0xFFCDDDC4)
                                    : selected == i
                                    ? selectedPaper
                                    : Colors.white,
                                border: Border.all(
                                  color: i == clue.secretIndex ? rust : rule,
                                  width: i == clue.secretIndex ? 2 : 1,
                                ),
                              ),
                              child: Text(
                                value[i] == '_' ? '' : value[i],
                                style: const TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      children: [
                        TextButton(
                          onPressed: () => setState(() => hint = !hint),
                          child: const Text('İpucu'),
                        ),
                        FilledButton(
                          onPressed: ready && !solved.contains(active)
                              ? check
                              : null,
                          child: Text(
                            solved.contains(active) ? 'Doğru ✓' : 'Kontrol et',
                          ),
                        ),
                      ],
                    ),
                    if (hint) Text(clue.hint, textAlign: TextAlign.center),
                    const Divider(color: rule),
                    const Text(
                      'Çerçeveli harflerden gizli sözcüğü bul.',
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < clues.length; i++)
                          Container(
                            width: 35,
                            height: 37,
                            margin: const EdgeInsets.all(2),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: solved.contains(i) ? selectedPaper : paper,
                              border: Border.all(color: ink),
                            ),
                            child: Text(
                              solved.contains(i)
                                  ? clues[i].answer[clues[i].secretIndex]
                                  : '·',
                              style: const TextStyle(
                                fontFamily: 'serif',
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (solved.length == clues.length)
                      Text(
                        'Şifre çözüldü: ${clues.map((c) => c.answer[c.secretIndex]).join()}',
                        style: const TextStyle(
                          color: green,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        LetterKeyboard(onLetter: type, onDelete: erase),
      ],
    );
  }
}

class PictureScene extends StatelessWidget {
  final int active;
  final int level;
  List<PictureClue> get clues => pictureCluesForLevel(level);
  final Set<int> solved;
  final ValueChanged<int> onSelect;
  const PictureScene({
    super.key,
    required this.active,
    this.level = 1,
    required this.solved,
    required this.onSelect,
  });
  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: 1.55,
    child: LayoutBuilder(
      builder: (context, constraints) => Container(
        decoration: BoxDecoration(border: Border.all(color: ink)),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: level == 1
                    ? _ParkScenePainter()
                    : _NewPictureScenePainter(level),
              ),
            ),
            for (var i = 0; i < clues.length; i++)
              Positioned.fromRect(
                rect: Rect.fromLTWH(
                  clues[i].area.left * constraints.maxWidth,
                  clues[i].area.top * constraints.maxHeight,
                  clues[i].area.width * constraints.maxWidth,
                  clues[i].area.height * constraints.maxHeight,
                ),
                child: Semantics(
                  label: '${i + 1}. görsel',
                  button: true,
                  child: GestureDetector(
                    key: ValueKey('picture_object_$i'),
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onSelect(i),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: active == i
                              ? rust
                              : solved.contains(i)
                              ? green
                              : ink,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          solved.contains(i) ? '✓' : '${i + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

class _ParkScenePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 600, size.height / 380);
    canvas.clipRect(const Rect.fromLTWH(0, 0, 600, 380));
    final outline = Paint()
      ..color = ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;
    void rect(Rect r, Color color, {double round = 0}) {
      final rr = RRect.fromRectAndRadius(r, Radius.circular(round));
      canvas.drawRRect(rr, Paint()..color = color);
      canvas.drawRRect(rr, outline);
    }

    void oval(Rect r, Color color) {
      canvas.drawOval(r, Paint()..color = color);
      canvas.drawOval(r, outline);
    }

    void line(Offset a, Offset b) => canvas.drawLine(a, b, outline);
    void shape(List<Offset> points, Color color) {
      final p = Path()..addPolygon(points, true);
      canvas.drawPath(p, Paint()..color = color);
      canvas.drawPath(p, outline);
    }

    canvas.drawRect(
      const Rect.fromLTWH(0, 0, 600, 380),
      Paint()..color = const Color(0xFFE4EFF0),
    );
    canvas.drawOval(
      const Rect.fromLTWH(-100, 220, 800, 300),
      Paint()..color = const Color(0xFFDCE3CA),
    );
    // Güneş ve ışınları.
    for (var i = 0; i < 12; i++) {
      final a = i * math.pi / 6;
      final v = Offset(math.cos(a), math.sin(a));
      line(const Offset(98, 68) + v * 39, const Offset(98, 68) + v * 49);
    }
    oval(const Rect.fromLTWH(68, 38, 60, 60), const Color(0xFFE6BC56));
    // Ağaç.
    rect(
      const Rect.fromLTWH(82, 199, 25, 114),
      const Color(0xFFB77B52),
      round: 3,
    );
    for (final r in [
      const Rect.fromLTWH(23, 150, 110, 92),
      const Rect.fromLTWH(82, 145, 100, 91),
      const Rect.fromLTWH(59, 111, 100, 96),
    ]) {
      oval(r, const Color(0xFF88A47C));
    }
    line(const Offset(94, 274), const Offset(122, 245));
    // Ev.
    rect(const Rect.fromLTWH(388, 145, 151, 109), const Color(0xFFF5E7CE));
    rect(const Rect.fromLTWH(498, 94, 19, 50), const Color(0xFFB66A50));
    shape(const [
      Offset(369, 148),
      Offset(463, 78),
      Offset(557, 148),
    ], const Color(0xFFB96D53));
    rect(const Rect.fromLTWH(445, 196, 34, 58), const Color(0xFFB68D64));
    rect(const Rect.fromLTWH(400, 166, 31, 32), const Color(0xFFA5C7D0));
    rect(const Rect.fromLTWH(495, 166, 31, 32), const Color(0xFFA5C7D0));
    line(const Offset(415, 166), const Offset(415, 198));
    line(const Offset(400, 182), const Offset(431, 182));
    // Kedi.
    oval(const Rect.fromLTWH(225, 208, 58, 48), const Color(0xFFD3A571));
    shape(const [
      Offset(218, 208),
      Offset(214, 178),
      Offset(237, 191),
    ], const Color(0xFFD3A571));
    shape(const [
      Offset(246, 191),
      Offset(267, 179),
      Offset(270, 212),
    ], const Color(0xFFD3A571));
    oval(const Rect.fromLTWH(214, 188, 59, 45), const Color(0xFFD3A571));
    oval(const Rect.fromLTWH(229, 204, 4, 5), ink);
    oval(const Rect.fromLTWH(251, 204, 4, 5), ink);
    line(const Offset(241, 216), const Offset(246, 216));
    canvas.drawPath(
      Path()
        ..moveTo(277, 240)
        ..quadraticBezierTo(316, 239, 295, 211),
      outline,
    );
    // Bank üzerindeki zarf.
    rect(const Rect.fromLTWH(230, 323, 170, 13), const Color(0xFFB68D64));
    line(const Offset(246, 336), const Offset(246, 369));
    line(const Offset(387, 336), const Offset(387, 369));
    rect(
      const Rect.fromLTWH(254, 277, 112, 57),
      const Color(0xFFFFFCF3),
      round: 2,
    );
    line(const Offset(255, 278), const Offset(310, 315));
    line(const Offset(365, 278), const Offset(310, 315));
    rect(const Rect.fromLTWH(346, 283, 12, 16), const Color(0xFFBE6A54));
    // Top.
    oval(const Rect.fromLTWH(482, 291, 66, 66), const Color(0xFFE6BC56));
    canvas.drawArc(
      const Rect.fromLTWH(493, 292, 32, 65),
      -math.pi / 2,
      math.pi,
      false,
      outline,
    );
    line(const Offset(485, 310), const Offset(541, 342));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ParkScenePainter old) => false;
}

const gardenPictureClues = [
  PictureClue(
    'BALON',
    'İçi havayla dolan, ipinden tutulan oyuncak',
    0,
    Rect.fromLTWH(.03, .04, .23, .43),
  ),
  PictureClue(
    'AĞAÇ',
    'Gövdesi ve dalları olan bitki',
    0,
    Rect.fromLTWH(.31, .05, .32, .52),
  ),
  PictureClue(
    'HAVUÇ',
    'Toprak altında yetişen turuncu sebze',
    0,
    Rect.fromLTWH(.72, .33, .22, .32),
  ),
  PictureClue(
    'ÇİÇEK',
    'Renkli yapraklarıyla açan bitki',
    0,
    Rect.fromLTWH(.03, .53, .24, .42),
  ),
  PictureClue(
    'ELMA',
    'Amasya ile anılan meyve',
    0,
    Rect.fromLTWH(.35, .65, .23, .29),
  ),
  PictureClue(
    'MANTAR',
    'Şapka biçimli başlığı olan canlı',
    0,
    Rect.fromLTWH(.70, .68, .26, .28),
  ),
];
const roomPictureClues = [
  PictureClue(
    'BALON',
    'İpi olan, havayla şişirilen oyuncak',
    0,
    Rect.fromLTWH(.03, .03, .23, .48),
  ),
  PictureClue(
    'İNCİ',
    'İstiridyeden çıkan değerli, yuvarlak süs',
    0,
    Rect.fromLTWH(.28, .65, .22, .28),
  ),
  PictureClue(
    'LAMBA',
    'Masayı aydınlatan elektrikli araç',
    0,
    Rect.fromLTWH(.50, .20, .23, .55),
  ),
  PictureClue(
    'GÜNEŞ',
    'Pencereden görünen yıldız',
    0,
    Rect.fromLTWH(.76, .03, .22, .35),
  ),
  PictureClue(
    'İPLİK',
    'Yumak hâlinde sarılmış ince dokuma lifi',
    0,
    Rect.fromLTWH(.73, .69, .23, .26),
  ),
  PictureClue(
    'NAR',
    'Kırmızı taneleri olan meyve',
    0,
    Rect.fromLTWH(.03, .70, .23, .25),
  ),
];
List<PictureClue> pictureCluesForLevel(int level) => switch (level) {
  2 => gardenPictureClues,
  3 => roomPictureClues,
  _ => pictureClues,
};

class _NewPictureScenePainter extends CustomPainter {
  final int level;
  const _NewPictureScenePainter(this.level);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 600, size.height / 380);
    final pen = Paint()
      ..color = ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    void oval(double x, double y, double w, double h, Color color) {
      final r = Rect.fromLTWH(x, y, w, h);
      canvas.drawOval(r, Paint()..color = color);
      canvas.drawOval(r, pen);
    }

    void rect(double x, double y, double w, double h, Color color) {
      final r = Rect.fromLTWH(x, y, w, h);
      canvas.drawRect(r, Paint()..color = color);
      canvas.drawRect(r, pen);
    }

    void line(double x, double y, double a, double b) =>
        canvas.drawLine(Offset(x, y), Offset(a, b), pen);
    void polygon(List<Offset> points, Color color) {
      final p = Path()..addPolygon(points, true);
      canvas.drawPath(p, Paint()..color = color);
      canvas.drawPath(p, pen);
    }

    // Ortak balon: her sahnede nesne kendi numarasından seçilebilir.
    canvas.drawRect(
      const Rect.fromLTWH(0, 0, 600, 380),
      Paint()
        ..color = level == 2
            ? const Color(0xFFE3F0EA)
            : const Color(0xFFF2E6D2),
    );
    if (level == 2) {
      canvas.drawOval(
        const Rect.fromLTWH(-120, 180, 850, 430),
        Paint()..color = const Color(0xFFDCE5C5),
      );
      rect(270, 145, 24, 95, const Color(0xFFAE805B));
      oval(205, 70, 100, 110, const Color(0xFF7C9F73));
      oval(260, 60, 95, 110, const Color(0xFF89AA79));
      oval(235, 30, 90, 110, const Color(0xFF9BB786));
      // Havuç ve yaprakları.
      polygon(const [
        Offset(452, 172),
        Offset(501, 192),
        Offset(452, 247),
      ], const Color(0xFFE99A47));
      line(468, 165, 472, 137);
      line(478, 172, 502, 149);
      line(459, 172, 447, 145);
      line(468, 195, 482, 201);
      // Çiçek.
      line(89, 274, 89, 350);
      oval(91, 309, 30, 14, const Color(0xFF88A47C));
      for (var i = 0; i < 6; i++) {
        final a = i * math.pi / 3;
        oval(
          77 + math.cos(a) * 23,
          260 + math.sin(a) * 23,
          28,
          28,
          const Color(0xFFD18C9B),
        );
      }
      oval(79, 264, 25, 25, const Color(0xFFE6BC56));
      // Elma.
      oval(236, 277, 49, 61, const Color(0xFFC56C57));
      oval(263, 277, 49, 61, const Color(0xFFC56C57));
      line(273, 283, 279, 264);
      oval(280, 260, 26, 12, const Color(0xFF88A47C));
      // Mantar.
      rect(481, 310, 22, 41, const Color(0xFFF5E7CE));
      final cap = Path()
        ..moveTo(447, 316)
        ..quadraticBezierTo(492, 242, 539, 316)
        ..close();
      canvas.drawPath(cap, Paint()..color = const Color(0xFFBD6D5B));
      canvas.drawPath(cap, pen);
      for (final p in [
        const Offset(475, 299),
        const Offset(501, 286),
        const Offset(518, 305),
      ]) {
        oval(p.dx, p.dy, 9, 9, paper);
      }
    } else {
      // Pencere ve çalışma masası.
      rect(448, 14, 139, 132, const Color(0xFFDCECF0));
      line(448, 144, 587, 144);
      oval(495, 39, 50, 50, const Color(0xFFE6BC56));
      for (var i = 0; i < 8; i++) {
        final a = i * math.pi / 4;
        line(
          520 + math.cos(a) * 32,
          64 + math.sin(a) * 32,
          520 + math.cos(a) * 39,
          64 + math.sin(a) * 39,
        );
      }
      rect(20, 287, 560, 18, const Color(0xFFB68D64));
      line(46, 305, 46, 378);
      line(552, 305, 552, 378);
      // Masa lambası.
      rect(332, 265, 75, 10, const Color(0xFF749C83));
      line(369, 265, 369, 181);
      polygon(const [
        Offset(345, 114),
        Offset(393, 114),
        Offset(420, 180),
        Offset(318, 180),
      ], const Color(0xFF88A47C));
      // İnci kolye.
      for (var i = 0; i < 13; i++) {
        final a = i * math.pi / 6;
        oval(
          225 + math.cos(a) * 40,
          306 + math.sin(a) * 22,
          12,
          12,
          const Color(0xFFFFFAF0),
        );
      }
      // İplik yumağı.
      oval(470, 300, 65, 49, const Color(0xFFB197BF));
      for (var i = 0; i < 4; i++) {
        line(480 + i * 9, 307, 500 + i * 7, 342);
      }
      canvas.drawPath(
        Path()
          ..moveTo(527, 332)
          ..quadraticBezierTo(569, 331, 557, 359),
        pen,
      );
      // Nar, ayırt edici taç ve görünür taneler.
      oval(52, 302, 65, 51, const Color(0xFFC36B60));
      polygon(const [
        Offset(76, 305),
        Offset(73, 294),
        Offset(83, 299),
        Offset(91, 290),
        Offset(94, 305),
      ], const Color(0xFFC36B60));
      oval(90, 316, 19, 25, const Color(0xFFF1C4A5));
      for (var i = 0; i < 4; i++) {
        oval(
          94 + (i % 2) * 6,
          322 + (i ~/ 2) * 7,
          3,
          3,
          const Color(0xFF9B4141),
        );
      }
    }
    oval(48, 30, 70, 93, const Color(0xFFD99A75));
    polygon(const [
      Offset(78, 121),
      Offset(72, 132),
      Offset(88, 132),
    ], const Color(0xFFD99A75));
    canvas.drawPath(
      Path()
        ..moveTo(80, 132)
        ..cubicTo(55, 157, 108, 164, 80, 190),
      pen,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _NewPictureScenePainter oldDelegate) =>
      oldDelegate.level != level;
}
