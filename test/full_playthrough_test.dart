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
  setUp(() async => prefs.clear());

  Future<void> open(WidgetTester tester, Widget child) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(home: child));
    await tester.pumpAndSettle();
  }

  Future<void> click(WidgetTester tester, Finder finder) async {
    expect(finder, findsOneWidget);
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pump();
  }

  Future<void> letters(WidgetTester tester, String value) async {
    for (final char in value.split('')) {
      await tester.tap(find.byKey(ValueKey('letter_$char')));
      await tester.pump();
      expect(tester.takeException(), isNull,
          reason: '$char harfi girilirken Flutter hatası');
    }
  }

  test('Üç bölümlük sürüm 6 tür ve 18 bölüm içeriyor', () {
    expect(levelsPerPuzzle, 3);
    expect(puzzles, hasLength(6));
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
              final words = arrowWordsForLevel(level);
              for (var i = 0; i < words.length; i++) {
                await click(tester, find.byKey(ValueKey('arrow_clue_$i')));
                await letters(tester, words[i].text);
              }
              await click(tester, find.text('Kontrol et'));

            case 'kare':
              final placed = makeCrosswords(pack, arrow: false);
              for (var i = 0; i < placed.length; i++) {
                await click(tester, find.byKey(ValueKey('extra_cross_clue_$i')));
                await letters(tester, placed[i].answer.word);
              }
              await click(tester, find.text('Cevapları kontrol et'));

            case 'sudoku':
              final solution = extraSudokuSolution(level);
              final fixed = extraSudokuFixed(level);
              for (var r = 0; r < 9; r++) {
                for (var c = 0; c < 9; c++) {
                  if (fixed[r][c]) continue;
                  await click(tester, find.byKey(ValueKey('extra_sudoku_$r,$c')));
                  await click(tester,
                      find.byKey(ValueKey('extra_number_${solution[r][c]}')));
                }
              }
              await click(tester, find.text('Sudoku kontrol et'));

            case 'av':
              final board = makeExtraSearch(pack, level);
              for (final entry in board.entries) {
                final cells = searchCells(entry);
                await click(tester,
                    find.byKey(ValueKey('search_${cells.first.$1},${cells.first.$2}')));
                await click(tester,
                    find.byKey(ValueKey('search_${cells.last.$1},${cells.last.$2}')));
              }

            case 'sarmal':
              final answer = pack.words.map((e) => trUpper(e.word)).join();
              await letters(tester, answer);
              final saved = jsonDecode(
                  (await Store.read('extra_sarmal_$level'))!) as Map<String, dynamic>;
              expect((saved['entered'] as Map).length, answer.length);
              await click(tester, find.text('Sarmalı kontrol et'));

            case 'resim':
              for (final clue in pictureCluesForLevel(level)) {
                await letters(tester, clue.answer);
                await click(tester, find.text('Kontrol et'));
                await tester.pumpAndSettle();
              }
          }

          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          expect(await Store.read(chapter), '1',
              reason: '${puzzle.id} bölüm $level tamamlanmış olmalı');
          expect(find.text('Bölüm tamamlandı!'), findsOneWidget);
          if (['kare', 'sudoku', 'sarmal'].contains(puzzle.id)) {
            final raw = await Store.read('extra_${puzzle.id}_$level');
            expect(raw, isNotNull);
            final saved = jsonDecode(raw!) as Map<String, dynamic>;
            expect(saved['found'], isA<List>());
            expect(saved['entered'], isA<Map>());
          }
        },
      );
    }
  }
}
