import 'package:flutter_test/flutter_test.dart';
import 'package:bulmaca_gazetesi/main.dart';

void main() {
  test('Türkçe büyük harfler', () {
    expect(trUpper('çiçek ıslak iz'), 'ÇİÇEK ISLAK İZ');
  });
  test('Sarmal 5x5 her hücreyi bir kez dolaşır', () {
    final cells = spiralPositions(5);
    expect(cells.length, 25);
    expect(cells.toSet().length, 25);
    expect(cells.first, (0, 0));
    expect(cells.last, (2, 2));
  });
  test('Kare ve çengel kelimeleri ızgara dışında değil', () {
    for (final w in [...crossWords, ...arrowWords]) {
      expect(w.text.isNotEmpty, true);
      expect(w.r + (w.vertical ? w.text.length : 1) <= crossSize, true);
      expect(w.c + (w.vertical ? 1 : w.text.length) <= crossSize, true);
    }
  });
  test('Sudoku çözümünde satırlar 1-9 içerir', () {
    for (final row in sudokuSolved) {
      expect(row.split('').toSet().length, 9);
    }
  });
}
