import 'dart:convert';
import 'package:bulmaca_gazetesi/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late SharedPreferencesAsync prefs;
  setUpAll(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    prefs = SharedPreferencesAsync();
  });
  setUp(() async {
    await prefs.clear();
  });
  Future<void> open(WidgetTester tester, Widget child) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(home: child));
    await tester.pumpAndSettle();
  }

  Future<void> click(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.tap(finder);
    await tester.pump();
  }

  Future<void> letters(WidgetTester tester, String value) async {
    for (final char in value.split('')) {
      await tester.tap(find.byKey(ValueKey('letter_$char')));
      await tester.pump();
      expect(tester.takeException(), isNull, reason: '$char yazılırken hata');
    }
  }

  test('10 yeni sudokunun tümü farklı ve satır/sütun/alanları geçerli', () {
    final boards = <String>{};
    for (var level = 2; level <= 11; level++) {
      final board = extraSudokuSolution(level);
      boards.add(board.map((r) => r.join()).join());
      for (var i = 0; i < 9; i++) {
        expect(board[i].toSet(), {1, 2, 3, 4, 5, 6, 7, 8, 9});
        expect(List.generate(9, (r) => board[r][i]).toSet(), {
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
          9,
        });
        expect(
          List.generate(
            9,
            (j) => board[i ~/ 3 * 3 + j ~/ 3][i % 3 * 3 + j % 3],
          ).toSet(),
          {1, 2, 3, 4, 5, 6, 7, 8, 9},
        );
      }
    }
    expect(boards.length, 10);
  });

  for (final puzzle in puzzles) {
    for (var level = 2; level <= levelsPerPuzzle; level++) {
      testWidgets(
        '${puzzle.id} bölüm $level ekrandan çözülür, kaydedilir ve tamamlanır',
        (tester) async {
          final pack = extraPacks[level - 2];
          await open(
            tester,
            ExtraLevelScreen(
              key: ValueKey('${puzzle.id}_$level'),
              puzzle: puzzle,
              level: level,
            ),
          );
          final chapter = 'chapter_${puzzle.id}_$level';
          expect(await Store.read(chapter), isNull);
          switch (puzzle.id) {
            case 'cengel':
            case 'kare':
              final placed = makeCrosswords(pack, arrow: puzzle.id == 'cengel');
              for (var i = 0; i < placed.length; i++) {
                final word = placed[i].answer;
                await click(
                  tester,
                  find.text('${i + 1}. ${word.clue} (${word.word.length})'),
                );
                await letters(tester, word.word);
              }
              await click(tester, find.text('Cevapları kontrol et'));
            case 'sudoku':
              final solution = extraSudokuSolution(level),
                  fixed = extraSudokuFixed(level);
              for (var r = 0; r < 9; r++) {
                for (var c = 0; c < 9; c++) {
                  if (fixed[r][c]) continue;
                  await click(
                    tester,
                    find.byKey(ValueKey('extra_sudoku_$r,$c')),
                  );
                  await click(
                    tester,
                    find.byKey(ValueKey('extra_number_${solution[r][c]}')),
                  );
                }
              }
              await click(tester, find.text('Sudoku kontrol et'));
            case 'av':
              final board = makeExtraSearch(pack, level);
              for (final entry in board.entries) {
                final cells = searchCells(entry);
                await click(
                  tester,
                  find.byKey(
                    ValueKey('search_${cells.first.$1},${cells.first.$2}'),
                  ),
                );
                await click(
                  tester,
                  find.byKey(
                    ValueKey('search_${cells.last.$1},${cells.last.$2}'),
                  ),
                );
              }
            case 'sarmal':
              final answer = pack.words.map((e) => trUpper(e.word)).join();
              await letters(tester, answer);
              final data =
                  jsonDecode((await Store.read('extra_sarmal_$level'))!)
                      as Map<String, dynamic>;
              final entered = data['entered'] as Map;
              expect(
                entered.length,
                answer.length,
                reason: '36. kutudan sonra giriş durmamalı',
              );
              await click(tester, find.text('Sarmalı kontrol et'));
            case 'resim':
              for (var i = 0; i < 5; i++) {
                final field = find.byKey(ValueKey('picture_answer_$i'));
                await tester.ensureVisible(field);
                await tester.enterText(field, pack.words[i].word);
                await tester.pump();
              }
              await click(tester, find.text('Cevapları kontrol et'));
          }
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          expect(await Store.read(chapter), '1');
          expect(find.text('Bölüm tamamlandı!'), findsOneWidget);
          if (puzzle.id != 'av') {
            final data =
                jsonDecode((await Store.read('extra_${puzzle.id}_$level'))!)
                    as Map<String, dynamic>;
            expect(data['found'], isA<List>());
            expect(data['entered'], isA<Map>());
          }
        },
      );
    }
  }
}
