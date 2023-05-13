import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorama/configuration/helpers.dart';
import 'package:colorama/configuration/state.dart';
import 'package:colorama/configuration/storage.dart';
import 'package:colorama/pages/finish.dart';
import 'package:flutter/material.dart';

class ChooserWaitsPage extends StatefulWidget {
  const ChooserWaitsPage({super.key});

  @override
  State<ChooserWaitsPage> createState() => _ChooserWaitsPageState();
}

class _ChooserWaitsPageState extends State<ChooserWaitsPage> {
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
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ColorSection(
              playerName: GlobalState.userName!,
              r: GlobalState.r!,
              g: GlobalState.g!,
              b: GlobalState.b!,
            ),
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                stream: Storage.getStream(),
                builder: (context, snapshot) {
                  if (snapshot.data?.data() != null) {
                    final data = snapshot.data!.data() as Map;
                    final players = data['players'] as List;
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        for (var item in players)
                          if (item['name'] != null &&
                              item['r'] != null &&
                              item['g'] != null &&
                              item['b'] != null)
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
