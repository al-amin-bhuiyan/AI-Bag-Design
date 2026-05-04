import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

/// NetworkManager - Global connectivity monitor
/// Proactively monitors internet connection and alerts the user
class NetworkManager extends GetxService {
  // Dependencies
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  // Observable state
  final RxBool isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    // Listen to network changes
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }

  /// Initialize the network status on startup
  Future<void> _initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } catch (e) {
      debugPrint('❌ NetworkManager Error checking connectivity: $e');
    }
  }

  /// Update connection status based on ConnectivityResult
  void _updateConnectionStatus(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.none) || result.isEmpty) {
      isConnected.value = false;
      _showNoInternetSnackbar();
    } else {
      if (!isConnected.value) {
        isConnected.value = true;
        _showRestoredSnackbar();
      }
    }
  }

  /// Shows a persistent snackbar when offline
  void _showNoInternetSnackbar() {
    Fluttertoast.cancel(); // Cancel any existing toasts
    Fluttertoast.showToast(
      msg: 'No Internet Connection. Please check your network.',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFFF44336),
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  /// Dismisses offline message and shows briefly that internet is back
  void _showRestoredSnackbar() {
    Fluttertoast.cancel(); // Cancel any existing toasts
    Fluttertoast.showToast(
      msg: 'Internet Connection Restored.',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFF4CAF50),
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}