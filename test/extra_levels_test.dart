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
      expect(makeCrosswords(pack, arrow: true).length, greaterThanOrEqualTo(7));
    }
  });

  test('On farklı kelime avında tüm cevaplar tahtanın içindedir', () {
    for (var level = 2; level <= 11; level++) {
      final board = makeExtraSearch(extraPacks[level - 2], level);
      expect(board.grid.length, extraSearchRows);
      expect(board.grid.first.length, extraSearchColumns);
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

  test('Ek 10 Sudoku: her tahta geçerli ve birbirinden farklıdır', () {
    final signatures = <String>{};
    for (var level = 2; level <= 11; level++) {
      final board = extraSudokuSolution(level);
      final fixed = extraSudokuFixed(level);
      const digits = {1, 2, 3, 4, 5, 6, 7, 8, 9};
      expect(board.length, 9);
      expect(fixed.length, 9);
      for (var i = 0; i < 9; i++) {
        expect(board[i].toSet(), digits, reason: 'Bölüm $level satır $i');
        expect(
          {for (var r = 0; r < 9; r++) board[r][i]},
          digits,
          reason: 'Bölüm $level sütun $i',
        );
      }
      for (var br = 0; br < 9; br += 3) {
        for (var bc = 0; bc < 9; bc += 3) {
          expect(
            {
              for (var r = br; r < br + 3; r++)
                for (var c = bc; c < bc + 3; c++) board[r][c],
            },
            digits,
            reason: 'Bölüm $level kutu $br,$bc',
          );
        }
      }
      signatures.add(board.map((row) => row.join()).join());
    }
    expect(signatures.length, 10);
  });

  test('Ek sarmal: tüm cevaplar ızgaraya sığar ve sona erişilir', () {
    for (final pack in extraPacks) {
      final answer = pack.words.map((w) => trUpper(w.word)).join();
      expect(answer.length, lessThanOrEqualTo(spiralPositions(12).length));
      expect(answer.length, greaterThan(36));
    }
  });

  test('Ek çengel ve kare: yazılmış hücrelerde hiçbir harf çakışmaz', () {
    for (final pack in extraPacks) {
      for (final arrow in [true, false]) {
        final placed = makeCrosswords(pack, arrow: arrow);
        final letters = <(int, int), String>{};
        expect(placed, isNotEmpty);
        for (final word in placed) {
          for (var i = 0; i < word.cells.length; i++) {
            final pos = word.cells[i];
            expect(pos.$1, inInclusiveRange(0, 11));
            expect(pos.$2, inInclusiveRange(0, 11));
            if (letters.containsKey(pos)) {
              expect(letters[pos], word.answer.word[i]);
            }
            letters[pos] = word.answer.word[i];
          }
        }
        if (arrow) {
          for (final word in placed) {
            final clue = (
              word.row - (word.vertical ? 1 : 0),
              word.col - (word.vertical ? 0 : 1),
            );
            expect(clue.$1, inInclusiveRange(0, 11));
            expect(clue.$2, inInclusiveRange(0, 11));
            expect(letters.containsKey(clue), false);
          }
        }
      }
    }
  });
}
