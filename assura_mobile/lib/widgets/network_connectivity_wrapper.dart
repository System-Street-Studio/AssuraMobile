import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkConnectivityWrapper extends StatelessWidget {
  final Widget child;

  const NetworkConnectivityWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          child,
          StreamBuilder<List<ConnectivityResult>>(
            stream: Connectivity().onConnectivityChanged,
            builder: (context, snapshot) {
              final disconnected = snapshot.hasData &&
                  snapshot.data!.isNotEmpty &&
                  snapshot.data!.every((result) => result == ConnectivityResult.none);

              if (disconnected) {
                return Positioned(
                  top: MediaQuery.of(context).padding.top, // Places it just below the status bar
                  left: 0,
                  right: 0,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      color: Colors.redAccent,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.wifi_off, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'No Internet Connection',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
