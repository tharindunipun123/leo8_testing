import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/pages/home%20page/bloc/home_page_event.dart';
import 'package:flutter_application_1/pages/home%20page/bloc/home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc() : super(HomePageState()) {
    on<IndexEvent>(
      (event, emit) => emit(state.copyWith(index: event.index)),
    );
  }
}
