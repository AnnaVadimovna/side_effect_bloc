library side_effect_bloc;

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:side_effect_bloc/src/bloc_side_effect_listener.dart';

/// {@template multi_bloc_listener}
/// Merges multiple [BlocSideEffectListener] widgets into one widget tree.
///
/// [MultiBlocSideEffectListener] improves the readability and eliminates
/// the need to nest multiple [BlocSideEffectListener]s.
///
/// By using [MultiBlocSideEffectListener] we can go from:
///
/// ```dart
/// BlocSideEffectListener<BlocA, BlocASideEffect>(
///   listener: (context, sideEffect) {},
///   child: BlocSideEffectListener<BlocB, BlocBSideEffect>(
///     listener: (context, sideEffect) {},
///     child: BlocSideEffectListener<BlocC, BlocCSideEffect>(
///       listener: (context, sideEffect) {},
///       child: ChildA(),
///     ),
///   ),
/// )
/// ```
///
/// to:
///
/// ```dart
/// MultiBlocSideEffectListener(
///   listeners: [
///     BlocSideEffectListener<BlocA, BlocASideEffect>(
///       listener: (context, sideEffect) {},
///     ),
///     BlocSideEffectListener<BlocB, BlocBSideEffect>(
///       listener: (context, sideEffect) {},
///     ),
///     BlocSideEffectListener<BlocC, BlocCSideEffect>(
///       listener: (context, sideEffect) {},
///     ),
///   ],
///   child: ChildA(),
/// )
/// ```
///
/// [MultiBlocSideEffectListener] converts the [BlocSideEffectListener] list
/// into a tree of nested [BlocSideEffectListener] widgets.
/// As a result, the only advantage of using [MultiBlocSideEffectListener]
/// is improved readability due to the reduction in nesting and boilerplate.
/// {@endtemplate}
class MultiBlocSideEffectListener extends MultiProvider {
  /// {@macro multi_bloc_listener}
  MultiBlocSideEffectListener({
    Key? key,
    required List<BlocSideEffectListenerSingleChildWidget> listeners,
    required Widget child,
  }) : super(key: key, providers: listeners, child: child);
}
