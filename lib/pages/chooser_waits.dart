import 'package:colorama/configuration/helpers.dart';
import 'package:colorama/configuration/state.dart';
import 'package:flutter/material.dart';

class ChooserWaitsPage extends StatefulWidget {
  const ChooserWaitsPage({super.key});

  @override
  State<ChooserWaitsPage> createState() => _ChooserWaitsPageState();
}

class _ChooserWaitsPageState extends State<ChooserWaitsPage> {
  final _seed = [
    {'name': 'hola', 'r': 123, 'g': 234, 'b': 234},
    {'name': 'chau', 'r': 234, 'g': 1, 'b': 215},
    {'name': 'lao', 'r': 255, 'g': 100, 'b': 224},
    {'name': 'lio', 'r': 26, 'g': 200, 'b': 251},
    {'name': '1csa', 'r': 80, 'g': 232, 'b': 321},
  ];

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
            for (var item in _seed)
              ColorSection(
                playerName: item['name'] as String,
                r: item['r'] as int,
                g: item['g'] as int,
                b: item['b'] as int,
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
