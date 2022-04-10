part of 'page_one_bloc.dart';

@freezed
class PageOneCommand with _$PageOneCommand {
  const factory PageOneCommand.goToNext() = _GoToNext;
  const factory PageOneCommand.openSnackbar() = _OpenSnackbar;
}
