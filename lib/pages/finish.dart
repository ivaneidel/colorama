import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorama/configuration/helpers.dart';
import 'package:colorama/configuration/state.dart';
import 'package:colorama/configuration/storage.dart';
import 'package:flutter/material.dart';

class FinishPage extends StatefulWidget {
  const FinishPage({super.key});

  @override
  State<FinishPage> createState() => _FinishPageState();
}

class _FinishPageState extends State<FinishPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                    final data = snapshot.data!.data() as Map;
                    final chooser = data['chooser'];
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
                      ],
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
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
