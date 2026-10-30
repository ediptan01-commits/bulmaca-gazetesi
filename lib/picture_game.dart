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
  const PictureGame({super.key, required this.onSolved});
  @override
  State<PictureGame> createState() => _PictureGameState();
}

class _PictureGameState extends State<PictureGame> {
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
    final raw = await Store.read('picture_cipher');
    if (!mounted) return;
    if (raw != null) {
      try {
        final data = jsonDecode(raw) as Map<String, dynamic>;
        for (var i = 0; i < pictureClues.length; i++) {
          final value = data['$i'];
          if (value is String &&
              value.length <= pictureClues[i].answer.length) {
            answers[i] = value;
            if (value == pictureClues[i].answer) solved.add(i);
          }
        }
      } catch (_) {
        /* Bozuk kayıt resmi ve soruları etkilemez. */
      }
    }
    setState(() {
      active = pictureClues.indexWhere(
        (c) => !solved.contains(pictureClues.indexOf(c)),
      );
      if (active < 0) active = 0;
      ready = true;
    });
  }

  void save() => Store.write(
    'picture_cipher',
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
          .padRight(pictureClues[active].answer.length, '_')
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
          .padRight(pictureClues[active].answer.length, '_')
          .split('');
      if (chars[selected] == '_' && selected > 0) selected--;
      chars[selected] = '_';
      answers[active] = chars.join();
    });
    save();
  }

  void check() {
    if (answers[active] != pictureClues[active].answer) {
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
    if (solved.length == pictureClues.length) {
      widget.onSolved();
    } else {
      final next = List.generate(
        pictureClues.length,
        (i) => i,
      ).firstWhere((i) => !solved.contains(i));
      choose(next);
    }
  }

  @override
  Widget build(BuildContext context) {
    final clue = pictureClues[active],
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
                        Text('${solved.length} / 6'),
                      ],
                    ),
                    const SizedBox(height: 6),
                    PictureScene(
                      active: active,
                      solved: solved,
                      onSelect: choose,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < pictureClues.length; i++)
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
                        for (var i = 0; i < pictureClues.length; i++)
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
                                  ? pictureClues[i].answer[pictureClues[i]
                                        .secretIndex]
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
                    if (solved.length == pictureClues.length)
                      Text(
                        'Şifre çözüldü: $pictureSecret',
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
  final Set<int> solved;
  final ValueChanged<int> onSelect;
  const PictureScene({
    super.key,
    required this.active,
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
            Positioned.fill(child: CustomPaint(painter: _ParkScenePainter())),
            for (var i = 0; i < pictureClues.length; i++)
              Positioned.fromRect(
                rect: Rect.fromLTWH(
                  pictureClues[i].area.left * constraints.maxWidth,
                  pictureClues[i].area.top * constraints.maxHeight,
                  pictureClues[i].area.width * constraints.maxWidth,
                  pictureClues[i].area.height * constraints.maxHeight,
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
