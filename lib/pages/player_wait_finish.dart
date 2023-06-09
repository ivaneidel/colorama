import 'dart:async';

import 'package:colorama/configuration/helpers.dart';
import 'package:colorama/configuration/storage.dart';
import 'package:colorama/pages/finish.dart';
import 'package:flutter/material.dart';

class PlayerWaitFinishPage extends StatefulWidget {
  const PlayerWaitFinishPage({super.key});

  @override
  State<PlayerWaitFinishPage> createState() => _PlayerWaitFinishPageState();
}

class _PlayerWaitFinishPageState extends State<PlayerWaitFinishPage> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = Storage.getStream().listen((snapshot) {
      final data = snapshot.data() as Map;
      final finished = data['finished'];

      if (finished == true) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const FinishPage(),
            settings: const RouteSettings(name: 'FinishPage'),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Esperando que el resto termine de adivinar',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: const LinearProgressIndicator(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
