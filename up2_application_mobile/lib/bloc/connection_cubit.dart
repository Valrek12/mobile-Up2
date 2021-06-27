import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity/connectivity.dart';

class ConnectionEthernateState {
  final bool connected;
  ConnectionEthernateState(this.connected) : assert(connected != null);
}

class ConnectionCubit extends Cubit<ConnectionEthernateState> {
  StreamSubscription<ConnectivityResult> _subscription;
  ConnectionCubit() : super(ConnectionEthernateState(false)) {
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      emit(ConnectionEthernateState(result != ConnectivityResult.none));
    });
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
