import 'package:colorama/configuration/state.dart';
import 'package:colorama/configuration/storage.dart';
import 'package:colorama/pages/player_wait_rest.dart';
import 'package:flutter/material.dart';

class JoinPage extends StatefulWidget {
  const JoinPage({super.key});

  @override
  State<JoinPage> createState() => JoinPageState();
}

class JoinPageState extends State<JoinPage> {
  final _nameController = TextEditingController();
  final _matchController = TextEditingController();
  var _loading = false;

  Future<void> _joinGame() async {
    if (mounted) setState(() {});
    _loading = true;
    try {
      final name = _nameController.text.trim();
      final matchId = int.parse(_matchController.text.trim());

      GlobalState.setUserName(name);

      await Storage.joinGame(
        playerName: name,
        matchId: matchId,
      );

      GlobalState.setCurrentMatchId(matchId);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const PlayerWaitRestPage(),
          settings: const RouteSettings(name: 'PlayerWaitRestPage'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Ocurrió un error ${e.toString()}',
          ),
        ),
      );
    }
    if (mounted) setState(() {});
    _loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Ingresá tu nombre',
                  hintText: 'Marcelo',
                ),
                textInputAction: TextInputAction.done,
                onChanged: (value) {
                  if (mounted) setState(() {});
                },
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _matchController,
                decoration: const InputDecoration(
                  labelText: 'Ingresá el número de la partida',
                  hintText: '123456',
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onChanged: (value) {
                  if (mounted) setState(() {});
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _nameController.text.trim().isNotEmpty &&
                            _matchController.text.trim().isNotEmpty &&
                            !_loading
                        ? _joinGame
                        : null,
                    child: _loading
                        ? const CircularProgressIndicator(strokeWidth: 1)
                        : const Text('Continuar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
