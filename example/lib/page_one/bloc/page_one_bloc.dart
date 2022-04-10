import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

part 'page_one_bloc.freezed.dart';
part 'page_one_command.dart';
part 'page_one_event.dart';
part 'page_one_state.dart';

class PageOneBloc extends Bloc<PageOneEvent, PageOneState>
    with SideEffectBlocMixin<PageOneEvent, PageOneState, PageOneCommand> {
  PageOneBloc() : super(const PageOneState.initial()) {
    on<NextClick>(
      (event, emit) {
        produceSideEffect(const PageOneCommand.goToNext());
      },
    );
    on<OpenSnackbarClick>(
      (event, emit) {
        produceSideEffect(const PageOneCommand.openSnackbar());
      },
    );
  }
}
