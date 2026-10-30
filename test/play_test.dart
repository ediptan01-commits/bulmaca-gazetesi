import 'dart:convert';

import 'package:bulmaca_gazetesi/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late SharedPreferencesAsync preferences;
  setUpAll(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    preferences = SharedPreferencesAsync();
  });
  setUp(() async {
    await preferences.clear();
  });

  Future<void> open(
    WidgetTester tester,
    Widget child, {
    Size size = const Size(390, 844),
    double textScale = 1,
  }) async {
    tester.view.reset();
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(
            size: size,
            textScaler: TextScaler.linear(textScale),
          ),
          child: Scaffold(body: SafeArea(child: child)),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Kesişim kutusunda yön değişir ve harf her iki cevaba yazılır', (
    tester,
  ) async {
    await open(tester, CrossGame(arrow: false, onSolved: () {}));
    // DEMİR ve DÜĞME aynı başlangıç kutusunda kesişir.
    await tester.tap(find.byKey(const ValueKey('cross_0,0')));
    await tester.pump();
    expect(
      find.textContaining('Giysiyi iliklemeye yarayan parça'),
      findsWidgets,
    );
    await tester.tap(find.byKey(const ValueKey('letter_D')));
    await tester.pumpAndSettle();
    final saved =
        jsonDecode((await Store.read('cross_false'))!) as Map<String, dynamic>;
    expect(saved['0,0'], 'D');
    expect(saved.length, 1);
    await tester.tap(find.byTooltip('Harf sil'));
    await tester.pumpAndSettle();
    expect(jsonDecode((await Store.read('cross_false'))!), isEmpty);
  });

  testWidgets('Çengel soru hücresi seçilir ve ok yönüne yazılır', (
    tester,
  ) async {
    await open(tester, CrossGame(arrow: true, onSolved: () {}));
    final clue = arrowWords.first;
    await tester.tap(
      find
          .bySemanticsLabel('${clue.clue}, ${clue.vertical ? 'aşağı' : 'sağa'}')
          .first,
    );
    await tester.tap(find.byKey(ValueKey('letter_${clue.text[0]}')));
    await tester.pumpAndSettle();
    final saved =
        jsonDecode((await Store.read('cross_true'))!) as Map<String, dynamic>;
    expect(saved['${clue.r},${clue.c}'], clue.text[0]);
  });

  testWidgets('Kelime avı ters uçtan seçilir, yeniden açılınca korunur', (
    tester,
  ) async {
    var solved = 0;
    await open(tester, SearchGame(onSolved: () => solved++));
    final entry = searchEntries.first, cells = searchCells(searchEntries.first);
    await tester.tap(
      find.byKey(ValueKey('search_${cells.last.$1},${cells.last.$2}')),
    );
    await tester.tap(
      find.byKey(ValueKey('search_${cells.first.$1},${cells.first.$2}')),
    );
    await tester.pumpAndSettle();
    expect(await Store.read('search_found'), entry.$1);
    expect(find.text('1 / 12 kelime bulundu'), findsOneWidget);
    await open(
      tester,
      SearchGame(key: const ValueKey('reopen'), onSolved: () => solved++),
    );
    expect(find.text('1 / 12 kelime bulundu'), findsOneWidget);
    expect(solved, 0);
  });

  testWidgets('Sarmal doğru doldurulunca tamamlanır ve boşta tamamlanmaz', (
    tester,
  ) async {
    var solved = 0;
    await open(tester, SpiralGame(onSolved: () => solved++));
    final check = find.text('Sarmalı kontrol et');
    await tester.ensureVisible(check);
    await tester.tap(check);
    await tester.pumpAndSettle();
    expect(solved, 0);
    await Store.write('spiral', spiralAnswer);
    await open(
      tester,
      SpiralGame(key: const ValueKey('filled'), onSolved: () => solved++),
    );
    await tester.ensureVisible(check);
    await tester.tap(check);
    await tester.pumpAndSettle();
    expect(solved, 1);
  });

  testWidgets('Kelime avında sürükleme başlangıç harfini korur', (
    tester,
  ) async {
    await open(tester, SearchGame(onSolved: () {}));
    final cells = searchCells(searchEntries[1]);
    final from = tester.getCenter(
      find.byKey(ValueKey('search_${cells.first.$1},${cells.first.$2}')),
    );
    final to = tester.getCenter(
      find.byKey(ValueKey('search_${cells.last.$1},${cells.last.$2}')),
    );
    await tester.dragFrom(from, to - from);
    await tester.pumpAndSettle();
    expect(await Store.read('search_found'), searchEntries[1].$1);
  });

  testWidgets('Yeni sayıya eski örneklerin tamamlanma durumu taşınmaz', (
    tester,
  ) async {
    await preferences.setString('done_cengel', '1');
    await preferences.setString('cross_true', '{"0,0":"X"}');
    await preferences.setString('done_sudoku', '1');
    expect(await Store.done('cengel'), isFalse);
    expect(await Store.read('cross_true'), isNull);
    expect(await Store.done('sudoku'), isTrue);
  });

  testWidgets(
    'Altı sayfa küçük ekranda ve büyük metinde taşma olmadan açılır',
    (tester) async {
      for (final puzzle in puzzles) {
        await open(
          tester,
          PuzzleScreen(key: ValueKey(puzzle.id), puzzle: puzzle),
          size: const Size(320, 740),
          textScale: 1.3,
        );
        expect(tester.takeException(), isNull, reason: puzzle.name);
        if (['cengel', 'kare', 'sarmal'].contains(puzzle.id)) {
          expect(
            find.byKey(const ValueKey('letter_A')).hitTestable(),
            findsOneWidget,
          );
        }
      }
    },
  );
}
