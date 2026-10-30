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

  test('Dairesel sarmalın 49 dilimi daire içinde ve ayrı ayrı seçilebilir', () {
    const geometry = CircularSpiralGeometry(360);
    expect(CircularSpiralGeometry.counts.reduce((a, b) => a + b), 49);
    for (var i = 0; i < 49; i++) {
      expect(geometry.hit(geometry.center(i)), i);
      expect(
        (geometry.center(i) - geometry.origin).distance,
        lessThan(geometry.radius),
      );
    }
    expect(geometry.hit(const Offset(0, 0)), isNull);
    expect(geometry.center(48), geometry.origin);
  });

  testWidgets('Klavye Türkçe Q sırasındadır ve Q W X içerir', (tester) async {
    var value = '';
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.bottomCenter,
            child: LetterKeyboard(onLetter: (s) => value = s, onDelete: () {}),
          ),
        ),
      ),
    );
    expect(turkishQRows, ['QWERTYUIOPĞÜ', 'ASDFGHJKLŞİ', 'ZXCVBNMÖÇ']);
    final q = find.byKey(const ValueKey('letter_Q')),
        w = find.byKey(const ValueKey('letter_W')),
        a = find.byKey(const ValueKey('letter_A'));
    expect(tester.getCenter(q).dx, lessThan(tester.getCenter(w).dx));
    expect(tester.getCenter(q).dy, lessThan(tester.getCenter(a).dy));
    await tester.tap(find.byKey(const ValueKey('letter_İ')));
    expect(value, 'İ');
  });

  testWidgets(
    'Karalama izi canlı görünür, doğru kelimede kalır ve geri yüklenir',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: SearchGame(onSolved: () {})),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final cells = searchCells(searchEntries.first);
      final first = tester.getCenter(
        find.byKey(ValueKey('search_${cells.first.$1},${cells.first.$2}')),
      );
      final last = tester.getCenter(
        find.byKey(ValueKey('search_${cells.last.$1},${cells.last.$2}')),
      );
      final gesture = await tester.startGesture(first);
      await gesture.moveTo(Offset((first.dx + last.dx) / 2, first.dy));
      await tester.pump();
      await gesture.moveTo(last);
      await tester.pump();
      expect(
        tester.widget<WordSearchInk>(find.byType(WordSearchInk)).live.length,
        greaterThan(1),
      );
      await gesture.up();
      await tester.pumpAndSettle();
      final saved =
          jsonDecode((await Store.read('search_ink'))!) as Map<String, dynamic>;
      expect(saved[searchEntries.first.$1], isNotEmpty);
      expect(
        tester.widget<WordSearchInk>(find.byType(WordSearchInk)).strokes,
        hasLength(1),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: SearchGame(key: const ValueKey('reload'), onSolved: () {}),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        tester.widget<WordSearchInk>(find.byType(WordSearchInk)).strokes,
        hasLength(1),
      );
    },
  );

  testWidgets(
    'Gerçek telefon sayfasında hızlı tek hareketli karalama çalışır',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(
          home: PuzzleScreen(puzzle: puzzles.firstWhere((p) => p.id == 'av')),
        ),
      );
      await tester.pumpAndSettle();
      for (final entry in searchEntries) {
        final cells = searchCells(entry);
        final from = tester.getCenter(
          find.byKey(ValueKey('search_${cells.first.$1},${cells.first.$2}')),
        );
        final to = tester.getCenter(
          find.byKey(ValueKey('search_${cells.last.$1},${cells.last.$2}')),
        );
        await tester.dragFrom(from, to - from);
        await tester.pumpAndSettle();
        expect(
          (await Store.read('search_found'))!.split('|'),
          contains(entry.$1),
        );
      }
      expect(
        tester.widget<WordSearchInk>(find.byType(WordSearchInk)).strokes,
        hasLength(searchEntries.length),
      );
    },
  );
}
