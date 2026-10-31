import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bulmaca_gazetesi/main.dart';

void main() {
  for (final count in [49, 60, 70, 100]) {
    test('İçten dışa spiral $count kutuda kesintisiz ve seçilebilir', () {
      final geometry = CircularSpiralGeometry(390, cellCount: count);
      var previous = 0.0;
      for (var i = 0; i < count; i++) {
        final center = geometry.center(i);
        final distance = (center - geometry.origin).distance;
        expect(distance, greaterThan(previous));
        expect(distance, lessThan(geometry.radius));
        expect(geometry.hit(center), i);
        expect(geometry.path(i).getBounds().left, greaterThanOrEqualTo(0));
        expect(geometry.path(i).getBounds().right, lessThanOrEqualTo(390));
        previous = distance;
      }
      expect(geometry.hit(geometry.origin), isNull);
    });
    testWidgets('Spiralde $count numaralı son kutuya dokunulabilir', (
      tester,
    ) async {
      var selected = -1;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 390,
              height: 390,
              child: CircularSpiralBoard(
                cellCount: count,
                entered: const {},
                errors: const {},
                selected: 0,
                activeStart: 0,
                activeLength: 4,
                onSelect: (i) => selected = i,
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byKey(ValueKey('spiral_${count - 1}')));
      expect(selected, count - 1);
      expect(tester.takeException(), isNull);
    });
  }
}
