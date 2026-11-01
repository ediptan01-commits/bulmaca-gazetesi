import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bulmaca_gazetesi/main.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  testWidgets('Yeni kimlik telefona sığar ve yalnızca iki bölüm sunar', (
    tester,
  ) async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    tester.view.physicalSize = const Size(320, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const BulmacaApp());
    await tester.pumpAndSettle();
    expect(find.text(appName), findsOneWidget);
    expect(find.text(appSlogan), findsOneWidget);
    expect(find.text('6 bulmaca türü • 12 bölüm'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Çengel Bulmaca'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('level_2')), findsOneWidget);
    expect(find.byKey(const ValueKey('level_3')), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
