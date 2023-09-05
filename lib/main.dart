import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

Stream<ConnectivityResult> get connectivityStream async* {
  final c = Connectivity();
  yield await c.checkConnectivity();
  yield* c.onConnectivityChanged;
}

Stream<bool> get connectedStream =>
    connectivityStream.map((e) => e != ConnectivityResult.none);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Body(),
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: connectedStream,
      builder: (context, snapshot) {
        debugPrint('$snapshot');
        return Center(
          child: switch (snapshot) {
            AsyncSnapshot(hasData: true, data: bool d) => HasData(data: d),
            AsyncSnapshot(
              hasError: true,
              error: Object e,
              stackTrace: StackTrace s
            ) =>
              Error.throwWithStackTrace(e, s),
            _ => const CircularProgressIndicator.adaptive(),
          },
        );
      },
    );
  }
}

class HasData extends StatelessWidget {
  const HasData({
    super.key,
    required this.data,
  });

  final bool data;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('hello $data'));
  }
}
