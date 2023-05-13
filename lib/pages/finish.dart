import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorama/configuration/helpers.dart';
import 'package:colorama/configuration/state.dart';
import 'package:colorama/configuration/storage.dart';
import 'package:colorama/pages/chooser.dart';
import 'package:colorama/pages/wait_chooser.dart';
import 'package:flutter/material.dart';

class FinishPage extends StatefulWidget {
  const FinishPage({super.key});

  @override
  State<FinishPage> createState() => _FinishPageState();
}

class _FinishPageState extends State<FinishPage> {
  StreamSubscription? _subscription;
  String _winner = '';

  void _startNextRound() async {
    final newChooser = _winner.isNotEmpty ? _winner : GlobalState.userName!;
    if (_winner.isEmpty) {
      _winner = GlobalState.userName!;
      if (mounted) setState(() {});
    }

    await Storage.startNextRound(
      matchId: GlobalState.currentMatchId!,
      newChooser: newChooser,
    );
  }

  void _computeWinner(Map<String, dynamic> match) {
    if (_winner.isEmpty) {
      final r = match['r'] as int;
      final g = match['g'] as int;
      final b = match['b'] as int;

      final potentialWinners = [];

      var deviation = 10;

      // Get potential winners
      while (potentialWinners.isEmpty && deviation < 30) {
        for (var player in match['players']) {
          final _r = player['r'];
          final _g = player['g'];
          final _b = player['b'];

          final dR = (r - _r).abs();
          final dG = (g - _g).abs();
          final dB = (b - _b).abs();

          if (dR <= deviation && dG <= deviation && dB <= deviation) {
            potentialWinners.add(
              {
                'name': player['name'],
                'dR': dR,
                'dG': dG,
                'dB': dB,
                'dT': dR + dG + dB,
              },
            );
          }
        }

        deviation = deviation + 10;
      }

      if (potentialWinners.isNotEmpty) {
        var lowestScore = 1000;

        // Get actual winner
        for (var player in potentialWinners) {
          if (player['dT'] < lowestScore) {
            lowestScore = player['dT'];
            _winner = player['name'];
          }
        }
        if (mounted) setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Nadié ganó, continúa ${match['chooser']}',
            ),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _subscription = Storage.getStream().listen((snapshot) {
        final data = snapshot.data() as Map<String, dynamic>;

        if (data['started'] == true && data['finished'] == true) {
          _computeWinner(data); // Will be called once
        }

        final shouldRestart =
            data['started'] == false && data['finished'] == false;

        if (shouldRestart) {
          if (GlobalState.userName == _winner) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => const ChooserPage(),
                settings: const RouteSettings(name: 'ChooserPage'),
              ),
            );
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => const WaitChooserPage(),
                settings: const RouteSettings(name: 'WaitChooserPage'),
              ),
            );
          }
        }
      });
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
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Partida terminada!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: StreamBuilder<DocumentSnapshot>(
                  stream: Storage.getStream(),
                  builder: (context, snapshot) {
                    if (snapshot.data?.data() != null) {
                      final data =
                          snapshot.data!.data() as Map<String, dynamic>;

                      if (data['started'] == true && data['finished'] == true) {
                        final chooser = data['chooser'];
                        final isChooser = chooser == GlobalState.userName;
                        final r = data['r'];
                        final g = data['g'];
                        final b = data['b'];

                        final players = data['players'] as List;
                        return Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ColorSection(
                              playerName: chooser as String,
                              r: r as int,
                              g: g as int,
                              b: b as int,
                            ),
                            const SizedBox(height: 16),
                            for (var item in players)
                              ColorSection(
                                playerName: item['name'] as String,
                                r: item['r'] as int,
                                g: item['g'] as int,
                                b: item['b'] as int,
                              ),
                            const SizedBox(height: 32),
                            Text(
                              'Ganó: $_winner',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 32,
                              ),
                            ),
                            const SizedBox(height: 32),
                            if (isChooser)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        'Apretá continuar para iniciar la siguiente ronda',
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: ElevatedButton(
                                        onPressed: _startNextRound,
                                        child: const Text('Continuar'),
                                      ),
                                    ),
                                    const SizedBox(height: 32),
                                  ],
                                ),
                              ),
                          ],
                        );
                      }
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ColorSection extends StatelessWidget {
  final String playerName;
  final int r;
  final int g;
  final int b;

  const ColorSection({
    super.key,
    required this.playerName,
    required this.r,
    required this.g,
    required this.b,
  });

  Color get _backgroundColor => Color.fromARGB(255, r, g, b);

  bool get _isSelf => playerName == GlobalState.userName;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: _backgroundColor,
        child: Center(
          child: Text(
            _isSelf ? 'Tu color' : playerName,
            style: TextStyle(
              fontSize: 24,
              color: getTextColor(
                _backgroundColor,
              ),
              fontWeight: _isSelf ? FontWeight.bold : null,
            ),
          ),
        ),
      ),
    );
  }
}
