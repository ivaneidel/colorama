import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorama/configuration/helpers.dart';
import 'package:colorama/configuration/state.dart';
import 'package:colorama/configuration/storage.dart';
import 'package:colorama/pages/chooser.dart';
import 'package:flutter/material.dart';

class WaitRestPage extends StatefulWidget {
  const WaitRestPage({super.key});

  @override
  State<WaitRestPage> createState() => _WaitRestPageState();
}

class _WaitRestPageState extends State<WaitRestPage> {
  var _loading = false;

  Future<void> _startGame(BuildContext context) async {
    _loading = true;
    if (mounted) setState(() {});
    try {
      final matchId = GlobalState.currentMatchId!;
      await Storage.startGame(matchId: matchId);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const ChooserPage(),
          settings: const RouteSettings(name: 'ChooserPage'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Ocurrió un error: ${e.toString()}',
          ),
        ),
      );
    }
    _loading = false;
    if (mounted) setState(() {});
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
                const Expanded(child: SizedBox.shrink()),
                Text(
                  'Hola ${GlobalState.userName}!',
                  style: const TextStyle(
                    fontSize: 32,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tu número de partida es:',
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
                const SizedBox(height: 32),
                StreamBuilder<DocumentSnapshot>(
                  stream: Storage.getStream(),
                  builder: (context, snapshot) {
                    if (snapshot.data?.data() != null) {
                      final data = snapshot.data!.data() as Map;
                      final players = data['players'] as List;

                      return Wrap(
                        alignment: WrapAlignment.start,
                        runAlignment: WrapAlignment.start,
                        runSpacing: 20,
                        spacing: 20,
                        children: [
                          for (final player in players)
                            Chip(
                              label: Text(player['name']),
                            ),
                        ],
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
                const Expanded(child: SizedBox.shrink()),
                const Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    'Apretá continuar cuando todo el mundo ya haya ingresado',
                    textAlign: TextAlign.right,
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: _loading ? null : () => _startGame(context),
                    child: const Text('Continuar'),
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
