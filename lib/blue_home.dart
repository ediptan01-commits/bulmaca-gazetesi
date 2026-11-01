part of 'main.dart';

// Bulmaca Dünyası: mavi modern ana sayfa.
// Bu dosya yalnızca ana sayfayı yönetir; bulmaca motorlarına dokunmaz.
const _blueDark = Color(0xFF073A89);
const _blue = Color(0xFF075FC2);
const _gold = Color(0xFFFFC44F);
const _navy = Color(0xFF10285A);

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _BlueHomeState();
}

class _BlueHomeState extends State<Home> {
  int tab = 0;
  final Map<String, int> completed = {};
  final Set<String> dailySolved = {};
  String get dailyKey {
    final now = DateTime.now();
    return 'daily_${now.year}_${now.month}_${now.day}';
  }
  int get finishedTypes => puzzles.where((p) => (completed[p.id] ?? 0) > 0).length;
  int get finishedLevels => completed.values.fold(0, (int a, int b) => a + b);

  @override
  void initState() {
    super.initState();
    refresh();
  }

  Future<void> refresh() async {
    final next = <String, int>{};
    for (final p in puzzles) {
      var count = await Store.done(p.id) ? 1 : 0;
      for (var level = 2; level <= levelsPerPuzzle; level++) {
        if (await Store.read('chapter_${p.id}_$level') == '1') count++;
      }
      next[p.id] = count;
    }
    final savedToday = (await Store.read(dailyKey) ?? '').split('|');
    if (mounted) {
      setState(() {
        completed..clear()..addAll(next);
        dailySolved..clear()..addAll(savedToday.where((v) => v.isNotEmpty));
      });
    }
  }

