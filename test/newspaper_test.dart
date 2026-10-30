import 'package:bulmaca_gazetesi/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Altı bulmaca türü korunur', () {
    expect(puzzles.map((p) => p.id).toSet(), {
      'cengel',
      'kare',
      'sudoku',
      'av',
      'sarmal',
      'resim',
    });
  });

  for (final arrow in [false, true]) {
    test(
      '${arrow ? 'Çengel' : 'Kare'}: kesişimler, sorular ve bütünlük doğru',
      () {
        final words = arrow ? arrowWords : crossWords;
        final size = arrow ? arrowSize : crossSize;
        final grid = <(int, int), String>{};
        expect(words.length, greaterThanOrEqualTo(20));
        expect(words.map((w) => w.text).toSet().length, words.length);
        for (final w in words) {
          expect(w.clue, isNotEmpty);
          for (var i = 0; i < w.cells.length; i++) {
            final cell = w.cells[i];
            expect(cell.$1, inInclusiveRange(0, size - 1));
            expect(cell.$2, inInclusiveRange(0, size - 1));
            if (grid.containsKey(cell)) {
              expect(
                grid[cell],
                w.text[i],
                reason: '${w.text} kesişiminde harf çakışması',
              );
            }
            grid[cell] = w.text[i];
          }
        }
        // Her kesintisiz yatay/dikey harf dizisinin bir sorusu olmalı.
        for (final cell in grid.keys) {
          for (final vertical in [false, true]) {
            final dr = vertical ? 1 : 0, dc = vertical ? 0 : 1;
            if (grid.containsKey((cell.$1 - dr, cell.$2 - dc))) continue;
            var length = 0;
            while (grid.containsKey((
              cell.$1 + length * dr,
              cell.$2 + length * dc,
            ))) {
              length++;
            }
            if (length > 1) {
              expect(
                words.any(
                  (w) =>
                      w.r == cell.$1 &&
                      w.c == cell.$2 &&
                      w.vertical == vertical &&
                      w.text.length == length,
                ),
                isTrue,
                reason: '$cell noktasında ipucusuz dizi',
              );
            }
          }
        }
        // Ayrık küçük bulmacalar yerine tek bir bağlı ızgara.
        final reached = {grid.keys.first};
        var previous = 0;
        while (previous != reached.length) {
          previous = reached.length;
          for (final w in words) {
            if (w.cells.any(reached.contains)) reached.addAll(w.cells);
          }
        }
        expect(reached.length, grid.length);
        if (arrow) {
          for (final w in words) {
            expect(w.clueCell.$1, inInclusiveRange(0, size - 1));
            expect(w.clueCell.$2, inInclusiveRange(0, size - 1));
            expect(
              grid.containsKey(w.clueCell),
              isFalse,
              reason: '${w.text} soru kutusu harf üstünde',
            );
          }
        }
        final clueCells = arrow
            ? words.map((w) => w.clueCell).toSet().length
            : 0;
        final black = size * size - grid.length - clueCells;
        expect(black / (size * size), lessThan(arrow ? .06 : .2));
      },
    );
  }

  test('Kelime avındaki tüm cevaplar sekiz yönde erişilebilir', () {
    expect(searchGrid.length, 12);
    expect(searchWords.length, 8);
    expect(searchGrid.every((row) => row.length == searchGrid.length), isTrue);
    expect(searchEntries.map((e) => (e.$4, e.$5)).toSet().length, 8);
    for (final e in searchEntries) {
      final letters = searchCells(e).map((c) => searchGrid[c.$1][c.$2]).join();
      expect(letters, e.$1);
    }
  });

  test('Sarmal zincirinde ortak harfler doğru ve 49 kutunun tümü dolu', () {
    for (var i = 1; i < spiralWords.length; i++) {
      expect(spiralWords[i - 1].$1.split('').last, spiralWords[i].$1[0]);
    }
    expect(spiralAnswer.length, 49);
    final cells = spiralPositions(7);
    expect(cells.length, spiralAnswer.length);
    expect(cells.toSet().length, 49);
    for (var i = 1; i < cells.length; i++) {
      expect(
        (cells[i].$1 - cells[i - 1].$1).abs() +
            (cells[i].$2 - cells[i - 1].$2).abs(),
        1,
      );
    }
    for (var i = 0; i < spiralWords.length; i++) {
      expect(
        spiralAnswer.substring(
          spiralStarts[i],
          spiralStarts[i] + spiralWords[i].$1.length,
        ),
        spiralWords[i].$1,
      );
    }
  });
}
