library side_effect_bloc;

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:side_effect_bloc/src/side_effect_provider.dart';

/// {@template side_effect_bloc_mixin}
/// Mixin to enrich the existing bloc  with `Stream` of `Side effects`
/// {@endtemplate}
mixin SideEffectBlocMixin<STATE, SIDE_EFFECT> on BlocBase<STATE>
    implements SideEffectProvider<SIDE_EFFECT> {
  final StreamController<SIDE_EFFECT> _sideEffectController =
      StreamController.broadcast();

  /// Emits a new [sideEffect].
  void produceSideEffect(SIDE_EFFECT sideEffect) {
    try {
      if (_sideEffectController.isClosed) {
        throw StateError('Cannot emit new states after calling close');
      }
      _sideEffectController.add(sideEffect);
    } catch (error, stackTrace) {
      onError(error, stackTrace);
      rethrow;
    }
  }

  @override
  Stream<SIDE_EFFECT> get sideEffects => _sideEffectController.stream;

  @mustCallSuper
  @override
  Future<void> close() async {
    await super.close();
    await _sideEffectController.close();
  }

  @override
  bool get isClosed => super.isClosed && _sideEffectController.isClosed;
}
