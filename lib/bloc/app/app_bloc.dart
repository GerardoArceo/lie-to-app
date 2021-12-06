import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppInitial()) {
    on<AppEvent>((event, emit) {

      if (event is SetLoadingState ) {
        state.isLoading.sink.add(event.loadingState);
      } else if (event is SetBluetoothState ) {
        state.bluetoothConected.sink.add(event.bluetoothState);
      }

    });
  }
}