  Future<void> open(Puzzle p) async {
    final previous = completed[p.id] ?? 0;
    await Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => LevelSelectScreen(puzzle: p),
    ));
    await refresh();
    if ((completed[p.id] ?? 0) > previous) {
      dailySolved.add(p.id);
      await Store.write(dailyKey, dailySolved.join('|'));
      if (mounted) setState(() {});
    }
  }

  Future<void> openDaily() async {
    final next = puzzles.firstWhere(
      (p) => !dailySolved.contains(p.id),
      orElse: () => puzzles.first,
    );
    await open(next);
  }

  Widget roundIcon(IconData icon, VoidCallback action) => Material(
    color: const Color(0xFF07529F),
    shape: CircleBorder(side: BorderSide(color: Colors.lightBlueAccent.shade100, width: 1.5)),
    child: InkWell(
      customBorder: const CircleBorder(),
      onTap: action,
      child: Padding(
        padding: const EdgeInsets.all(11),
        child: Icon(icon, size: 23, color: Colors.white),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _blue,
    body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF004B9F), Color(0xFF078CE4), Color(0xFF0453AA), Color(0xFF052B6C)],
          stops: [0, .38, .72, 1],
        ),
      ),
      child: SafeArea(
        child: Column(children: [
          Expanded(
            child: IndexedStack(index: tab, children: [
              _homePage(),
              _puzzlePage(),
              _awardsPage(),
              _profilePage(),
            ]),
          ),
          _bottomBar(),
        ]),
      ),
    ),
  );

  Widget _homePage() => LayoutBuilder(
    builder: (context, constraints) => ListView(
      padding: const EdgeInsets.fromLTRB(15, 12, 15, 16),
      children: [
        _header(),
        const SizedBox(height: 17),
        _dailyChallenge(),
        const SizedBox(height: 23),
        const _CollectionHeader(),
        const SizedBox(height: 15),
        _puzzleGrid(constraints.maxWidth),
        const SizedBox(height: 14),
      ],
    ),
  );

  Widget _header() => Column(children: [
    Row(children: [
      roundIcon(Icons.person_rounded, () => setState(() => tab = 3)),
      const SizedBox(width: 6),
      const Expanded(child: Text(appName,
        textAlign: TextAlign.center,
        maxLines: 2,
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 31,
          height: 1.0, color: _gold,
          shadows: [Shadow(color: Color(0xFF653B00), blurRadius: 5,
            offset: Offset(1, 3))]))),
      roundIcon(Icons.settings_rounded, () => _message('İlerlemen bu cihazda otomatik kaydediliyor.')),
    ]),
    const SizedBox(height: 7),
    const Text('Klasik Bulmacalar  •  Zihin Oyunları  •  Eğlence',
      maxLines: 1, textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w600)),
  ]);

  void _message(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }

  Widget _dailyChallenge() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: const LinearGradient(colors: [Color(0xFF0D55AE), Color(0xFF052F7A)]),
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: const Color(0xFF8BDAFF), width: 1.8),
      boxShadow: const [BoxShadow(color: Color(0x66001C4D), blurRadius: 12, offset: Offset(0, 7))],
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        const Icon(Icons.calendar_month_rounded, color: _gold, size: 30),
        const SizedBox(width: 9),
        const Expanded(child: Text('Bugünün Zihin Görevi',
          style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w900))),
        const Icon(Icons.emoji_events_rounded, size: 32, color: _gold),
      ]),
      const SizedBox(height: 9),
      const Text('3 farklı bulmaca çöz, zihnini çalıştır!',
        style: TextStyle(color: Colors.white, fontSize: 13.5)),
      const SizedBox(height: 15),
      Row(children: [
        Expanded(child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: (dailySolved.length / 3).clamp(0.0, 1.0),
            minHeight: 11,
            backgroundColor: const Color(0xFF6AB3EF),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF5DE06A)),
          ),
        )),
        const SizedBox(width: 10),
        Text('${dailySolved.length.clamp(0, 3)} / 3',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
        const SizedBox(width: 12),
        Material(
          color: _gold,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: openDaily,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.play_arrow_rounded, color: _navy),
                SizedBox(width: 3),
                Text('Oyna', style: TextStyle(color: _navy, fontSize: 15, fontWeight: FontWeight.w900)),
              ]),
            ),
          ),
        ),
      ]),
    ]),
  );

  Widget _puzzleGrid(double availableWidth) => GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: puzzles.length,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: availableWidth > 640 ? 3 : 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: availableWidth > 640 ? 0.93 : 0.83,
    ),
    itemBuilder: (_, i) => _PuzzleTile(
      puzzle: puzzles[i],
      finished: (completed[puzzles[i].id] ?? 0) > 0,
      onTap: () => open(puzzles[i]),
    ),
  );

  Widget _puzzlePage() => _subPage(
    'Bulmaca Koleksiyonu',
    Icons.grid_view_rounded,
    LayoutBuilder(builder: (context, c) => _puzzleGrid(c.maxWidth)),
  );

  Widget _awardsPage() => _subPage('Başarılar', Icons.emoji_events_rounded,
    Column(children: [
      const Icon(Icons.workspace_premium_rounded, size: 72, color: _gold),
      const SizedBox(height: 12),
      Text('$finishedTypes farklı bulmaca türünü tamamladın',
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      Text('Çözülen toplam bulmaca: $finishedLevels',
        style: const TextStyle(color: Colors.white70)),
      const SizedBox(height: 20),
      for (final p in puzzles)
        ListTile(
          leading: Icon((completed[p.id] ?? 0) > 0 ? Icons.verified : Icons.lock_outline,
            color: (completed[p.id] ?? 0) > 0 ? _gold : Colors.white54),
          title: Text(p.name, style: const TextStyle(color: Colors.white)),
          onTap: () => open(p),
        ),
    ]),
  );

  Widget _profilePage() => _subPage('Profil', Icons.person_rounded,
    Column(children: [
      const CircleAvatar(radius: 42, backgroundColor: Color(0xFF72C9FF),
        child: Icon(Icons.person_rounded, color: _navy, size: 50)),
      const SizedBox(height: 15),
      const Text('Bulmaca Kaşifi',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
      const SizedBox(height: 8),
      Text('$finishedLevels bulmaca tamamlandı',
        style: const TextStyle(color: Colors.white70)),
      const SizedBox(height: 18),
      const Text('İlerlemen bu cihazda saklanır.',
        style: TextStyle(color: Colors.white70)),
    ]),
  );

  Widget _subPage(String heading, IconData icon, Widget content) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
    children: [
      Row(children: [
        Icon(icon, color: _gold, size: 29),
        const SizedBox(width: 12),
        Expanded(child: Text(heading,
          style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 25))),
      ]),
      const SizedBox(height: 20),
      content,
    ],
  );

  Widget _bottomBar() => Container(
    margin: const EdgeInsets.fromLTRB(10, 0, 10, 9),
    padding: const EdgeInsets.symmetric(vertical: 7),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(22),
      gradient: const LinearGradient(colors: [Color(0xFF074C9E), Color(0xFF042A68)]),
      border: Border.all(color: const Color(0xFF6BD3FF), width: 1.3),
      boxShadow: const [BoxShadow(color: Color(0x66001A4C), blurRadius: 10, offset: Offset(0, 3))],
    ),
    child: Row(children: [
      _nav(0, Icons.home_rounded, 'Ana Sayfa'),
      _nav(1, Icons.grid_view_rounded, 'Bulmacalar'),
      _nav(2, Icons.emoji_events_rounded, 'Başarılar'),
      _nav(3, Icons.person_rounded, 'Profil'),
    ]),
  );

  Widget _nav(int index, IconData icon, String label) => Expanded(
    child: InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => setState(() => tab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: tab == index ? const Color(0xFF0673D2) : Colors.transparent,
          borderRadius: BorderRadius.circular(17),
          border: tab == index ? Border.all(color: const Color(0xFF71D8FF)) : null,
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 24, color: tab == index ? _gold : Colors.white),
          const SizedBox(height: 2),
          Text(label, maxLines: 1, style: TextStyle(
            color: tab == index ? _gold : Colors.white,
            fontSize: 10.5, fontWeight: FontWeight.w700)),
        ]),
      ),
    ),
  );
}

