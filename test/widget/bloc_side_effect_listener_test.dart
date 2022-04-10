import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../test_bloc.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key, this.onListenerCalled}) : super(key: key);

  final BlocWidgetListener<String>? onListenerCalled;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late TestBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = TestBloc();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: BlocSideEffectListener<TestBloc, String>(
          bloc: _bloc,
          listener: (context, state) {
            widget.onListenerCalled?.call(context, state);
          },
          child: Column(
            children: [
              ElevatedButton(
                key: const Key('cubit_listener_reset_button'),
                child: const SizedBox(),
                onPressed: () {
                  setState(() => _bloc = TestBloc());
                },
              ),
              ElevatedButton(
                key: const Key('cubit_listener_noop_button'),
                child: const SizedBox(),
                onPressed: () {
                  setState(() => _bloc = _bloc);
                },
              ),
              ElevatedButton(
                key: const Key('cubit_listener_increment_button'),
                child: const SizedBox(),
                onPressed: () => _bloc.add(EmitSideEffectEvent('1')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  group('BlocListener', () {
    testWidgets(
        'throws AssertionError '
        'when child is not specified', (tester) async {
      const expected =
          '''BlocSideEffectListener<TestBloc, String> used outside of MultiBlocListener must specify a child''';
      await tester.pumpWidget(
        BlocSideEffectListener<TestBloc, String>(
          bloc: TestBloc(),
          listener: (context, state) {},
        ),
      );
      expect(
        tester.takeException(),
        isA<AssertionError>().having((e) => e.message, 'message', expected),
      );
    });

    testWidgets('renders child properly', (tester) async {
      const targetKey = Key('cubit_listener_container');
      await tester.pumpWidget(
        BlocSideEffectListener<TestBloc, String>(
          bloc: TestBloc(),
          listener: (_, __) {},
          child: const SizedBox(key: targetKey),
        ),
      );
      expect(find.byKey(targetKey), findsOneWidget);
    });

    testWidgets('calls listener on single state change', (tester) async {
      final bloc = TestBloc();
      final states = <String>[];
      const expectedStates = ['1'];
      await tester.pumpWidget(
        BlocSideEffectListener<TestBloc, String>(
          bloc: bloc,
          listener: (_, state) {
            states.add(state);
          },
          child: const SizedBox(),
        ),
      );
      bloc.add(EmitSideEffectEvent('1'));
      await tester.pump();
      expect(states, expectedStates);
    });

    testWidgets('calls listener on multiple state change', (tester) async {
      final bloc = TestBloc();
      final states = <String>[];
      const expectedStates = ['1', '2'];
      await tester.pumpWidget(
        BlocSideEffectListener<TestBloc, String>(
          bloc: bloc,
          listener: (_, state) {
            states.add(state);
          },
          child: const SizedBox(),
        ),
      );
      bloc.add(EmitSideEffectEvent('1'));
      await tester.pump();
      bloc.add(EmitSideEffectEvent('2'));
      await tester.pump();
      expect(states, expectedStates);
    });

    testWidgets(
        'updates when the cubit is changed at runtime to a different cubit '
        'and unsubscribes from old cubit', (tester) async {
      var listenerCallCount = 0;
      String? latestState;
      final incrementFinder = find.byKey(
        const Key('cubit_listener_increment_button'),
      );
      final resetCubitFinder = find.byKey(
        const Key('cubit_listener_reset_button'),
      );
      await tester.pumpWidget(MyApp(
        onListenerCalled: (_, state) {
          listenerCallCount++;
          latestState = state;
        },
      ));

      await tester.tap(incrementFinder);
      await tester.pump();
      expect(listenerCallCount, 1);
      expect(latestState, '1');

      await tester.tap(incrementFinder);
      await tester.pump();
      expect(listenerCallCount, 2);
      expect(latestState, '1');

      await tester.tap(resetCubitFinder);
      await tester.pump();
      await tester.tap(incrementFinder);
      await tester.pump();
      expect(listenerCallCount, 3);
      expect(latestState, '1');
    });

    testWidgets(
        'does not update when the cubit is changed at runtime to same cubit '
        'and stays subscribed to current cubit', (tester) async {
      var listenerCallCount = 0;
      String? latestState;
      final incrementFinder = find.byKey(
        const Key('cubit_listener_increment_button'),
      );
      final noopCubitFinder = find.byKey(
        const Key('cubit_listener_noop_button'),
      );
      await tester.pumpWidget(MyApp(
        onListenerCalled: (context, state) {
          listenerCallCount++;
          latestState = state;
        },
      ));

      await tester.tap(incrementFinder);
      await tester.pump();
      expect(listenerCallCount, 1);
      expect(latestState, '1');

      await tester.tap(incrementFinder);
      await tester.pump();
      expect(listenerCallCount, 2);
      expect(latestState, '1');

      await tester.tap(noopCubitFinder);
      await tester.pump();
      await tester.tap(incrementFinder);
      await tester.pump();
      expect(listenerCallCount, 3);
      expect(latestState, '1');
    });
  });
}
