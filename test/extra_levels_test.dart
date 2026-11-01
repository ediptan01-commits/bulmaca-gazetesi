import 'package:flutter_test/flutter_test.dart';
import 'package:bulmaca_gazetesi/main.dart';

void main() {
  test('İlk sürüm altı tür ve toplam on iki bölüm içerir', () {
    expect(levelsPerPuzzle, 2);
    expect(puzzles.length, 6);
    expect((levelsPerPuzzle - 1) * puzzles.length, 6);
    expect(extraPacks.length, 10);
    expect(extraPacks.map((p) => p.title).toSet().length, 10);
  });

  test('Her yeni seviyede geçerli ipucu ve kelimeler vardır', () {
    for (final pack in extraPacks) {
      expect(pack.words.length, greaterThanOrEqualTo(8));
      for (final word in pack.words) {
        expect(word.word.isNotEmpty, isTrue);
        expect(word.clue.isNotEmpty, isTrue);
      }
      expect(makeCrosswords(pack, arrow: false), isNotEmpty);
      expect(makeCrosswords(pack, arrow: true), isNotEmpty);
    }
  });

  test('On farklı kelime avında tüm cevaplar tahtanın içindedir', () {
    for (var level = 2; level <= 11; level++) {
      final board = makeExtraSearch(extraPacks[level - 2], level);
      expect(board.grid.length, 13);
      expect(board.entries.length, extraPacks[level - 2].words.length);
      for (final entry in board.entries) {
        final actual = List.generate(
          entry.$1.length,
          (i) => board.grid[entry.$2 + i * entry.$4][entry.$3 + i * entry.$5],
        ).join();
        expect(actual, entry.$1);
      }
    }
  });
}
