part of 'main.dart';

const selectedPaper = Color(0xFFE6D4AF);
const rule = Color(0xFF908573);

class EditionHeading extends StatelessWidget {
  final String label;
  const EditionHeading({super.key, required this.label});
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 9),
    decoration: const BoxDecoration(
      border: Border(
        top: BorderSide(color: ink, width: 2),
        bottom: BorderSide(color: ink),
      ),
    ),
    child: Text(
      label.toUpperCase(),
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontFamily: 'serif',
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
    ),
  );
}

class LetterKeyboard extends StatelessWidget {
  final ValueChanged<String> onLetter;
  final VoidCallback onDelete;
  const LetterKeyboard({
    super.key,
    required this.onLetter,
    required this.onDelete,
  });
  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      color: paper,
      border: Border(top: BorderSide(color: rule)),
    ),
    padding: const EdgeInsets.fromLTRB(5, 7, 5, 4),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final row in ['ABCÇDEFG', 'ĞHIİJKLM', 'NOÖPRSŞT', 'UÜVYZ'])
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final letter in row.split(''))
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: SizedBox(
                      height: 38,
                      child: OutlinedButton(
                        key: ValueKey('letter_$letter'),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          foregroundColor: ink,
                          visualDensity: VisualDensity.compact,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        onPressed: () => onLetter(letter),
                        child: Text(
                          letter,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              if (row == 'UÜVYZ')
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 38,
                    child: IconButton(
                      tooltip: 'Harf sil',
                      onPressed: onDelete,
                      icon: const Icon(Icons.backspace_outlined),
                    ),
                  ),
                ),
            ],
          ),
      ],
    ),
  );
}

class PaperGrid extends StatelessWidget {
  final int size;
  final Widget Function(int, int) cell;
  const PaperGrid({super.key, required this.size, required this.cell});
  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: 1,
    child: Container(
      decoration: BoxDecoration(border: Border.all(color: ink)),
      child: Column(
        children: [
          for (var r = 0; r < size; r++)
            Expanded(
              child: Row(
                children: [
                  for (var c = 0; c < size; c++) Expanded(child: cell(r, c)),
                ],
              ),
            ),
        ],
      ),
    ),
  );
}

class ZoomablePaper extends StatefulWidget {
  final Widget child;
  const ZoomablePaper({super.key, required this.child});
  @override
  State<ZoomablePaper> createState() => _ZoomablePaperState();
}

class _ZoomablePaperState extends State<ZoomablePaper> {
  final controller = TransformationController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        children: [
          const Expanded(
            child: Text(
              'İki parmakla büyüt • Kaydırarak gez',
              style: TextStyle(fontSize: 11, color: Colors.black54),
            ),
          ),
          IconButton(
            tooltip: 'Izgarayı sıfırla',
            visualDensity: VisualDensity.compact,
            onPressed: () => controller.value = Matrix4.identity(),
            icon: const Icon(Icons.fit_screen, size: 20),
          ),
        ],
      ),
      AspectRatio(
        aspectRatio: 1,
        child: ClipRect(
          child: InteractiveViewer(
            transformationController: controller,
            minScale: 1,
            maxScale: 4,
            child: widget.child,
          ),
        ),
      ),
    ],
  );
}

class CrossGame extends StatefulWidget {
  final bool arrow;
  final VoidCallback onSolved;
  const CrossGame({super.key, required this.arrow, required this.onSolved});
  @override
  State<CrossGame> createState() => _CrossGameState();
}

class _CrossGameState extends State<CrossGame> {
  late final words = widget.arrow ? arrowWords : crossWords;
  late final solution = <(int, int), String>{
    for (final w in words)
      for (var i = 0; i < w.text.length; i++) w.cells[i]: w.text[i],
  };
  late final starts = words.map((w) => (w.r, w.c)).toSet().toList()
    ..sort(
      (a, b) => a.$1 == b.$1 ? a.$2.compareTo(b.$2) : a.$1.compareTo(b.$1),
    );
  final filled = <String, String>{};
  final errors = <String>{};
  int active = 0, selected = 0;
  bool ready = false;
  String id((int, int) cell) => '${cell.$1},${cell.$2}';
  int number(WordEntry w) => starts.indexOf((w.r, w.c)) + 1;
  @override
  void initState() {
    super.initState();
    restore();
  }

