import 'package:bulmaca_gazetesi/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (var level = 1; level <= 2; level++) {
    test('Çapraz $level: tüm sözcükler tutarlı ve tek bağlantılıdır', () {
      final words = freeCrossWordsForLevel(level);
      expect(words.length, 18);
      expect(freeCrossRows(words), lessThanOrEqualTo(18));
      expect(freeCrossColumns(words), lessThanOrEqualTo(18));
      expect(words.map((w) => w.text).toSet().length, 18);
      final cells = <(int, int), String>{};
      final owners = <(int, int), List<int>>{};
      for (var n = 0; n < words.length; n++) {
        final word = words[n];
        for (var i = 0; i < word.text.length; i++) {
          final pos = word.cells[i];
          expect(pos.$1, inInclusiveRange(0, freeCrossRows(words) - 1));
          expect(pos.$2, inInclusiveRange(0, freeCrossColumns(words) - 1));
          if (cells.containsKey(pos)) expect(cells[pos], word.text[i]);
          cells[pos] = word.text[i];
          owners.putIfAbsent(pos, () => []).add(n);
        }
      }
      final connected = <int>{0};
      var previous = -1;
      while (previous != connected.length) {
        previous = connected.length;
        for (final group in owners.values) {
          if (group.any(connected.contains)) connected.addAll(group);
        }
      }
      expect(connected.length, words.length);
      for (final pos in cells.keys) {
        for (final vertical in [false, true]) {
          final before = (
            pos.$1 - (vertical ? 1 : 0),
            pos.$2 - (vertical ? 0 : 1),
          );
          if (cells.containsKey(before)) continue;
          var cursor = pos;
          var text = '';
          while (cells.containsKey(cursor)) {
            text += cells[cursor]!;
            cursor = (
              cursor.$1 + (vertical ? 1 : 0),
              cursor.$2 + (vertical ? 0 : 1),
            );
          }
          if (text.length > 1) {
            expect(
              words.where(
                (w) =>
                    w.r == pos.$1 &&
                    w.c == pos.$2 &&
                    w.vertical == vertical &&
                    w.text == text,
              ),
              hasLength(1),
            );
          }
        }
      }
    });
  }
}
