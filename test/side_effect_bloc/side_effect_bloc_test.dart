import 'package:bloc/bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../test_bloc.dart';

class MockBlocObserver extends Mock implements BlocObserver {}

void main() {
  group('Side effect bloc Tests', () {
    late TestBloc bloc;
    late MockBlocObserver observer;
    setUp(() {
      bloc = TestBloc();
      observer = MockBlocObserver();
    });

    test('triggers onCreate on observer when instantiated', () {
      BlocOverrides.runZoned(() {
        final bloc = TestBloc();
        // ignore: invalid_use_of_protected_member
        verify(() => observer.onCreate(bloc)).called(1);
      }, blocObserver: observer);
    });

    test('triggers onClose on observer when closed', () async {
      await BlocOverrides.runZoned(() async {
        final bloc = TestBloc();
        await bloc.close();
        // ignore: invalid_use_of_protected_member
        verify(() => observer.onClose(bloc)).called(1);
      }, blocObserver: observer);
    });

    test('triggers isClosed is true on bloc when closed', () async {
      await BlocOverrides.runZoned(() async {
        final bloc = TestBloc();
        await bloc.close();
        expect(bloc.isClosed, isTrue);
      }, blocObserver: observer);
    });

    test('should map single event to correct side effect', () {
      BlocOverrides.runZoned(() {
        final expectedStates = <String>['payload'];
        expectLater(
          bloc.sideEffects,
          emitsInOrder(expectedStates),
        );

        bloc
          ..add(EmitSideEffectEvent('payload'))
          ..close();
      }, blocObserver: observer);
    });

    test('should no map single event to side effect', () {
      BlocOverrides.runZoned(() {
        final bloc = TestBloc();
        final expectedStates = <String>[];
        expectLater(bloc.sideEffects, emitsInOrder(expectedStates));

        bloc
          ..add(NoEmitSideEffectEvent())
          ..close();
      }, blocObserver: observer);
    });
  });
}