  Future<void> restore() async {
    final data = await Store.read('cross_${widget.arrow}');
    if (!mounted) return;
    if (data != null) {
      try {
        final raw = jsonDecode(data) as Map<String, dynamic>;
        for (final cell in solution.keys) {
          final value = raw[id(cell)];
          if (value is String && value.length == 1) filled[id(cell)] = value;
        }
      } catch (_) {
        /* An incomplete old save starts with a clean board. */
      }
    }
    setState(() => ready = true);
  }

  void save() {
    Store.write('cross_${widget.arrow}', jsonEncode(filled));
  }

  void choose(int index) => setState(() {
    active = index;
    selected = 0;
  });
  void tap((int, int) cell) {
    final candidates = [
      for (var i = 0; i < words.length; i++)
        if (words[i].cells.contains(cell)) i,
    ];
    if (candidates.isEmpty) return;
    setState(() {
      if (words[active].cells[selected] == cell && candidates.length > 1) {
        active =
            candidates[(candidates.indexOf(active) + 1) % candidates.length];
      } else if (!candidates.contains(active)) {
        active = candidates.first;
      }
      selected = words[active].cells.indexOf(cell);
    });
  }

  void type(String letter) {
    if (!ready) return;
    setState(() {
      final key = id(words[active].cells[selected]);
      filled[key] = letter;
      errors.remove(key);
      if (selected < words[active].text.length - 1) selected++;
    });
    save();
  }

  void erase() {
    if (!ready) return;
    setState(() {
      if (!filled.containsKey(id(words[active].cells[selected])) &&
          selected > 0) {
        selected--;
      }
      final key = id(words[active].cells[selected]);
      filled.remove(key);
      errors.remove(key);
    });
    save();
  }

