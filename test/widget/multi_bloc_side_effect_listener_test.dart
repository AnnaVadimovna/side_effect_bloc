import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../test_bloc.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
}

void main() {
  group('MultiBlocSideEffectListener', () {
    testWidgets('calls listeners on state changes', (tester) async {
      final statesA = <String>[];
      const expectedStatesA = ['1', '2'];
      final testBlocA = TestBloc();

      final statesB = <String>[];
      final expectedStatesB = ['1'];
      final testBlocB = TestBloc();

      await tester.pumpWidget(
        MultiBlocSideEffectListener(
          listeners: [
            BlocSideEffectListener<TestBloc, String>(
              bloc: testBlocA,
              listener: (context, sideEffect) => statesA.add(sideEffect),
            ),
            BlocSideEffectListener<TestBloc, String>(
              bloc: testBlocB,
              listener: (context, sideEffect) => statesB.add(sideEffect),
            ),
          ],
          child: const SizedBox(key: Key('the_child')),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('the_child')), findsOneWidget);

      testBlocA.add(EmitSideEffectEvent('1'));
      await tester.pump();
      testBlocA.add(EmitSideEffectEvent('2'));
      await tester.pump();
      testBlocB.add(EmitSideEffectEvent('1'));
      await tester.pump();

      expect(statesA, expectedStatesA);
      expect(statesB, expectedStatesB);
    });

    testWidgets('calls listeners on state changes without explicit types',
        (tester) async {
      final statesA = <String>[];
      const expectedStatesA = ['1', '2'];
      final testBlocA = TestBloc();

      final statesB = <String>[];
      final expectedStatesB = ['1'];
      final testBlocB = TestBloc();

      await tester.pumpWidget(
        MultiBlocSideEffectListener(
          listeners: [
            BlocSideEffectListener(
              bloc: testBlocA,
              listener: (BuildContext context, String sideEffect) =>
                  statesA.add(sideEffect),
            ),
            BlocSideEffectListener(
              bloc: testBlocB,
              listener: (BuildContext context, String sideEffect) =>
                  statesB.add(sideEffect),
            ),
          ],
          child: const SizedBox(key: Key('the_child')),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('the_child')), findsOneWidget);

      testBlocA.add(EmitSideEffectEvent('1'));
      await tester.pump();
      testBlocA.add(EmitSideEffectEvent('2'));
      await tester.pump();
      testBlocB.add(EmitSideEffectEvent('1'));
      await tester.pump();

      expect(statesA, expectedStatesA);
      expect(statesB, expectedStatesB);
    });
  });
}
