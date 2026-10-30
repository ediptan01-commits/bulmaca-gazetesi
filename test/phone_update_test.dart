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
  Future<void> open(WidgetTester tester, Widget game) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: game)));
    await tester.pumpAndSettle();
  }

  testWidgets(
    'Çengelde yazı, silme ve soru değiştirme yakınlaştırmayı değiştirmez',
    (tester) async {
      await open(tester, CrossGame(arrow: true, onSolved: () {}));
      expect(find.textContaining('OKLU ÇENGEL'), findsNothing);
      expect(find.textContaining('Kaydırarak'), findsNothing);
      await tester.tap(find.byTooltip('Büyüt'));
      await tester.pumpAndSettle();
      final controller = tester
          .widget<InteractiveViewer>(
            find.byKey(const ValueKey('cross_viewport')),
          )
          .transformationController!;
      final original = List<double>.from(controller.value.storage);
      for (final letter in ['T', 'U', 'Z']) {
        await tester.tap(find.byKey(ValueKey('letter_$letter')));
        await tester.pump();
      }
      await tester.tap(find.byTooltip('Harf sil'));
      await tester.pump();
      await tester.tap(find.byTooltip('Sonraki soru'));
      await tester.pumpAndSettle();
      expect(controller.value.storage, orderedEquals(original));
    },
  );
  testWidgets('Eski eğri karalamalar açılırken düz merkez çizgisine dönüşür', (
    tester,
  ) async {
    expect(searchWords.length, 11);
    final entry = searchEntries.first;
    await Store.write('search_found', entry.$1);
    await Store.write(
      'search_ink',
      jsonEncode({
        entry.$1: [
          [.1, .1],
          [.2, .7],
          [.9, .4],
        ],
      }),
    );
    await open(
      tester,
      SingleChildScrollView(child: SearchGame(onSolved: () {})),
    );
    final stroke = tester
        .widget<WordSearchInk>(find.byType(WordSearchInk))
        .strokes
        .single;
    expect(stroke.length, 2);
    expect(stroke.first.dy, stroke.last.dy);
    expect(snapSearchEnd((7, 4), (8, 9)), (7, 9));
  });
  testWidgets(
    'Altı çizimli nesne çözülünce gizli şifre açılır ve kayıt korunur',
    (tester) async {
      var complete = 0;
      await open(tester, PictureGame(onSolved: () => complete++));
      expect(find.byType(PictureScene), findsOneWidget);
      expect(pictureSecret, 'GAZETE');
      for (final clue in pictureClues) {
        for (final char in clue.answer.split('')) {
          await tester.tap(find.byKey(ValueKey('letter_$char')));
          await tester.pump();
        }
        await tester.tap(find.text('Kontrol et'));
        await tester.pumpAndSettle();
      }
      expect(complete, 1);
      expect(find.text('Şifre çözüldü: GAZETE'), findsOneWidget);
      final saved =
          jsonDecode((await Store.read('picture_cipher'))!)
              as Map<String, dynamic>;
      for (var i = 0; i < pictureClues.length; i++) {
        expect(saved['$i'], pictureClues[i].answer);
      }
      await open(
        tester,
        PictureGame(
          key: const ValueKey('restored'),
          onSolved: () => complete++,
        ),
      );
      expect(find.text('Şifre çözüldü: GAZETE'), findsOneWidget);
      expect(complete, 1);
    },
  );
}
