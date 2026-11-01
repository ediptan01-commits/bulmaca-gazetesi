part of 'main.dart';

class SearchGame extends StatefulWidget {
  final VoidCallback onSolved;
  const SearchGame({super.key, required this.onSolved});
  @override
  State<SearchGame> createState() => _SearchGameState();
}

class _SearchGameState extends State<SearchGame> {
  (int, int)? start, end, panOrigin;
  final found = <String>{};
  final savedStrokes = <String, List<Offset>>{};
  List<Offset> live = [];
  bool ready = false, dragging = false;
  int? activePointer;
  Offset? downPoint;
  Offset center((int, int) cell) => Offset(
    (cell.$2 + .5) / searchGrid.first.length,
    (cell.$1 + .5) / searchGrid.length,
  );
  @override
  void initState() {
    super.initState();
    restore();
  }

  Future<void> restore() async {
    final raw = await Store.read('search_found');
    if (!mounted) return;
    found.addAll((raw ?? '').split('|').where(searchWords.contains));
    for (final entry in searchEntries) {
      if (found.contains(entry.$1)) {
        savedStrokes[entry.$1] = [
          center(searchCells(entry).first),
          center(searchCells(entry).last),
        ];
      }
    }
    setState(() => ready = true);
  }

  void select((int, int) pos) {
    if (!ready) return;
    if (start == null) {
      setState(() {
        start = pos;
        end = pos;
        live = [center(pos)];
      });
    } else {
      finish(pos);
    }
  }

  void cancel() => setState(() {
    start = null;
    end = null;
    live = [];
    dragging = false;
  });
  void finish((int, int) pos) {
    if (start == null) return;
    pos = snapSearchEnd(start!, pos);
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
      if (match != null) {
        found.add(match);
        final entry = searchEntries.firstWhere((e) => e.$1 == match);
        savedStrokes[match] = [
          center(searchCells(entry).first),
          center(searchCells(entry).last),
        ];
      }
      start = null;
      end = null;
      live = [];
      dragging = false;
    });
    if (match != null) {
      Store.write('search_found', found.join('|'));
      Store.write(
        'search_ink',
        jsonEncode({
          for (final entry in savedStrokes.entries)
            entry.key: entry.value.map((p) => [p.dx, p.dy]).toList(),
        }),
      );
      if (found.length == searchWords.length) widget.onSolved();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Karaladığın çizgide aranan bir kelime yok.'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final strokes = <List<Offset>>[
      for (final entry in searchEntries)
        if (found.contains(entry.$1))
          savedStrokes[entry.$1] ??
              [
                center(searchCells(entry).first),
                center(searchCells(entry).last),
              ],
    ];
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 660),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Kelimenin harflerini parmağınla karala. Çizgi harflere düzgün oturur. 11 kelime, sekiz yön • 10×12 tahta.',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final cellHeight = width / searchGrid.first.length;
                (int, int) position(Offset p) => (
                  (p.dy / cellHeight).floor().clamp(
                    0,
                    searchGrid.length - 1,
                  ),
                  (p.dx / width * searchGrid.first.length).floor().clamp(
                    0,
                    searchGrid.first.length - 1,
                  ),
                );
                return RawGestureDetector(
                  gestures: {
                    EagerGestureRecognizer:
                        GestureRecognizerFactoryWithHandlers<
                          EagerGestureRecognizer
                        >(() => EagerGestureRecognizer(), (_) {}),
                  },
                  child: Listener(
                    behavior: HitTestBehavior.opaque,
                    onPointerDown: (event) {
                      if (!ready || activePointer != null) return;
                      activePointer = event.pointer;
                      downPoint = event.localPosition;
                      panOrigin = position(event.localPosition);
                      live = [center(panOrigin!)];
                    },
                    onPointerMove: (event) {
                      if (event.pointer != activePointer || downPoint == null) {
                        return;
                      }
                      if (!dragging &&
                          (event.localPosition - downPoint!).distance < 4) {
                        return;
                      }
                      setState(() {
                        if (!dragging) {
                          start = panOrigin;
                          dragging = true;
                        }
                        end = snapSearchEnd(
                          start!,
                          position(event.localPosition),
                        );
                        live = [center(start!), center(end!)];
                      });
                    },
                    onPointerUp: (event) {
                      if (event.pointer != activePointer) return;
                      activePointer = null;
                      if (dragging) {
                        finish(position(event.localPosition));
                      } else {
                        select(position(event.localPosition));
                      }
                    },
                    onPointerCancel: (event) {
                      if (event.pointer == activePointer) {
                        activePointer = null;
                        cancel();
                      }
                    },
                    child: Stack(
                      children: [
                        PaperGrid(
                          size: searchGrid.first.length,
                          rows: searchGrid.length,
                          cell: (r, c) => Semantics(
                            label:
                                'Satır ${r + 1}, sütun ${c + 1}, ${searchGrid[r][c]}',
                            button: true,
                            child: InkWell(
                              onTap: () => select((r, c)),
                              child: Container(
                                key: ValueKey('search_$r,$c'),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: rule, width: .25),
                                ),
                                alignment: Alignment.center,
                                child: FittedBox(
                                  child: Text(
                                    searchGrid[r][c],
                                    style: const TextStyle(
                                      fontFamily: 'serif',
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: WordSearchInk(
                            strokes: strokes,
                            live: start != null || dragging
                                ? List.of(live)
                                : const [],
                          ),
                        ),
                      ],
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
                      fontSize: 18,
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
                onPressed: cancel,
                child: const Text('Seçimi iptal et'),
              ),
          ],
        ),
      ),
    );
  }
}

(int, int) snapSearchEnd((int, int) start, (int, int) end) {
  final dr = end.$1 - start.$1, dc = end.$2 - start.$2;
  if (dr == 0 && dc == 0) return start;
  final angle =
      (math.atan2(dr.toDouble(), dc.toDouble()) / (math.pi / 4)).round() *
      math.pi /
      4;
  final dy = math.sin(angle).round(), dx = math.cos(angle).round();
  var count = math.max(dr.abs(), dc.abs());
  while (count > 0 &&
      (start.$1 + count * dy < 0 ||
          start.$1 + count * dy >= searchGrid.length ||
          start.$2 + count * dx < 0 ||
          start.$2 + count * dx >= searchGrid.first.length)) {
    count--;
  }
  return (start.$1 + count * dy, start.$2 + count * dx);
}
