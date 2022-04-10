import 'package:bloc/bloc.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

abstract class TestEvent {}

class EmitSideEffectEvent extends TestEvent {
  EmitSideEffectEvent(this.value);

  final String value;
}

class NoEmitSideEffectEvent extends TestEvent {}

class TestState {}

class TestBloc extends SideEffectBloc<TestEvent, TestState, String> {
  TestBloc() : super(TestState()) {
    on<EmitSideEffectEvent>(
      (event, emit) {
        produceSideEffect(event.value);
      },
    );
    on<NoEmitSideEffectEvent>(
      (event, emit) {
        emit(TestState());
      },
    );
  }
}

class TestBloc2 extends Bloc<TestEvent, TestState> {
  TestBloc2() : super(TestState()) {
    on<EmitSideEffectEvent>(
      (event, emit) {},
    );
    on<NoEmitSideEffectEvent>(
      (event, emit) {},
    );
  }
}
