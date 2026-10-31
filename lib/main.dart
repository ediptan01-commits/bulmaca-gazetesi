import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'newspaper.dart';
part 'newspaper_ui.dart';
part 'newspaper_components.dart';
part 'search_game.dart';
part 'picture_game.dart';
part 'extra_levels.dart';

void main() => runApp(const BulmacaApp());
const appName = 'Bulmaca Dünyası';
const appSlogan = 'Her Bulmacada Yeni Bir Macera!';
const paper = Color(0xFFF7F2E8);
const ink = Color(0xFF173E32);
const rust = Color(0xFF82623E);
const green = Color(0xFF29654D);

String trUpper(String s) =>
    s.replaceAll('i', 'İ').replaceAll('ı', 'I').toUpperCase();

class Store {
  static final _prefs = SharedPreferencesAsync();
  static Future<String?> read(String key) => _prefs.getString(_key(key));
  static String _key(String key) =>
      ['sudoku_board', 'done_sudoku'].contains(key)
      ? key
      : ['cross_true', 'cross_false', 'done_cengel', 'done_kare'].contains(key)
      ? 'edition5_$key'
      : ['picture_cipher', 'done_resim'].contains(key)
      ? 'edition4_$key'
      : key.startsWith('search_') || key == 'done_av'
      ? 'edition5_$key'
      : 'edition2_$key';
  static Future<void> write(String key, String val) =>
      _prefs.setString(_key(key), val);
  static Future<bool> done(String id) async => (await read('done_$id')) == '1';
  static Future<void> complete(String id) => write('done_$id', '1');
}

class Puzzle {
  final String id, name, subtitle, emoji;
  const Puzzle(this.id, this.name, this.subtitle, this.emoji);
}

const puzzles = <Puzzle>[
  Puzzle('cengel', 'Çengel Bulmaca', 'İpuçlarından kutucuklara', '🧩'),
  Puzzle('kare', 'Kare Bulmaca', 'Kesişen kelimeleri çöz', '🔠'),
  Puzzle('sudoku', 'Sudoku', '1–9 sayı mantığı', '🔢'),
  Puzzle('av', 'Kelime Avı', 'Harflere dokunarak bul', '🔎'),
  Puzzle('sarmal', 'Sarmal Bulmaca', 'İç içe ilerleyen kelimeler', '🌀'),
  Puzzle('resim', 'Resimli Bulmaca', 'Resimlerden gizli şifreye', '🖼️'),
];

class BulmacaApp extends StatelessWidget {
  const BulmacaApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: appName,
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: paper,
      colorScheme: ColorScheme.fromSeed(seedColor: green, surface: paper),
      appBarTheme: const AppBarTheme(
        backgroundColor: paper,
        foregroundColor: ink,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'serif',
          fontSize: 23,
          color: ink,
          fontWeight: FontWeight.bold,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: ink,
          foregroundColor: paper,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: const Color(0xFFFFFAF0),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFFB7AA92)),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    ),
    home: const Home(),
  );
}

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Map<String, int> completed = {};
  int get total => completed.values.fold(0, (a, b) => a + b);
  @override
  void initState() {
    super.initState();
    refresh();
  }

  Future<void> refresh() async {
    final counts = <String, int>{};
    for (final p in puzzles) {
      var count = await Store.done(p.id) ? 1 : 0;
      for (var i = 2; i <= levelsPerPuzzle; i++) {
        if (await Store.read('chapter_undefined_$i') == '1') {
          count++;
        }
      }
      counts[p.id] = count;
    }
    if (mounted) {
      setState(() {
        completed
          ..clear()
          ..addAll(counts);
      });
    }
  }

  Future<void> open(Puzzle p) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LevelSelectScreen(puzzle: p)),
    );
    refresh();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      centerTitle: false,
      title: const Text(
        appName,
        style: TextStyle(fontWeight: FontWeight.w800, color: ink, fontSize: 24),
      ),
    ),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: ink,
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.public, color: paper, size: 38),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Keşfet. Düşün. Çöz.',
                            style: TextStyle(
                              color: paper,
                              fontSize: 21,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      appSlogan,
                      style: TextStyle(
                        color: paper,
                        fontSize: 27,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '6 bulmaca türü • 18 bölüm',
                      style: TextStyle(color: Color(0xFFD3E1D5), fontSize: 15),
                    ),
                    const SizedBox(height: 22),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: total / 18,
                        minHeight: 7,
                        color: const Color(0xFFD9BD80),
                        backgroundColor: Colors.white24,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$total / 18 bölüm tamamlandı',
                      style: const TextStyle(color: paper),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              const Text(
                'Bugün hangi macera?',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 23,
                  color: ink,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Kaldığın yerden devam et veya yeni bir tür keşfet.',
                style: TextStyle(color: green, height: 1.4),
              ),
              const SizedBox(height: 16),
              for (final p in puzzles)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Material(
                    color: const Color(0xFFFFFCF6),
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => open(p),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Row(
                          children: [
                            Container(
                              width: 54,
                              height: 54,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE5EBDD),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                p.emoji,
                                style: const TextStyle(fontSize: 28),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: ink,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    p.subtitle,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: green,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${completed[p.id] ?? 0} / 3 bölüm',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: ink,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              color: green,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              const Text(
                'İlerlemen bu cihazda otomatik kaydedilir.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: green),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class PuzzleScreen extends StatefulWidget {
  final Puzzle puzzle;
  const PuzzleScreen({super.key, required this.puzzle});
  @override
  State<PuzzleScreen> createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  bool done = false;
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final d = await Store.done(widget.puzzle.id);
    if (mounted) setState(() => done = d);
  }

  Future<void> solved() async {
    if (done) return;
    await Store.complete(widget.puzzle.id);
    if (!mounted) return;
    setState(() => done = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tebrikler! Bulmaca tamamlandı.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget game = switch (widget.puzzle.id) {
      'cengel' => CrossGame(
        key: const ValueKey('cengel'),
        arrow: true,
        onSolved: solved,
      ),
      'kare' => CrossGame(
        key: const ValueKey('kare'),
        arrow: false,
        onSolved: solved,
      ),
      'sudoku' => SudokuGame(onSolved: solved),
      'av' => SearchGame(onSolved: solved),
      'sarmal' => SpiralGame(onSolved: solved),
      _ => PictureGame(onSolved: solved),
    };
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.puzzle.name),
        actions: [
          if (done)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.verified, color: green),
            ),
        ],
      ),
      body: SafeArea(
        child: ['cengel', 'kare', 'sarmal', 'resim'].contains(widget.puzzle.id)
            ? game
            : ListView(
                padding: const EdgeInsets.all(14),
                children: [
                  EditionHeading(
                    label: widget.puzzle.id == 'av'
                        ? 'KÜLTÜR & EDEBİYAT • 11 KELİME'
                        : widget.puzzle.subtitle,
                  ),
                  const SizedBox(height: 14),
                  game,
                ],
              ),
      ),
    );
  }
}