  void check() {
    setState(() {
      errors.clear();
      for (final e in solution.entries) {
        if (filled.containsKey(id(e.key)) && filled[id(e.key)] != e.value) {
          errors.add(id(e.key));
        }
      }
    });
    final empty = solution.keys.where((c) => !filled.containsKey(id(c))).length;
    final ok = empty == 0 && errors.isEmpty;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? 'Tüm cevaplar doğru. Sayfa tamamlandı!'
              : '$empty boş kutu, ${errors.length} hatalı harf.',
        ),
      ),
    );
    if (ok) widget.onSolved();
  }

  Widget cell(int r, int c) {
    final pos = (r, c), key = id(pos);
    final hints = [
      for (var i = 0; i < words.length; i++)
        if (words[i].clueCell == pos) i,
    ];
    if (widget.arrow && hints.isNotEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: hints.contains(active)
              ? selectedPaper
              : const Color(0xFFE8E3D7),
          border: Border.all(color: rule, width: .4),
        ),
        child: Column(
          children: [
            for (final i in hints)
              Expanded(
                child: InkWell(
                  key: ValueKey('arrow_clue_$i'),
                  onTap: () => choose(i),
                  child: Semantics(
                    excludeSemantics: true,
                    label:
                        '${words[i].clue}, ${words[i].vertical ? 'aşağı' : 'sağa'}',
                    button: true,
                    child: Padding(
                      padding: const EdgeInsets.all(1),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Center(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: SizedBox(
                                  width: 40,
                                  child: Text(
                                    words[i].clue,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 7,
                                      height: 1.05,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: FittedBox(
                                child: Text(
                                  words[i].vertical ? '↓' : '→',
                                  style: const TextStyle(
                                    fontSize: 9,
                                    height: .9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }
    final has = solution.containsKey(pos);
    final inWord = words[active].cells.contains(pos);
    final current = words[active].cells[selected] == pos;
    final startNumber = starts.indexOf(pos) + 1;
    return Semantics(
      label: has
          ? 'Satır ${r + 1}, sütun ${c + 1}, ${filled[key] ?? 'boş'}'
          : 'Kapalı kutu',
      button: has,
      child: InkWell(
        onTap: has ? () => tap(pos) : null,
        child: Container(
          key: ValueKey('cross_$r,$c'),
          decoration: BoxDecoration(
            color: !has
                ? ink
                : current
                ? const Color(0xFFD3AE68)
                : inWord
                ? selectedPaper
                : Colors.white,
            border: Border.all(
              color: current ? rust : rule,
              width: current ? 1.7 : .4,
            ),
          ),
          child: has
              ? Stack(
                  children: [
                    if (!widget.arrow && startNumber > 0)
                      Positioned(
                        top: 1,
                        left: 2,
                        child: Text(
                          '$startNumber',
                          style: const TextStyle(fontSize: 8, height: 1),
                        ),
                      ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: FittedBox(
                          child: Text(
                            filled[key] ?? '',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: errors.contains(key)
                                  ? Colors.red.shade800
                                  : ink,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : null,
        ),
      ),
    );
  }

  Widget clues(bool vertical) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          vertical ? 'YUKARIDAN AŞAĞIYA' : 'SOLDAN SAĞA',
          style: const TextStyle(
            fontFamily: 'serif',
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      for (var i = 0; i < words.length; i++)
        if (words[i].vertical == vertical)
          InkWell(
            onTap: () => choose(i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 9),
              decoration: BoxDecoration(
                color: active == i ? selectedPaper : null,
                border: const Border(
                  bottom: BorderSide(color: rule, width: .4),
                ),
              ),
              child: Text(
                '${number(words[i])}. ${words[i].clue} (${words[i].text.length})',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: active == i ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
    ],
  );
  @override
  Widget build(BuildContext context) {
    final word = words[active];
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 660),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    EditionHeading(
                      label:
                          '${widget.arrow ? 'OKLU ÇENGEL' : 'KLASİK KARE'} • ${words.length} SORU • SAYI 002',
                    ),
                    ZoomablePaper(
                      child: PaperGrid(size: crossSize, cell: cell),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.arrow
                          ? 'Gri soru kutusuna dokun, ok yönünde yaz. Küçük ipuçlarını büyüterek okuyabilirsin.'
                          : 'Numarayı ipucuyla eşleştir. Kesişim kutusuna yeniden dokunarak yönü değiştir.',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    if (!widget.arrow) ...[clues(false), clues(true)],
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: ready ? check : null,
                      icon: const Icon(Icons.fact_check_outlined),
                      label: const Text('Cevapları kontrol et'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          color: selectedPaper,
          padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
          child: Row(
            children: [
              IconButton(
                tooltip: 'Önceki soru',
                onPressed: () =>
                    choose((active - 1 + words.length) % words.length),
                icon: const Icon(Icons.chevron_left),
              ),
              Expanded(
                child: Text(
                  '${number(word)} ${word.vertical ? '↓' : '→'}  ${word.clue} (${word.text.length})',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Sonraki soru',
                onPressed: () => choose((active + 1) % words.length),
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),
        LetterKeyboard(onLetter: type, onDelete: erase),
      ],
    );
  }
}

List<(int, int)> searchCells((String, int, int, int, int) entry) =>
    List.generate(
      entry.$1.length,
      (i) => (entry.$2 + i * entry.$4, entry.$3 + i * entry.$5),
    );

class SearchGame extends StatefulWidget {
  final VoidCallback onSolved;
  const SearchGame({super.key, required this.onSolved});
  @override
  State<SearchGame> createState() => _SearchGameState();
}

class _SearchGameState extends State<SearchGame> {
  (int, int)? start, end, panOrigin;
  final found = <String>{};
  bool ready = false, dragging = false;
  @override
  void initState() {
    super.initState();
    restore();
  }

  Future<void> restore() async {
    final raw = await Store.read('search_found');
    if (!mounted) return;
    setState(() {
      found.addAll((raw ?? '').split('|').where(searchWords.contains));
      ready = true;
    });
  }

  Set<(int, int)> get preview {
    if (start == null || end == null) return {};
    final dr = end!.$1 - start!.$1, dc = end!.$2 - start!.$2;
    if (dr != 0 && dc != 0 && dr.abs() != dc.abs()) return {start!};
    final length = (dr.abs() > dc.abs() ? dr.abs() : dc.abs()) + 1;
    return {
      for (var i = 0; i < length; i++)
        (start!.$1 + i * dr.sign, start!.$2 + i * dc.sign),
    };
  }

  void select((int, int) pos) {
    if (!ready) return;
    if (start == null) {
      setState(() {
        start = pos;
        end = pos;
      });
    } else {
      finish(pos);
    }
  }

  void finish((int, int) pos) {
    if (start == null) return;
    String? match;
    for (final entry in searchEntries) {
      final cells = searchCells(entry);
      if ((start == cells.first && pos == cells.last) ||
          (pos == cells.first && start == cells.last)) {
        match = entry.$1;
        break;
      }
    }
    setState(() {
      if (match != null) found.add(match);
      start = null;
      end = null;
      dragging = false;
    });
    if (match != null) {
      Store.write('search_found', found.join('|'));
      if (found.length == searchWords.length) widget.onSolved();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Seçilen çizgide aranan bir kelime yok.'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final marked = {
      for (final e in searchEntries)
        if (found.contains(e.$1)) ...searchCells(e),
    };
    final selection = preview;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 660),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Kelimeler sekiz yönde gizli: yatay, dikey, çapraz ve tersten. İlk ve son harfe dokun veya parmağını sürükle.',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                (int, int) position(Offset p) {
                  final cell = constraints.maxWidth / searchGrid.length;
                  return (
                    (p.dy / cell).floor().clamp(0, searchGrid.length - 1),
                    (p.dx / cell).floor().clamp(0, searchGrid.length - 1),
                  );
                }

                return GestureDetector(
                  onPanDown: ready
                      ? (details) => panOrigin = position(details.localPosition)
                      : null,
                  onPanStart: ready
                      ? (details) => setState(() {
                          start = panOrigin ?? position(details.localPosition);
                          end = start;
                          dragging = true;
                        })
                      : null,
                  onPanUpdate: ready
                      ? (details) => setState(
                          () => end = position(details.localPosition),
                        )
                      : null,
                  onPanEnd: ready
                      ? (_) {
                          if (end != null) finish(end!);
                        }
                      : null,
                  onPanCancel: () {
                    if (dragging) {
                      setState(() {
                        start = null;
                        end = null;
                        dragging = false;
                      });
                    }
                  },
                  child: PaperGrid(
                    size: searchGrid.length,
                    cell: (r, c) => Semantics(
                      label:
                          'Satır ${r + 1}, sütun ${c + 1}, ${searchGrid[r][c]}',
                      button: true,
                      child: InkWell(
                        onTap: () => select((r, c)),
                        child: Container(
                          key: ValueKey('search_$r,$c'),
                          decoration: BoxDecoration(
                            color: selection.contains((r, c))
                                ? selectedPaper
                                : marked.contains((r, c))
                                ? const Color(0xFFCDDDC4)
                                : Colors.white,
                            border: Border.all(color: rule, width: .25),
                          ),
                          alignment: Alignment.center,
                          child: FittedBox(
                            child: Text(
                              searchGrid[r][c],
                              style: const TextStyle(
                                fontFamily: 'serif',
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                for (final word in searchWords)
                  Text(
                    word,
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: found.contains(word) ? green : ink,
                      decoration: found.contains(word)
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
              ],
            ),
            const Divider(color: ink, height: 28),
            Text(
              '${found.length} / ${searchWords.length} kelime bulundu',
              textAlign: TextAlign.center,
            ),
            if (start != null)
              TextButton(
                onPressed: () => setState(() {
                  start = null;
                  end = null;
                }),
                child: const Text('Seçimi iptal et'),
              ),
          ],
        ),
      ),
    );
  }
}

class SpiralGame extends StatefulWidget {
  final VoidCallback onSolved;
  const SpiralGame({super.key, required this.onSolved});
  @override
  State<SpiralGame> createState() => _SpiralGameState();
}

class _SpiralGameState extends State<SpiralGame> {
  final entered = <int, String>{};
  final positions = spiralPositions(7);
  final errors = <int>{};
  final starts = spiralStarts;
  int selected = 0, active = 0;
  bool ready = false;
  @override
  void initState() {
    super.initState();
    restore();
  }

  Future<void> restore() async {
    final raw = await Store.read('spiral');
    if (!mounted) return;
    if (raw != null && raw.length == spiralAnswer.length) {
      for (var i = 0; i < raw.length; i++) {
        if (raw[i] != '_') entered[i] = raw[i];
      }
    }
    setState(() => ready = true);
  }

  void save() => Store.write(
    'spiral',
    List.generate(spiralAnswer.length, (i) => entered[i] ?? '_').join(),
  );
  void move(int index) {
    selected = index;
    if (index < starts[active] ||
        index >= starts[active] + spiralWords[active].$1.length) {
      active = starts.lastIndexWhere((s) => s <= index);
    }
  }

  void put(String letter) {
    if (!ready) return;
    setState(() {
      entered[selected] = letter;
      errors.remove(selected);
      if (selected < spiralAnswer.length - 1) move(selected + 1);
    });
    save();
  }

  void erase() {
    if (!ready) return;
    setState(() {
      if (!entered.containsKey(selected) && selected > 0) move(selected - 1);
      entered.remove(selected);
      errors.remove(selected);
    });
    save();
  }

  void choose(int i) => setState(() {
    active = i;
    selected = starts[i];
  });
  void check() {
    setState(() {
      errors.clear();
      for (final e in entered.entries) {
        if (e.value != spiralAnswer[e.key]) errors.add(e.key);
      }
    });
    final empty = spiralAnswer.length - entered.length,
        ok = entered.length == spiralAnswer.length && errors.isEmpty;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? 'Sarmal eksiksiz çözüldü!'
              : '$empty boş kutu, ${errors.length} hatalı harf.',
        ),
      ),
    );
    if (ok) widget.onSolved();
  }

  Widget cell(int r, int c) {
    final index = positions.indexOf((r, c));
    final inWord =
        index >= starts[active] &&
        index < starts[active] + spiralWords[active].$1.length;
    final beginning = starts.indexOf(index);
    final next = index < positions.length - 1 ? positions[index + 1] : null;
    final arrow = next == null
        ? '•'
        : next.$1 > r
        ? '↓'
        : next.$1 < r
        ? '↑'
        : next.$2 > c
        ? '→'
        : '←';
    return Semantics(
      label: '${index + 1}. kutu, ${entered[index] ?? 'boş'}',
      button: true,
      child: InkWell(
        onTap: () => setState(() => move(index)),
        child: Container(
          key: ValueKey('spiral_$index'),
          decoration: BoxDecoration(
            color: selected == index
                ? const Color(0xFFD3AE68)
                : inWord
                ? selectedPaper
                : Colors.white,
            border: Border.all(
              color: selected == index ? rust : rule,
              width: selected == index ? 1.7 : .4,
            ),
          ),
          child: Stack(
            children: [
              if (beginning >= 0)
                Positioned(
                  top: 2,
                  left: 3,
                  child: Text(
                    '${beginning + 1}',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              Positioned(
                bottom: 1,
                right: 3,
                child: Text(
                  arrow,
                  style: const TextStyle(color: rule, fontSize: 11),
                ),
              ),
              Center(
                child: Text(
                  entered[index] ?? '',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                    color: errors.contains(index) ? Colors.red.shade800 : ink,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 660),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const EditionHeading(label: 'SARMAL • 13 SORU • 49 KUTU'),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Sol üstten başla, okları izleyerek merkeze ilerle. Her cevabın son harfi sonraki cevabın ilk harfidir. Ortak harf tek kutuya yazılır.',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  PaperGrid(size: 7, cell: cell),
                  const SizedBox(height: 12),
                  for (var i = 0; i < spiralWords.length; i++)
                    InkWell(
                      onTap: () => choose(i),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: active == i ? selectedPaper : null,
                          border: const Border(
                            bottom: BorderSide(color: rule, width: .4),
                          ),
                        ),
                        child: Text(
                          '${i + 1}. ${spiralWords[i].$2} (${spiralWords[i].$1.length})',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: active == i
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: ready ? check : null,
                    icon: const Icon(Icons.fact_check_outlined),
                    label: const Text('Sarmalı kontrol et'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      Container(
        color: selectedPaper,
        child: Row(
          children: [
            IconButton(
              tooltip: 'Önceki soru',
              onPressed: () => choose(
                (active - 1 + spiralWords.length) % spiralWords.length,
              ),
              icon: const Icon(Icons.chevron_left),
            ),
            Expanded(
              child: Text(
                '${active + 1}. ${spiralWords[active].$2} (${spiralWords[active].$1.length})',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            IconButton(
              tooltip: 'Sonraki soru',
              onPressed: () => choose((active + 1) % spiralWords.length),
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
      ),
      LetterKeyboard(onLetter: put, onDelete: erase),
    ],
  );
}
