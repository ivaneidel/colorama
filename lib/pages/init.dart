import 'package:colorama/configuration/state.dart';
import 'package:colorama/configuration/storage.dart';
import 'package:colorama/pages/wait_rest.dart';
import 'package:flutter/material.dart';

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  final _nameController = TextEditingController();
  var _loading = false;

  Future<void> _startGame() async {
    if (mounted) setState(() {});
    _loading = true;
    try {
      final name = _nameController.text.trim();

      GlobalState.setUserName(name);

      final matchId = await Storage.createGame(
        ownerName: name,
      );

      GlobalState.setCurrentMatchId(matchId);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const WaitRestPage(),
          settings: const RouteSettings(name: 'WaitRestPage'),
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
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed:
                        _nameController.text.trim().isNotEmpty && !_loading
                            ? _startGame
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
