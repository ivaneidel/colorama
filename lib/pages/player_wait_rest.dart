import 'dart:async';

import 'package:colorama/configuration/helpers.dart';
import 'package:colorama/configuration/state.dart';
import 'package:colorama/configuration/storage.dart';
import 'package:colorama/pages/wait_chooser.dart';
import 'package:flutter/material.dart';

class PlayerWaitRestPage extends StatefulWidget {
  const PlayerWaitRestPage({super.key});

  @override
  State<PlayerWaitRestPage> createState() => _PlayerWaitRestPageState();
}

class _PlayerWaitRestPageState extends State<PlayerWaitRestPage> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = Storage.getStream().listen((snapshot) {
      final data = snapshot.data() as Map;
      final started = data['started'];

      if (started == true) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const WaitChooserPage(),
            settings: const RouteSettings(name: 'WaitChooserPage'),
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
      onWillPop: () => willPop(context),
      child: Scaffold(
        appBar: AppBar(),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(child: SizedBox.shrink()),
                Text(
                  'Hola ${GlobalState.userName}!',
                  style: const TextStyle(
                    fontSize: 32,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'El número de partida es:',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${GlobalState.currentMatchId}',
                  style: const TextStyle(
                    fontSize: 48,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: const LinearProgressIndicator(),
                ),
                const SizedBox(height: 8),
                const Text(
                  '(Esperando a los demás jugadores)',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                const Expanded(child: SizedBox.shrink()),
                const Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    'Cuando todos se hayan unido, el juego va a empezar',
                    textAlign: TextAlign.right,
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
