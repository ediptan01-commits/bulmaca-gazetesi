
import 'package:flutter_test/flutter_test.dart';
import 'package:bulmaca_gazetesi/main.dart';

void main() {
  test('Türkçe harfler doğru büyütülür', () {
    expect(trUpper('istanbul'), 'İSTANBUL');
    expect(trUpper('bulmaca'), 'BULMACA');
  });

  test('Sarmal konumları doğru oluşturulur', () {
    final positions = spiralPositions(5);

    expect(positions.length, 25);
    expect(positions.toSet().length, 25);
    expect(positions.first, (0, 0));
    expect(positions.last, (2, 2));
  });
}
