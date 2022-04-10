part of 'page_one_bloc.dart';

@freezed
class PageOneEvent with _$PageOneEvent {
  const factory PageOneEvent.nextClick() = NextClick;
  const factory PageOneEvent.openSnackbarClick() = OpenSnackbarClick;
}
