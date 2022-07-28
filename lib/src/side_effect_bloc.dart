library side_effect_bloc;

import 'package:bloc/bloc.dart';
import 'package:side_effect_bloc/src/side_effect_bloc_mixin.dart';

/// {@template side_effect_bloc}
/// Abstract class which extend base bloc with `Stream` of `Side effects`
/// {@endtemplate}
abstract class SideEffectBloc<EVENT, STATE, COMMAND> extends Bloc<EVENT, STATE>
    with SideEffectBlocMixin<STATE, COMMAND> {
  /// {@macro side_effect_bloc}
  SideEffectBloc(STATE initialState) : super(initialState);
}

/// {@template side_effect_bloc}
/// Abstract class which extend base cubit with `Stream` of `Side effects`
/// {@endtempla
abstract class SideEffectCubit<STATE, EFFECT> extends Cubit<STATE>
    with SideEffectBlocMixin<STATE, EFFECT> {
  /// {@macro side_effect_bloc}
  SideEffectCubit(STATE initialState) : super(initialState);
}
