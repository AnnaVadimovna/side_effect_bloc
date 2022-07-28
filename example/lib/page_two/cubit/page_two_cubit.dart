import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

part 'page_two_event.dart';
part 'page_two_state.dart';

class PageTwoCubit extends Cubit<PageTwoState> with SideEffectBlocMixin<PageTwoState, PageTwoShowDialogEvent> {
  PageTwoCubit() : super(PageTwoInitial());

  Future<void> processData() async {
    //processing heavy task
    await Future.delayed(const Duration(milliseconds: 500));

    produceSideEffect(PageTwoShowDialogEvent(label: 'Done'));
  }
}
