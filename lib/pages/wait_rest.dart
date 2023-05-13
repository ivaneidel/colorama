import 'package:colorama/configuration/helpers.dart';
import 'package:colorama/configuration/state.dart';
import 'package:colorama/pages/chooser.dart';
import 'package:flutter/material.dart';

class WaitRestPage extends StatelessWidget {
  const WaitRestPage({super.key});

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
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ChooserPage(),
                        settings: const RouteSettings(name: 'ChooserPage'),
                      ),
                    ),
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
