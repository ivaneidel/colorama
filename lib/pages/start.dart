import 'package:colorama/configuration/colors.dart';
import 'package:colorama/configuration/components.dart';
import 'package:colorama/pages/init.dart';
import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const TitleRow(),
            const SizedBox(height: 32),
            LargeButton(
              label: 'INICIAR',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const InitPage(),
                  settings: const RouteSettings(name: 'InitPage'),
                ),
              ),
            ),
            const SizedBox(height: 32),
            LargeButton(label: 'UNIRSE', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}

class TitleRow extends StatelessWidget {
  const TitleRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        TitleLetter(letter: 'C', color: rColor),
        TitleLetter(letter: 'o', color: gColor),
        TitleLetter(letter: 'l', color: bColor),
        TitleLetter(letter: 'o', color: rColor),
        TitleLetter(letter: 'r', color: gColor),
        TitleLetter(letter: 'a', color: bColor),
        TitleLetter(letter: 'm', color: rColor),
        TitleLetter(letter: 'a', color: gColor),
      ],
    );
  }
}

class TitleLetter extends StatelessWidget {
  final String letter;
  final Color color;

  const TitleLetter({
    super.key,
    required this.letter,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      letter,
      style: TextStyle(
        color: color,
        fontSize: 60,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
