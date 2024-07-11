import 'package:example/timer_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:step_timer/step_timer.dart';

Future pumpTimerPage(WidgetTester tester) async {
  await tester.pumpWidget(const MaterialApp(home: TimerPage()));
}

String getTimerValue() {
  Finder widget = find.byKey(const Key("timerValue"));
  final Text textWidget = widget.evaluate().single.widget as Text;
  return textWidget.data ?? "";
}

void compareTimerValue(int compareValue) async {
  String actualTimerValue = getTimerValue();
  expect(
    actualTimerValue,
    compareValue.toString(),
  );
}

Future delay(WidgetTester tester, {int seconds = 5}) async {
  await tester.pump(Duration(seconds: seconds));
}

Future checkWidgetAvailability(WidgetTester tester) async {
  await pumpTimerPage(tester);

  await delay(tester);

  expect(find.byType(StepTimerIndicator), findsOneWidget);
  expect(find.byType(FloatingActionButton), findsOneWidget);
  compareTimerValue(0);
  expect(find.byIcon(Icons.play_arrow), findsOneWidget);
}

Future hitPlayPause(WidgetTester tester) async {
  await tester.tap(find.byKey(const ValueKey("Play Pause Button")));
}

Future _onStart(WidgetTester tester) async {
  await hitPlayPause(tester);
  await delay(tester);
  await hitPlayPause(tester);
  await delay(tester);
  compareTimerValue(5);
}

Future _onResume(WidgetTester tester) async {
  // Hitting Play Button
  await hitPlayPause(tester);
  await delay(tester);
  // Hitting Pause Button
  await hitPlayPause(tester);
  await delay(tester, seconds: 2);
  // Hitting Play Button to Resume
  await hitPlayPause(tester);
  await delay(tester);
  compareTimerValue(10);
}

Future _onFinish(WidgetTester tester) async {
  // Hit Play Button
  await hitPlayPause(tester);
  await delay(tester, seconds: 60);
  compareTimerValue(60);
}

void main() {
  // testWidgets('Check Widget Availability', (WidgetTester tester) async {
  //   await checkWidgetAvailability(tester);
  // });
  testWidgets('Check Timer Start', (WidgetTester tester) async {
    await pumpTimerPage(tester);
    await _onStart(tester);
  });
  testWidgets('Check Timer Resume', (WidgetTester tester) async {
    await pumpTimerPage(tester);
    await _onResume(tester);
  });

  testWidgets('Check Timer Finish', (WidgetTester tester) async {
    await pumpTimerPage(tester);
    await _onFinish(tester);
  });
}