const sudokuSolved = [
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
const sudokuGivens = [
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

class SudokuGame extends StatefulWidget {
  final VoidCallback onSolved;
  const SudokuGame({super.key, required this.onSolved});
  @override
  State<SudokuGame> createState() => _SudokuGameState();
}

class _SudokuGameState extends State<SudokuGame> {
  late List<List<int>> board;
  int row = 0, col = 0;
  bool notes = false;
  final notesMap = <String, Set<int>>{};
  @override
  void initState() {
    super.initState();
    board = sudokuGivens
        .map((s) => s.split('').map(int.parse).toList())
        .toList();
    restore();
  }

  Future<void> restore() async {
    final raw = await Store.read('sudoku_board');
    if (raw != null &&
        raw.length == 81 &&
        RegExp(r'^[0-9]{81}$').hasMatch(raw)) {
      if (mounted) {
        setState(() {
          for (var i = 0; i < 81; i++) {
            if (sudokuGivens[i ~/ 9][i % 9] == '0') {
              board[i ~/ 9][i % 9] = int.parse(raw[i]);
            }
          }
        });
      }
    }
  }

  void put(int n) {
    if (sudokuGivens[row][col] != '0') return;
    setState(() {
      if (notes && n != 0) {
        notesMap.putIfAbsent('$row,$col', () => {}).add(n);
      } else {
        board[row][col] = n;
        notesMap.remove('$row,$col');
      }
    });
    Store.write('sudoku_board', board.map((r) => r.join()).join());
  }

  void check() {
    final ok = List.generate(
      9,
      (r) => List.generate(
        9,
        (c) => board[r][c] == int.parse(sudokuSolved[r][c]),
      ).every((v) => v),
    ).every((v) => v);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? 'Sudoku tamamlandı!' : 'Henüz doğru tamamlanmadı.'),
      ),
    );
    if (ok) widget.onSolved();
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      AspectRatio(
        aspectRatio: 1,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 9,
          ),
          itemCount: 81,
          itemBuilder: (ctx, i) {
            final r = i ~/ 9, c = i % 9, fixed = sudokuGivens[r][c] != '0';
            final selected = r == row && c == col;
            final wrong =
                board[r][c] != 0 &&
                board[r][c] != int.parse(sudokuSolved[r][c]);
            return GestureDetector(
              onTap: () => setState(() {
                row = r;
                col = c;
              }),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFFF0D497)
                      : ((r ~/ 3 + c ~/ 3) % 2 == 0
                            ? Colors.white
                            : const Color(0xFFF2E9D7)),
                  border: Border(
                    left: BorderSide(color: ink, width: c % 3 == 0 ? 2 : 0.3),
                    top: BorderSide(color: ink, width: r % 3 == 0 ? 2 : 0.3),
                    right: BorderSide(color: ink, width: c == 8 ? 2 : 0),
                    bottom: BorderSide(color: ink, width: r == 8 ? 2 : 0),
                  ),
                ),
                child: board[r][c] != 0
                    ? Text(
                        '${board[r][c]}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: fixed
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: wrong && !fixed ? rust : ink,
                        ),
                      )
                    : Text(
                        (notesMap['$r,$c'] ?? {}).join(' '),
                        style: const TextStyle(fontSize: 7),
                      ),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 10),
      const Text('Bir satırda, sütunda veya 3×3 alanda sayı tekrar etmez.'),
      Wrap(
        spacing: 5,
        children: List.generate(
          9,
          (i) => OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(39, 43),
              padding: EdgeInsets.zero,
            ),
            onPressed: () => put(i + 1),
            child: Text('${i + 1}'),
          ),
        ),
      ),
      Wrap(
        alignment: WrapAlignment.center,
        children: [
          TextButton.icon(
            onPressed: () => put(0),
            icon: const Icon(Icons.backspace),
            label: const Text('Sil'),
          ),
          TextButton.icon(
            onPressed: () => setState(() => notes = !notes),
            icon: Icon(notes ? Icons.edit_note : Icons.edit_outlined),
            label: Text('Not ${notes ? 'açık' : 'kapalı'}'),
          ),
        ],
      ),
      FilledButton(onPressed: check, child: const Text('Sudoku kontrol et')),
    ],
  );
}

