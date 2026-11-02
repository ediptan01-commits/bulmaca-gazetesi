import 'package:bulmaca_gazetesi/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  setUpAll(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });
  setUp(() async => SharedPreferencesAsync().clear());
  testWidgets('İkinci bölümde sürüklenen çizgi düz kalır ve yeniden açılır', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final puzzle = puzzles.firstWhere((p) => p.id == 'av');
    Future<void> open(String key) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ExtraLevelScreen(key: ValueKey(key), puzzle: puzzle, level: 2),
        ),
      );
      await tester.pumpAndSettle();
    }

    await open('first');
    expect(find.byType(SearchGame), findsOneWidget);
    final board = makeExtraSearch(extraPacks[0], 2);
    final entry = board.entries.first;
    final cells = searchCells(entry);
    final first = tester.getCenter(
      find.byKey(ValueKey('search_${cells.first.$1},${cells.first.$2}')),
    );
    final last = tester.getCenter(
      find.byKey(ValueKey('search_${cells.last.$1},${cells.last.$2}')),
    );
    final gesture = await tester.startGesture(first);
    await gesture.moveTo(
      Offset((first.dx + last.dx) / 2 + 3, (first.dy + last.dy) / 2 - 4),
    );
    await tester.pump();
    await gesture.moveTo(last);
    await gesture.up();
    await tester.pumpAndSettle();
    var ink = tester.widget<WordSearchInk>(find.byType(WordSearchInk));
    expect(ink.strokes, hasLength(1));
    expect(ink.strokes.single, hasLength(2));
    expect(await Store.read('search_level_2_found'), entry.$1);
    await open('reload');
    ink = tester.widget<WordSearchInk>(find.byType(WordSearchInk));
    expect(ink.strokes, hasLength(1));
    expect(ink.strokes.single, hasLength(2));
    expect(tester.takeException(), isNull);
  });
  testWidgets('Eski ikinci bölüm kaydı düzgün çizgiye dönüştürülür', (
    tester,
  ) async {
    final word = makeExtraSearch(extraPacks[0], 2).entries.first.$1;
    await Store.write('extra_av_2', '{"found":["$word"]}');
    await tester.pumpWidget(
      MaterialApp(
        home: ExtraLevelScreen(
          puzzle: puzzles.firstWhere((p) => p.id == 'av'),
          level: 2,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      tester.widget<WordSearchInk>(find.byType(WordSearchInk)).strokes,
      hasLength(1),
    );
  });
}
