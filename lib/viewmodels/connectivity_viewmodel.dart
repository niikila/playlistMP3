import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityViewModel extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  late final StreamSubscription<List<ConnectivityResult>> _subscription;

  bool _isOffline = false;
  bool get isOffline => _isOffline;

  ConnectivityViewModel() {
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      final wasOffline = _isOffline;
      _isOffline = results.contains(ConnectivityResult.none);

      if (_isOffline != wasOffline) {
        notifyListeners();
      }

      if (_isOffline) {
        print('Sin conexión');
        // Aquí puedes lanzar algún evento, o controlar desde HomePage
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
