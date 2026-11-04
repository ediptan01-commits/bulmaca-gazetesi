import 'package:bulmaca_gazetesi/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final kind in ['cengel', 'kare', 'capraz']) {
    for (final level in [1, 2]) {
      test('$kind bölüm $level: bütün kelimeler kesişim ve numaralama bakımından tutarlı', () {
        final words = kind == 'capraz'
            ? freeCrossWordsForLevel(level)
            : gazeteWordsForLevel(kind, level);
        expect(words.length, greaterThanOrEqualTo(18));
        expect(words.map((w) => w.text).toSet(), hasLength(words.length));

        final cells = <(int, int), String>{};
        final owners = <(int, int), Set<int>>{};
        for (var index = 0; index < words.length; index++) {
          final word = words[index];
          expect(word.clue.trim(), isNotEmpty);
          for (var i = 0; i < word.text.length; i++) {
            final pos = word.cells[i];
            if (cells.containsKey(pos)) {
              expect(cells[pos], word.text[i], reason: '$kind $level: çakışan harf $pos');
            }
            cells[pos] = word.text[i];
            owners.putIfAbsent(pos, () => {}).add(index);
          }
        }

        for (final position in cells.keys) {
          for (final vertical in [false, true]) {
            final dr = vertical ? 1 : 0;
            final dc = vertical ? 0 : 1;
            if (cells.containsKey((position.$1 - dr, position.$2 - dc))) {
              continue;
            }
            var answer = '';
            var i = 0;
            while (cells.containsKey((position.$1 + i * dr, position.$2 + i * dc))) {
              answer += cells[(position.$1 + i * dr, position.$2 + i * dc)]!;
              i++;
            }
            if (answer.length < 2) continue;
            expect(
              words.where((word) =>
                  word.r == position.$1 &&
                  word.c == position.$2 &&
                  word.vertical == vertical &&
                  word.text == answer),
              hasLength(1),
              reason: '$kind $level: sorusuz harf dizisi $answer',
            );
          }
        }

        final connected = <int>{0};
        var previous = -1;
        while (connected.length != previous) {
          previous = connected.length;
          for (final group in owners.values) {
            if (group.any(connected.contains)) {
              connected.addAll(group);
            }
          }
        }
        expect(connected, hasLength(words.length));
      });
    }
  }

  testWidgets('Çengelde ipucu hücresi yok; soru listesi ızgara dışında', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 390,
          height: 800,
          child: CrossGame(arrow: true, level: 1, onSolved: () {}),
        ),
      ),
    ));
    await tester.pumpAndSettle();
    expect(find.byType(PaperGrid), findsOneWidget);
    expect(find.byType(ArrowPaperGrid), findsNothing);
    expect(find.text('SOLDAN SAĞA'), findsOneWidget);
    expect(find.text('YUKARIDAN AŞAĞIYA'), findsOneWidget);
  });
}