class _CollectionHeader extends StatelessWidget {
  const _CollectionHeader();
  @override
  Widget build(BuildContext context) => Row(children: [
    const Expanded(child: Divider(color: _gold, thickness: 1.5)),
    const SizedBox(width: 10),
    const Text('Bulmaca Koleksiyonu', style: TextStyle(
      color: Colors.white, fontSize: 21, fontWeight: FontWeight.w900,
      shadows: [Shadow(color: _blueDark, blurRadius: 5, offset: Offset(1, 2))])),
    const SizedBox(width: 10),
    const Expanded(child: Divider(color: _gold, thickness: 1.5)),
  ]);
}

class _PuzzleTile extends StatelessWidget {
  final Puzzle puzzle;
  final bool finished;
  final VoidCallback onTap;
  const _PuzzleTile({required this.puzzle, required this.finished, required this.onTap});

  static const shades = <String, List<Color>>{
    'cengel': [Color(0xFFFFE4A5), Color(0xFFFFF3D9)],
    'kare': [Color(0xFFB9DFFF), Color(0xFFE4F2FF)],
    'sudoku': [Color(0xFFA9E7D2), Color(0xFFDDFCF2)],
    'av': [Color(0xFFC4B8FF), Color(0xFFEEE9FF)],
    'sarmal': [Color(0xFFFFC6CA), Color(0xFFFFE9E9)],
    'resim': [Color(0xFFFFD783), Color(0xFFFFF0C3)],
  };

  @override
  Widget build(BuildContext context) {
    final colors = shades[puzzle.id]!;
    return Material(
      color: colors[1],
      borderRadius: BorderRadius.circular(22),
      elevation: 5,
      shadowColor: const Color(0x8803244D),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white, width: 2),
            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [colors[0], colors[1]]),
          ),
          child: Column(children: [
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 12, 10, 3),
                child: CustomPaint(
                  painter: _PuzzleMiniaturePainter(puzzle.id),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(6, 4, 6, 8),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(puzzle.name,
                    maxLines: 2, textAlign: TextAlign.center,
                    style: const TextStyle(color: _navy, fontWeight: FontWeight.w900, fontSize: 15, height: 1.12)),
                  const SizedBox(height: 8),
                  Text(_description(puzzle.id),
                    maxLines: 2, textAlign: TextAlign.center,
                    style: const TextStyle(color: _navy, fontSize: 10.5, height: 1.2)),
                  if (finished) const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Icon(Icons.verified_rounded, color: Color(0xFF218F57), size: 19)),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  String _description(String id) => switch (id) {
    'cengel' => 'İpuçlarından kelimeleri bul!',
    'kare' => 'Kesişimlerden kelimeleri tamamla!',
    'sudoku' => 'Sayılarla zihnini zorla!',
    'av' => 'Gizli kelimeleri keşfet!',
    'sarmal' => 'Harfleri takip et, sırra ulaş!',
    _ => 'Görsellerden kelimeyi bul!',
  };
}

// Her kartın üzerinde türü doğru temsil eden gerçek oyun ızgarası çizilir.
class _PuzzleMiniaturePainter extends CustomPainter {
  final String type;
  const _PuzzleMiniaturePainter(this.type);