String normalize(String s) => trUpper(s)
    .replaceAll('İ', 'I')
    .replaceAll('Ş', 'S')
    .replaceAll('Ğ', 'G')
    .replaceAll('Ü', 'U')
    .replaceAll('Ö', 'O')
    .replaceAll('Ç', 'C');

// Sarmalın konumları dış kenardan başlayıp merkeze ilerler.
List<(int, int)> spiralPositions(int n) {
  final result = <(int, int)>[];
  int top = 0, left = 0, bottom = n - 1, right = n - 1;
  while (top <= bottom && left <= right) {
    for (var c = left; c <= right; c++) {
      result.add((top, c));
    }
    top++;
    for (var r = top; r <= bottom; r++) {
      result.add((r, right));
    }
    right--;
    if (top <= bottom) {
      for (var c = right; c >= left; c--) {
        result.add((bottom, c));
      }
      bottom--;
    }
    if (left <= right) {
      for (var r = bottom; r >= top; r--) {
        result.add((r, left));
      }
      left++;
    }
  }
  return result;
}

/// İlk sürümde her tür için üç oynanabilir bölüm.
const levelsPerPuzzle = 3;

class LevelSelectScreen extends StatefulWidget {
  final Puzzle puzzle;
  const LevelSelectScreen({super.key, required this.puzzle});
  @override
  State<LevelSelectScreen> createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends State<LevelSelectScreen> {
  final Set<int> completed = {};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    reload();
  }

  Future<void> reload() async {
    final ids = <int>{};
    for (var level = 1; level <= levelsPerPuzzle; level++) {
      final done = level == 1
          ? await Store.done(widget.puzzle.id)
          : await Store.read('chapter_${widget.puzzle.id}_$level') == '1';
      if (done) ids.add(level);
    }
    if (mounted) {
      setState(() {
        completed
          ..clear()
          ..addAll(ids);
        loading = false;
      });
    }
  }

  Future<void> open(int level) async {
    if (level > 1 && !completed.contains(level - 1)) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => level == 1
            ? PuzzleScreen(puzzle: widget.puzzle)
            : ExtraLevelScreen(puzzle: widget.puzzle, level: level),
      ),
    );
    reload();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.puzzle.name)),
    body: loading
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            padding: const EdgeInsets.all(16),
            children: [
              EditionHeading(
                label: '${widget.puzzle.name} • $levelsPerPuzzle BÖLÜM',
              ),
              const SizedBox(height: 14),
              Text(
                '${completed.length} / $levelsPerPuzzle bölüm tamamlandı',
                style: const TextStyle(fontFamily: 'serif', fontSize: 16),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: completed.length / levelsPerPuzzle,
                color: green,
                backgroundColor: Colors.black12,
              ),
              const SizedBox(height: 18),
              for (var i = 1; i <= levelsPerPuzzle; i++)
                Card(
                  child: ListTile(
                    key: ValueKey('level_$i'),
                    onTap: i == 1 || completed.contains(i - 1)
                        ? () => open(i)
                        : null,
                    leading: CircleAvatar(
                      backgroundColor: completed.contains(i)
                          ? green
                          : selectedPaper,
                      foregroundColor: completed.contains(i)
                          ? Colors.white
                          : ink,
                      child: completed.contains(i)
                          ? const Icon(Icons.check)
                          : Text('$i'),
                    ),
                    title: Text(
                      'Bölüm $i',
                      style: const TextStyle(
                        fontFamily: 'serif',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      i == 1 ? 'Klasik gazete bulmacası' : extraTheme(i),
                    ),
                    trailing: Icon(
                      i == 1 || completed.contains(i - 1)
                          ? Icons.chevron_right
                          : Icons.lock_outline,
                    ),
                  ),
                ),
            ],
          ),
  );
}
