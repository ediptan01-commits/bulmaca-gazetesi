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
      trUpper(label),
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

class PaperGrid extends StatelessWidget {
  final int size;
  final int? rows;
  final Widget Function(int, int) cell;
  const PaperGrid({
    super.key,
    required this.size,
    this.rows,
    required this.cell,
  });
  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: size / (rows ?? size),
    child: Container(
      decoration: BoxDecoration(border: Border.all(color: ink)),
      child: Column(
        children: [
          for (var r = 0; r < (rows ?? size); r++)
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

class CrossGame extends StatefulWidget {
  final bool arrow;
  final int level;
  final VoidCallback onSolved;
  const CrossGame({
    super.key,
    required this.arrow,
    this.level = 1,
    required this.onSolved,
  });
  @override
  State<CrossGame> createState() => _CrossGameState();
}

class _CrossGameState extends State<CrossGame> {
  late final words = widget.arrow
      ? arrowWordsForLevel(widget.level)
      : crossWords;
  int get size => widget.arrow ? arrowSize : crossSize;
  int get rows => widget.arrow ? arrowRows : crossSize;
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

  String get saveKey => widget.arrow && widget.level > 1
      ? 'arrow_v2_${widget.level}'
      : 'cross_${widget.arrow}';
  Future<void> restore() async {
    final data = await Store.read(saveKey);
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
    Store.write(saveKey, jsonEncode(filled));
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
                                  width: 56,
                                  child: Text(
                                    words[i].clue,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 11,
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
                              fontSize: widget.arrow ? 24 : 22,
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
          child: LayoutBuilder(
            builder: (context, available) => SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(4, 2, 4, 8),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: widget.arrow
                        ? math.max(
                            120,
                            math.min(
                              available.maxWidth - 8,
                              available.maxHeight - 44,
                            ),
                          )
                        : 660,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ZoomablePaper(
                        gridSize: size,
                        gridRows: rows,
                        minimumCellSize: 0,
                        onCheck: ready ? check : null,
                        child: PaperGrid(size: size, rows: rows, cell: cell),
                      ),
                      if (!widget.arrow)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: clues(false)),
                            const SizedBox(width: 12),
                            Expanded(child: clues(true)),
                          ],
                        ),
                    ],
                  ),
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

class SpiralGame extends StatefulWidget {
  final VoidCallback onSolved;
  const SpiralGame({super.key, required this.onSolved});
  @override
  State<SpiralGame> createState() => _SpiralGameState();
}

class _SpiralGameState extends State<SpiralGame> {
  final entered = <int, String>{};
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
                  const EditionHeading(
                    label: 'DAİRESEL SARMAL • 13 SORU • 49 KUTU',
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Dış halkadaki 1’den başla, saat yönünde ilerle; halkayı bitirince okla bir iç halkaya geç. Her cevabın son harfi sonraki cevabın ilk harfidir.',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  CircularSpiralBoard(
                    entered: entered,
                    errors: errors,
                    selected: selected,
                    activeStart: starts[active],
                    activeLength: spiralWords[active].$1.length,
                    onSelect: (index) => setState(() => move(index)),
                  ),
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