  @override
  void paint(Canvas canvas, Size size) {
    final scale = math.min(size.width, size.height);
    final cx = size.width / 2, cy = size.height / 2;
    final line = Paint()..color = const Color(0xFF38445F)..strokeWidth = 1;
    final white = Paint()..color = Colors.white;
    final dark = Paint()..color = const Color(0xFF283041);

    void grid(int n, {bool numbers = false, bool findWords = false}) {
      final side = math.min(size.width * .90, size.height * .96);
      final cell = side / n;
      final left = cx - side / 2, top = cy - side / 2;
      canvas.drawRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, side, side), const Radius.circular(4)), white);
      final chars = 'KELİMEAVIBULMACASUDOKU';
      for (var y = 0; y < n; y++) {
        for (var x = 0; x < n; x++) {
          final rect = Rect.fromLTWH(left + x * cell, top + y * cell, cell, cell);
          if (!numbers && !findWords && ((x * 3 + y * 5) % 11 < 2)) {
            canvas.drawRect(rect.deflate(.4), dark);
          } else if (findWords && y == n ~/ 2 && x < n - 1) {
            canvas.drawRect(rect.deflate(.4), Paint()..color = const Color(0xFFEAA3F4));
          }
          canvas.drawRect(rect, line..style = PaintingStyle.stroke);
          line.style = PaintingStyle.fill;
          if (numbers && (x + y * 4) % 3 == 0) {
            _letter(canvas, '${(x * 2 + y * 3) % 9 + 1}',
              Offset(rect.center.dx, rect.center.dy), cell * .60);
          } else if (findWords) {
            _letter(canvas, chars[(y * n + x) % chars.length],
              Offset(rect.center.dx, rect.center.dy), cell * .55);
          }
        }
      }
    }

    switch (type) {
      case 'cengel':
      case 'kare':
        grid(7);
        break;
      case 'sudoku':
        grid(9, numbers: true);
        break;
      case 'av':
        grid(7, findWords: true);
        break;
      case 'sarmal':
        for (var ring = 4; ring >= 1; ring--) {
          canvas.drawCircle(Offset(cx, cy), scale * ring / 9,
            Paint()..color = ring.isEven ? Colors.white : const Color(0xFFFFE5B7));
          canvas.drawCircle(Offset(cx, cy), scale * ring / 9,
            Paint()..color = const Color(0xFFAF753B)..style = PaintingStyle.stroke..strokeWidth = 1.4);
          for (var i = 0; i < ring * 6; i++) {
            final a = 2 * math.pi * i / (ring * 6);
            _letter(canvas, 'KELİME'[i % 6],
              Offset(cx + math.cos(a) * scale * ring / 9,
                cy + math.sin(a) * scale * ring / 9), scale * .085);
          }
        }
        break;
      case 'resim':
        final side = math.min(size.width * .84, size.height * .90);
        final left = cx - side / 2, top = cy - side / 2;
        final icons = [Icons.landscape, Icons.pets, Icons.apple, Icons.help_outline];
        final bg = [const Color(0xFFB4DAF2), const Color(0xFFFFE6B8),
          const Color(0xFFE7F1D9), Colors.white];
        for (var i = 0; i < 4; i++) {
          final tile = Rect.fromLTWH(left + (i % 2) * side / 2,
            top + (i ~/ 2) * side / 2, side / 2 - 3, side / 2 - 3);
          canvas.drawRRect(RRect.fromRectAndRadius(tile, const Radius.circular(7)),
            Paint()..color = bg[i]);
          final text = String.fromCharCode(icons[i].codePoint);
          final tp = TextPainter(
            text: TextSpan(text: text, style: TextStyle(fontFamily: icons[i].fontFamily,
              package: icons[i].fontPackage, fontSize: side * .28,
              color: const Color(0xFF366FA1))),
            textDirection: TextDirection.ltr,
          )..layout();
          tp.paint(canvas, tile.center - Offset(tp.width / 2, tp.height / 2));
        }
        break;
    }
  }

  static void _letter(Canvas canvas, String value, Offset center, double fontSize) {
    final painter = TextPainter(
      text: TextSpan(text: value, style: TextStyle(
        fontSize: fontSize, fontWeight: FontWeight.bold,
        color: const Color(0xFF263A62))),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, center - Offset(painter.width / 2, painter.height / 2));
  }

  @override
  bool shouldRepaint(covariant _PuzzleMiniaturePainter oldDelegate) => oldDelegate.type != type;
}
