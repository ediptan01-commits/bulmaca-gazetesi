import 'package:bulmaca_gazetesi/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  for (var level = 1; level <= 3; level++) {
    test(
      'Çengel $level: bütün harfler erişilebilir ve bütün dizilerin sorusu var',
      () {
        final words = arrowWordsForLevel(level);
        final rows = level == 1 ? arrowRows : 8;
        final letters = <(int, int), String>{};
        final hints = words.map((w) => w.clueCell).toSet();
        for (final w in words) {
          expect(w.clue, isNotEmpty);
          expect(w.cells.any(hints.contains), isFalse,
              reason: '${w.text}: ipucu harfi kapatıyor');
          for (var i = 0; i < w.cells.length; i++) {
            final cell = w.cells[i];
            expect(cell.$1, inInclusiveRange(0, rows - 1));
            expect(cell.$2, inInclusiveRange(0, arrowSize - 1));
            if (letters.containsKey(cell)) {
              expect(letters[cell], w.text[i]);
            }
            letters[cell] = w.text[i];
          }
        }
        for (final cell in hints) {
          expect(cell.$1, inInclusiveRange(0, rows - 1));
          expect(cell.$2, inInclusiveRange(0, arrowSize - 1));
        }
        for (final cell in letters.keys) {
          for (final vertical in [false, true]) {
            final dr = vertical ? 1 : 0, dc = vertical ? 0 : 1;
            if (letters.containsKey((cell.$1 - dr, cell.$2 - dc))) continue;
            var n = 0;
            while (letters.containsKey((cell.$1 + n * dr, cell.$2 + n * dc))) {
              n++;
            }
            if (n > 1) {
              expect(
                words.any((w) =>
                    w.r == cell.$1 && w.c == cell.$2 &&
                    w.vertical == vertical && w.text.length == n),
                isTrue,
                reason: 'Sorusuz ${vertical ? 'dikey' : 'yatay'} kelime: $cell',
              );
            }
          }
        }
        // 8×11 çengelde alt ve üst blokların her ikisi de doludur.
        final closed = rows * arrowSize - letters.length - hints.length;
        expect(closed, lessThanOrEqualTo(level == 1 ? 9 : 3));
      },
    );
    testWidgets(
      'Çengel $level: küçük telefonda ilk ve son satır klavye üstüne sığar',
      (tester) async {
        SharedPreferencesAsyncPlatform.instance =
            InMemorySharedPreferencesAsync.empty();
        tester.view.physicalSize = const Size(320, 640);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Çengel')),
            body: SafeArea(
              child: CrossGame(arrow: true, level: level, onSolved: () {}),
            ),
          ),
        ));
        await tester.pumpAndSettle();
        final grid = tester.getRect(find.byType(PaperGrid));
        final keyboard = tester.getRect(find.byType(LetterKeyboard));
        expect(grid.top, greaterThanOrEqualTo(56));
        expect(grid.bottom, lessThan(keyboard.top));
        expect(tester.takeException(), isNull);
      },
    );
  }
  test('Üç resimli bölüm farklı sahne ve anlamlı şifre içerir', () {
    expect([
      for (var level = 1; level <= 3; level++)
        pictureCluesForLevel(level).map((c) => c.answer[c.secretIndex]).join(),
    ], ['GAZETE', 'BAHÇEM', 'BİLGİN']);
    expect(pictureCluesForLevel(2).map((c) => c.answer),
        isNot(pictureCluesForLevel(3).map((c) => c.answer)));
  });
}
