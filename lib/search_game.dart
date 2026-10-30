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
    (cell.$2 + .5) / searchGrid.length,
    (cell.$1 + .5) / searchGrid.length,
  );
  @override
  void initState() {
    super.initState();
    restore();
  }

  Future<void> restore() async {
    final raw = await Store.read('search_found'),
        strokes = await Store.read('search_ink');
    if (!mounted) return;
    found.addAll((raw ?? '').split('|').where(searchWords.contains));
    if (strokes != null) {
      try {
        final data = jsonDecode(strokes) as Map<String, dynamic>;
        for (final word in found) {
          if (data[word] is! List) continue;
          final points = <Offset>[];
          for (final item in (data[word] as List).take(512)) {
            if (item is List &&
                item.length == 2 &&
                item[0] is num &&
                item[1] is num) {
              final x = (item[0] as num).toDouble(),
                  y = (item[1] as num).toDouble();
              if (x.isFinite && y.isFinite) {
                points.add(Offset(x.clamp(0, 1), y.clamp(0, 1)));
              }
            }
          }
          if (points.length >= 2) savedStrokes[word] = points;
        }
      } catch (_) {
        /* Bulunan kelimeler, eski kayıtlarda da çizgiyle gösterilir. */
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
        savedStrokes[match] = dragging && live.length > 1
            ? List.of(live)
            : [center(start!), center(pos)];
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
              'Kelimenin harflerini parmağınla karala. Kalem izi parmağını izler; doğru kelimenin üstündeki çizgi kalır. Sözcükler sekiz yönde saklı.',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                (int, int) position(Offset p) => (
                  (p.dy / width * searchGrid.length).floor().clamp(
                    0,
                    searchGrid.length - 1,
                  ),
                  (p.dx / width * searchGrid.length).floor().clamp(
                    0,
                    searchGrid.length - 1,
                  ),
                );
                Offset normalized(Offset p) => Offset(
                  (p.dx / width).clamp(0, 1),
                  (p.dy / width).clamp(0, 1),
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
                      live = [normalized(event.localPosition)];
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
                        end = position(event.localPosition);
                        if (live.length < 512) {
                          live.add(normalized(event.localPosition));
                        }
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
                                  color: Colors.white,
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
                onPressed: cancel,
                child: const Text('Seçimi iptal et'),
              ),
          ],
        ),
      ),
    );
  }
}
