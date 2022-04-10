<a href="https://pub.dev/packages/side_effect_bloc"><img src="https://img.shields.io/pub/v/side_effect_bloc.svg" alt="Pub"></a>


Extended [bloc](https://pub.dev/packages/bloc) with a separate stream for events that should be consumed only once. 

A separate thread allows you to separate events related to navigation a toast/snackbar message, for example, from the state of the bloc.

## Usage

### Declare bloc

#### Adding mixin to existing bloc 

```dart
class FeatureBloc extends Bloc<FeatureEvent, FeatureState>
    with SideEffectBlocMixin<FeatureEvent, FeatureState, FeatureSideEffect> {
  FeatureBloc() : super(FeatureState.initial());
}
```

#### Inherit from bloc 

```dart
class FeatureBloc extends SideEffectBloc<FeatureEvent, FeatureState, FeatureSideEffect>{
  FeatureBloc() : super(FeatureState.initial());
}
```

### Emit side effect

```dart
class FeatureBloc extends SideEffectBloc<FeatureEvent, FeatureState, FeatureSideEffect>{
  FeatureBloc() : super(FeatureState.initial()){        
    on<ItemClick>(
      (event, emit) {
        produceSideEffect(FeatureSideEffect.openItem(event.id));
      },
    );
  }
}
```

### Listen side effect

```dart
// feature_view.dart
BlocSideEffectListener<FeatureBloc, FeatureSideEffect>(
    listener: (BuildContext context, FeatureSideEffect sideEffect) {
        sideEffect.when(
            goToNext: () => Navigator.of(context).pushNamed("/sub"),
            openSnackbar: () {
                const snackBar = SnackBar(
                    content: Text('Yay! A SnackBar!'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
            });
    },
    child: ...
)
```