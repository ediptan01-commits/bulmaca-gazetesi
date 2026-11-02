import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bulmaca_gazetesi/main.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  setUpAll(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });
  setUp(() async {
    await SharedPreferencesAsync().clear();
  });
  testWidgets(
    'Referans ana ekran: altı kart ve alt menü küçük telefonda açılır',
    (tester) async {
      tester.view.physicalSize = const Size(320, 740);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const BulmacaApp());
      await tester.pumpAndSettle();
      expect(find.byType(ReferenceArtwork), findsOneWidget);
      for (final p in puzzles.take(6)) {
        expect(find.byKey(ValueKey('home_puzzle_${p.id}')), findsOneWidget);
      }
      for (final tab in ['home', 'puzzles', 'achievements', 'profile']) {
        expect(find.byKey(ValueKey('nav_$tab')), findsOneWidget);
      }
      await tester.tap(find.byKey(const ValueKey('home_puzzle_cengel')));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('level_2')), findsOneWidget);
      expect(find.byKey(const ValueKey('level_3')), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('Yeni çapraz türü koleksiyondan iki bölümüyle açılır', (
    tester,
  ) async {
    await tester.pumpWidget(const BulmacaApp());
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const ValueKey('nav_puzzles')));
    await tester.tap(find.byKey(const ValueKey('nav_puzzles')));
    await tester.pumpAndSettle();
    final card = find.byKey(const ValueKey('collection_capraz'));
    await tester.scrollUntilVisible(card, 250);
    await tester.tap(card);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('level_2')), findsOneWidget);
    expect(find.byKey(const ValueKey('level_3')), findsNothing);
    expect(tester.takeException(), isNull);
  });
  testWidgets('Profil gerçek toplam ilerlemeyi gösterir', (tester) async {
    for (final p in puzzles) {
      await Store.complete(p.id);
      await Store.write('chapter_${p.id}_2', '1');
    }
    await tester.pumpWidget(const BulmacaApp());
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const ValueKey('nav_profile')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('nav_profile')));
    await tester.pumpAndSettle();
    expect(find.text('14 / 14 bölüm tamamlandı'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  test('Günlük görev üç farklı tür ister ve yıldız bir kez verilir', () async {
    await DailyGameProgress.record('cengel');
    await DailyGameProgress.record('cengel');
    expect((await DailyGameProgress.read()).length, 1);
    expect(await Store.read('daily_stars'), isNull);
    await DailyGameProgress.record('kare');
    await DailyGameProgress.record('sudoku');
    await DailyGameProgress.record('resim');
    expect(await Store.read('daily_stars'), '1');
  });
  test('Yeni çapraz ızgarası eski harf ve tamamlanma kaydını almaz', () async {
    final prefs = SharedPreferencesAsync();
    await prefs.setString('edition2_free_cross_1', '{"1,1":"X"}');
    await prefs.setString('edition2_done_capraz', '1');
    await prefs.setString('edition2_chapter_capraz_2', '1');
    expect(await Store.read('free_cross_1'), isNull);
    expect(await Store.done('capraz'), isFalse);
    expect(await Store.read('chapter_capraz_2'), isNull);
  });
  test(
    'Yeni çengel eski küçük ızgaranın tamamlanma kaydını kullanmaz',
    () async {
      final prefs = SharedPreferencesAsync();
      await prefs.setString('edition5_done_cengel', '1');
      await prefs.setString('edition2_chapter_cengel_2', '1');
      expect(await Store.done('cengel'), isFalse);
      expect(await Store.read('chapter_cengel_2'), isNull);
    },
  );
}
