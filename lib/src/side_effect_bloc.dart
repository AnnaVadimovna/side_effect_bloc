library side_effect_bloc;

import 'package:bloc/bloc.dart';
import 'package:side_effect_bloc/src/side_effect_bloc_mixin.dart';

/// {@template side_effect_bloc}
/// Abstract class which extend base bloc with `Stream` of `Side effects`
/// {@endtemplate}
abstract class SideEffectBloc<EVENT, STATE, COMMAND> extends Bloc<EVENT, STATE>
    with SideEffectBlocMixin<EVENT, STATE, COMMAND> {
  /// {@macro side_effect_bloc}
  SideEffectBloc(STATE initialState) : super(initialState);
}
