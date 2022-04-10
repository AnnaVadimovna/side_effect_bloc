library side_effect_bloc;

/// An object that provides access to a stream of side effects over time.
abstract class SideEffectProvider<SIDE_EFFECT> {
  /// The current [sideEffects] of side effects.
  Stream<SIDE_EFFECT> get sideEffects;
}
